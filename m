Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2313 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab3C3Jbv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Mar 2013 05:31:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH] em28xx: fix typo in scale_to_size().
Date: Sat, 30 Mar 2013 10:31:42 +0100
Cc: Frank Schaefer <fschaefer.oss@googlemail.com>,
	Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303301031.42165.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em28xx: fix typo in scale_to_size().

The second hscale should be vscale. This bug caused xawtv to fail because it
cannot find a workable image size.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index ef1959b..792ead1 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -996,7 +996,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	}
 
 	size_to_scale(dev, width, height, &hscale, &vscale);
-	scale_to_size(dev, hscale, hscale, &width, &height);
+	scale_to_size(dev, hscale, vscale, &width, &height);
 
 	f->fmt.pix.width = width;
 	f->fmt.pix.height = height;
-- 
1.7.10.4

