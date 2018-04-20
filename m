Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56615 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754757AbeDTMc1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 08:32:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/4] media: siano: get rid of __le32/__le16 cast warnings
Date: Fri, 20 Apr 2018 08:32:16 -0400
Message-Id: <d4fbc56d512429df07e35429d9ad3d90ab95f753.1524227382.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1524227382.git.mchehab@s-opensource.com>
References: <cover.1524227382.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1524227382.git.mchehab@s-opensource.com>
References: <cover.1524227382.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those are all false-positives that appear with smatch when building for
arm:

  drivers/media/common/siano/smsendian.c:38:36: warning: cast to restricted __le32
  drivers/media/common/siano/smsendian.c:38:36: warning: cast to restricted __le32
  drivers/media/common/siano/smsendian.c:38:36: warning: cast to restricted __le32
  drivers/media/common/siano/smsendian.c:38:36: warning: cast to restricted __le32
  drivers/media/common/siano/smsendian.c:38:36: warning: cast to restricted __le32
  drivers/media/common/siano/smsendian.c:38:36: warning: cast to restricted __le32
  drivers/media/common/siano/smsendian.c:47:44: warning: cast to restricted __le32
  drivers/media/common/siano/smsendian.c:47:44: warning: cast to restricted __le32
  drivers/media/common/siano/smsendian.c:47:44: warning: cast to restricted __le32
  drivers/media/common/siano/smsendian.c:47:44: warning: cast to restricted __le32
  drivers/media/common/siano/smsendian.c:47:44: warning: cast to restricted __le32
  drivers/media/common/siano/smsendian.c:47:44: warning: cast to restricted __le32
  drivers/media/common/siano/smsendian.c:67:35: warning: cast to restricted __le16
  drivers/media/common/siano/smsendian.c:67:35: warning: cast to restricted __le16
  drivers/media/common/siano/smsendian.c:67:35: warning: cast to restricted __le16
  drivers/media/common/siano/smsendian.c:67:35: warning: cast to restricted __le16
  drivers/media/common/siano/smsendian.c:84:44: warning: cast to restricted __le32
  drivers/media/common/siano/smsendian.c:84:44: warning: cast to restricted __le32
  drivers/media/common/siano/smsendian.c:84:44: warning: cast to restricted __le32
  drivers/media/common/siano/smsendian.c:84:44: warning: cast to restricted __le32
  drivers/media/common/siano/smsendian.c:84:44: warning: cast to restricted __le32
  drivers/media/common/siano/smsendian.c:84:44: warning: cast to restricted __le32
  drivers/media/common/siano/smsendian.c:98:26: warning: cast to restricted __le16
  drivers/media/common/siano/smsendian.c:98:26: warning: cast to restricted __le16
  drivers/media/common/siano/smsendian.c:98:26: warning: cast to restricted __le16
  drivers/media/common/siano/smsendian.c:98:26: warning: cast to restricted __le16
  drivers/media/common/siano/smsendian.c:99:28: warning: cast to restricted __le16
  drivers/media/common/siano/smsendian.c:99:28: warning: cast to restricted __le16
  drivers/media/common/siano/smsendian.c:99:28: warning: cast to restricted __le16
  drivers/media/common/siano/smsendian.c:99:28: warning: cast to restricted __le16
  drivers/media/common/siano/smsendian.c:100:27: warning: cast to restricted __le16
  drivers/media/common/siano/smsendian.c:100:27: warning: cast to restricted __le16
  drivers/media/common/siano/smsendian.c:100:27: warning: cast to restricted __le16
  drivers/media/common/siano/smsendian.c:100:27: warning: cast to restricted __le16

Get rid of them by adding explicit forced casts.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/common/siano/smsendian.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/common/siano/smsendian.c b/drivers/media/common/siano/smsendian.c
index bfe831c10b1c..b95a631f23f9 100644
--- a/drivers/media/common/siano/smsendian.c
+++ b/drivers/media/common/siano/smsendian.c
@@ -35,7 +35,7 @@ void smsendian_handle_tx_message(void *buffer)
 	switch (msg->x_msg_header.msg_type) {
 	case MSG_SMS_DATA_DOWNLOAD_REQ:
 	{
-		msg->msg_data[0] = le32_to_cpu(msg->msg_data[0]);
+		msg->msg_data[0] = le32_to_cpu((__force __le32)(msg->msg_data[0]));
 		break;
 	}
 
@@ -44,7 +44,7 @@ void smsendian_handle_tx_message(void *buffer)
 				sizeof(struct sms_msg_hdr))/4;
 
 		for (i = 0; i < msg_words; i++)
-			msg->msg_data[i] = le32_to_cpu(msg->msg_data[i]);
+			msg->msg_data[i] = le32_to_cpu((__force __le32)msg->msg_data[i]);
 
 		break;
 	}
@@ -64,7 +64,7 @@ void smsendian_handle_rx_message(void *buffer)
 	{
 		struct sms_version_res *ver =
 			(struct sms_version_res *) msg;
-		ver->chip_model = le16_to_cpu(ver->chip_model);
+		ver->chip_model = le16_to_cpu((__force __le16)ver->chip_model);
 		break;
 	}
 
@@ -81,7 +81,7 @@ void smsendian_handle_rx_message(void *buffer)
 				sizeof(struct sms_msg_hdr))/4;
 
 		for (i = 0; i < msg_words; i++)
-			msg->msg_data[i] = le32_to_cpu(msg->msg_data[i]);
+			msg->msg_data[i] = le32_to_cpu((__force __le32)msg->msg_data[i]);
 
 		break;
 	}
@@ -95,9 +95,9 @@ void smsendian_handle_message_header(void *msg)
 #ifdef __BIG_ENDIAN
 	struct sms_msg_hdr *phdr = (struct sms_msg_hdr *)msg;
 
-	phdr->msg_type = le16_to_cpu(phdr->msg_type);
-	phdr->msg_length = le16_to_cpu(phdr->msg_length);
-	phdr->msg_flags = le16_to_cpu(phdr->msg_flags);
+	phdr->msg_type = le16_to_cpu((__force __le16)phdr->msg_type);
+	phdr->msg_length = le16_to_cpu((__force __le16)phdr->msg_length);
+	phdr->msg_flags = le16_to_cpu((__force __le16)phdr->msg_flags);
 #endif /* __BIG_ENDIAN */
 }
 EXPORT_SYMBOL_GPL(smsendian_handle_message_header);
-- 
2.14.3
