Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:33175 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1039993AbdDUS33 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Apr 2017 14:29:29 -0400
Received: by mail-qk0-f171.google.com with SMTP id h67so78720253qke.0
        for <linux-media@vger.kernel.org>; Fri, 21 Apr 2017 11:29:28 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Michael Ira Krufky <mkrufky@linuxtv.org>
Subject: [PATCH] mxl111sf: Fix driver to use heap allocate buffers for USB messages
Date: Fri, 21 Apr 2017 12:28:37 -0400
Message-Id: <1492792117-13287-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The recent changes in 4.9 to mandate USB buffers be heap allocated
broke this driver, which was allocating the buffers on the stack.
This resulted in the device failing at initialization.

Introduce dedicated send/receive buffers as part of the state
structure, and add a mutex to protect access to them.

Note: we also had to tweak the API to mxl111sf_ctrl_msg to pass
the pointer to the state struct rather than the device, since
we need it inside the function to access the buffers and the
mutex.  This patch adjusts the callers to match the API change.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Reported-by: Doug Lung <dlung0@gmail.com>
Cc: Michael Ira Krufky <mkrufky@linuxtv.org>
---
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c |  4 ++--
 drivers/media/usb/dvb-usb-v2/mxl111sf.c     | 32 +++++++++++++++++------------
 drivers/media/usb/dvb-usb-v2/mxl111sf.h     |  8 +++++++-
 3 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c b/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c
