Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:41776 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934443AbcA1JB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 04:01:58 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: Re: [PATCH 4/12] TW686x: Fix s_std() / g_std() / g_parm() pointer to self
References: <m337tif6om.fsf@t19.piap.pl>
Date: Thu, 28 Jan 2016 10:01:56 +0100
In-Reply-To: <m337tif6om.fsf@t19.piap.pl> ("Krzysztof \=\?utf-8\?Q\?Ha\=C5\=82as\?\=
 \=\?utf-8\?Q\?a\=22's\?\= message of
	"Thu, 28 Jan 2016 09:29:29 +0100")
Message-ID: <m3h9hydqm3.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index 5a1b9ab..78f4f55 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -416,7 +416,7 @@ static int tw686x_querycap(struct file *file, void *priv,
 
 static int tw686x_s_std(struct file *file, void *priv, v4l2_std_id id)
 {
-	struct tw686x_video_channel *vc = priv;
+	struct tw686x_video_channel *vc = video_drvdata(file);
 	unsigned std, count = 0;
 	u32 sdt, std_mask = 0;
 
@@ -437,7 +437,7 @@ static int tw686x_s_std(struct file *file, void *priv, v4l2_std_id id)
 
 static int tw686x_g_std(struct file *file, void *priv, v4l2_std_id *id)
 {
-	struct tw686x_video_channel *vc = priv;
+	struct tw686x_video_channel *vc = video_drvdata(file);
 
 	*id = vc->video_standard;
 	return 0;
@@ -457,7 +457,7 @@ static int tw686x_enum_fmt_vid_cap(struct file *file, void *priv,
 static int tw686x_g_parm(struct file *file, void *priv,
 			 struct v4l2_streamparm *sp)
 {
-	struct tw686x_video_channel *vc = priv;
+	struct tw686x_video_channel *vc = video_drvdata(file);
 
 	if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
