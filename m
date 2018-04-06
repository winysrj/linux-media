Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:36634 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756408AbeDFOXd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:23:33 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 06/21] media: davinci_vpfe: vpfe_video: remove an unused var
Date: Fri,  6 Apr 2018 10:23:07 -0400
Message-Id: <991f1e2724233c32c5aa517d21bf31d2a0a2ed52.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

as warned:

  drivers/staging/media/davinci_vpfe/vpfe_video.c: In function 'vpfe_streamon':
  drivers/staging/media/davinci_vpfe/vpfe_video.c:1471:31: warning: variable 'sdinfo' set but not used [-Wunused-but-set-variable]
    struct vpfe_ext_subdev_info *sdinfo;
                               ^~~~~~

While here, cleanup this kernel-doc warning:

  drivers/staging/media/davinci_vpfe/vpfe_video.c:225: warning: Function parameter or member 'pipe' not described in 'vpfe_video_validate_pipeline'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 588743a6fd8a..390fc98d07dd 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -214,7 +214,7 @@ int vpfe_video_is_pipe_ready(struct vpfe_pipeline *pipe)
 	return 1;
 }
 
-/**
+/*
  * Validate a pipeline by checking both ends of all links for format
  * discrepancies.
  *
@@ -1468,7 +1468,6 @@ static int vpfe_streamon(struct file *file, void *priv,
 	struct vpfe_device *vpfe_dev = video->vpfe_dev;
 	struct vpfe_pipeline *pipe = &video->pipe;
 	struct vpfe_fh *fh = file->private_data;
-	struct vpfe_ext_subdev_info *sdinfo;
 	int ret = -EINVAL;
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_streamon\n");
@@ -1483,7 +1482,6 @@ static int vpfe_streamon(struct file *file, void *priv,
 		v4l2_err(&vpfe_dev->v4l2_dev, "fh->io_allowed\n");
 		return -EACCES;
 	}
-	sdinfo = video->current_ext_subdev;
 	/* If buffer queue is empty, return error */
 	if (list_empty(&video->buffer_queue.queued_list)) {
 		v4l2_err(&vpfe_dev->v4l2_dev, "buffer queue is empty\n");
-- 
2.14.3
