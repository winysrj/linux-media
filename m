Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35862 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751635AbdBNTsC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 14:48:02 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH v2] siano: make it work again with CONFIG_VMAP_STACK
Date: Tue, 14 Feb 2017 17:47:57 -0200
Message-Id: <cf18292e098a882bbe00cd758cf3022126581132.1487101669.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reported as a Kaffeine bug:
	https://bugs.kde.org/show_bug.cgi?id=375811

The USB control messages require DMA to work. We cannot pass
a stack-allocated buffer, as it is not warranted that the
stack would be into a DMA enabled area.

On Kernel 4.9, the default is to not accept DMA on stack anymore
on x86 architecture. On other architectures, this has been a
requirement since Kernel 2.2. So, after this patch, this driver
should likely work fine on all archs.

Tested with USB ID 2040:5510: Hauppauge Windham

Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/siano/smsusb.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index a4dcaec31d02..8c1f926567ec 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -218,22 +218,30 @@ static int smsusb_start_streaming(struct smsusb_device_t *dev)
 static int smsusb_sendrequest(void *context, void *buffer, size_t size)
 {
 	struct smsusb_device_t *dev = (struct smsusb_device_t *) context;
-	struct sms_msg_hdr *phdr = (struct sms_msg_hdr *) buffer;
-	int dummy;
+	struct sms_msg_hdr *phdr;
+	int dummy, ret;
 
 	if (dev->state != SMSUSB_ACTIVE) {
 		pr_debug("Device not active yet\n");
 		return -ENOENT;
 	}
 
+	phdr = kmalloc(size, GFP_KERNEL);
+	if (!phdr)
+		return -ENOMEM;
+	memcpy(phdr, buffer, size);
+
 	pr_debug("sending %s(%d) size: %d\n",
 		  smscore_translate_msg(phdr->msg_type), phdr->msg_type,
 		  phdr->msg_length);
 
 	smsendian_handle_tx_message((struct sms_msg_data *) phdr);
-	smsendian_handle_message_header((struct sms_msg_hdr *)buffer);
-	return usb_bulk_msg(dev->udev, usb_sndbulkpipe(dev->udev, 2),
-			    buffer, size, &dummy, 1000);
+	smsendian_handle_message_header((struct sms_msg_hdr *)phdr);
+	ret = usb_bulk_msg(dev->udev, usb_sndbulkpipe(dev->udev, 2),
+			    phdr, size, &dummy, 1000);
+
+	kfree(phdr);
+	return ret;
 }
 
 static char *smsusb1_fw_lkup[] = {
-- 
2.9.3
