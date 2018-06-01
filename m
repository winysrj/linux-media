Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35948 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751425AbeFAIT2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 04:19:28 -0400
Received: by mail-wr0-f194.google.com with SMTP id f16-v6so20118209wrm.3
        for <linux-media@vger.kernel.org>; Fri, 01 Jun 2018 01:19:28 -0700 (PDT)
From: Neil Armstrong <narmstrong@baylibre.com>
To: airlied@linux.ie, hans.verkuil@cisco.com, lee.jones@linaro.org,
        olof@lixom.net, seanpaul@google.com
Cc: Neil Armstrong <narmstrong@baylibre.com>, sadolfsson@google.com,
        felixe@google.com, bleung@google.com, darekm@google.com,
        marcheu@chromium.org, fparent@baylibre.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        eballetbo@gmail.com
Subject: [PATCH v7 4/6] mfd: cros-ec: Introduce CEC commands and events definitions.
Date: Fri,  1 Jun 2018 10:19:12 +0200
Message-Id: <1527841154-24832-5-git-send-email-narmstrong@baylibre.com>
In-Reply-To: <1527841154-24832-1-git-send-email-narmstrong@baylibre.com>
References: <1527841154-24832-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The EC can expose a CEC bus, this patch adds the CEC related definitions
needed by the cros-ec-cec driver.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Tested-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/linux/mfd/cros_ec_commands.h | 81 ++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/include/linux/mfd/cros_ec_commands.h b/include/linux/mfd/cros_ec_commands.h
index cc0768e..fe33a81 100644
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
+	EC_MKBP_EVENT_CEC_EVENT = 8,
+
+	/* Send an incoming CEC message to the AP */
+	EC_MKBP_EVENT_CEC_MESSAGE = 9,
+
 	/* Number of MKBP events */
 	EC_MKBP_EVENT_COUNT,
 };
@@ -2850,6 +2858,79 @@ struct ec_params_reboot_ec {
 
 /*****************************************************************************/
 /*
+ * HDMI CEC commands
+ *
+ * These commands are for sending and receiving message via HDMI CEC
+ */
+#define EC_MAX_CEC_MSG_LEN 16
+
+/* CEC message from the AP to be written on the CEC bus */
+#define EC_CMD_CEC_WRITE_MSG 0x00B8
+
+/**
+ * struct ec_params_cec_write - Message to write to the CEC bus
+ * @msg: message content to write to the CEC bus
+ */
+struct ec_params_cec_write {
+	uint8_t msg[EC_MAX_CEC_MSG_LEN];
+} __packed;
+
+/* Set various CEC parameters */
+#define EC_CMD_CEC_SET 0x00BA
+
+/**
+ * struct ec_params_cec_set - CEC parameters set
+ * @cmd: parameter type, can be CEC_CMD_ENABLE or CEC_CMD_LOGICAL_ADDRESS
+ * @val: in case cmd is CEC_CMD_ENABLE, this field can be 0 to disable CEC
+ *	or 1 to enable CEC functionality, in case cmd is CEC_CMD_LOGICAL_ADDRESS,
+ *	this field encodes the requested logical address between 0 and 15
+ *	or 0xff to unregister
+ */
+struct ec_params_cec_set {
+	uint8_t cmd; /* enum cec_command */
+	uint8_t val;
+} __packed;
+
+/* Read various CEC parameters */
+#define EC_CMD_CEC_GET 0x00BB
+
+/**
+ * struct ec_params_cec_get - CEC parameters get
+ * @cmd: parameter type, can be CEC_CMD_ENABLE or CEC_CMD_LOGICAL_ADDRESS
+ */
+struct ec_params_cec_get {
+	uint8_t cmd; /* enum cec_command */
+} __packed;
+
+/**
+ * struct ec_response_cec_get - CEC parameters get response
+ * @val: in case cmd was CEC_CMD_ENABLE, this field will 0 if CEC is
+ *	disabled or 1 if CEC functionality is enabled,
+ *	in case cmd was CEC_CMD_LOGICAL_ADDRESS, this will encode the
+ *	configured logical address between 0 and 15 or 0xff if unregistered
+ */
+struct ec_response_cec_get {
+	uint8_t val;
+} __packed;
+
+/* CEC parameters command */
+enum ec_cec_command {
+	/* CEC reading, writing and events enable */
+	CEC_CMD_ENABLE,
+	/* CEC logical address  */
+	CEC_CMD_LOGICAL_ADDRESS,
+};
+
+/* Events from CEC to AP */
+enum mkbp_cec_event {
+	/* Outgoing message was acknowledged by a follower */
+	EC_MKBP_CEC_SEND_OK			= BIT(0),
+	/* Outgoing message was not acknowledged */
+	EC_MKBP_CEC_SEND_FAILED			= BIT(1),
+};
+
+/*****************************************************************************/
+/*
  * Special commands
  *
  * These do not follow the normal rules for commands.  See each command for
-- 
2.7.4
