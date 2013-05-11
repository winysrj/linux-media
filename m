Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58777 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab3EKPxt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 May 2013 11:53:49 -0400
Received: by mail-pa0-f41.google.com with SMTP id rl6so3646881pac.14
        for <linux-media@vger.kernel.org>; Sat, 11 May 2013 08:53:49 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Roberto_Alc=E2ntara?= <roberto@eletronica.org>
Date: Sat, 11 May 2013 12:53:29 -0300
Message-ID: <CAEt6MXmqv6KwkKoQzAGkG+vU07z_vV6gET8hSDAdxu=WBt3jtw@mail.gmail.com>
Subject: [PATCH] smscoreapi: Make Siano firmware load more verbose
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Roberto Alcantara <roberto@eletronica.org>

diff --git a/drivers/media/common/siano/smscoreapi.c
b/drivers/media/common/siano/smscoreapi.c
index 45ac9ee..dbe9b4d 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -1154,7 +1154,7 @@ static int
smscore_load_firmware_from_file(struct smscore_device_t *coredev,

     char *fw_filename = smscore_get_fw_filename(coredev, mode);
     if (!fw_filename) {
-        sms_info("mode %d not supported on this device", mode);
+        sms_err("mode %d not supported on this device", mode);
         return -ENOENT;
     }
     sms_debug("Firmware name: %s", fw_filename);
@@ -1165,14 +1165,14 @@ static int
smscore_load_firmware_from_file(struct smscore_device_t *coredev,

     rc = request_firmware(&fw, fw_filename, coredev->device);
     if (rc < 0) {
-        sms_info("failed to open \"%s\"", fw_filename);
+        sms_err("failed to open firmware file \"%s\"", fw_filename);
         return rc;
     }
     sms_info("read fw %s, buffer size=0x%zx", fw_filename, fw->size);
     fw_buf = kmalloc(ALIGN(fw->size, SMS_ALLOC_ALIGNMENT),
              GFP_KERNEL | GFP_DMA);
     if (!fw_buf) {
-        sms_info("failed to allocate firmware buffer");
+        sms_err("failed to allocate firmware buffer");
         return -ENOMEM;
     }
     memcpy(fw_buf, fw->data, fw->size);
