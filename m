Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:44409 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752427AbeENWkt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 18:40:49 -0400
Received: by mail-lf0-f66.google.com with SMTP id h197-v6so20382957lfg.11
        for <linux-media@vger.kernel.org>; Mon, 14 May 2018 15:40:49 -0700 (PDT)
From: Neil Armstrong <narmstrong@baylibre.com>
To: airlied@linux.ie, hans.verkuil@cisco.com, lee.jones@linaro.org,
        olof@lixom.net, seanpaul@google.com
Cc: Neil Armstrong <narmstrong@baylibre.com>, sadolfsson@google.com,
        felixe@google.com, bleung@google.com, darekm@google.com,
        marcheu@chromium.org, fparent@baylibre.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Stefan Adolfsson <sadolfsson@chromium.org>
Subject: [RFC PATCH 4/5] mfd: cros-ec: Introduce CEC commands and events definitions.
Date: Tue, 15 May 2018 00:40:38 +0200
Message-Id: <1526337639-3568-5-git-send-email-narmstrong@baylibre.com>
In-Reply-To: <1526337639-3568-1-git-send-email-narmstrong@baylibre.com>
References: <1526337639-3568-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Adolfsson <sadolfsson@chromium.org>

The EC can expose a CEC bus, this patch adds the CEC related definitions
needed by the cros-ec-cec driver.
Having a 16 byte mkbp event size makes it possible to send CEC
messages from the EC to the AP directly inside the mkbp event
instead of first doing a notification and then a read.

Signed-off-by: Stefan Adolfsson <sadolfsson@chromium.org>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 drivers/platform/chrome/cros_ec_proto.c | 42 +++++++++++++----
 include/linux/mfd/cros_ec.h             |  2 +-
 include/linux/mfd/cros_ec_commands.h    | 80 +++++++++++++++++++++++++++++++++
 3 files changed, 114 insertions(+), 10 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
index e7bbdf9..ba47f79 100644
--- a/drivers/platform/chrome/cros_ec_proto.c
+++ b/drivers/platform/chrome/cros_ec_proto.c
@@ -504,29 +504,53 @@ int cros_ec_cmd_xfer_status(struct cros_ec_device *ec_dev,
 }
 EXPORT_SYMBOL(cros_ec_cmd_xfer_status);
 
