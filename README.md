
# VM Resource Monitoring and Auto-Scaling Project

## Objective
This project demonstrates how to monitor system resources (CPU, memory, disk, and network usage) on a local VM using **Grafana** and **Node Exporter**, with alerts for when resource usage exceeds 75%. In case of high resource usage, it triggers auto-scaling actions to a public cloud (e.g., AWS, Azure, or GCP).

---

## Project Deliverables

1. **Document Report**  
   A step-by-step guide on setting up Grafana, Node Exporter, creating dashboards, configuring alerts, and setting up auto-scaling.

2. **Architecture Design**  
   Diagram illustrating the flow from local VM resource monitoring to cloud scaling.

3. **Source Code Repo**  
   This repository contains monitoring scripts, configurations, and application code.

4. **Recorded Video Demo**  
   A video showing the entire setup, demonstrating how to monitor resources and trigger auto-scaling actions.

---

## Steps for Setup

### 1. Grafana Installation

To install **Grafana**, follow these steps:

1. **Install Grafana**:
   On your VM, use the `pkg` command to install Grafana if available:

   ```bash
   sudo pkg update
   sudo pkg install grafana8
   ```

2. **Start Grafana**:

   Enable and start the **Grafana** service:

   ```bash
   sudo service grafana start
   ```

   Access the Grafana web interface by navigating to `http://<VM_IP>:3000`. Use the default credentials:
   - Username: `admin`
   - Password: `admin` (You will be prompted to change the password on the first login).

---

### 2. Node Exporter Installation

1. **Download and Install Node Exporter**:

   ```bash
   wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
   tar -xvzf node_exporter-1.3.1.linux-amd64.tar.gz
   sudo mv node_exporter-1.3.1.linux-amd64/node_exporter /usr/local/bin/
   ```

2. **Run Node Exporter**:
   
   Start **Node Exporter** to collect system metrics:

   ```bash
   nohup /usr/local/bin/node_exporter --web.disable-tls --web.enable-http2=false &
   ```

   Visit `http://<VM_IP>:9100/metrics` to verify it is running.

---

### 3. Configure Prometheus Data Source in Grafana

1. **Add Prometheus Data Source**:
   - Log in to **Grafana**, navigate to **Configuration** → **Data Sources**.
   - Select **Prometheus** as the data source.
   - Set the URL to `http://<VM_IP>:9090` (Prometheus server).

2. **Save and Test**:
   Ensure that the connection is successful by clicking **Save & Test**.

---

### 4. Create Grafana Dashboards

1. **Create New Dashboard**:
   - Click **Create → Dashboard** in Grafana.
   - Add panels to display key metrics like:
     - **CPU Usage**: Query `avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) by (instance)`.
     - **Memory Usage**: Query `(node_memory_MemTotal_bytes - node_memory_MemFree_bytes) / node_memory_MemTotal_bytes * 100`.
     - **Disk Usage**: Query `node_filesystem_avail_bytes`.

2. **Save Dashboard**:
   After adding panels for various metrics, save the dashboard.

---

### 5. Set Up Alerts in Grafana

1. **Configure Alerts**:
   - Go to the **Alert** tab on your dashboard's panel.
   - Set up an alert condition such as **CPU > 75%** or **Memory > 75%**.
   
2. **Set Alert Notifications**:
   - Configure a notification channel (Email, Slack, etc.) under **Alerting → Notification Channels**.

---

### 6. Auto-Scaling Setup

Since Grafana doesn't manage auto-scaling directly, you need to set up cloud auto-scaling manually.

1. **Auto-Scaling Configuration**:
   - In **AWS**, **Azure**, or **GCP**, create an **Auto Scaling Group** that automatically adjusts resources based on metrics such as CPU or memory usage.
   - Define a scaling policy to increase the number of instances when **CPU > 75%** or **Memory > 75%**.

2. **Auto-Scaling Trigger**:
   - When an alert is triggered (e.g., **CPU > 75%**), you can use cloud-specific APIs to trigger an auto-scaling action, or manually monitor and adjust the scaling via the cloud provider's console.

---

## Code & Configurations

The following is a summary of the key files in the repository:

1. **Grafana Dashboard JSON**:
   The **JSON** export of the Grafana dashboard can be found in `grafana-dashboard.json`.

2. **Node Exporter Configuration**:
   Configuration for **Node Exporter** can be found in `/etc/systemd/system/node_exporter.service` or similar, if using **systemd**. Alternatively, start it manually via `nohup`:

   ```bash
   nohup /usr/local/bin/node_exporter --web.disable-tls --web.enable-http2=false &
   ```

3. **Prometheus Configuration (prometheus.yml)**:
   Configuration for Prometheus can be found in the `prometheus.yml` file. Make sure it scrapes **Node Exporter** for metrics:

   ```yaml
   scrape_configs:
     - job_name: 'node'
       static_configs:
         - targets: ['<VM_IP>:9100']
   ```

## Architecture Design

Below is the architecture diagram for the project:

![Architecture Design Diagram](./images/architecture_design_diagram.png)

The diagram illustrates the flow from local VM resource monitoring to cloud-based auto-scaling.

---

## Conclusion

This project demonstrates how to monitor and manage the system resources of a local VM using **Grafana** and **Node Exporter**. By setting up alerts for resource usage and integrating with cloud auto-scaling, the system can automatically scale to handle increased load when necessary.

---

### Repository Structure

```plaintext
/
|-- grafana-dashboard.json   # Grafana dashboard export (JSON)
|-- prometheus.yml           # Prometheus configuration file
|-- node_exporter_setup.sh   # Script to install and configure Node Exporter
|-- auto-scaling-scripts     # Scripts for triggering auto-scaling (AWS, GCP, etc.)
|-- README.md                # This file
```

