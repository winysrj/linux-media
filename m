Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:57246 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932715AbdC2VNN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 17:13:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Varsha Rao <rvarsha016@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        =?UTF-8?q?J=C3=A9r=C3=A9my=20Lefaure?=
        <jeremy.lefaure@lse.epita.fr>,
        sayli karnik <karniksayli1995@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: atomisp: avoid false-positive maybe-uninitialized warning
Date: Wed, 29 Mar 2017 23:12:21 +0200
Message-Id: <20170329211248.2617903-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In combination with CONFIG_PROFILE_ANNOTATED_BRANCHES=y, the unlikely()
inside of the WARN() macro becomes too complex for gcc to see that
we don't use the output arguments of mt9m114_to_res() are used
correctly:

drivers/staging/media/atomisp/i2c/mt9m114.c: In function 'mt9m114_get_fmt':
drivers/staging/media/atomisp/i2c/mt9m114.c:817:13: error: 'height' may be used uninitialized in this function [-Werror=maybe-uninitialized]
  int width, height;
             ^~~~~~
drivers/staging/media/atomisp/i2c/mt9m114.c: In function 'mt9m114_s_exposure_selection':
drivers/staging/media/atomisp/i2c/mt9m114.c:1179:13: error: 'height' may be used uninitialized in this function [-Werror=maybe-uninitialized]

Without WARN_ON(), there is no problem, so by simply replacing it with
v4l2_err(), the warnings go away. The WARN() output is also not needed
here, as we'd probably catch the problem before even getting here,
and other checks for the same condition already use v4l2_err.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: fix new build regression found by 0day kbuild bot
---
 drivers/staging/media/atomisp/i2c/mt9m114.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/mt9m114.c b/drivers/staging/media/atomisp/i2c/mt9m114.c
index c4f4c888a59a..ced175c268d1 100644
--- a/drivers/staging/media/atomisp/i2c/mt9m114.c
+++ b/drivers/staging/media/atomisp/i2c/mt9m114.c
@@ -689,12 +689,13 @@ static struct mt9m114_res_struct *mt9m114_to_res(u32 w, u32 h)
 	return &mt9m114_res[index];
 }
 
-static int mt9m114_res2size(unsigned int res, int *h_size, int *v_size)
+static int mt9m114_res2size(struct v4l2_subdev *sd, int *h_size, int *v_size)
 {
+	struct mt9m114_device *dev = to_mt9m114_sensor(sd);
 	unsigned short hsize;
 	unsigned short vsize;
 
-	switch (res) {
+	switch (dev->res) {
 	case MT9M114_RES_736P:
 		hsize = MT9M114_RES_736P_SIZE_H;
 		vsize = MT9M114_RES_736P_SIZE_V;
@@ -708,7 +709,8 @@ static int mt9m114_res2size(unsigned int res, int *h_size, int *v_size)
 		vsize = MT9M114_RES_960P_SIZE_V;
 		break;
 	default:
-		WARN(1, "%s: Resolution 0x%08x unknown\n", __func__, res);
+		v4l2_err(sd, "%s: Resolution 0x%08x unknown\n", __func__,
+			 dev->res);
 		return -EINVAL;
 	}
 
@@ -812,15 +814,14 @@ static int mt9m114_get_fmt(struct v4l2_subdev *sd,
 				struct v4l2_subdev_pad_config *cfg,
 				struct v4l2_subdev_format *format)
 {
-    struct v4l2_mbus_framefmt *fmt = &format->format;
-	struct mt9m114_device *dev = to_mt9m114_sensor(sd);
+	struct v4l2_mbus_framefmt *fmt = &format->format;
 	int width, height;
 	int ret;
 	if (format->pad)
 		return -EINVAL;
 	fmt->code = MEDIA_BUS_FMT_SGRBG10_1X10;
 
-	ret = mt9m114_res2size(dev->res, &width, &height);
+	ret = mt9m114_res2size(sd, &width, &height);
 	if (ret)
 		return ret;
 	fmt->width = width;
@@ -1174,7 +1175,6 @@ static int mt9m114_s_exposure_selection(struct v4l2_subdev *sd,
 					struct v4l2_subdev_selection *sel)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct mt9m114_device *dev = to_mt9m114_sensor(sd);
 	struct misensor_reg exp_reg;
 	int width, height;
 	int grid_width, grid_height;
@@ -1192,7 +1192,7 @@ static int mt9m114_s_exposure_selection(struct v4l2_subdev *sd,
 	grid_right = sel->r.left + sel->r.width - 1;
 	grid_bottom = sel->r.top + sel->r.height - 1;
 
-	ret = mt9m114_res2size(dev->res, &width, &height);
+	ret = mt9m114_res2size(sd, &width, &height);
 	if (ret)
 		return ret;
 
-- 
2.9.0
