Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33698 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751278AbeEDOTo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 10:19:44 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>
Subject: [PATCH] media: video-i2c: get rid of two gcc warnings
Date: Fri,  4 May 2018 10:19:34 -0400
Message-Id: <1b3d5f2ae882cfca37c4422dfd72fd455d01166a.1525443571.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After adding this driver, gcc complains with:

drivers/media/i2c/video-i2c.c:55:1: warning: 'static' is not at beginning of declaration [-Wold-style-declaration]
 const static struct v4l2_fmtdesc amg88xx_format = {
 ^~~~~
drivers/media/i2c/video-i2c.c:59:1: warning: 'static' is not at beginning of declaration [-Wold-style-declaration]
 const static struct v4l2_frmsize_discrete amg88xx_size = {
 ^~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/i2c/video-i2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
index 971eb46c87f6..0b347cc19aa5 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -52,11 +52,11 @@ struct video_i2c_data {
 	struct list_head vid_cap_active;
 };
 
-const static struct v4l2_fmtdesc amg88xx_format = {
+static const struct v4l2_fmtdesc amg88xx_format = {
 	.pixelformat = V4L2_PIX_FMT_Y12,
 };
 
-const static struct v4l2_frmsize_discrete amg88xx_size = {
+static const struct v4l2_frmsize_discrete amg88xx_size = {
 	.width = 8,
 	.height = 8,
 };
-- 
2.17.0