index ffb49c2..0eb33e04 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c
@@ -316,7 +316,7 @@ static int mxl111sf_i2c_sw_xfer_msg(struct mxl111sf_state *state,
 static int mxl111sf_i2c_send_data(struct mxl111sf_state *state,
 				  u8 index, u8 *wdata)
 {
-	int ret = mxl111sf_ctrl_msg(state->d, wdata[0],
+	int ret = mxl111sf_ctrl_msg(state, wdata[0],
 				    &wdata[1], 25, NULL, 0);
 	mxl_fail(ret);
 
@@ -326,7 +326,7 @@ static int mxl111sf_i2c_send_data(struct mxl111sf_state *state,
 static int mxl111sf_i2c_get_data(struct mxl111sf_state *state,
 				 u8 index, u8 *wdata, u8 *rdata)
 {
-	int ret = mxl111sf_ctrl_msg(state->d, wdata[0],
+	int ret = mxl111sf_ctrl_msg(state, wdata[0],
 				    &wdata[1], 25, rdata, 24);
 	mxl_fail(ret);
 
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index abf69d8..b0d5904 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -24,9 +24,6 @@
 #include "lgdt3305.h"
 #include "lg2160.h"
 
-/* Max transfer size done by I2C transfer functions */
-#define MAX_XFER_SIZE  64
-
 int dvb_usb_mxl111sf_debug;
 module_param_named(debug, dvb_usb_mxl111sf_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info, 2=xfer, 4=i2c, 8=reg, 16=adv (or-able)).");
@@ -55,27 +52,34 @@
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-int mxl111sf_ctrl_msg(struct dvb_usb_device *d,
+int mxl111sf_ctrl_msg(struct mxl111sf_state *state,
 		      u8 cmd, u8 *wbuf, int wlen, u8 *rbuf, int rlen)
 {
+	struct dvb_usb_device *d = state->d;
 	int wo = (rbuf == NULL || rlen == 0); /* write-only */
 	int ret;
-	u8 sndbuf[MAX_XFER_SIZE];
 
-	if (1 + wlen > sizeof(sndbuf)) {
+	if (1 + wlen > MXL_MAX_XFER_SIZE) {
 		pr_warn("%s: len=%d is too big!\n", __func__, wlen);
 		return -EOPNOTSUPP;
 	}
 
 	pr_debug("%s(wlen = %d, rlen = %d)\n", __func__, wlen, rlen);
 
-	memset(sndbuf, 0, 1+wlen);
+	mutex_lock(&state->msg_lock);
+	memset(state->sndbuf, 0, 1+wlen);
+	memset(state->rcvbuf, 0, rlen);
+
+	state->sndbuf[0] = cmd;
+	memcpy(&state->sndbuf[1], wbuf, wlen);
 
-	sndbuf[0] = cmd;
-	memcpy(&sndbuf[1], wbuf, wlen);
+	ret = (wo) ? dvb_usbv2_generic_write(d, state->sndbuf, 1+wlen) :
+		dvb_usbv2_generic_rw(d, state->sndbuf, 1+wlen, state->rcvbuf,
+				     rlen);
+
+	memcpy(rbuf, state->rcvbuf, rlen);
+	mutex_unlock(&state->msg_lock);
 
-	ret = (wo) ? dvb_usbv2_generic_write(d, sndbuf, 1+wlen) :
-		dvb_usbv2_generic_rw(d, sndbuf, 1+wlen, rbuf, rlen);
 	mxl_fail(ret);
 
 	return ret;
@@ -91,7 +95,7 @@ int mxl111sf_read_reg(struct mxl111sf_state *state, u8 addr, u8 *data)
 	u8 buf[2];
 	int ret;
 
-	ret = mxl111sf_ctrl_msg(state->d, MXL_CMD_REG_READ, &addr, 1, buf, 2);
+	ret = mxl111sf_ctrl_msg(state, MXL_CMD_REG_READ, &addr, 1, buf, 2);
 	if (mxl_fail(ret)) {
 		mxl_debug("error reading reg: 0x%02x", addr);
 		goto fail;
@@ -117,7 +121,7 @@ int mxl111sf_write_reg(struct mxl111sf_state *state, u8 addr, u8 data)
 
 	pr_debug("W: (0x%02x, 0x%02x)\n", addr, data);
 
-	ret = mxl111sf_ctrl_msg(state->d, MXL_CMD_REG_WRITE, buf, 2, NULL, 0);
+	ret = mxl111sf_ctrl_msg(state, MXL_CMD_REG_WRITE, buf, 2, NULL, 0);
 	if (mxl_fail(ret))
 		pr_err("error writing reg: 0x%02x, val: 0x%02x", addr, data);
 	return ret;
@@ -926,6 +930,8 @@ static int mxl111sf_init(struct dvb_usb_device *d)
 		  .len = sizeof(eeprom), .buf = eeprom },
 	};
 
+	mutex_init(&state->msg_lock);
+
 	ret = get_chip_info(state);
 	if (mxl_fail(ret))
 		pr_err("failed to get chip info during probe");
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.h b/drivers/media/usb/dvb-usb-v2/mxl111sf.h
index 846260e..3e6f588 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.h
@@ -19,6 +19,9 @@
 #include <media/tveeprom.h>
 #include <media/media-entity.h>
 
+/* Max transfer size done by I2C transfer functions */
+#define MXL_MAX_XFER_SIZE  64
+
 #define MXL_EP1_REG_READ     1
 #define MXL_EP2_REG_WRITE    2
 #define MXL_EP3_INTERRUPT    3
@@ -86,6 +89,9 @@ struct mxl111sf_state {
 	struct mutex fe_lock;
 	u8 num_frontends;
 	struct mxl111sf_adap_state adap_state[3];
+	u8 sndbuf[MXL_MAX_XFER_SIZE];
+	u8 rcvbuf[MXL_MAX_XFER_SIZE];
+	struct mutex msg_lock;
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
 	struct media_entity tuner;
 	struct media_pad tuner_pads[2];
@@ -108,7 +114,7 @@ int mxl111sf_ctrl_program_regs(struct mxl111sf_state *state,
 
 /* needed for hardware i2c functions in mxl111sf-i2c.c:
  * mxl111sf_i2c_send_data / mxl111sf_i2c_get_data */
-int mxl111sf_ctrl_msg(struct dvb_usb_device *d,
+int mxl111sf_ctrl_msg(struct mxl111sf_state *state,
 		      u8 cmd, u8 *wbuf, int wlen, u8 *rbuf, int rlen);
 
 #define mxl_printk(kern, fmt, arg...) \
-- 
1.9.1
