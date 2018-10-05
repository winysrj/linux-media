Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51616 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727968AbeJEVRi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 17:17:38 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tianshu Qiu <tian.shu.qiu@intel.com>
Subject: [PATCH] media: imx355: fix a few coding style issues
Date: Fri,  5 Oct 2018 10:18:39 -0400
Message-Id: <0bd81e42f9b1466000835989c94b4048a87c3a6c.1538749118.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Function alignments are off by 1 space, as reported by
checkpatch.pl --strict.

Fix those.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/i2c/imx355.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/media/i2c/imx355.c b/drivers/media/i2c/imx355.c
index 803df2a014bb..20c8eea5db4b 100644
--- a/drivers/media/i2c/imx355.c
+++ b/drivers/media/i2c/imx355.c
@@ -1136,7 +1136,7 @@ static int imx355_write_reg(struct imx355 *imx355, u16 reg, u32 len, u32 val)
 
 /* Write a list of registers */
 static int imx355_write_regs(struct imx355 *imx355,
-			      const struct imx355_reg *regs, u32 len)
+			     const struct imx355_reg *regs, u32 len)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&imx355->sd);
 	int ret;
@@ -1248,8 +1248,8 @@ static const struct v4l2_ctrl_ops imx355_ctrl_ops = {
 };
 
 static int imx355_enum_mbus_code(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_pad_config *cfg,
-				  struct v4l2_subdev_mbus_code_enum *code)
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct imx355 *imx355 = to_imx355(sd);
 
@@ -1264,8 +1264,8 @@ static int imx355_enum_mbus_code(struct v4l2_subdev *sd,
 }
 
 static int imx355_enum_frame_size(struct v4l2_subdev *sd,
-				   struct v4l2_subdev_pad_config *cfg,
-				   struct v4l2_subdev_frame_size_enum *fse)
+				  struct v4l2_subdev_pad_config *cfg,
+				  struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct imx355 *imx355 = to_imx355(sd);
 
@@ -1298,8 +1298,8 @@ static void imx355_update_pad_format(struct imx355 *imx355,
 }
 
 static int imx355_do_get_pad_format(struct imx355 *imx355,
-				     struct v4l2_subdev_pad_config *cfg,
-				     struct v4l2_subdev_format *fmt)
+				    struct v4l2_subdev_pad_config *cfg,
+				    struct v4l2_subdev_format *fmt)
 {
 	struct v4l2_mbus_framefmt *framefmt;
 	struct v4l2_subdev *sd = &imx355->sd;
@@ -1315,8 +1315,8 @@ static int imx355_do_get_pad_format(struct imx355 *imx355,
 }
 
 static int imx355_get_pad_format(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_pad_config *cfg,
-				  struct v4l2_subdev_format *fmt)
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_format *fmt)
 {
 	struct imx355 *imx355 = to_imx355(sd);
 	int ret;
@@ -1330,8 +1330,8 @@ static int imx355_get_pad_format(struct v4l2_subdev *sd,
 
 static int
 imx355_set_pad_format(struct v4l2_subdev *sd,
-		       struct v4l2_subdev_pad_config *cfg,
-		       struct v4l2_subdev_format *fmt)
+		      struct v4l2_subdev_pad_config *cfg,
+		      struct v4l2_subdev_format *fmt)
 {
 	struct imx355 *imx355 = to_imx355(sd);
 	const struct imx355_mode *mode;
@@ -1680,7 +1680,7 @@ static struct imx355_hwcfg *imx355_get_hwcfg(struct device *dev)
 		goto out_err;
 
 	ret = fwnode_property_read_u32(dev_fwnode(dev), "clock-frequency",
-					&cfg->ext_clk);
+				       &cfg->ext_clk);
 	if (ret) {
 		dev_err(dev, "can't get clock frequency");
 		goto out_err;
@@ -1689,7 +1689,7 @@ static struct imx355_hwcfg *imx355_get_hwcfg(struct device *dev)
 	dev_dbg(dev, "ext clk: %d", cfg->ext_clk);
 	if (cfg->ext_clk != IMX355_EXT_CLK) {
 		dev_err(dev, "external clock %d is not supported",
-			 cfg->ext_clk);
+			cfg->ext_clk);
 		goto out_err;
 	}
 
@@ -1700,9 +1700,9 @@ static struct imx355_hwcfg *imx355_get_hwcfg(struct device *dev)
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
