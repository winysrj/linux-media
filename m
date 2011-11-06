Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40138 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab1KFUcf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 15:32:35 -0500
Received: by mail-fx0-f46.google.com with SMTP id o14so4498572faa.19
        for <linux-media@vger.kernel.org>; Sun, 06 Nov 2011 12:32:34 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH 13/13] staging: as102: Eliminate as10x_handle_t alias
Date: Sun,  6 Nov 2011 21:31:50 +0100
Message-Id: <1320611510-3326-14-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
References: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove pre-processor defined as10x_handle_t data type by directly
replacing it with struct as102_bus_adapter_t. phandle is renamed
to adap inside function bodies.

Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
I'm not sure about this one, maybe something less invasive is needed.
---
 drivers/staging/media/as102/as102_drv.c        |    6 +-
 drivers/staging/media/as102/as102_drv.h        |    4 +-
 drivers/staging/media/as102/as102_fw.c         |    4 +-
 drivers/staging/media/as102/as102_fw.h         |    2 +-
 drivers/staging/media/as102/as102_usb_drv.c    |    6 +-
 drivers/staging/media/as102/as10x_cmd.c        |  137 ++++++++++++------------
 drivers/staging/media/as102/as10x_cmd.h        |   28 +++---
 drivers/staging/media/as102/as10x_cmd_cfg.c    |   66 ++++++------
 drivers/staging/media/as102/as10x_cmd_stream.c |   56 +++++-----
 drivers/staging/media/as102/as10x_handle.h     |   20 ++--
 10 files changed, 163 insertions(+), 166 deletions(-)

