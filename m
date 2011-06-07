Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:63275 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab1FGJ6K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 05:58:10 -0400
Date: Tue, 7 Jun 2011 11:58:08 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 2/3 v2] V4L: pxa-camera: try to force progressive video format
In-Reply-To: <Pine.LNX.4.64.1106071150080.31635@axis700.grange>
Message-ID: <Pine.LNX.4.64.1106071157020.31635@axis700.grange>
References: <Pine.LNX.4.64.1106071150080.31635@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The pxa-camera driver only supports progressive video so far. Passing
down to the client the same format, as what the user has requested can
result in interlaced video, even if the client supports both. This
patch avoids such cases.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/pxa_camera.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index c7f84da..88aa1ba 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1502,7 +1502,8 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 	/* limit to sensor capabilities */
 	mf.width	= pix->width;
 	mf.height	= pix->height;
-	mf.field	= pix->field;
+	/* Only progressive video supported so far */
+	mf.field	= V4L2_FIELD_NONE;
 	mf.colorspace	= pix->colorspace;
 	mf.code		= xlate->code;
 
-- 
1.7.2.5

