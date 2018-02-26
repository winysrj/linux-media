Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:47910 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751825AbeBZNkQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 08:40:16 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/3] media: tvp541x: fix some kernel-doc parameters
Date: Mon, 26 Feb 2018 08:40:09 -0500
Message-Id: <225fe212a2d58c7113aa2781a3594ae8d9827ea9.1519652405.git.mchehab@s-opensource.com>
In-Reply-To: <00d9da502565e97fcca3805eec98db6df3594ec0.1519652405.git.mchehab@s-opensource.com>
References: <00d9da502565e97fcca3805eec98db6df3594ec0.1519652405.git.mchehab@s-opensource.com>
In-Reply-To: <00d9da502565e97fcca3805eec98db6df3594ec0.1519652405.git.mchehab@s-opensource.com>
References: <00d9da502565e97fcca3805eec98db6df3594ec0.1519652405.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Solve the following warnings:
  + drivers/media/i2c/tvp514x.c: warning: Excess function parameter 'a' description in 'tvp514x_g_frame_interval':  => 759
  + drivers/media/i2c/tvp514x.c: warning: Excess function parameter 'a' description in 'tvp514x_s_frame_interval':  => 784
  + drivers/media/i2c/tvp514x.c: warning: Function parameter or member 'ival' not described in 'tvp514x_g_frame_interval':  => 759
  + drivers/media/i2c/tvp514x.c: warning: Function parameter or member 'ival' not described in 'tvp514x_s_frame_interval':  => 784

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/tvp514x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 310f9fce520d..6a9890531d01 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -749,7 +749,7 @@ static int tvp514x_s_ctrl(struct v4l2_ctrl *ctrl)
 /**
  * tvp514x_g_frame_interval() - V4L2 decoder interface handler
  * @sd: pointer to standard V4L2 sub-device structure
- * @a: pointer to a v4l2_subdev_frame_interval structure
+ * @ival: pointer to a v4l2_subdev_frame_interval structure
  *
  * Returns the decoder's video CAPTURE parameters.
  */
@@ -773,7 +773,7 @@ tvp514x_g_frame_interval(struct v4l2_subdev *sd,
 /**
  * tvp514x_s_frame_interval() - V4L2 decoder interface handler
  * @sd: pointer to standard V4L2 sub-device structure
- * @a: pointer to a v4l2_subdev_frame_interval structure
+ * @ival: pointer to a v4l2_subdev_frame_interval structure
  *
  * Configures the decoder to use the input parameters, if possible. If
  * not possible, returns the appropriate error code.
-- 
2.14.3
