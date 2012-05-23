Return-path: <linux-media-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:9109 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870Ab2EWWsU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 18:48:20 -0400
From: Daniel Drake <dsd@laptop.org>
To: mchehab@infradead.org
Cc: corbet@lwn.net, linux-media@vger.kernel.org
Subject: [PATCH] via-camera: pass correct format settings to sensor
Message-Id: <20120523224815.D4D3C9D401E@zog.reactivated.net>
Date: Wed, 23 May 2012 23:48:15 +0100 (BST)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The code attempts to maintain a "user format" and a "sensor format",
but in this case it looks like a typo is passing the user format down
to the sensor.

This was preventing display of video at anything other than 640x480.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/media/video/via-camera.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/via-camera.c b/drivers/media/video/via-camera.c
index 308e150..eb404c2 100644
--- a/drivers/media/video/via-camera.c
+++ b/drivers/media/video/via-camera.c
@@ -963,7 +963,7 @@ static int viacam_do_try_fmt(struct via_camera *cam,
 
 	upix->pixelformat = f->pixelformat;
 	viacam_fmt_pre(upix, spix);
-	v4l2_fill_mbus_format(&mbus_fmt, upix, f->mbus_code);
+	v4l2_fill_mbus_format(&mbus_fmt, spix, f->mbus_code);
 	ret = sensor_call(cam, video, try_mbus_fmt, &mbus_fmt);
 	v4l2_fill_pix_format(spix, &mbus_fmt);
 	viacam_fmt_post(upix, spix);
-- 
1.7.10.1

