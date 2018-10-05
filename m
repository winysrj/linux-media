Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46398 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728139AbeJEVLa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 17:11:30 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Bingbu Cao <bingbu.cao@intel.com>
Subject: [PATCH] media: imx319: fix a few coding style issues
Date: Fri,  5 Oct 2018 10:12:32 -0400
Message-Id: <7b74068d5d852fa80bd0314683cf4bf41fd870cc.1538748750.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Function alignments are off by 1 space, as reported by
checkpatch.pl --strict.

Fix those.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/i2c/imx319.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/media/i2c/imx319.c b/drivers/media/i2c/imx319.c
index 329049f7e64d..0d3e27812b93 100644
--- a/drivers/media/i2c/imx319.c
+++ b/drivers/media/i2c/imx319.c
@@ -1836,7 +1836,7 @@ static int imx319_write_reg(struct imx319 *imx319, u16 reg, u32 len, u32 val)
 
 /* Write a list of registers */
 static int imx319_write_regs(struct imx319 *imx319,
-			      const struct imx319_reg *regs, u32 len)
+			     const struct imx319_reg *regs, u32 len)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
 	int ret;
@@ -1947,8 +1947,8 @@ static const struct v4l2_ctrl_ops imx319_ctrl_ops = {
 };
 
 static int imx319_enum_mbus_code(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_pad_config *cfg,
-				  struct v4l2_subdev_mbus_code_enum *code)
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct imx319 *imx319 = to_imx319(sd);
 
@@ -1963,8 +1963,8 @@ static int imx319_enum_mbus_code(struct v4l2_subdev *sd,
 }
 
 static int imx319_enum_frame_size(struct v4l2_subdev *sd,
-				   struct v4l2_subdev_pad_config *cfg,
-				   struct v4l2_subdev_frame_size_enum *fse)
+				  struct v4l2_subdev_pad_config *cfg,
+				  struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct imx319 *imx319 = to_imx319(sd);
 
@@ -1997,8 +1997,8 @@ static void imx319_update_pad_format(struct imx319 *imx319,
 }
 
 static int imx319_do_get_pad_format(struct imx319 *imx319,
-				     struct v4l2_subdev_pad_config *cfg,
-				     struct v4l2_subdev_format *fmt)
+				    struct v4l2_subdev_pad_config *cfg,
+				    struct v4l2_subdev_format *fmt)
 {
 	struct v4l2_mbus_framefmt *framefmt;
 	struct v4l2_subdev *sd = &imx319->sd;
@@ -2014,8 +2014,8 @@ static int imx319_do_get_pad_format(struct imx319 *imx319,
 }
 
 static int imx319_get_pad_format(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_pad_config *cfg,
-				  struct v4l2_subdev_format *fmt)
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_format *fmt)
 {
 	struct imx319 *imx319 = to_imx319(sd);
 	int ret;
@@ -2029,8 +2029,8 @@ static int imx319_get_pad_format(struct v4l2_subdev *sd,
 
 static int
 imx319_set_pad_format(struct v4l2_subdev *sd,
-		       struct v4l2_subdev_pad_config *cfg,
-		       struct v4l2_subdev_format *fmt)
+		      struct v4l2_subdev_pad_config *cfg,
+		      struct v4l2_subdev_format *fmt)
 {
 	struct imx319 *imx319 = to_imx319(sd);
 	const struct imx319_mode *mode;
@@ -2380,7 +2380,7 @@ static struct imx319_hwcfg *imx319_get_hwcfg(struct device *dev)
 		goto out_err;
 
 	ret = fwnode_property_read_u32(dev_fwnode(dev), "clock-frequency",
-					&cfg->ext_clk);
+				       &cfg->ext_clk);
 	if (ret) {
 		dev_err(dev, "can't get clock frequency");
 		goto out_err;
@@ -2389,7 +2389,7 @@ static struct imx319_hwcfg *imx319_get_hwcfg(struct device *dev)
 	dev_dbg(dev, "ext clk: %d", cfg->ext_clk);
 	if (cfg->ext_clk != IMX319_EXT_CLK) {
 		dev_err(dev, "external clock %d is not supported",
-			 cfg->ext_clk);
+			cfg->ext_clk);
 		goto out_err;
 	}
 
@@ -2400,9 +2400,9 @@ static struct imx319_hwcfg *imx319_get_hwcfg(struct device *dev)
 	}
 
 	cfg->nr_of_link_freqs = bus_cfg.nr_of_link_frequencies;
-	cfg->link_freqs = devm_kcalloc(
-		dev, bus_cfg.nr_of_link_frequencies + 1,
-		sizeof(*cfg->link_freqs), GFP_KERNEL);
+	cfg->link_freqs = devm_kcalloc(dev,
+				       bus_cfg.nr_of_link_frequencies + 1,
+				       sizeof(*cfg->link_freqs), GFP_KERNEL);
 	if (!cfg->link_freqs)
 		goto out_err;
 
-- 
2.17.1
