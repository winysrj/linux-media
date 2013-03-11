Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3675 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab3CKVBM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 17:01:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 13/15] au0828: don't change global state information on open().
Date: Mon, 11 Mar 2013 22:00:44 +0100
Message-Id: <5e0a0e255cd84992ca541d2aeb7c122b574ae859.1363035203.git.hans.verkuil@cisco.com>
In-Reply-To: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
References: <1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
References: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Just opening a device shouldn't have any side-effects.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/au0828/au0828-video.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index ac89b2c5..1f06d97 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1005,11 +1005,6 @@ static int au0828_v4l2_open(struct file *filp)
 			printk(KERN_INFO "Au0828 can't set alternate to 5!\n");
 			return -EBUSY;
 		}
-		dev->width = NTSC_STD_W;
-		dev->height = NTSC_STD_H;
-		dev->frame_size = dev->width * dev->height * 2;
-		dev->field_size = dev->width * dev->height;
-		dev->bytesperline = dev->width * 2;
 
 		au0828_analog_stream_enable(dev);
 		au0828_analog_stream_reset(dev);
@@ -1031,8 +1026,6 @@ static int au0828_v4l2_open(struct file *filp)
 				    &dev->lock);
 
 	/* VBI Setup */
-	dev->vbi_width = 720;
-	dev->vbi_height = 1;
 	videobuf_queue_vmalloc_init(&fh->vb_vbiq, &au0828_vbi_qops,
 				    NULL, &dev->slock,
 				    V4L2_BUF_TYPE_VBI_CAPTURE,
@@ -1983,6 +1976,8 @@ int au0828_analog_register(struct au0828_dev *dev,
 	dev->field_size = dev->width * dev->height;
 	dev->frame_size = dev->field_size << 1;
 	dev->bytesperline = dev->width << 1;
+	dev->vbi_width = 720;
+	dev->vbi_height = 1;
 	dev->ctrl_ainput = 0;
 	dev->ctrl_freq = 960;
 	dev->std = V4L2_STD_NTSC_M;
-- 
1.7.10.4

