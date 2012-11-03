Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54771 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab2KCDs4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2012 23:48:56 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so5923896iea.19
        for <linux-media@vger.kernel.org>; Fri, 02 Nov 2012 20:48:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+XOLwg-Rnxm2G3mmvORXthGzeczvBEZdKGDoRZH10Wtvw@mail.gmail.com>
References: <1351773720-22639-1-git-send-email-elezegarcia@gmail.com>
	<CA+6av4nv=J7wZKKbKVSGyNRVaZUO24Qv8NwbbCK8v_ZrU-7oUQ@mail.gmail.com>
	<CALF0-+XOLwg-Rnxm2G3mmvORXthGzeczvBEZdKGDoRZH10Wtvw@mail.gmail.com>
Date: Sat, 3 Nov 2012 04:48:55 +0100
Message-ID: <CA+6av4m8Dqn_p+2MLXO7Z8+J=_=ubf6mFnzvZZ9S8B1Nf+RReg@mail.gmail.com>
Subject: Re: [PATCH] stkwebcam: Fix sparse warning on undeclared symbol
From: Arvydas Sidorenko <asido4@gmail.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-media@vger.kernel.org,
	Andrea Anacleto <andreaanacleto@libero.it>,
	Jaime Velasco Juan <jsagarribay@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> If you have the time to test it and stamp a "Tested-by" on it, I would
> appreciate it.
>
> Thanks,
>
>     Ezequiel

I applied and tested on 3.7.0-rc3 - everything is ok.
Signed patch is bellow.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
Tested-by: Arvydas Sidorenko <asido4@gmail.com>

---
 drivers/media/usb/stkwebcam/stk-webcam.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c
b/drivers/media/usb/stkwebcam/stk-webcam.c
index 86a0fc5..e4839d8 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -55,9 +55,6 @@ MODULE_AUTHOR("Jaime Velasco Juan
<jsagarribay@gmail.com> and Nicolas VIVIEN");
 MODULE_DESCRIPTION("Syntek DC1125 webcam driver");


-/* bool for webcam LED management */
-int first_init = 1;
-
 /* Some cameras have audio interfaces, we aren't interested in those */
 static struct usb_device_id stkwebcam_table[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x174f, 0xa311, 0xff, 0xff, 0xff) },
@@ -554,6 +551,7 @@ static void stk_free_buffers(struct stk_camera *dev)

 static int v4l_stk_open(struct file *fp)
 {
+    static int first_init = 1; /* webcam LED management */
 	struct stk_camera *dev;
 	struct video_device *vdev;

-- 
1.8.0
