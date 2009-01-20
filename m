Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:45055 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbZATWOP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 17:14:15 -0500
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id D14FA11F9EA
	for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 22:38:07 +0100 (CET)
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 71AB3D48024
	for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 22:37:24 +0100 (CET)
Received: from [192.168.1.151] (unknown [78.226.152.136])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 6C3E4D4809C
	for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 22:37:22 +0100 (CET)
Message-ID: <49764412.8030305@free.fr>
Date: Tue, 20 Jan 2009 22:37:22 +0100
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH 1/5] usbvision: use usb_make_path to report bus info
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
Here is the set of patches that makes usb driver use usb_make_path to report bus info (except for pvrusb2 since Mike said he would do the patch)
I would like to have a Acked-by for these patches before doing a pull request, to be sure I did not do weird things.
Thanks
Cheers,
Thierry

usb_make_path reports canonical bus info. Use it when reporting bus info
in VIDIOC_QUERYCAP.

Signed-off-by: Thierry MERLE <thierry.merle@free.fr>
---
diff -r f4d7d0b84940 -r 306881b74bb9 linux/drivers/media/video/usbvision/usbvision-video.c
--- a/linux/drivers/media/video/usbvision/usbvision-video.c	Sun Jan 18 10:55:38 2009 +0000
+++ b/linux/drivers/media/video/usbvision/usbvision-video.c	Tue Jan 20 21:40:44 2009 +0100
@@ -524,8 +524,7 @@
 	strlcpy(vc->card,
 		usbvision_device_data[usbvision->DevModel].ModelString,
 		sizeof(vc->card));
-	strlcpy(vc->bus_info, dev_name(&usbvision->dev->dev),
-		sizeof(vc->bus_info));
+	usb_make_path(usbvision->dev, vc->bus_info, sizeof(vc->bus_info));
 	vc->version = USBVISION_DRIVER_VERSION;
 	vc->capabilities = V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_AUDIO |
