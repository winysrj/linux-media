Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39136 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab0JUTV7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 15:21:59 -0400
Date: Thu, 21 Oct 2010 21:21:45 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Istvan Varga <istvanv@users.sourceforge.net>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] V4L/DVB: cx88: uninitialized variable
Message-ID: <20101021192145.GH5985@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Fixes a gcc warning:

drivers/media/video/cx88/cx88-video.c:772:
	warning: ‘core’ may be used uninitialized in this function

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 19c64a7..c19ec71 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -752,7 +752,7 @@ static int video_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct cx8800_dev *dev = video_drvdata(file);
-	struct cx88_core *core;
+	struct cx88_core *core = dev->core;
 	struct cx8800_fh *fh;
 	enum v4l2_buf_type type = 0;
 	int radio = 0;
@@ -786,7 +786,6 @@ static int video_open(struct file *file)
 	fh->fmt      = format_by_fourcc(V4L2_PIX_FMT_BGR24);
 
 	mutex_lock(&core->lock);
-	core = dev->core;
 
 	videobuf_queue_sg_init(&fh->vidq, &cx8800_video_qops,
 			    &dev->pci->dev, &dev->slock,
