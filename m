Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56653 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751940Ab0BIXik (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2010 18:38:40 -0500
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1Nezg3-0002qY-Gh
	for linux-media@vger.kernel.org; Wed, 10 Feb 2010 00:39:31 +0100
Date: Wed, 10 Feb 2010 00:39:31 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] tw9910: use TABs for indentation
Message-ID: <Pine.LNX.4.64.1002100038410.4585@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/tw9910.c |    8 ++++----
 include/media/tw9910.h       |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index 5b801a6..76be733 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -233,10 +233,10 @@ struct tw9910_hsync_ctrl {
 };
 
 struct tw9910_priv {
-	struct v4l2_subdev                subdev;
-	struct tw9910_video_info       *info;
-	const struct tw9910_scale_ctrl *scale;
-	u32                             revision;
+	struct v4l2_subdev		subdev;
+	struct tw9910_video_info	*info;
+	const struct tw9910_scale_ctrl	*scale;
+	u32				revision;
 };
 
 static const struct tw9910_scale_ctrl tw9910_ntsc_scales[] = {
diff --git a/include/media/tw9910.h b/include/media/tw9910.h
index 5e2895a..90bcf1f 100644
--- a/include/media/tw9910.h
+++ b/include/media/tw9910.h
@@ -30,8 +30,8 @@ enum tw9910_mpout_pin {
 };
 
 struct tw9910_video_info {
-	unsigned long          buswidth;
-	enum tw9910_mpout_pin  mpout;
+	unsigned long		buswidth;
+	enum tw9910_mpout_pin	mpout;
 };
 
 
-- 
1.6.2.4

