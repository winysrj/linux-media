Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37158 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752858AbdGSJ6i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 05:58:38 -0400
Date: Wed, 19 Jul 2017 12:58:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] [media] atomisp2: array underflow in imx_enum_frame_size()
Message-ID: <20170719095820.ucy74kccuph5i737@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The code looks in imx_enum_frame_size() looks like this:

  2066          int index = fse->index;
  2067          struct imx_device *dev = to_imx_sensor(sd);
  2068  
  2069          mutex_lock(&dev->input_lock);
  2070          if (index >= dev->entries_curr_table) {
  2071                  mutex_unlock(&dev->input_lock);
  2072                  return -EINVAL;
  2073          }
  2074  
  2075          fse->min_width = dev->curr_res_table[index].width;

"fse->index" is a u32 that comes from the user.  We want negative values
of "index" to be -EINVAL so we don't read before the start of the
dev->curr_res_table[] array.  I've made "entries_curr_table" unsigned
long to fix this.  I thought about making it unsigned int, but because
of struct alignment, it doesn't use more memory either way.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/atomisp/i2c/imx/imx.h b/drivers/staging/media/atomisp/i2c/imx/imx.h
index 36b3f3a5a41f..41b4133ca995 100644
--- a/drivers/staging/media/atomisp/i2c/imx/imx.h
+++ b/drivers/staging/media/atomisp/i2c/imx/imx.h
@@ -480,7 +480,7 @@ struct imx_device {
 	struct imx_vcm *vcm_driver;
 	struct imx_otp *otp_driver;
 	const struct imx_resolution *curr_res_table;
-	int entries_curr_table;
+	unsigned long entries_curr_table;
 	const struct firmware *fw;
 	struct imx_reg_addr *reg_addr;
 	const struct imx_reg *param_hold;
diff --git a/drivers/staging/media/atomisp/i2c/ov8858.h b/drivers/staging/media/atomisp/i2c/ov8858.h
index 9be6a0e63861..d3fde200c013 100644
--- a/drivers/staging/media/atomisp/i2c/ov8858.h
+++ b/drivers/staging/media/atomisp/i2c/ov8858.h
@@ -266,7 +266,7 @@ struct ov8858_device {
 	const struct ov8858_reg *regs;
 	struct ov8858_vcm *vcm_driver;
 	const struct ov8858_resolution *curr_res_table;
-	int entries_curr_table;
+	unsigned long entries_curr_table;
 
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_ctrl *run_mode;
diff --git a/drivers/staging/media/atomisp/i2c/ov8858_btns.h b/drivers/staging/media/atomisp/i2c/ov8858_btns.h
index 09e3cdc1a394..f9a3cf8fbf1a 100644
--- a/drivers/staging/media/atomisp/i2c/ov8858_btns.h
+++ b/drivers/staging/media/atomisp/i2c/ov8858_btns.h
@@ -266,7 +266,7 @@ struct ov8858_device {
 	const struct ov8858_reg *regs;
 	struct ov8858_vcm *vcm_driver;
 	const struct ov8858_resolution *curr_res_table;
-	int entries_curr_table;
+	unsigned long entries_curr_table;
 
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_ctrl *run_mode;
