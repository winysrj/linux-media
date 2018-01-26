Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:39164 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752941AbeAZOoa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Jan 2018 09:44:30 -0500
From: Colin King <colin.king@canonical.com>
To: Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: staging: atomisp: remove redundant assignments to various variables
Date: Fri, 26 Jan 2018 14:44:24 +0000
Message-Id: <20180126144424.21406-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

There are various assignments that are being made to variables that are
not read and the variables are being updated later on, hence the redundant
assignments can be removed.

Cleans up clang warnings:
drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:1950:8:
warning: Value stored to 'pdata' during its initialization is never read
drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c:1853:29:
warning: Value stored to 'asd' during its initialization is never read
drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c:4505:29:
warning: Value stored to 'asd' during its initialization is never read
drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c:1139:30:
warning: Value stored to 'asd' during its initialization is never read
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c:6961:27:
warning: Value stored to 'tmp_in_info' during its initialization is
never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c         | 2 +-
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c          | 2 +-
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c | 2 +-
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c         | 1 -
 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c       | 2 +-
 5 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
index 40d01bf4bf28..ba0c584d5be7 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
@@ -1947,7 +1947,7 @@ static int ov5693_probe(struct i2c_client *client)
 	struct ov5693_device *dev;
 	int i2c;
 	int ret = 0;
-	void *pdata = client->dev.platform_data;
+	void *pdata;
 	unsigned int i;
 
 	/*
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index debf0e3853ff..ddad1231f2e5 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -1850,7 +1850,7 @@ irqreturn_t atomisp_isr_thread(int irq, void *isp_ptr)
 	bool frame_done_found[MAX_STREAM_NUM] = {0};
 	bool css_pipe_done[MAX_STREAM_NUM] = {0};
 	unsigned int i;
-	struct atomisp_sub_device *asd = &isp->asd[0];
+	struct atomisp_sub_device *asd;
 
 	dev_dbg(isp->dev, ">%s\n", __func__);
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
index b7f9da014641..7621b4537147 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
@@ -4502,7 +4502,7 @@ int atomisp_css_isr_thread(struct atomisp_device *isp,
 {
 	enum atomisp_input_stream_id stream_id = 0;
 	struct atomisp_css_event current_event;
-	struct atomisp_sub_device *asd = &isp->asd[0];
+	struct atomisp_sub_device *asd;
 #ifndef ISP2401
 	bool reset_wdt_timer[MAX_STREAM_NUM] = {false};
 #endif
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index 548e00e7d67b..ba20344ec560 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -1137,7 +1137,6 @@ static int init_atomisp_wdts(struct atomisp_device *isp)
 
 	for (i = 0; i < isp->num_of_streams; i++) {
 		struct atomisp_sub_device *asd = &isp->asd[i];
-		asd = &isp->asd[i];
 #ifndef ISP2401
 		timer_setup(&asd->wdt, atomisp_wdt, 0);
 #else
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 322bb3de6098..b3300969089b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -6958,7 +6958,7 @@ static enum ia_css_err ia_css_pipe_create_cas_scaler_desc_single_output(
 	unsigned int i;
 	unsigned int hor_ds_factor = 0, ver_ds_factor = 0;
 	enum ia_css_err err = IA_CSS_SUCCESS;
-	struct ia_css_frame_info tmp_in_info = IA_CSS_BINARY_DEFAULT_FRAME_INFO;
+	struct ia_css_frame_info tmp_in_info;
 
 	unsigned max_scale_factor_per_stage = MAX_PREFERRED_YUV_DS_PER_STEP;
 
-- 
2.15.1
