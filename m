Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933233Ab3CSQvH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:51:07 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 22/46] [media] siano: Configure board's mtu and xtal
Date: Tue, 19 Mar 2013 13:49:11 -0300
Message-Id: <1363711775-2120-23-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Backported from Doron Cohen's patch:
	http://patchwork.linuxtv.org/patch/7889/

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.c | 56 +++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 6e60c99..acf28af 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -825,6 +825,57 @@ static int smscore_init_ir(struct smscore_device_t *coredev)
 }
 
 /**
+ * configures device features according to board configuration structure.
+ *
+ * @param coredev pointer to a coredev object returned by
+ *                smscore_register_device
+ *
+ * @return 0 on success, <0 on error.
+ */
+int smscore_configure_board(struct smscore_device_t *coredev)
+{
+	struct sms_board *board;
+
+	board = sms_get_board(coredev->board_id);
+	if (!board) {
+		sms_err("no board configuration exist.");
+		return -EINVAL;
+	}
+
+	if (board->mtu) {
+		struct SmsMsgData_ST MtuMsg;
+		sms_debug("set max transmit unit %d", board->mtu);
+
+		MtuMsg.xMsgHeader.msgSrcId = 0;
+		MtuMsg.xMsgHeader.msgDstId = HIF_TASK;
+		MtuMsg.xMsgHeader.msgFlags = 0;
+		MtuMsg.xMsgHeader.msgType = MSG_SMS_SET_MAX_TX_MSG_LEN_REQ;
+		MtuMsg.xMsgHeader.msgLength = sizeof(MtuMsg);
+		MtuMsg.msgData[0] = board->mtu;
+
+		smsendian_handle_tx_message((struct SmsMsgHdr_ST *)&MtuMsg);
+		coredev->sendrequest_handler(coredev->context, &MtuMsg,
+					     sizeof(MtuMsg));
+	}
+
+	if (board->crystal) {
+		struct SmsMsgData_ST CrysMsg;
+		sms_debug("set crystal value %d", board->crystal);
+
+		SMS_INIT_MSG(&CrysMsg.xMsgHeader,
+				MSG_SMS_NEW_CRYSTAL_REQ,
+				sizeof(CrysMsg));
+		CrysMsg.msgData[0] = board->crystal;
+
+		smsendian_handle_tx_message((struct SmsMsgHdr_S *)&CrysMsg);
+		coredev->sendrequest_handler(coredev->context, &CrysMsg,
+					     sizeof(CrysMsg));
+	}
+
+	return 0;
+}
+
+/**
  * sets initial device mode and notifies client hotplugs that device is ready
  *
  * @param coredev pointer to a coredev object returned by
@@ -840,6 +891,11 @@ int smscore_start_device(struct smscore_device_t *coredev)
 		sms_info("set device mode faile , rc %d", rc);
 		return rc;
 	}
+	rc = smscore_configure_board(coredev);
+	if (rc < 0) {
+		sms_info("configure board failed , rc %d", rc);
+		return rc;
+	}
 
 	kmutex_lock(&g_smscore_deviceslock);
 
-- 
1.8.1.4