+static int get_next_event_xfer(struct cros_ec_device *ec_dev,
+			       struct cros_ec_command *msg,
+			       int version, uint32_t size)
+{
+	int ret;
+
+	msg->version = version;
+	msg->command = EC_CMD_GET_NEXT_EVENT;
+	msg->insize = size;
+	msg->outsize = 0;
+
+	ret = cros_ec_cmd_xfer(ec_dev, msg);
+	if (ret > 0) {
+		ec_dev->event_size = ret - 1;
+		memcpy(&ec_dev->event_data, msg->data, size);
+	}
+
+	return ret;
+}
+
 static int get_next_event(struct cros_ec_device *ec_dev)
 {
 	u8 buffer[sizeof(struct cros_ec_command) + sizeof(ec_dev->event_data)];
 	struct cros_ec_command *msg = (struct cros_ec_command *)&buffer;
+	static int cmd_version = 1;
 	int ret;
 
+	BUILD_BUG_ON(sizeof(union ec_response_get_next_data_v1) != 16);
+
 	if (ec_dev->suspended) {
 		dev_dbg(ec_dev->dev, "Device suspended.\n");
 		return -EHOSTDOWN;
 	}
 
-	msg->version = 0;
-	msg->command = EC_CMD_GET_NEXT_EVENT;
-	msg->insize = sizeof(ec_dev->event_data);
-	msg->outsize = 0;
+	if (cmd_version == 1) {
+		ret = get_next_event_xfer(ec_dev, msg, cmd_version,
+					  sizeof(ec_dev->event_data));
+		if (ret != EC_RES_INVALID_VERSION)
+			return ret;
 
-	ret = cros_ec_cmd_xfer(ec_dev, msg);
-	if (ret > 0) {
-		ec_dev->event_size = ret - 1;
-		memcpy(&ec_dev->event_data, msg->data,
-		       sizeof(ec_dev->event_data));
+		/* Fallback to version 0 for future send attempts */
+		cmd_version = 0;
 	}
 
+	ret = get_next_event_xfer(ec_dev, msg, cmd_version,
+				  sizeof(struct ec_response_get_next_event));
+
 	return ret;
 }
 
diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
index 2d4e23c..f3415eb 100644
--- a/include/linux/mfd/cros_ec.h
+++ b/include/linux/mfd/cros_ec.h
@@ -147,7 +147,7 @@ struct cros_ec_device {
 	bool mkbp_event_supported;
 	struct blocking_notifier_head event_notifier;
 
-	struct ec_response_get_next_event event_data;
+	struct ec_response_get_next_event_v1 event_data;
 	int event_size;
 	u32 host_event_wake_mask;
 };
diff --git a/include/linux/mfd/cros_ec_commands.h b/include/linux/mfd/cros_ec_commands.h
index f2edd99..18df466 100644
--- a/include/linux/mfd/cros_ec_commands.h
+++ b/include/linux/mfd/cros_ec_commands.h
@@ -804,6 +804,8 @@ enum ec_feature_code {
 	EC_FEATURE_MOTION_SENSE_FIFO = 24,
 	/* EC has RTC feature that can be controlled by host commands */
 	EC_FEATURE_RTC = 27,
+	/* EC supports CEC commands */
+	EC_FEATURE_CEC = 35,
 };
 
 #define EC_FEATURE_MASK_0(event_code) (1UL << (event_code % 32))
@@ -2078,6 +2080,12 @@ enum ec_mkbp_event {
 	/* EC sent a sysrq command */
 	EC_MKBP_EVENT_SYSRQ = 6,
 
+	/* Notify the AP that something happened on CEC */
+	EC_MKBP_CEC_EVENT = 8,
+
+	/* Send an incoming CEC message to the AP */
+	EC_MKBP_EVENT_CEC_MESSAGE = 9,
+
 	/* Number of MKBP events */
 	EC_MKBP_EVENT_COUNT,
 };
@@ -2093,12 +2101,31 @@ union ec_response_get_next_data {
 	uint32_t   sysrq;
 } __packed;
 
+union ec_response_get_next_data_v1 {
+	uint8_t   key_matrix[16];
+
+	/* Unaligned */
+	uint32_t  host_event;
+
+	uint32_t   buttons;
+	uint32_t   switches;
+	uint32_t   sysrq;
+	uint32_t   cec_events;
+	uint8_t    cec_message[16];
+} __packed;
+
 struct ec_response_get_next_event {
 	uint8_t event_type;
 	/* Followed by event data if any */
 	union ec_response_get_next_data data;
 } __packed;
 
+struct ec_response_get_next_event_v1 {
+	uint8_t event_type;
+	/* Followed by event data if any */
+	union ec_response_get_next_data_v1 data;
+} __packed;
+
 /* Bit indices for buttons and switches.*/
 /* Buttons */
 #define EC_MKBP_POWER_BUTTON	0
@@ -2828,6 +2855,59 @@ struct ec_params_reboot_ec {
 /* Current version of ACPI memory address space */
 #define EC_ACPI_MEM_VERSION_CURRENT 1
 
+/*****************************************************************************/
+/*
+ * HDMI CEC commands
+ *
+ * These commands are for sending and receiving message via HDMI CEC
+ */
+#define MAX_CEC_MSG_LEN 16
+
+/* CEC message from the AP to be written on the CEC bus */
+#define EC_CMD_CEC_WRITE_MSG 0x00B8
+
+/* Message to write to the CEC bus */
+struct ec_params_cec_write {
+	uint8_t msg[MAX_CEC_MSG_LEN];
+} __packed;
+
+/* Set various CEC parameters */
+#define EC_CMD_CEC_SET 0x00BA
+
+struct ec_params_cec_set {
+	uint8_t cmd; /* enum cec_command */
+	union {
+		uint8_t enable;
+		uint8_t address;
+	};
+} __packed;
+
+/* Read various CEC parameters */
+#define EC_CMD_CEC_GET 0x00BB
+
+struct ec_params_cec_get {
+	uint8_t cmd; /* enum cec_command */
+} __packed;
+
+struct ec_response_cec_get {
+	union {
+		uint8_t enable;
+		uint8_t address;
+	};
+}__packed;
+
+enum cec_command {
+	/* CEC reading, writing and events enable */
+	CEC_CMD_ENABLE,
+	/* CEC logical address  */
+	CEC_CMD_LOGICAL_ADDRESS,
+};
+
+/* Events from CEC to AP */
+enum mkbp_cec_event {
+	EC_MKBP_CEC_SEND_OK			= 1 << 0,
+	EC_MKBP_CEC_SEND_FAILED			= 1 << 1,
+};
 
 /*****************************************************************************/
 /*
-- 
2.7.4
