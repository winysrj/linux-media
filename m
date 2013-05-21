Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f52.google.com ([209.85.210.52]:57895 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3EUUcw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 16:32:52 -0400
Received: by mail-da0-f52.google.com with SMTP id o9so660249dan.11
        for <linux-media@vger.kernel.org>; Tue, 21 May 2013 13:32:51 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Roberto_Alc=E2ntara?= <roberto@eletronica.org>
Date: Tue, 21 May 2013 17:32:30 -0300
Message-ID: <CAEt6MX=6BHTufFgNpo1cRRxGGkzaLYDZQtkuX4WWxHT7arkZ0w@mail.gmail.com>
Subject: [PATCH] smscoreapi: memory leak fix
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure release_firmware is called if kmalloc fails.

Signed-off-by:Roberto Alcantara <roberto@eletronica.org>
diff --git a/linux/drivers/media/common/siano/smscoreapi.c
b/linux/drivers/media/common/siano/smscoreapi.c
index dbe9b4d..f65b4e3 100644
--- a/linux/drivers/media/common/siano/smscoreapi.c
+++ b/linux/drivers/media/common/siano/smscoreapi.c
@@ -1173,16 +1173,16 @@ static int
smscore_load_firmware_from_file(struct smscore_device_t *coredev,
              GFP_KERNEL | GFP_DMA);
     if (!fw_buf) {
         sms_err("failed to allocate firmware buffer");
-        return -ENOMEM;
-    }
-    memcpy(fw_buf, fw->data, fw->size);
-    fw_buf_size = fw->size;
-
-    rc = (coredev->device_flags & SMS_DEVICE_FAMILY2) ?
-        smscore_load_firmware_family2(coredev, fw_buf, fw_buf_size)
-        : loadfirmware_handler(coredev->context, fw_buf,
-        fw_buf_size);
+        rc = -ENOMEM;
+    } else {
+        memcpy(fw_buf, fw->data, fw->size);
+        fw_buf_size = fw->size;

+        rc = (coredev->device_flags & SMS_DEVICE_FAMILY2) ?
+            smscore_load_firmware_family2(coredev, fw_buf, fw_buf_size)
+            : loadfirmware_handler(coredev->context, fw_buf,
+            fw_buf_size);
+    }
     kfree(fw_buf);
     release_firmware(fw);
