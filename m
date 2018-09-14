Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57238 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbeINXiT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 19:38:19 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/4] media: em28xx: make v4l2-compliance happier by starting sequence on zero
Date: Fri, 14 Sep 2018 15:22:34 -0300
Message-Id: <88789c529759c28029c89f41442d745d4dd5aae8.1536949178.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1536949178.git.mchehab+samsung@kernel.org>
References: <cover.1536949178.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1536949178.git.mchehab+samsung@kernel.org>
References: <cover.1536949178.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2-compliance tool complains if a video doesn't start
with a zero sequence number.

While this shouldn't cause any real problem for apps, let's
make it happier, in order to better check the v4l2-compliance
differences before and after patchsets.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-video.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 41ac47f1589c..26859aaf5c93 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1093,6 +1093,8 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 
 	em28xx_videodbg("%s\n", __func__);
 
+	dev->v4l2->field_count = 0;
+
 	/*
 	 * Make sure streaming is not already in progress for this type
 	 * of filehandle (e.g. video, vbi)
-- 
2.17.1