diff --git a/drivers/staging/media/as102/as102_drv.c b/drivers/staging/media/as102/as102_drv.c
index 44f6017..b8adfd2 100644
--- a/drivers/staging/media/as102/as102_drv.c
+++ b/drivers/staging/media/as102/as102_drv.c
@@ -60,7 +60,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 static void as102_stop_stream(struct as102_dev_t *dev)
 {
-	struct as102_bus_adapter_t *bus_adap;
+	struct as10x_bus_adapter_t *bus_adap;
 
 	if (dev != NULL)
 		bus_adap = &dev->bus_adap;
@@ -83,7 +83,7 @@ static void as102_stop_stream(struct as102_dev_t *dev)
 
 static int as102_start_stream(struct as102_dev_t *dev)
 {
-	struct as102_bus_adapter_t *bus_adap;
+	struct as10x_bus_adapter_t *bus_adap;
 	int ret = -EFAULT;
 
 	if (dev != NULL)
@@ -109,7 +109,7 @@ static int as102_start_stream(struct as102_dev_t *dev)
 static int as10x_pid_filter(struct as102_dev_t *dev,
 			    int index, u16 pid, int onoff) {
 
-	struct as102_bus_adapter_t *bus_adap = &dev->bus_adap;
+	struct as10x_bus_adapter_t *bus_adap = &dev->bus_adap;
 	int ret = -EFAULT;
 
 	ENTER();
diff --git a/drivers/staging/media/as102/as102_drv.h b/drivers/staging/media/as102/as102_drv.h
index 06466fd..0ecef9e 100644
--- a/drivers/staging/media/as102/as102_drv.h
+++ b/drivers/staging/media/as102/as102_drv.h
@@ -50,7 +50,7 @@ extern int elna_enable;
 #define AS102_USB_BUF_SIZE	512
 #define MAX_STREAM_URB		32
 
-struct as102_bus_adapter_t {
+struct as10x_bus_adapter_t {
 	struct usb_device *usb_dev;
 	/* bus token lock */
 	struct mutex lock;
@@ -72,7 +72,7 @@ struct as102_bus_adapter_t {
 
 struct as102_dev_t {
 	const char *name;
-	struct as102_bus_adapter_t bus_adap;
+	struct as10x_bus_adapter_t bus_adap;
 	struct list_head device_entry;
 	struct kref kref;
 	unsigned long minor;
diff --git a/drivers/staging/media/as102/as102_fw.c b/drivers/staging/media/as102/as102_fw.c
index fa56939..43ebc43 100644
--- a/drivers/staging/media/as102/as102_fw.c
+++ b/drivers/staging/media/as102/as102_fw.c
@@ -101,7 +101,7 @@ static int parse_hex_line(unsigned char *fw_data, unsigned char *addr,
 	return (count * 2) + 2;
 }
 
-static int as102_firmware_upload(struct as102_bus_adapter_t *bus_adap,
+static int as102_firmware_upload(struct as10x_bus_adapter_t *bus_adap,
 				 unsigned char *cmd,
 				 const struct firmware *firmware) {
 
@@ -162,7 +162,7 @@ error:
 	return (errno == 0) ? total_read_bytes : errno;
 }
 
-int as102_fw_upload(struct as102_bus_adapter_t *bus_adap)
+int as102_fw_upload(struct as10x_bus_adapter_t *bus_adap)
 {
 	int errno = -EFAULT;
 	const struct firmware *firmware;
diff --git a/drivers/staging/media/as102/as102_fw.h b/drivers/staging/media/as102/as102_fw.h
index a1fdb92..bd21f05 100644
--- a/drivers/staging/media/as102/as102_fw.h
+++ b/drivers/staging/media/as102/as102_fw.h
@@ -34,5 +34,5 @@ struct as10x_fw_pkt_t {
 } __packed;
 
 #ifdef __KERNEL__
-int as102_fw_upload(struct as102_bus_adapter_t *bus_adap);
+int as102_fw_upload(struct as10x_bus_adapter_t *bus_adap);
 #endif
diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index 97bceeb..9faab5b 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -74,7 +74,7 @@ static struct usb_class_driver as102_usb_class_driver = {
 	.minor_base	= AS102_DEVICE_MAJOR,
 };
 
-static int as102_usb_xfer_cmd(struct as102_bus_adapter_t *bus_adap,
+static int as102_usb_xfer_cmd(struct as10x_bus_adapter_t *bus_adap,
 			      unsigned char *send_buf, int send_buf_len,
 			      unsigned char *recv_buf, int recv_buf_len)
 {
@@ -131,7 +131,7 @@ static int as102_usb_xfer_cmd(struct as102_bus_adapter_t *bus_adap,
 	return ret;
 }
 
-static int as102_send_ep1(struct as102_bus_adapter_t *bus_adap,
+static int as102_send_ep1(struct as10x_bus_adapter_t *bus_adap,
 			  unsigned char *send_buf,
 			  int send_buf_len,
 			  int swap32)
@@ -154,7 +154,7 @@ static int as102_send_ep1(struct as102_bus_adapter_t *bus_adap,
 	return ret ? ret : actual_len;
 }
 
-static int as102_read_ep2(struct as102_bus_adapter_t *bus_adap,
+static int as102_read_ep2(struct as10x_bus_adapter_t *bus_adap,
 		   unsigned char *recv_buf, int recv_buf_len)
 {
 	int ret = 0, actual_len;
diff --git a/drivers/staging/media/as102/as10x_cmd.c b/drivers/staging/media/as102/as10x_cmd.c
index 1663a45..0387bb8 100644
--- a/drivers/staging/media/as102/as10x_cmd.c
+++ b/drivers/staging/media/as102/as10x_cmd.c
@@ -25,35 +25,35 @@
 
 /**
  * as10x_cmd_turn_on - send turn on command to AS10x
- * @phandle:   pointer to AS10x handle
+ * @adap:   pointer to AS10x bus adapter
  *
  * Return 0 when no error, < 0 in case of error.
  */
-int as10x_cmd_turn_on(as10x_handle_t *phandle)
+int as10x_cmd_turn_on(struct as10x_bus_adapter_t *adap)
 {
 	int error;
 	struct as10x_cmd_t *pcmd, *prsp;
 
 	ENTER();
 
-	pcmd = phandle->cmd;
-	prsp = phandle->rsp;
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
 
 	/* prepare command */
-	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
 			sizeof(pcmd->body.turn_on.req));
 
 	/* fill command */
 	pcmd->body.turn_on.req.proc_id = cpu_to_le16(CONTROL_PROC_TURNON);
 
 	/* send command */
-	if (phandle->ops->xfer_cmd) {
-		error = phandle->ops->xfer_cmd(phandle, (uint8_t *) pcmd,
-					       sizeof(pcmd->body.turn_on.req) +
-					       HEADER_SIZE,
-					       (uint8_t *) prsp,
-					       sizeof(prsp->body.turn_on.rsp) +
-					       HEADER_SIZE);
+	if (adap->ops->xfer_cmd) {
+		error = adap->ops->xfer_cmd(adap, (uint8_t *) pcmd,
+					    sizeof(pcmd->body.turn_on.req) +
+					    HEADER_SIZE,
+					    (uint8_t *) prsp,
+					    sizeof(prsp->body.turn_on.rsp) +
+					    HEADER_SIZE);
 	} else {
 		error = AS10X_CMD_ERROR;
 	}
@@ -71,31 +71,31 @@ out:
 
 /**
  * as10x_cmd_turn_off - send turn off command to AS10x
- * @phandle:   pointer to AS10x handle
+ * @adap:   pointer to AS10x bus adapter
  *
  * Return 0 on success or negative value in case of error.
  */
-int as10x_cmd_turn_off(as10x_handle_t *phandle)
+int as10x_cmd_turn_off(struct as10x_bus_adapter_t *adap)
 {
 	int error;
 	struct as10x_cmd_t *pcmd, *prsp;
 
 	ENTER();
 
-	pcmd = phandle->cmd;
-	prsp = phandle->rsp;
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
 
 	/* prepare command */
-	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
 			sizeof(pcmd->body.turn_off.req));
 
 	/* fill command */
 	pcmd->body.turn_off.req.proc_id = cpu_to_le16(CONTROL_PROC_TURNOFF);
 
 	/* send command */
-	if (phandle->ops->xfer_cmd) {
-		error = phandle->ops->xfer_cmd(
-			phandle, (uint8_t *) pcmd,
+	if (adap->ops->xfer_cmd) {
+		error = adap->ops->xfer_cmd(
+			adap, (uint8_t *) pcmd,
 			sizeof(pcmd->body.turn_off.req) + HEADER_SIZE,
 			(uint8_t *) prsp,
 			sizeof(prsp->body.turn_off.rsp) + HEADER_SIZE);
@@ -116,23 +116,24 @@ out:
 
 /**
  * as10x_cmd_set_tune - send set tune command to AS10x
- * @phandle: pointer to AS10x handle
+ * @adap:    pointer to AS10x bus adapter
  * @ptune:   tune parameters
  *
  * Return 0 on success or negative value in case of error.
  */
-int as10x_cmd_set_tune(as10x_handle_t *phandle, struct as10x_tune_args *ptune)
+int as10x_cmd_set_tune(struct as10x_bus_adapter_t *adap,
+		       struct as10x_tune_args *ptune)
 {
 	int error;
 	struct as10x_cmd_t *preq, *prsp;
 
 	ENTER();
 
-	preq = phandle->cmd;
-	prsp = phandle->rsp;
+	preq = adap->cmd;
+	prsp = adap->rsp;
 
 	/* prepare command */
-	as10x_cmd_build(preq, (++phandle->cmd_xid),
+	as10x_cmd_build(preq, (++adap->cmd_xid),
 			sizeof(preq->body.set_tune.req));
 
 	/* fill command */
@@ -150,14 +151,14 @@ int as10x_cmd_set_tune(as10x_handle_t *phandle, struct as10x_tune_args *ptune)
 		ptune->transmission_mode;
 
 	/* send command */
-	if (phandle->ops->xfer_cmd) {
-		error = phandle->ops->xfer_cmd(phandle,
-					       (uint8_t *) preq,
-					       sizeof(preq->body.set_tune.req)
-					       + HEADER_SIZE,
-					       (uint8_t *) prsp,
-					       sizeof(prsp->body.set_tune.rsp)
-					       + HEADER_SIZE);
+	if (adap->ops->xfer_cmd) {
+		error = adap->ops->xfer_cmd(adap,
+					    (uint8_t *) preq,
+					    sizeof(preq->body.set_tune.req)
+					    + HEADER_SIZE,
+					    (uint8_t *) prsp,
+					    sizeof(prsp->body.set_tune.rsp)
+					    + HEADER_SIZE);
 	} else {
 		error = AS10X_CMD_ERROR;
 	}
@@ -175,12 +176,12 @@ out:
 
 /**
  * as10x_cmd_get_tune_status - send get tune status command to AS10x
- * @phandle: pointer to AS10x handle
+ * @adap: pointer to AS10x bus adapter
  * @pstatus: pointer to updated status structure of the current tune
  *
  * Return 0 on success or negative value in case of error.
  */
-int as10x_cmd_get_tune_status(as10x_handle_t *phandle,
+int as10x_cmd_get_tune_status(struct as10x_bus_adapter_t *adap,
 			      struct as10x_tune_status *pstatus)
 {
 	int error;
@@ -188,11 +189,11 @@ int as10x_cmd_get_tune_status(as10x_handle_t *phandle,
 
 	ENTER();
 
-	preq = phandle->cmd;
-	prsp = phandle->rsp;
+	preq = adap->cmd;
+	prsp = adap->rsp;
 
 	/* prepare command */
-	as10x_cmd_build(preq, (++phandle->cmd_xid),
+	as10x_cmd_build(preq, (++adap->cmd_xid),
 			sizeof(preq->body.get_tune_status.req));
 
 	/* fill command */
@@ -200,9 +201,9 @@ int as10x_cmd_get_tune_status(as10x_handle_t *phandle,
 		cpu_to_le16(CONTROL_PROC_GETTUNESTAT);
 
 	/* send command */
-	if (phandle->ops->xfer_cmd) {
-		error = phandle->ops->xfer_cmd(
-			phandle,
+	if (adap->ops->xfer_cmd) {
+		error = adap->ops->xfer_cmd(
+			adap,
 			(uint8_t *) preq,
 			sizeof(preq->body.get_tune_status.req) + HEADER_SIZE,
 			(uint8_t *) prsp,
@@ -233,23 +234,23 @@ out:
 
 /**
  * as10x_cmd_get_tps - send get TPS command to AS10x
- * @phandle:   pointer to AS10x handle
+ * @adap:      pointer to AS10x handle
  * @ptps:      pointer to TPS parameters structure
  *
  * Return 0 on success or negative value in case of error.
  */
-int as10x_cmd_get_tps(as10x_handle_t *phandle, struct as10x_tps *ptps)
+int as10x_cmd_get_tps(struct as10x_bus_adapter_t *adap, struct as10x_tps *ptps)
 {
 	int error;
 	struct as10x_cmd_t *pcmd, *prsp;
 
 	ENTER();
 
-	pcmd = phandle->cmd;
-	prsp = phandle->rsp;
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
 
 	/* prepare command */
-	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
 			sizeof(pcmd->body.get_tps.req));
 
 	/* fill command */
@@ -257,14 +258,14 @@ int as10x_cmd_get_tps(as10x_handle_t *phandle, struct as10x_tps *ptps)
 		cpu_to_le16(CONTROL_PROC_GETTPS);
 
 	/* send command */
-	if (phandle->ops->xfer_cmd) {
-		error = phandle->ops->xfer_cmd(phandle,
-					       (uint8_t *) pcmd,
-					       sizeof(pcmd->body.get_tps.req) +
-					       HEADER_SIZE,
-					       (uint8_t *) prsp,
-					       sizeof(prsp->body.get_tps.rsp) +
-					       HEADER_SIZE);
+	if (adap->ops->xfer_cmd) {
+		error = adap->ops->xfer_cmd(adap,
+					    (uint8_t *) pcmd,
+					    sizeof(pcmd->body.get_tps.req) +
+					    HEADER_SIZE,
+					    (uint8_t *) prsp,
+					    sizeof(prsp->body.get_tps.rsp) +
+					    HEADER_SIZE);
 	} else {
 		error = AS10X_CMD_ERROR;
 	}
@@ -296,12 +297,12 @@ out:
 
 /**
  * as10x_cmd_get_demod_stats - send get demod stats command to AS10x
- * @phandle:       pointer to AS10x handle
+ * @adap:          pointer to AS10x bus adapter
  * @pdemod_stats:  pointer to demod stats parameters structure
  *
  * Return 0 on success or negative value in case of error.
  */
-int as10x_cmd_get_demod_stats(as10x_handle_t  *phandle,
+int as10x_cmd_get_demod_stats(struct as10x_bus_adapter_t *adap,
 			      struct as10x_demod_stats *pdemod_stats)
 {
 	int error;
@@ -309,11 +310,11 @@ int as10x_cmd_get_demod_stats(as10x_handle_t  *phandle,
 
 	ENTER();
 
-	pcmd = phandle->cmd;
-	prsp = phandle->rsp;
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
 
 	/* prepare command */
-	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
 			sizeof(pcmd->body.get_demod_stats.req));
 
 	/* fill command */
@@ -321,8 +322,8 @@ int as10x_cmd_get_demod_stats(as10x_handle_t  *phandle,
 		cpu_to_le16(CONTROL_PROC_GET_DEMOD_STATS);
 
 	/* send command */
-	if (phandle->ops->xfer_cmd) {
-		error = phandle->ops->xfer_cmd(phandle,
+	if (adap->ops->xfer_cmd) {
+		error = adap->ops->xfer_cmd(adap,
 				(uint8_t *) pcmd,
 				sizeof(pcmd->body.get_demod_stats.req)
 				+ HEADER_SIZE,
@@ -360,13 +361,13 @@ out:
 
 /**
  * as10x_cmd_get_impulse_resp - send get impulse response command to AS10x
- * @phandle:  pointer to AS10x handle
+ * @adap:     pointer to AS10x bus adapter
  * @is_ready: pointer to value indicating when impulse
  *	      response data is ready
  *
  * Return 0 on success or negative value in case of error.
  */
-int as10x_cmd_get_impulse_resp(as10x_handle_t     *phandle,
+int as10x_cmd_get_impulse_resp(struct as10x_bus_adapter_t *adap,
 			       uint8_t *is_ready)
 {
 	int error;
@@ -374,11 +375,11 @@ int as10x_cmd_get_impulse_resp(as10x_handle_t     *phandle,
 
 	ENTER();
 
-	pcmd = phandle->cmd;
-	prsp = phandle->rsp;
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
 
 	/* prepare command */
-	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
 			sizeof(pcmd->body.get_impulse_rsp.req));
 
 	/* fill command */
@@ -386,8 +387,8 @@ int as10x_cmd_get_impulse_resp(as10x_handle_t     *phandle,
 		cpu_to_le16(CONTROL_PROC_GET_IMPULSE_RESP);
 
 	/* send command */
-	if (phandle->ops->xfer_cmd) {
-		error = phandle->ops->xfer_cmd(phandle,
+	if (adap->ops->xfer_cmd) {
+		error = adap->ops->xfer_cmd(adap,
 					(uint8_t *) pcmd,
 					sizeof(pcmd->body.get_impulse_rsp.req)
 					+ HEADER_SIZE,
diff --git a/drivers/staging/media/as102/as10x_cmd.h b/drivers/staging/media/as102/as10x_cmd.h
index da31c6d..4ea249e 100644
--- a/drivers/staging/media/as102/as10x_cmd.h
+++ b/drivers/staging/media/as102/as10x_cmd.h
@@ -489,41 +489,41 @@ void as10x_cmd_build(struct as10x_cmd_t *pcmd, uint16_t proc_id,
 int as10x_rsp_parse(struct as10x_cmd_t *r, uint16_t proc_id);
 
 /* as10x cmd */
-int as10x_cmd_turn_on(as10x_handle_t *phandle);
-int as10x_cmd_turn_off(as10x_handle_t *phandle);
+int as10x_cmd_turn_on(struct as10x_bus_adapter_t *adap);
+int as10x_cmd_turn_off(struct as10x_bus_adapter_t *adap);
 
-int as10x_cmd_set_tune(as10x_handle_t *phandle,
+int as10x_cmd_set_tune(struct as10x_bus_adapter_t *adap,
 		       struct as10x_tune_args *ptune);
 
-int as10x_cmd_get_tune_status(as10x_handle_t *phandle,
+int as10x_cmd_get_tune_status(struct as10x_bus_adapter_t *adap,
 			      struct as10x_tune_status *pstatus);
 
-int as10x_cmd_get_tps(as10x_handle_t *phandle,
+int as10x_cmd_get_tps(struct as10x_bus_adapter_t *adap,
 		      struct as10x_tps *ptps);
 
-int as10x_cmd_get_demod_stats(as10x_handle_t  *phandle,
+int as10x_cmd_get_demod_stats(struct as10x_bus_adapter_t  *adap,
 			      struct as10x_demod_stats *pdemod_stats);
 
-int as10x_cmd_get_impulse_resp(as10x_handle_t *phandle,
+int as10x_cmd_get_impulse_resp(struct as10x_bus_adapter_t *adap,
 			       uint8_t *is_ready);
 
 /* as10x cmd stream */
-int as10x_cmd_add_PID_filter(as10x_handle_t *phandle,
+int as10x_cmd_add_PID_filter(struct as10x_bus_adapter_t *adap,
 			     struct as10x_ts_filter *filter);
-int as10x_cmd_del_PID_filter(as10x_handle_t *phandle,
+int as10x_cmd_del_PID_filter(struct as10x_bus_adapter_t *adap,
 			     uint16_t pid_value);
 
-int as10x_cmd_start_streaming(as10x_handle_t *phandle);
-int as10x_cmd_stop_streaming(as10x_handle_t *phandle);
+int as10x_cmd_start_streaming(struct as10x_bus_adapter_t *adap);
+int as10x_cmd_stop_streaming(struct as10x_bus_adapter_t *adap);
 
 /* as10x cmd cfg */
-int as10x_cmd_set_context(as10x_handle_t *phandle,
+int as10x_cmd_set_context(struct as10x_bus_adapter_t *adap,
 			  uint16_t tag,
 			  uint32_t value);
-int as10x_cmd_get_context(as10x_handle_t *phandle,
+int as10x_cmd_get_context(struct as10x_bus_adapter_t *adap,
 			  uint16_t tag,
 			  uint32_t *pvalue);
 
-int as10x_cmd_eLNA_change_mode(as10x_handle_t *phandle, uint8_t mode);
+int as10x_cmd_eLNA_change_mode(struct as10x_bus_adapter_t *adap, uint8_t mode);
 int as10x_context_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id);
 #endif
diff --git a/drivers/staging/media/as102/as10x_cmd_cfg.c b/drivers/staging/media/as102/as10x_cmd_cfg.c
index ec6f69f..d2a4bce 100644
--- a/drivers/staging/media/as102/as10x_cmd_cfg.c
+++ b/drivers/staging/media/as102/as10x_cmd_cfg.c
@@ -28,13 +28,13 @@
 
 /**
  * as10x_cmd_get_context - Send get context command to AS10x
- * @phandle:   pointer to AS10x handle
+ * @adap:      pointer to AS10x bus adapter
  * @tag:       context tag
  * @pvalue:    pointer where to store context value read
  *
  * Return 0 on success or negative value in case of error.
  */
-int as10x_cmd_get_context(as10x_handle_t *phandle, uint16_t tag,
+int as10x_cmd_get_context(struct as10x_bus_adapter_t *adap, uint16_t tag,
 			  uint32_t *pvalue)
 {
 	int  error;
@@ -42,11 +42,11 @@ int as10x_cmd_get_context(as10x_handle_t *phandle, uint16_t tag,
 
 	ENTER();
 
-	pcmd = phandle->cmd;
-	prsp = phandle->rsp;
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
 
 	/* prepare command */
-	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
 			sizeof(pcmd->body.context.req));
 
 	/* fill command */
@@ -55,14 +55,14 @@ int as10x_cmd_get_context(as10x_handle_t *phandle, uint16_t tag,
 	pcmd->body.context.req.type = cpu_to_le16(GET_CONTEXT_DATA);
 
 	/* send command */
-	if (phandle->ops->xfer_cmd) {
-		error  = phandle->ops->xfer_cmd(phandle,
-						(uint8_t *) pcmd,
-						sizeof(pcmd->body.context.req)
-						+ HEADER_SIZE,
-						(uint8_t *) prsp,
-						sizeof(prsp->body.context.rsp)
-						+ HEADER_SIZE);
+	if (adap->ops->xfer_cmd) {
+		error  = adap->ops->xfer_cmd(adap,
+					     (uint8_t *) pcmd,
+					     sizeof(pcmd->body.context.req)
+					     + HEADER_SIZE,
+					     (uint8_t *) prsp,
+					     sizeof(prsp->body.context.rsp)
+					     + HEADER_SIZE);
 	} else {
 		error = AS10X_CMD_ERROR;
 	}
@@ -87,13 +87,13 @@ out:
 
 /**
  * as10x_cmd_set_context - send set context command to AS10x
- * @phandle:   pointer to AS10x handle
+ * @adap:      pointer to AS10x bus adapter
  * @tag:       context tag
  * @value:     value to set in context
  *
  * Return 0 on success or negative value in case of error.
  */
-int as10x_cmd_set_context(as10x_handle_t *phandle, uint16_t tag,
+int as10x_cmd_set_context(struct as10x_bus_adapter_t *adap, uint16_t tag,
 			  uint32_t value)
 {
 	int error;
@@ -101,11 +101,11 @@ int as10x_cmd_set_context(as10x_handle_t *phandle, uint16_t tag,
 
 	ENTER();
 
-	pcmd = phandle->cmd;
-	prsp = phandle->rsp;
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
 
 	/* prepare command */
-	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
 			sizeof(pcmd->body.context.req));
 
 	/* fill command */
@@ -116,14 +116,14 @@ int as10x_cmd_set_context(as10x_handle_t *phandle, uint16_t tag,
 	pcmd->body.context.req.type = cpu_to_le16(SET_CONTEXT_DATA);
 
 	/* send command */
-	if (phandle->ops->xfer_cmd) {
-		error  = phandle->ops->xfer_cmd(phandle,
-						(uint8_t *) pcmd,
-						sizeof(pcmd->body.context.req)
-						+ HEADER_SIZE,
-						(uint8_t *) prsp,
-						sizeof(prsp->body.context.rsp)
-						+ HEADER_SIZE);
+	if (adap->ops->xfer_cmd) {
+		error  = adap->ops->xfer_cmd(adap,
+					     (uint8_t *) pcmd,
+					     sizeof(pcmd->body.context.req)
+					     + HEADER_SIZE,
+					     (uint8_t *) prsp,
+					     sizeof(prsp->body.context.rsp)
+					     + HEADER_SIZE);
 	} else {
 		error = AS10X_CMD_ERROR;
 	}
@@ -142,7 +142,7 @@ out:
 
 /**
  * as10x_cmd_eLNA_change_mode - send eLNA change mode command to AS10x
- * @phandle:   pointer to AS10x handle
+ * @adap:      pointer to AS10x bus adapter
  * @mode:      mode selected:
  *	        - ON    : 0x0 => eLNA always ON
  *	        - OFF   : 0x1 => eLNA always OFF
@@ -151,18 +151,18 @@ out:
  *
  * Return 0 on success or negative value in case of error.
  */
-int as10x_cmd_eLNA_change_mode(as10x_handle_t *phandle, uint8_t mode)
+int as10x_cmd_eLNA_change_mode(struct as10x_bus_adapter_t *adap, uint8_t mode)
 {
 	int error;
 	struct as10x_cmd_t *pcmd, *prsp;
 
 	ENTER();
 
-	pcmd = phandle->cmd;
-	prsp = phandle->rsp;
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
 
 	/* prepare command */
-	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
 			sizeof(pcmd->body.cfg_change_mode.req));
 
 	/* fill command */
@@ -171,8 +171,8 @@ int as10x_cmd_eLNA_change_mode(as10x_handle_t *phandle, uint8_t mode)
 	pcmd->body.cfg_change_mode.req.mode = mode;
 
 	/* send command */
-	if (phandle->ops->xfer_cmd) {
-		error  = phandle->ops->xfer_cmd(phandle, (uint8_t *) pcmd,
+	if (adap->ops->xfer_cmd) {
+		error  = adap->ops->xfer_cmd(adap, (uint8_t *) pcmd,
 				sizeof(pcmd->body.cfg_change_mode.req)
 				+ HEADER_SIZE, (uint8_t *) prsp,
 				sizeof(prsp->body.cfg_change_mode.rsp)
diff --git a/drivers/staging/media/as102/as10x_cmd_stream.c b/drivers/staging/media/as102/as10x_cmd_stream.c
index 045c706..6d000f6 100644
--- a/drivers/staging/media/as102/as10x_cmd_stream.c
+++ b/drivers/staging/media/as102/as10x_cmd_stream.c
@@ -23,12 +23,12 @@
 
 /**
  * as10x_cmd_add_PID_filter - send add filter command to AS10x
- * @phandle:   pointer to AS10x handle
+ * @adap:      pointer to AS10x bus adapter
  * @filter:    TSFilter filter for DVB-T
  *
  * Return 0 on success or negative value in case of error.
  */
-int as10x_cmd_add_PID_filter(as10x_handle_t *phandle,
+int as10x_cmd_add_PID_filter(struct as10x_bus_adapter_t *adap,
 			     struct as10x_ts_filter *filter)
 {
 	int error;
@@ -36,11 +36,11 @@ int as10x_cmd_add_PID_filter(as10x_handle_t *phandle,
 
 	ENTER();
 
-	pcmd = phandle->cmd;
-	prsp = phandle->rsp;
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
 
 	/* prepare command */
-	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
 			sizeof(pcmd->body.add_pid_filter.req));
 
 	/* fill command */
@@ -55,8 +55,8 @@ int as10x_cmd_add_PID_filter(as10x_handle_t *phandle,
 		pcmd->body.add_pid_filter.req.idx = 0xFF;
 
 	/* send command */
-	if (phandle->ops->xfer_cmd) {
-		error = phandle->ops->xfer_cmd(phandle, (uint8_t *) pcmd,
+	if (adap->ops->xfer_cmd) {
+		error = adap->ops->xfer_cmd(adap, (uint8_t *) pcmd,
 				sizeof(pcmd->body.add_pid_filter.req)
 				+ HEADER_SIZE, (uint8_t *) prsp,
 				sizeof(prsp->body.add_pid_filter.rsp)
@@ -83,12 +83,12 @@ out:
 
 /**
  * as10x_cmd_del_PID_filter - Send delete filter command to AS10x
- * @phandle:      pointer to AS10x handle
+ * @adap:         pointer to AS10x bus adapte
  * @pid_value:    PID to delete
  *
  * Return 0 on success or negative value in case of error.
  */
-int as10x_cmd_del_PID_filter(as10x_handle_t *phandle,
+int as10x_cmd_del_PID_filter(struct as10x_bus_adapter_t *adap,
 			     uint16_t pid_value)
 {
 	int error;
@@ -96,11 +96,11 @@ int as10x_cmd_del_PID_filter(as10x_handle_t *phandle,
 
 	ENTER();
 
-	pcmd = phandle->cmd;
-	prsp = phandle->rsp;
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
 
 	/* prepare command */
-	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
 			sizeof(pcmd->body.del_pid_filter.req));
 
 	/* fill command */
@@ -109,8 +109,8 @@ int as10x_cmd_del_PID_filter(as10x_handle_t *phandle,
 	pcmd->body.del_pid_filter.req.pid = cpu_to_le16(pid_value);
 
 	/* send command */
-	if (phandle->ops->xfer_cmd) {
-		error = phandle->ops->xfer_cmd(phandle, (uint8_t *) pcmd,
+	if (adap->ops->xfer_cmd) {
+		error = adap->ops->xfer_cmd(adap, (uint8_t *) pcmd,
 				sizeof(pcmd->body.del_pid_filter.req)
 				+ HEADER_SIZE, (uint8_t *) prsp,
 				sizeof(prsp->body.del_pid_filter.rsp)
@@ -132,22 +132,22 @@ out:
 
 /**
  * as10x_cmd_start_streaming - Send start streaming command to AS10x
- * @phandle:   pointer to AS10x handle
+ * @adap:   pointer to AS10x bus adapter
  *
  * Return 0 on success or negative value in case of error.
  */
-int as10x_cmd_start_streaming(as10x_handle_t *phandle)
+int as10x_cmd_start_streaming(struct as10x_bus_adapter_t *adap)
 {
 	int error;
 	struct as10x_cmd_t *pcmd, *prsp;
 
 	ENTER();
 
-	pcmd = phandle->cmd;
-	prsp = phandle->rsp;
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
 
 	/* prepare command */
-	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
 			sizeof(pcmd->body.start_streaming.req));
 
 	/* fill command */
@@ -155,8 +155,8 @@ int as10x_cmd_start_streaming(as10x_handle_t *phandle)
 		cpu_to_le16(CONTROL_PROC_START_STREAMING);
 
 	/* send command */
-	if (phandle->ops->xfer_cmd) {
-		error = phandle->ops->xfer_cmd(phandle, (uint8_t *) pcmd,
+	if (adap->ops->xfer_cmd) {
+		error = adap->ops->xfer_cmd(adap, (uint8_t *) pcmd,
 				sizeof(pcmd->body.start_streaming.req)
 				+ HEADER_SIZE, (uint8_t *) prsp,
 				sizeof(prsp->body.start_streaming.rsp)
@@ -178,22 +178,22 @@ out:
 
 /**
  * as10x_cmd_stop_streaming - Send stop streaming command to AS10x
- * @phandle:   pointer to AS10x handle
+ * @adap:   pointer to AS10x bus adapter
  *
  * Return 0 on success or negative value in case of error.
  */
-int as10x_cmd_stop_streaming(as10x_handle_t *phandle)
+int as10x_cmd_stop_streaming(struct as10x_bus_adapter_t *adap)
 {
 	int8_t error;
 	struct as10x_cmd_t *pcmd, *prsp;
 
 	ENTER();
 
-	pcmd = phandle->cmd;
-	prsp = phandle->rsp;
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
 
 	/* prepare command */
-	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
 			sizeof(pcmd->body.stop_streaming.req));
 
 	/* fill command */
@@ -201,8 +201,8 @@ int as10x_cmd_stop_streaming(as10x_handle_t *phandle)
 		cpu_to_le16(CONTROL_PROC_STOP_STREAMING);
 
 	/* send command */
-	if (phandle->ops->xfer_cmd) {
-		error = phandle->ops->xfer_cmd(phandle, (uint8_t *) pcmd,
+	if (adap->ops->xfer_cmd) {
+		error = adap->ops->xfer_cmd(adap, (uint8_t *) pcmd,
 				sizeof(pcmd->body.stop_streaming.req)
 				+ HEADER_SIZE, (uint8_t *) prsp,
 				sizeof(prsp->body.stop_streaming.rsp)
diff --git a/drivers/staging/media/as102/as10x_handle.h b/drivers/staging/media/as102/as10x_handle.h
index d67203a..62b9795 100644
--- a/drivers/staging/media/as102/as10x_handle.h
+++ b/drivers/staging/media/as102/as10x_handle.h
@@ -17,10 +17,9 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 #ifdef __KERNEL__
-struct as102_bus_adapter_t;
+struct as10x_bus_adapter_t;
 struct as102_dev_t;
 
-#define as10x_handle_t struct as102_bus_adapter_t
 #include "as10x_cmd.h"
 
 /* values for "mode" field */
@@ -29,29 +28,26 @@ struct as102_dev_t;
 #define REGMODE32	32
 
 struct as102_priv_ops_t {
-	int (*upload_fw_pkt) (struct as102_bus_adapter_t *bus_adap,
+	int (*upload_fw_pkt) (struct as10x_bus_adapter_t *bus_adap,
 			      unsigned char *buf, int buflen, int swap32);
 
-	int (*send_cmd) (struct as102_bus_adapter_t *bus_adap,
+	int (*send_cmd) (struct as10x_bus_adapter_t *bus_adap,
 			 unsigned char *buf, int buflen);
 
-	int (*xfer_cmd) (struct as102_bus_adapter_t *bus_adap,
+	int (*xfer_cmd) (struct as10x_bus_adapter_t *bus_adap,
 			 unsigned char *send_buf, int send_buf_len,
 			 unsigned char *recv_buf, int recv_buf_len);
-/*
-	int (*pid_filter) (struct as102_bus_adapter_t *bus_adap,
-			   int index, u16 pid, int onoff);
-*/
+
 	int (*start_stream) (struct as102_dev_t *dev);
 	void (*stop_stream) (struct as102_dev_t *dev);
 
-	int (*reset_target) (struct as102_bus_adapter_t *bus_adap);
+	int (*reset_target) (struct as10x_bus_adapter_t *bus_adap);
 
-	int (*read_write)(struct as102_bus_adapter_t *bus_adap, uint8_t mode,
+	int (*read_write)(struct as10x_bus_adapter_t *bus_adap, uint8_t mode,
 			  uint32_t rd_addr, uint16_t rd_len,
 			  uint32_t wr_addr, uint16_t wr_len);
 
-	int (*as102_read_ep2) (struct as102_bus_adapter_t *bus_adap,
+	int (*as102_read_ep2) (struct as10x_bus_adapter_t *bus_adap,
 			       unsigned char *recv_buf,
 			       int recv_buf_len);
 };
-- 
1.7.5.4

