Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.mujha-vel.cz ([81.30.225.246]:60869 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab0AFRLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jan 2010 12:11:52 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	linux-media@vger.kernel.org
Subject: [PATCH 1/2] media: dvb/siano, fix memory leak
Date: Wed,  6 Jan 2010 17:45:27 +0100
Message-Id: <1262796328-17176-1-git-send-email-jslaby@suse.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stanse found a memory leak in smscore_gpio_configure. buffer is not
freed/assigned on all paths. Fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
---
 drivers/media/dvb/siano/smscoreapi.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/siano/smscoreapi.c b/drivers/media/dvb/siano/smscoreapi.c
index ca758bc..4bfd345 100644
--- a/drivers/media/dvb/siano/smscoreapi.c
+++ b/drivers/media/dvb/siano/smscoreapi.c
@@ -1459,8 +1459,10 @@ int smscore_gpio_configure(struct smscore_device_t *coredev, u8 PinNum,
 	if (!(coredev->device_flags & SMS_DEVICE_FAMILY2)) {
 		pMsg->xMsgHeader.msgType = MSG_SMS_GPIO_CONFIG_REQ;
 		if (GetGpioPinParams(PinNum, &TranslatedPinNum, &GroupNum,
-				&groupCfg) != 0)
-			return -EINVAL;
+				&groupCfg) != 0) {
+			rc = -EINVAL;
+			goto free;
+		}
 
 		pMsg->msgData[1] = TranslatedPinNum;
 		pMsg->msgData[2] = GroupNum;
@@ -1490,6 +1492,7 @@ int smscore_gpio_configure(struct smscore_device_t *coredev, u8 PinNum,
 		else
 			sms_err("smscore_gpio_configure error");
 	}
+free:
 	kfree(buffer);
 
 	return rc;
-- 
1.6.5.7

