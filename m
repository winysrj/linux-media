Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:42901 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753656AbcHTKyb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Aug 2016 06:54:31 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by tschai.lan (Postfix) with ESMTPSA id 5977E1800DD
        for <linux-media@vger.kernel.org>; Sat, 20 Aug 2016 12:54:26 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.8] cec-funcs.h: add missing vendor-specific messages
Message-ID: <a0bc830d-dd5a-4697-905f-da21013f205b@xs4all.nl>
Date: Sat, 20 Aug 2016 12:54:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cec-funcs.h header was missing support for these three vendor-specific messages:

CEC_MSG_VENDOR_COMMAND
CEC_MSG_VENDOR_COMMAND_WITH_ID
CEC_MSG_VENDOR_REMOTE_BUTTON_DOWN

Add wrappers for these messages.

I originally postponed adding these wrappers due to the fact that the argument is
just a byte array which cec-ctl couldn't handle at the time, and then I just forgot
to add them once the CEC framework was finalized.

It wasn't until an attempt to transmit a vendor specific command was made that I
realized that these wrappers were missing.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/include/linux/cec-funcs.h b/include/linux/cec-funcs.h
index 8af613e..138bbf7 100644
--- a/include/linux/cec-funcs.h
+++ b/include/linux/cec-funcs.h
@@ -1144,6 +1144,75 @@ static inline void cec_msg_give_device_vendor_id(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_DEVICE_VENDOR_ID : 0;
 }

+static inline void cec_msg_vendor_command(struct cec_msg *msg,
+					  __u8 size, const __u8 *vendor_cmd)
+{
+	if (size > 14)
+		size = 14;
+	msg->len = 2 + size;
+	msg->msg[1] = CEC_MSG_VENDOR_COMMAND;
+	memcpy(msg->msg + 2, vendor_cmd, size);
+}
+
+static inline void cec_ops_vendor_command(const struct cec_msg *msg,
+					  __u8 *size,
+					  const __u8 **vendor_cmd)
+{
+	*size = msg->len - 2;
+
+	if (*size > 14)
+		*size = 14;
+	*vendor_cmd = msg->msg + 2;
+}
+
+static inline void cec_msg_vendor_command_with_id(struct cec_msg *msg,
+						  __u32 vendor_id, __u8 size,
+						  const __u8 *vendor_cmd)
+{
+	if (size > 11)
+		size = 11;
+	msg->len = 5 + size;
+	msg->msg[1] = CEC_MSG_VENDOR_COMMAND_WITH_ID;
+	msg->msg[2] = vendor_id >> 16;
+	msg->msg[3] = (vendor_id >> 8) & 0xff;
+	msg->msg[4] = vendor_id & 0xff;
+	memcpy(msg->msg + 5, vendor_cmd, size);
+}
+
+static inline void cec_ops_vendor_command_with_id(const struct cec_msg *msg,
+						  __u32 *vendor_id,  __u8 *size,
+						  const __u8 **vendor_cmd)
+{
+	*size = msg->len - 5;
+
+	if (*size > 11)
+		*size = 11;
+	*vendor_id = (msg->msg[2] << 16) | (msg->msg[3] << 8) | msg->msg[4];
+	*vendor_cmd = msg->msg + 5;
+}
+
+static inline void cec_msg_vendor_remote_button_down(struct cec_msg *msg,
+						     __u8 size,
+						     const __u8 *rc_code)
+{
+	if (size > 14)
+		size = 14;
+	msg->len = 2 + size;
+	msg->msg[1] = CEC_MSG_VENDOR_REMOTE_BUTTON_DOWN;
+	memcpy(msg->msg + 2, rc_code, size);
+}
+
+static inline void cec_ops_vendor_remote_button_down(const struct cec_msg *msg,
+						     __u8 *size,
+						     const __u8 **rc_code)
+{
+	*size = msg->len - 2;
+
+	if (*size > 14)
+		*size = 14;
+	*rc_code = msg->msg + 2;
+}
+
 static inline void cec_msg_vendor_remote_button_up(struct cec_msg *msg)
 {
 	msg->len = 2;
