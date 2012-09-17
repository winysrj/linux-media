Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:54366 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab2IQNrp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 09:47:45 -0400
Received: by ggdk6 with SMTP id k6so1433998ggd.19
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2012 06:47:44 -0700 (PDT)
From: elezegarcia@gmail.com
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	<linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 2/4] pwc: Add return code check at vb2_queue_init()
Date: Mon, 17 Sep 2012 10:47:38 -0300
Message-Id: <1347889658-15116-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ezequiel Garcia <elezegarcia@gmail.com>

This function returns an integer and it's mandatory
to check the return code.

Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/usb/pwc/pwc-if.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 42e36ba..31d082e 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -1000,7 +1000,9 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 	pdev->vb_queue.buf_struct_size = sizeof(struct pwc_frame_buf);
 	pdev->vb_queue.ops = &pwc_vb_queue_ops;
 	pdev->vb_queue.mem_ops = &vb2_vmalloc_memops;
-	vb2_queue_init(&pdev->vb_queue);
+	rc = vb2_queue_init(&pdev->vb_queue);
+	if (rc)
+		goto err_free_mem;
 
 	/* Init video_device structure */
 	memcpy(&pdev->vdev, &pwc_template, sizeof(pwc_template));
-- 
1.7.8.6

