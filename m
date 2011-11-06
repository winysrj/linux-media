Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40138 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab1KFUcZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 15:32:25 -0500
Received: by mail-fx0-f46.google.com with SMTP id o14so4498572faa.19
        for <linux-media@vger.kernel.org>; Sun, 06 Nov 2011 12:32:25 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH 07/13] staging: as102: Whitespace and indentation cleanup
Date: Sun,  6 Nov 2011 21:31:44 +0100
Message-Id: <1320611510-3326-8-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
References: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove some unnecessary braces. Replace spaces with tabs where
expected. Replace gcc specific __FUNCTION__ with  C99 __func__.
No functional changes.

Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/as102_drv.c     |   38 +-
 drivers/staging/media/as102/as102_drv.h     |    6 +-
 drivers/staging/media/as102/as102_usb_drv.c |   14 +-
 drivers/staging/media/as102/as10x_cmd.c     |    2 +-
 drivers/staging/media/as102/as10x_cmd.h     |  687 ++++++++++++++-------------
 drivers/staging/media/as102/as10x_handle.h  |    6 +-
 drivers/staging/media/as102/as10x_types.h   |  235 +++++-----
 7 files changed, 493 insertions(+), 495 deletions(-)

diff --git a/drivers/staging/media/as102/as102_drv.c b/drivers/staging/media/as102/as102_drv.c
index e775900..3234039 100644
--- a/drivers/staging/media/as102/as102_drv.c
+++ b/drivers/staging/media/as102/as102_drv.c
@@ -121,22 +121,22 @@ static int as10x_pid_filter(struct as102_dev_t *dev,
 
 	switch (onoff) {
 	case 0:
-	    ret = as10x_cmd_del_PID_filter(bus_adap, (uint16_t) pid);
-	    dprintk(debug, "DEL_PID_FILTER([%02d] 0x%04x) ret = %d\n",
-		    index, pid, ret);
-	    break;
+		ret = as10x_cmd_del_PID_filter(bus_adap, (uint16_t) pid);
+		dprintk(debug, "DEL_PID_FILTER([%02d] 0x%04x) ret = %d\n",
+			index, pid, ret);
+		break;
 	case 1:
 	{
-	    struct as10x_ts_filter filter;
+		struct as10x_ts_filter filter;
 
-	    filter.type = TS_PID_TYPE_TS;
-	    filter.idx = 0xFF;
-	    filter.pid = pid;
+		filter.type = TS_PID_TYPE_TS;
+		filter.idx = 0xFF;
+		filter.pid = pid;
 
-	    ret = as10x_cmd_add_PID_filter(bus_adap, &filter);
-	    dprintk(debug, "ADD_PID_FILTER([%02d -> %02d], 0x%04x) ret = %d\n",
-		    index, filter.idx, filter.pid, ret);
-	    break;
+		ret = as10x_cmd_add_PID_filter(bus_adap, &filter);
+		dprintk(debug, "ADD_PID_FILTER([%02d -> %02d], 0x%04x) ret = %d\n",
+			index, filter.idx, filter.pid, ret);
+		break;
 	}
 	}
 
@@ -157,10 +157,9 @@ static int as102_dvb_dmx_start_feed(struct dvb_demux_feed *dvbdmxfeed)
 	if (mutex_lock_interruptible(&as102_dev->sem))
 		return -ERESTARTSYS;
 
-	if (pid_filtering) {
-		as10x_pid_filter(as102_dev,
-				dvbdmxfeed->index, dvbdmxfeed->pid, 1);
-	}
+	if (pid_filtering)
+		as10x_pid_filter(as102_dev, dvbdmxfeed->index,
+				 dvbdmxfeed->pid, 1);
 
 	if (as102_dev->streaming++ == 0)
 		ret = as102_start_stream(as102_dev);
@@ -183,10 +182,9 @@ static int as102_dvb_dmx_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
 	if (--as102_dev->streaming == 0)
 		as102_stop_stream(as102_dev);
 
-	if (pid_filtering) {
-		as10x_pid_filter(as102_dev,
-				dvbdmxfeed->index, dvbdmxfeed->pid, 0);
-	}
+	if (pid_filtering)
+		as10x_pid_filter(as102_dev, dvbdmxfeed->index,
+				 dvbdmxfeed->pid, 0);
 
 	mutex_unlock(&as102_dev->sem);
 	LEAVE();
diff --git a/drivers/staging/media/as102/as102_drv.h b/drivers/staging/media/as102/as102_drv.h
index af2bf1e..d32019c 100644
--- a/drivers/staging/media/as102/as102_drv.h
+++ b/drivers/staging/media/as102/as102_drv.h
@@ -32,13 +32,13 @@ extern struct usb_driver as102_usb_driver;
 
 #define dprintk(debug, args...) \
 	do { if (debug) {	\
-		printk(KERN_DEBUG "%s: ",__FUNCTION__);	\
+		pr_debug("%s: ", __func__);	\
 		printk(args);	\
 	} } while (0)
 
 #ifdef TRACE
-#define ENTER()                 printk(">> enter %s\n", __FUNCTION__)
-#define LEAVE()                 printk("<< leave %s\n", __FUNCTION__)
+#define ENTER()	pr_debug(">> enter %s\n", __func__)
+#define LEAVE()	pr_debug("<< leave %s\n", __func__)
 #else
 #define ENTER()
 #define LEAVE()
diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index 0a8f12b..e0c3854 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -56,16 +56,16 @@ static const char *as102_device_names[] = {
 };
 
 struct usb_driver as102_usb_driver = {
-	.name       =  DRIVER_FULL_NAME,
-	.probe      =  as102_usb_probe,
-	.disconnect =  as102_usb_disconnect,
-	.id_table   =  as102_usb_id_table
+	.name		= DRIVER_FULL_NAME,
+	.probe		= as102_usb_probe,
+	.disconnect	= as102_usb_disconnect,
+	.id_table	= as102_usb_id_table
 };
 
 static const struct file_operations as102_dev_fops = {
-	.owner   = THIS_MODULE,
-	.open    = as102_open,
-	.release = as102_release,
+	.owner		= THIS_MODULE,
+	.open		= as102_open,
+	.release	= as102_release,
 };
 
 static struct usb_class_driver as102_usb_class_driver = {
diff --git a/drivers/staging/media/as102/as10x_cmd.c b/drivers/staging/media/as102/as10x_cmd.c
index 0dcba80..1663a45 100644
--- a/drivers/staging/media/as102/as10x_cmd.c
+++ b/drivers/staging/media/as102/as10x_cmd.c
@@ -232,7 +232,7 @@ out:
 }
 
 /**
- * send get TPS command to AS10x
+ * as10x_cmd_get_tps - send get TPS command to AS10x
  * @phandle:   pointer to AS10x handle
  * @ptps:      pointer to TPS parameters structure
  *
diff --git a/drivers/staging/media/as102/as10x_cmd.h b/drivers/staging/media/as102/as10x_cmd.h
index 05f7150..9af8862 100644
--- a/drivers/staging/media/as102/as10x_cmd.h
+++ b/drivers/staging/media/as102/as10x_cmd.h
@@ -28,422 +28,423 @@
 /*********************************/
 /*       MACRO DEFINITIONS       */
 /*********************************/
-#define AS10X_CMD_ERROR -1
+#define AS10X_CMD_ERROR		-1
 
-#define SERVICE_PROG_ID        0x0002
-#define SERVICE_PROG_VERSION   0x0001
+#define SERVICE_PROG_ID		0x0002
+#define SERVICE_PROG_VERSION	0x0001
 
-#define HIER_NONE              0x00
-#define HIER_LOW_PRIORITY      0x01
+#define HIER_NONE		0x00
+#define HIER_LOW_PRIORITY	0x01
 
 #define HEADER_SIZE (sizeof(struct as10x_cmd_header_t))
 
 /* context request types */
-#define GET_CONTEXT_DATA        1
-#define SET_CONTEXT_DATA        2
+#define GET_CONTEXT_DATA	1
+#define SET_CONTEXT_DATA	2
 
 /* ODSP suspend modes */
-#define CFG_MODE_ODSP_RESUME  0
-#define CFG_MODE_ODSP_SUSPEND 1
+#define CFG_MODE_ODSP_RESUME	0
+#define CFG_MODE_ODSP_SUSPEND	1
 
 /* Dump memory size */
-#define DUMP_BLOCK_SIZE_MAX   0x20
+#define DUMP_BLOCK_SIZE_MAX	0x20
 
 /*********************************/
 /*     TYPE DEFINITION           */
 /*********************************/
 enum control_proc {
-   CONTROL_PROC_TURNON               = 0x0001,
-   CONTROL_PROC_TURNON_RSP           = 0x0100,
-   CONTROL_PROC_SET_REGISTER         = 0x0002,
-   CONTROL_PROC_SET_REGISTER_RSP     = 0x0200,
-   CONTROL_PROC_GET_REGISTER         = 0x0003,
-   CONTROL_PROC_GET_REGISTER_RSP     = 0x0300,
-   CONTROL_PROC_SETTUNE              = 0x000A,
-   CONTROL_PROC_SETTUNE_RSP          = 0x0A00,
-   CONTROL_PROC_GETTUNESTAT          = 0x000B,
-   CONTROL_PROC_GETTUNESTAT_RSP      = 0x0B00,
-   CONTROL_PROC_GETTPS               = 0x000D,
-   CONTROL_PROC_GETTPS_RSP           = 0x0D00,
-   CONTROL_PROC_SETFILTER            = 0x000E,
-   CONTROL_PROC_SETFILTER_RSP        = 0x0E00,
-   CONTROL_PROC_REMOVEFILTER         = 0x000F,
-   CONTROL_PROC_REMOVEFILTER_RSP     = 0x0F00,
-   CONTROL_PROC_GET_IMPULSE_RESP     = 0x0012,
-   CONTROL_PROC_GET_IMPULSE_RESP_RSP = 0x1200,
-   CONTROL_PROC_START_STREAMING      = 0x0013,
-   CONTROL_PROC_START_STREAMING_RSP  = 0x1300,
-   CONTROL_PROC_STOP_STREAMING       = 0x0014,
-   CONTROL_PROC_STOP_STREAMING_RSP   = 0x1400,
-   CONTROL_PROC_GET_DEMOD_STATS      = 0x0015,
-   CONTROL_PROC_GET_DEMOD_STATS_RSP  = 0x1500,
-   CONTROL_PROC_ELNA_CHANGE_MODE     = 0x0016,
-   CONTROL_PROC_ELNA_CHANGE_MODE_RSP = 0x1600,
-   CONTROL_PROC_ODSP_CHANGE_MODE     = 0x0017,
-   CONTROL_PROC_ODSP_CHANGE_MODE_RSP = 0x1700,
-   CONTROL_PROC_AGC_CHANGE_MODE      = 0x0018,
-   CONTROL_PROC_AGC_CHANGE_MODE_RSP  = 0x1800,
-
-   CONTROL_PROC_CONTEXT              = 0x00FC,
-   CONTROL_PROC_CONTEXT_RSP          = 0xFC00,
-   CONTROL_PROC_DUMP_MEMORY          = 0x00FD,
-   CONTROL_PROC_DUMP_MEMORY_RSP      = 0xFD00,
-   CONTROL_PROC_DUMPLOG_MEMORY       = 0x00FE,
-   CONTROL_PROC_DUMPLOG_MEMORY_RSP   = 0xFE00,
-   CONTROL_PROC_TURNOFF              = 0x00FF,
-   CONTROL_PROC_TURNOFF_RSP          = 0xFF00
+	CONTROL_PROC_TURNON			= 0x0001,
+	CONTROL_PROC_TURNON_RSP			= 0x0100,
+	CONTROL_PROC_SET_REGISTER		= 0x0002,
+	CONTROL_PROC_SET_REGISTER_RSP		= 0x0200,
+	CONTROL_PROC_GET_REGISTER		= 0x0003,
+	CONTROL_PROC_GET_REGISTER_RSP		= 0x0300,
+	CONTROL_PROC_SETTUNE			= 0x000A,
+	CONTROL_PROC_SETTUNE_RSP		= 0x0A00,
+	CONTROL_PROC_GETTUNESTAT		= 0x000B,
+	CONTROL_PROC_GETTUNESTAT_RSP		= 0x0B00,
+	CONTROL_PROC_GETTPS			= 0x000D,
+	CONTROL_PROC_GETTPS_RSP			= 0x0D00,
+	CONTROL_PROC_SETFILTER			= 0x000E,
+	CONTROL_PROC_SETFILTER_RSP		= 0x0E00,
+	CONTROL_PROC_REMOVEFILTER		= 0x000F,
+	CONTROL_PROC_REMOVEFILTER_RSP		= 0x0F00,
+	CONTROL_PROC_GET_IMPULSE_RESP		= 0x0012,
+	CONTROL_PROC_GET_IMPULSE_RESP_RSP	= 0x1200,
+	CONTROL_PROC_START_STREAMING		= 0x0013,
+	CONTROL_PROC_START_STREAMING_RSP	= 0x1300,
+	CONTROL_PROC_STOP_STREAMING		= 0x0014,
+	CONTROL_PROC_STOP_STREAMING_RSP		= 0x1400,
+	CONTROL_PROC_GET_DEMOD_STATS		= 0x0015,
+	CONTROL_PROC_GET_DEMOD_STATS_RSP	= 0x1500,
+	CONTROL_PROC_ELNA_CHANGE_MODE		= 0x0016,
+	CONTROL_PROC_ELNA_CHANGE_MODE_RSP	= 0x1600,
+	CONTROL_PROC_ODSP_CHANGE_MODE		= 0x0017,
+	CONTROL_PROC_ODSP_CHANGE_MODE_RSP	= 0x1700,
+	CONTROL_PROC_AGC_CHANGE_MODE		= 0x0018,
+	CONTROL_PROC_AGC_CHANGE_MODE_RSP	= 0x1800,
+
+	CONTROL_PROC_CONTEXT			= 0x00FC,
+	CONTROL_PROC_CONTEXT_RSP		= 0xFC00,
+	CONTROL_PROC_DUMP_MEMORY		= 0x00FD,
+	CONTROL_PROC_DUMP_MEMORY_RSP		= 0xFD00,
+	CONTROL_PROC_DUMPLOG_MEMORY		= 0x00FE,
+	CONTROL_PROC_DUMPLOG_MEMORY_RSP		= 0xFE00,
+	CONTROL_PROC_TURNOFF			= 0x00FF,
+	CONTROL_PROC_TURNOFF_RSP		= 0xFF00
 };
 
 union as10x_turn_on {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* error */
-      uint8_t error;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+	} rsp;
 } __packed;
 
 union as10x_turn_off {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* error */
-      uint8_t err;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t err;
+	} rsp;
 } __packed;
 
 union as10x_set_tune {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-      /* tune params */
-      struct as10x_tune_args args;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* response error */
-      uint8_t error;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+		/* tune params */
+		struct as10x_tune_args args;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* response error */
+		uint8_t error;
+	} rsp;
 } __packed;
 
 union as10x_get_tune_status {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* response error */
-      uint8_t error;
-      /* tune status */
-      struct as10x_tune_status sts;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* response error */
+		uint8_t error;
+		/* tune status */
+		struct as10x_tune_status sts;
+	} rsp;
 } __packed;
 
 union as10x_get_tps {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* response error */
-      uint8_t error;
-      /* tps details */
-      struct as10x_tps tps;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* response error */
+		uint8_t error;
+		/* tps details */
+		struct as10x_tps tps;
+	} rsp;
 } __packed;
 
 union as10x_common {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t  proc_id;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* response error */
-      uint8_t error;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t  proc_id;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* response error */
+		uint8_t error;
+	} rsp;
 } __packed;
 
 union as10x_add_pid_filter {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t  proc_id;
-      /* PID to filter */
-      uint16_t  pid;
-      /* stream type (MPE, PSI/SI or PES )*/
-      uint8_t stream_type;
-      /* PID index in filter table */
-      uint8_t idx;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* response error */
-      uint8_t error;
-      /* Filter id */
-      uint8_t filter_id;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t  proc_id;
+		/* PID to filter */
+		uint16_t  pid;
+		/* stream type (MPE, PSI/SI or PES )*/
+		uint8_t stream_type;
+		/* PID index in filter table */
+		uint8_t idx;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* response error */
+		uint8_t error;
+		/* Filter id */
+		uint8_t filter_id;
+	} rsp;
 } __packed;
 
 union as10x_del_pid_filter {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t  proc_id;
-      /* PID to remove */
-      uint16_t  pid;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* response error */
-      uint8_t error;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t  proc_id;
+		/* PID to remove */
+		uint16_t  pid;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* response error */
+		uint8_t error;
+	} rsp;
 } __packed;
 
 union as10x_start_streaming {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* error */
-      uint8_t error;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+	} rsp;
 } __packed;
 
 union as10x_stop_streaming {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* error */
-      uint8_t error;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+	} rsp;
 } __packed;
 
 union as10x_get_demod_stats {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* error */
-      uint8_t error;
-      /* demod stats */
-      struct as10x_demod_stats stats;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+		/* demod stats */
+		struct as10x_demod_stats stats;
+	} rsp;
 } __packed;
 
 union as10x_get_impulse_resp {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* error */
-      uint8_t error;
-      /* impulse response ready */
-      uint8_t is_ready;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+		/* impulse response ready */
+		uint8_t is_ready;
+	} rsp;
 } __packed;
 
 union as10x_fw_context {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-      /* value to write (for set context)*/
-      struct as10x_register_value reg_val;
-      /* context tag */
-      uint16_t tag;
-      /* context request type */
-      uint16_t type;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* value read (for get context) */
-      struct as10x_register_value reg_val;
-      /* context request type */
-      uint16_t type;
-      /* error */
-      uint8_t error;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+		/* value to write (for set context)*/
+		struct as10x_register_value reg_val;
+		/* context tag */
+		uint16_t tag;
+		/* context request type */
+		uint16_t type;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* value read (for get context) */
+		struct as10x_register_value reg_val;
+		/* context request type */
+		uint16_t type;
+		/* error */
+		uint8_t error;
+	} rsp;
 } __packed;
 
 union as10x_set_register {
-   /* request */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* register description */
-      struct as10x_register_addr reg_addr;
-      /* register content */
-      struct as10x_register_value reg_val;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* error */
-      uint8_t error;
-   } rsp;
+	/* request */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* register description */
+		struct as10x_register_addr reg_addr;
+		/* register content */
+		struct as10x_register_value reg_val;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+	} rsp;
 } __packed;
 
 union as10x_get_register {
-   /* request */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* register description */
-      struct as10x_register_addr reg_addr;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* error */
-      uint8_t error;
-      /* register content */
-      struct as10x_register_value reg_val;
-   } rsp;
+	/* request */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* register description */
+		struct as10x_register_addr reg_addr;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+		/* register content */
+		struct as10x_register_value reg_val;
+	} rsp;
 } __packed;
 
 union as10x_cfg_change_mode {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-      /* mode */
-      uint8_t mode;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* error */
-      uint8_t error;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+		/* mode */
+		uint8_t mode;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+	} rsp;
 } __packed;
 
 struct as10x_cmd_header_t {
-   uint16_t req_id;
-   uint16_t prog;
-   uint16_t version;
-   uint16_t data_len;
+	uint16_t req_id;
+	uint16_t prog;
+	uint16_t version;
+	uint16_t data_len;
 } __packed;
 
 #define DUMP_BLOCK_SIZE 16
 
 union as10x_dump_memory {
-   /* request */
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-      /* dump memory type request */
-      uint8_t dump_req;
-      /* register description */
-      struct as10x_register_addr reg_addr;
-      /* nb blocks to read */
-      uint16_t num_blocks;
-   } req;
-   /* response */
-   struct {
-      /* response identifier */
-      uint16_t proc_id;
-      /* error */
-      uint8_t error;
-      /* dump response */
-      uint8_t dump_rsp;
-      /* data */
-      union {
-	 uint8_t  data8[DUMP_BLOCK_SIZE];
-	 uint16_t data16[DUMP_BLOCK_SIZE / sizeof(uint16_t)];
-	 uint32_t data32[DUMP_BLOCK_SIZE / sizeof(uint32_t)];
-      } u;
-   } rsp;
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+		/* dump memory type request */
+		uint8_t dump_req;
+		/* register description */
+		struct as10x_register_addr reg_addr;
+		/* nb blocks to read */
+		uint16_t num_blocks;
+	} req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+		/* dump response */
+		uint8_t dump_rsp;
+		/* data */
+		union {
+			uint8_t  data8[DUMP_BLOCK_SIZE];
+			uint16_t data16[DUMP_BLOCK_SIZE / sizeof(uint16_t)];
+			uint32_t data32[DUMP_BLOCK_SIZE / sizeof(uint32_t)];
+		} u;
+	} rsp;
 } __packed;
 
 union as10x_dumplog_memory {
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-      /* dump memory type request */
-      uint8_t dump_req;
-   } req;
-   struct {
-      /* request identifier */
-      uint16_t proc_id;
-      /* error */
-      uint8_t error;
-      /* dump response */
-      uint8_t dump_rsp;
-      /* dump data */
-      uint8_t data[DUMP_BLOCK_SIZE];
-   } rsp;
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+		/* dump memory type request */
+		uint8_t dump_req;
+	} req;
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+		/* dump response */
+		uint8_t dump_rsp;
+		/* dump data */
+		uint8_t data[DUMP_BLOCK_SIZE];
+	} rsp;
 } __packed;
 
 union as10x_raw_data {
-   /* request */
-   struct {
-      uint16_t proc_id;
-      uint8_t data[64 - sizeof(struct as10x_cmd_header_t) -2 /* proc_id */];
-   } req;
-   /* response */
-   struct {
-      uint16_t proc_id;
-      uint8_t error;
-      uint8_t data[64 - sizeof(struct as10x_cmd_header_t) /* header */
-		      - 2 /* proc_id */ - 1 /* rc */];
-   } rsp;
+	/* request */
+	struct {
+		uint16_t proc_id;
+		uint8_t data[64 - sizeof(struct as10x_cmd_header_t)
+			     - 2 /* proc_id */];
+	} req;
+	/* response */
+	struct {
+		uint16_t proc_id;
+		uint8_t error;
+		uint8_t data[64 - sizeof(struct as10x_cmd_header_t)
+			     - 2 /* proc_id */ - 1 /* rc */];
+	} rsp;
 } __packed;
 
 struct as10x_cmd_t {
@@ -472,10 +473,10 @@ struct as10x_cmd_t {
 } __packed;
 
 struct as10x_token_cmd_t {
-   /* token cmd */
-   struct as10x_cmd_t c;
-   /* token response */
-   struct as10x_cmd_t r;
+	/* token cmd */
+	struct as10x_cmd_t c;
+	/* token response */
+	struct as10x_cmd_t r;
 } __packed;
 
 
diff --git a/drivers/staging/media/as102/as10x_handle.h b/drivers/staging/media/as102/as10x_handle.h
index 4f01a76..d67203a 100644
--- a/drivers/staging/media/as102/as10x_handle.h
+++ b/drivers/staging/media/as102/as10x_handle.h
@@ -24,9 +24,9 @@ struct as102_dev_t;
 #include "as10x_cmd.h"
 
 /* values for "mode" field */
-#define REGMODE8         8
-#define REGMODE16        16
-#define REGMODE32        32
+#define REGMODE8	8
+#define REGMODE16	16
+#define REGMODE32	32
 
 struct as102_priv_ops_t {
 	int (*upload_fw_pkt) (struct as102_bus_adapter_t *bus_adap,
diff --git a/drivers/staging/media/as102/as10x_types.h b/drivers/staging/media/as102/as10x_types.h
index 0b27f3a..c40c812 100644
--- a/drivers/staging/media/as102/as10x_types.h
+++ b/drivers/staging/media/as102/as10x_types.h
@@ -26,170 +26,169 @@
 /*********************************/
 
 /* bandwidth constant values */
-#define BW_5_MHZ           0x00
-#define BW_6_MHZ           0x01
-#define BW_7_MHZ           0x02
-#define BW_8_MHZ           0x03
+#define BW_5_MHZ		0x00
+#define BW_6_MHZ		0x01
+#define BW_7_MHZ		0x02
+#define BW_8_MHZ		0x03
 
 /* hierarchy priority selection values */
-#define HIER_NO_PRIORITY   0x00
-#define HIER_LOW_PRIORITY  0x01
-#define HIER_HIGH_PRIORITY 0x02
+#define HIER_NO_PRIORITY	0x00
+#define HIER_LOW_PRIORITY	0x01
+#define HIER_HIGH_PRIORITY	0x02
 
 /* constellation available values */
-#define CONST_QPSK         0x00
-#define CONST_QAM16        0x01
-#define CONST_QAM64        0x02
-#define CONST_UNKNOWN      0xFF
+#define CONST_QPSK		0x00
+#define CONST_QAM16		0x01
+#define CONST_QAM64		0x02
+#define CONST_UNKNOWN		0xFF
 
 /* hierarchy available values */
-#define HIER_NONE         0x00
-#define HIER_ALPHA_1      0x01
-#define HIER_ALPHA_2      0x02
-#define HIER_ALPHA_4      0x03
-#define HIER_UNKNOWN      0xFF
+#define HIER_NONE		0x00
+#define HIER_ALPHA_1		0x01
+#define HIER_ALPHA_2		0x02
+#define HIER_ALPHA_4		0x03
+#define HIER_UNKNOWN		0xFF
 
 /* interleaving available values */
-#define INTLV_NATIVE      0x00
-#define INTLV_IN_DEPTH    0x01
-#define INTLV_UNKNOWN     0xFF
+#define INTLV_NATIVE		0x00
+#define INTLV_IN_DEPTH		0x01
+#define INTLV_UNKNOWN		0xFF
 
 /* code rate available values */
-#define CODE_RATE_1_2     0x00
-#define CODE_RATE_2_3     0x01
-#define CODE_RATE_3_4     0x02
-#define CODE_RATE_5_6     0x03
-#define CODE_RATE_7_8     0x04
-#define CODE_RATE_UNKNOWN 0xFF
+#define CODE_RATE_1_2		0x00
+#define CODE_RATE_2_3		0x01
+#define CODE_RATE_3_4		0x02
+#define CODE_RATE_5_6		0x03
+#define CODE_RATE_7_8		0x04
+#define CODE_RATE_UNKNOWN	0xFF
 
 /* guard interval available values */
-#define GUARD_INT_1_32    0x00
-#define GUARD_INT_1_16    0x01
-#define GUARD_INT_1_8     0x02
-#define GUARD_INT_1_4     0x03
-#define GUARD_UNKNOWN     0xFF
+#define GUARD_INT_1_32		0x00
+#define GUARD_INT_1_16		0x01
+#define GUARD_INT_1_8		0x02
+#define GUARD_INT_1_4		0x03
+#define GUARD_UNKNOWN		0xFF
 
 /* transmission mode available values */
-#define TRANS_MODE_2K      0x00
-#define TRANS_MODE_8K      0x01
-#define TRANS_MODE_4K      0x02
-#define TRANS_MODE_UNKNOWN 0xFF
+#define TRANS_MODE_2K		0x00
+#define TRANS_MODE_8K		0x01
+#define TRANS_MODE_4K		0x02
+#define TRANS_MODE_UNKNOWN	0xFF
 
 /* DVBH signalling available values */
-#define TIMESLICING_PRESENT   0x01
-#define MPE_FEC_PRESENT       0x02
+#define TIMESLICING_PRESENT	0x01
+#define MPE_FEC_PRESENT		0x02
 
 /* tune state available */
-#define TUNE_STATUS_NOT_TUNED       0x00
-#define TUNE_STATUS_IDLE            0x01
-#define TUNE_STATUS_LOCKING         0x02
-#define TUNE_STATUS_SIGNAL_DVB_OK   0x03
-#define TUNE_STATUS_STREAM_DETECTED 0x04
-#define TUNE_STATUS_STREAM_TUNED    0x05
-#define TUNE_STATUS_ERROR           0xFF
+#define TUNE_STATUS_NOT_TUNED		0x00
+#define TUNE_STATUS_IDLE		0x01
+#define TUNE_STATUS_LOCKING		0x02
+#define TUNE_STATUS_SIGNAL_DVB_OK	0x03
+#define TUNE_STATUS_STREAM_DETECTED	0x04
+#define TUNE_STATUS_STREAM_TUNED	0x05
+#define TUNE_STATUS_ERROR		0xFF
 
 /* available TS FID filter types */
-#define TS_PID_TYPE_TS       0
-#define TS_PID_TYPE_PSI_SI   1
-#define TS_PID_TYPE_MPE      2
+#define TS_PID_TYPE_TS		0
+#define TS_PID_TYPE_PSI_SI	1
+#define TS_PID_TYPE_MPE		2
 
 /* number of echos available */
-#define MAX_ECHOS   15
+#define MAX_ECHOS	15
 
 /* Context types */
-#define CONTEXT_LNA                   1010
-#define CONTEXT_ELNA_HYSTERESIS       4003
-#define CONTEXT_ELNA_GAIN             4004
-#define CONTEXT_MER_THRESHOLD         5005
-#define CONTEXT_MER_OFFSET            5006
-#define CONTEXT_IR_STATE              7000
-#define CONTEXT_TSOUT_MSB_FIRST       7004
-#define CONTEXT_TSOUT_FALLING_EDGE    7005
+#define CONTEXT_LNA			1010
+#define CONTEXT_ELNA_HYSTERESIS		4003
+#define CONTEXT_ELNA_GAIN		4004
+#define CONTEXT_MER_THRESHOLD		5005
+#define CONTEXT_MER_OFFSET		5006
+#define CONTEXT_IR_STATE		7000
+#define CONTEXT_TSOUT_MSB_FIRST		7004
+#define CONTEXT_TSOUT_FALLING_EDGE	7005
 
 /* Configuration modes */
-#define CFG_MODE_ON     0
-#define CFG_MODE_OFF    1
-#define CFG_MODE_AUTO   2
+#define CFG_MODE_ON	0
+#define CFG_MODE_OFF	1
+#define CFG_MODE_AUTO	2
 
 struct as10x_tps {
-   uint8_t constellation;
-   uint8_t hierarchy;
-   uint8_t interleaving_mode;
-   uint8_t code_rate_HP;
-   uint8_t code_rate_LP;
-   uint8_t guard_interval;
-   uint8_t transmission_mode;
-   uint8_t DVBH_mask_HP;
-   uint8_t DVBH_mask_LP;
-   uint16_t cell_ID;
+	uint8_t constellation;
+	uint8_t hierarchy;
+	uint8_t interleaving_mode;
+	uint8_t code_rate_HP;
+	uint8_t code_rate_LP;
+	uint8_t guard_interval;
+	uint8_t transmission_mode;
+	uint8_t DVBH_mask_HP;
+	uint8_t DVBH_mask_LP;
+	uint16_t cell_ID;
 } __packed;
 
 struct as10x_tune_args {
-   /* frequency */
-   uint32_t freq;
-   /* bandwidth */
-   uint8_t bandwidth;
-   /* hierarchy selection */
-   uint8_t hier_select;
-   /* constellation */
-   uint8_t constellation;
-   /* hierarchy */
-   uint8_t hierarchy;
-   /* interleaving mode */
-   uint8_t interleaving_mode;
-   /* code rate */
-   uint8_t code_rate;
-   /* guard interval */
-   uint8_t guard_interval;
-   /* transmission mode */
-   uint8_t transmission_mode;
+	/* frequency */
+	uint32_t freq;
+	/* bandwidth */
+	uint8_t bandwidth;
+	/* hierarchy selection */
+	uint8_t hier_select;
+	/* constellation */
+	uint8_t constellation;
+	/* hierarchy */
+	uint8_t hierarchy;
+	/* interleaving mode */
+	uint8_t interleaving_mode;
+	/* code rate */
+	uint8_t code_rate;
+	/* guard interval */
+	uint8_t guard_interval;
+	/* transmission mode */
+	uint8_t transmission_mode;
 } __packed;
 
 struct as10x_tune_status {
-   /* tune status */
-   uint8_t tune_state;
-   /* signal strength */
-   int16_t signal_strength;
-   /* packet error rate 10^-4 */
-   uint16_t PER;
-   /* bit error rate 10^-4 */
-   uint16_t BER;
+	/* tune status */
+	uint8_t tune_state;
+	/* signal strength */
+	int16_t signal_strength;
+	/* packet error rate 10^-4 */
+	uint16_t PER;
+	/* bit error rate 10^-4 */
+	uint16_t BER;
 } __packed;
 
 struct as10x_demod_stats {
-   /* frame counter */
-   uint32_t frame_count;
-   /* Bad frame counter */
-   uint32_t bad_frame_count;
-   /* Number of wrong bytes fixed by Reed-Solomon */
-   uint32_t bytes_fixed_by_rs;
-   /* Averaged MER */
-   uint16_t mer;
-   /* statistics calculation state indicator (started or not) */
-   uint8_t has_started;
+	/* frame counter */
+	uint32_t frame_count;
+	/* Bad frame counter */
+	uint32_t bad_frame_count;
+	/* Number of wrong bytes fixed by Reed-Solomon */
+	uint32_t bytes_fixed_by_rs;
+	/* Averaged MER */
+	uint16_t mer;
+	/* statistics calculation state indicator (started or not) */
+	uint8_t has_started;
 } __packed;
 
 struct as10x_ts_filter {
-   uint16_t pid;  /** valid PID value 0x00 : 0x2000 */
-   uint8_t  type; /** Red TS_PID_TYPE_<N> values */
-   uint8_t  idx;  /** index in filtering table */
+	uint16_t pid;  /* valid PID value 0x00 : 0x2000 */
+	uint8_t  type; /* Red TS_PID_TYPE_<N> values */
+	uint8_t  idx;  /* index in filtering table */
 } __packed;
 
 struct as10x_register_value {
-   uint8_t       mode;
-   union {
-      uint8_t    value8;    /* 8 bit value */
-      uint16_t   value16;   /* 16 bit value */
-      uint32_t   value32;   /* 32 bit value */
-   }u;
+	uint8_t mode;
+	union {
+		uint8_t  value8;   /* 8 bit value */
+		uint16_t value16;  /* 16 bit value */
+		uint32_t value32;  /* 32 bit value */
+	} u;
 } __packed;
 
 struct as10x_register_addr {
-   /* register addr */
-   uint32_t addr;
-   /* register mode access */
-   uint8_t mode;
+	/* register addr */
+	uint32_t addr;
+	/* register mode access */
+	uint8_t mode;
 };
 
-
 #endif
-- 
1.7.5.4

