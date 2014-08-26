Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44072 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695AbaHZVzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:18 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 03/35] [media] dm644x_ccdc: declare some functions as static
Date: Tue, 26 Aug 2014 18:54:39 -0300
Message-Id: <1409090111-8290-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/davinci/dm644x_ccdc.c:133:6: warning: no previous protot
ype for 'ccdc_setwin' [-Wmissing-prototypes]
 void ccdc_setwin(struct v4l2_rect *image_win,
      ^
drivers/media/platform/davinci/dm644x_ccdc.c:373:6: warning: no previous protot
ype for 'ccdc_config_ycbcr' [-Wmissing-prototypes]
 void ccdc_config_ycbcr(void)
      ^
drivers/media/platform/davinci/dm644x_ccdc.c:526:6: warning: no previous protot
ype for 'ccdc_config_raw' [-Wmissing-prototypes]
 void ccdc_config_raw(void)
      ^

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/davinci/dm644x_ccdc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
index 07e98df3d867..b0b9cd54e9e9 100644
--- a/drivers/media/platform/davinci/dm644x_ccdc.c
+++ b/drivers/media/platform/davinci/dm644x_ccdc.c
@@ -130,9 +130,9 @@ static void ccdc_enable_vport(int flag)
  * This function will configure the window size
  * to be capture in CCDC reg
  */
-void ccdc_setwin(struct v4l2_rect *image_win,
-		enum ccdc_frmfmt frm_fmt,
-		int ppc)
+static void ccdc_setwin(struct v4l2_rect *image_win,
+			enum ccdc_frmfmt frm_fmt,
+			int ppc)
 {
 	int horz_start, horz_nr_pixels;
 	int vert_start, vert_nr_lines;
@@ -370,7 +370,7 @@ static int ccdc_set_params(void __user *params)
  * ccdc_config_ycbcr()
  * This function will configure CCDC for YCbCr video capture
  */
-void ccdc_config_ycbcr(void)
+static void ccdc_config_ycbcr(void)
 {
 	struct ccdc_params_ycbcr *params = &ccdc_cfg.ycbcr;
 	u32 syn_mode;
@@ -523,7 +523,7 @@ static void ccdc_config_fpc(struct ccdc_fault_pixel *fpc)
  * ccdc_config_raw()
  * This function will configure CCDC for Raw capture mode
  */
-void ccdc_config_raw(void)
+static void ccdc_config_raw(void)
 {
 	struct ccdc_params_raw *params = &ccdc_cfg.bayer;
 	struct ccdc_config_params_raw *config_params =
-- 
1.9.3

