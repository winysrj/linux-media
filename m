Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757830AbZFJToh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 15:44:37 -0400
Message-Id: <200906101944.n5AJiMDU031766@imap1.linux-foundation.org>
Subject: [patch 4/6] V4L/pwc: use usb_interface as parent, not usb_device
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	mzxreary@0pointer.de, kay.sievers@vrfy.org
From: akpm@linux-foundation.org
Date: Wed, 10 Jun 2009 12:44:21 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lennart Poettering <mzxreary@0pointer.de>

The current code creates a sysfs device path where the video4linux device
is child of the usb device itself instead of the interface it belongs to. 
That is evil and confuses udev.

This patch does basically the same thing as Kay's similar patch for the
ov511 driver:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ce96d0a44a4f8d1bb3dc12b5e98cb688c1bc730d

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Lennart Poettering <mzxreary@0pointer.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/pwc/pwc-if.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/pwc/pwc-if.c~v4l-pwc-use-usb_interface-as-parent-not-usb_device drivers/media/video/pwc/pwc-if.c
--- a/drivers/media/video/pwc/pwc-if.c~v4l-pwc-use-usb_interface-as-parent-not-usb_device
+++ a/drivers/media/video/pwc/pwc-if.c
@@ -1783,7 +1783,7 @@ static int usb_pwc_probe(struct usb_inte
 		return -ENOMEM;
 	}
 	memcpy(pdev->vdev, &pwc_template, sizeof(pwc_template));
-	pdev->vdev->parent = &(udev->dev);
+	pdev->vdev->parent = &intf->dev;
 	strcpy(pdev->vdev->name, name);
 	video_set_drvdata(pdev->vdev, pdev);
 
_
