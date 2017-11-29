Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:38009 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751897AbdK2TIq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:08:46 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [PATCH 09/22] media: tvp514x: fix kernel-doc parameters
Date: Wed, 29 Nov 2017 14:08:27 -0500
Message-Id: <ca292c88e954f0f49029445bfef57364dff705db.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are some struct fields that aren't documented, and some
consts whose comments start with /**, but they aren't kernel-doc
annotations. So, fix it:

  drivers/media/i2c/tvp514x.c:127: warning: No description found for parameter 'hdl'
  drivers/media/i2c/tvp514x.c:127: warning: No description found for parameter 'pad'
  drivers/media/i2c/tvp514x.c:127: warning: No description found for parameter 'format'
  drivers/media/i2c/tvp514x.c:127: warning: No description found for parameter 'int_seq'
  drivers/media/i2c/tvp514x.c:219: warning: cannot understand function prototype: 'const struct v4l2_fmtdesc tvp514x_fmt_list[] = '
  drivers/media/i2c/tvp514x.c:235: warning: cannot understand function prototype: 'const struct tvp514x_std_info tvp514x_std_list[] = '
  drivers/media/i2c/tvp514x.c:941: warning: No description found for parameter 'fmt'
  drivers/media/i2c/tvp514x.c:941: warning: Excess function parameter 'format' description in 'tvp514x_set_pad_format'
  drivers/media/i2c/tvp514x.c:1208: warning: cannot understand function prototype: 'const struct i2c_device_id tvp514x_id[] = '

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/tvp514x.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index ad2df998f9c5..d575b3e7e835 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -86,6 +86,7 @@ static int tvp514x_s_stream(struct v4l2_subdev *sd, int enable);
 /**
  * struct tvp514x_decoder - TVP5146/47 decoder object
  * @sd: Subdevice Slave handle
+ * @hdl: embedded &struct v4l2_ctrl_handler
  * @tvp514x_regs: copy of hw's regs with preset values.
  * @pdata: Board specific
  * @ver: Chip version
@@ -98,6 +99,9 @@ static int tvp514x_s_stream(struct v4l2_subdev *sd, int enable);
  * @std_list: Standards list
  * @input: Input routing at chip level
  * @output: Output routing at chip level
+ * @pad: subdev media pad associated with the decoder
+ * @format: media bus frame format
+ * @int_seq: driver's register init sequence
  */
 struct tvp514x_decoder {
 	struct v4l2_subdev sd;
@@ -211,7 +215,7 @@ static struct tvp514x_reg tvp514x_reg_list_default[] = {
 	{TOK_TERM, 0, 0},
 };
 
-/**
+/*
  * List of image formats supported by TVP5146/47 decoder
  * Currently we are using 8 bit mode only, but can be
  * extended to 10/20 bit mode.
@@ -226,7 +230,7 @@ static const struct v4l2_fmtdesc tvp514x_fmt_list[] = {
 	},
 };
 
-/**
+/*
  * Supported standards -
  *
  * Currently supports two standards only, need to add support for rest of the
@@ -931,7 +935,7 @@ static int tvp514x_get_pad_format(struct v4l2_subdev *sd,
  * tvp514x_set_pad_format() - V4L2 decoder interface handler for set pad format
  * @sd: pointer to standard V4L2 sub-device structure
  * @cfg: pad configuration
- * @format: pointer to v4l2_subdev_format structure
+ * @fmt: pointer to v4l2_subdev_format structure
  *
  * Set pad format for the output pad
  */
@@ -1199,7 +1203,7 @@ static const struct tvp514x_reg tvp514xm_init_reg_seq[] = {
 	{TOK_TERM, 0, 0},
 };
 
-/**
+/*
  * I2C Device Table -
  *
  * name - Name of the actual device/chip.
-- 
2.14.3
