Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933120Ab3CSQuS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:18 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 23/46] [media] siano: call MSG_SMS_INIT_DEVICE_REQ
Date: Tue, 19 Mar 2013 13:49:12 -0300
Message-Id: <1363711775-2120-24-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Newer firmwares seem to require an init device message. Apply
such change from Doron Cohen's patch:
	http://patchwork.linuxtv.org/patch/7889/

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.c | 43 ++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index acf28af..35486c5 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -1280,6 +1280,42 @@ static char *smscore_get_fw_filename(struct smscore_device_t *coredev,
 }
 
 /**
+ * send init device request and wait for response
+ *
+ * @param coredev pointer to a coredev object returned by
+ *                smscore_register_device
+ * @param mode requested mode of operation
+ *
+ * @return 0 on success, <0 on error.
+ */
+int smscore_init_device(struct smscore_device_t *coredev, int mode)
+{
+	void *buffer;
+	struct SmsMsgData_ST *msg;
+	int rc = 0;
+
+	buffer = kmalloc(sizeof(struct SmsMsgData_ST) +
+			SMS_DMA_ALIGNMENT, GFP_KERNEL | GFP_DMA);
+	if (!buffer) {
+		sms_err("Could not allocate buffer for init device message.");
+		return -ENOMEM;
+	}
+
+	msg = (struct SmsMsgData_ST *)SMS_ALIGN_ADDRESS(buffer);
+	SMS_INIT_MSG(&msg->xMsgHeader, MSG_SMS_INIT_DEVICE_REQ,
+			sizeof(struct SmsMsgData_ST));
+	msg->msgData[0] = mode;
+
+	smsendian_handle_tx_message((struct SmsMsgHdr_ST *)msg);
+	rc = smscore_sendrequest_and_wait(coredev, msg,
+			msg->xMsgHeader. msgLength,
+			&coredev->init_device_done);
+
+	kfree(buffer);
+	return rc;
+}
+
+/**
  * calls device handler to change mode of operation
  * NOTE: stellar/usb may disconnect when changing mode
  *
@@ -1341,8 +1377,13 @@ int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 			sms_info("mode %d is already supported by running firmware",
 				 mode);
 		}
+		if (coredev->fw_version >= 0x800) {
+			rc = smscore_init_device(coredev, mode);
+			if (rc < 0)
+				sms_err("device init failed, rc %d.", rc);
+		}
 	} else {
-		if (mode < DEVICE_MODE_DVBT || mode > DEVICE_MODE_DVBT_BDA) {
+		if (mode < DEVICE_MODE_DVBT || mode > DEVICE_MODE_MAX) {
 			sms_err("invalid mode specified %d", mode);
 			return -EINVAL;
 		}
-- 
1.8.1.4

