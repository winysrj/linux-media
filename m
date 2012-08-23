Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36090 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab2HWNIs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 09:08:48 -0400
Received: by mail-yw0-f46.google.com with SMTP id m54so166064yhm.19
        for <linux-media@vger.kernel.org>; Thu, 23 Aug 2012 06:08:48 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	<linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 02/10] pwc: Remove unneeded struct vb2_queue clearing
Date: Thu, 23 Aug 2012 10:08:23 -0300
Message-Id: <1345727311-27478-2-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1345727311-27478-1-git-send-email-elezegarcia@gmail.com>
References: <1345727311-27478-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

struct vb2_queue is allocated through kzalloc as part of a larger struct,
there's no need to clear it.

Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/usb/pwc/pwc-if.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index de7c7ba..825c61a 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -994,7 +994,6 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 	pdev->power_save = my_power_save;
 
 	/* Init videobuf2 queue structure */
-	memset(&pdev->vb_queue, 0, sizeof(pdev->vb_queue));
 	pdev->vb_queue.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	pdev->vb_queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
 	pdev->vb_queue.drv_priv = pdev;
-- 
1.7.8.6

