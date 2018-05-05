Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:54187 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751118AbeEEQJv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 5 May 2018 12:09:51 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Hans Verkuil <hansverk@cisco.com>,
        Tomoki Sekiyama <tomoki.sekiyama@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-mm@kvack.org
Subject: [PATCH 1/2] media: siano: don't use GFP_DMA
Date: Sat,  5 May 2018 12:09:45 -0400
Message-Id: <dc56acf384130d9703684a239d8daa8748f63d8e.1525536580.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I can't think on a single reason why this driver would be using
GFP_DMA. The typical usage is as an USB driver. Any DMA restrictions
should be handled inside the HCI driver, if any.

Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-mm@kvack.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/common/siano/smscoreapi.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 1c93258a2d47..a5f0db0810d4 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -697,7 +697,7 @@ int smscore_register_device(struct smsdevice_params_t *params,
 		buffer = dma_alloc_coherent(params->device,
 					    dev->common_buffer_size,
 					    &dev->common_buffer_phys,
-					    GFP_KERNEL | GFP_DMA);
+					    GFP_KERNEL);
 	if (!buffer) {
 		smscore_unregister_device(dev);
 		return -ENOMEM;
@@ -792,7 +792,7 @@ static int smscore_init_ir(struct smscore_device_t *coredev)
 		else {
 			buffer = kmalloc(sizeof(struct sms_msg_data2) +
 						SMS_DMA_ALIGNMENT,
-						GFP_KERNEL | GFP_DMA);
+						GFP_KERNEL);
 			if (buffer) {
 				struct sms_msg_data2 *msg =
 				(struct sms_msg_data2 *)
@@ -933,7 +933,7 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 	}
 
 	/* PAGE_SIZE buffer shall be enough and dma aligned */
-	msg = kmalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
+	msg = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
 
@@ -1168,7 +1168,7 @@ static int smscore_load_firmware_from_file(struct smscore_device_t *coredev,
 	}
 	pr_debug("read fw %s, buffer size=0x%zx\n", fw_filename, fw->size);
 	fw_buf = kmalloc(ALIGN(fw->size + sizeof(struct sms_firmware),
-			 SMS_ALLOC_ALIGNMENT), GFP_KERNEL | GFP_DMA);
+			 SMS_ALLOC_ALIGNMENT), GFP_KERNEL);
 	if (!fw_buf) {
 		pr_err("failed to allocate firmware buffer\n");
 		rc = -ENOMEM;
@@ -1260,7 +1260,7 @@ EXPORT_SYMBOL_GPL(smscore_unregister_device);
 static int smscore_detect_mode(struct smscore_device_t *coredev)
 {
 	void *buffer = kmalloc(sizeof(struct sms_msg_hdr) + SMS_DMA_ALIGNMENT,
-			       GFP_KERNEL | GFP_DMA);
+			       GFP_KERNEL);
 	struct sms_msg_hdr *msg =
 		(struct sms_msg_hdr *) SMS_ALIGN_ADDRESS(buffer);
 	int rc;
@@ -1309,7 +1309,7 @@ static int smscore_init_device(struct smscore_device_t *coredev, int mode)
 	int rc = 0;
 
 	buffer = kmalloc(sizeof(struct sms_msg_data) +
-			SMS_DMA_ALIGNMENT, GFP_KERNEL | GFP_DMA);
+			SMS_DMA_ALIGNMENT, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -1398,7 +1398,7 @@ int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 		coredev->device_flags &= ~SMS_DEVICE_NOT_READY;
 
 		buffer = kmalloc(sizeof(struct sms_msg_data) +
-				 SMS_DMA_ALIGNMENT, GFP_KERNEL | GFP_DMA);
+				 SMS_DMA_ALIGNMENT, GFP_KERNEL);
 		if (buffer) {
 			struct sms_msg_data *msg = (struct sms_msg_data *) SMS_ALIGN_ADDRESS(buffer);
 
@@ -1971,7 +1971,7 @@ int smscore_gpio_configure(struct smscore_device_t *coredev, u8 pin_num,
 	total_len = sizeof(struct sms_msg_hdr) + (sizeof(u32) * 6);
 
 	buffer = kmalloc(total_len + SMS_DMA_ALIGNMENT,
-			GFP_KERNEL | GFP_DMA);
+			GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -2043,7 +2043,7 @@ int smscore_gpio_set_level(struct smscore_device_t *coredev, u8 pin_num,
 			(3 * sizeof(u32)); /* keep it 3 ! */
 
 	buffer = kmalloc(total_len + SMS_DMA_ALIGNMENT,
-			GFP_KERNEL | GFP_DMA);
+			GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -2091,7 +2091,7 @@ int smscore_gpio_get_level(struct smscore_device_t *coredev, u8 pin_num,
 	total_len = sizeof(struct sms_msg_hdr) + (2 * sizeof(u32));
 
 	buffer = kmalloc(total_len + SMS_DMA_ALIGNMENT,
-			GFP_KERNEL | GFP_DMA);
+			GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
-- 
2.17.0
