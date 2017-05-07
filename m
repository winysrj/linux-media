Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33007 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756596AbdEGWCG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 7 May 2017 18:02:06 -0400
From: Guru Das Srinagesh <gurooodas@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@linux.intel.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: atomisp: Make undeclared symbols static
Date: Sun,  7 May 2017 13:58:58 -0700
Message-Id: <1494190738-395-1-git-send-email-gurooodas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix sparse warnings: "symbol not declared; should it be static?"

Signed-off-by: Guru Das Srinagesh <gurooodas@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
index 7ce8803..c151c84 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
@@ -130,9 +130,9 @@ static int atomisp_q_one_metadata_buffer(struct atomisp_sub_device *asd,
 	return 0;
 }
 
-int atomisp_q_one_s3a_buffer(struct atomisp_sub_device *asd,
-				enum atomisp_input_stream_id stream_id,
-				enum atomisp_css_pipe_id css_pipe_id)
+static int atomisp_q_one_s3a_buffer(struct atomisp_sub_device *asd,
+				    enum atomisp_input_stream_id stream_id,
+				    enum atomisp_css_pipe_id css_pipe_id)
 {
 	struct atomisp_s3a_buf *s3a_buf;
 	struct list_head *s3a_list;
@@ -172,9 +172,9 @@ int atomisp_q_one_s3a_buffer(struct atomisp_sub_device *asd,
 	return 0;
 }
 
-int atomisp_q_one_dis_buffer(struct atomisp_sub_device *asd,
-				enum atomisp_input_stream_id stream_id,
-				enum atomisp_css_pipe_id css_pipe_id)
+static int atomisp_q_one_dis_buffer(struct atomisp_sub_device *asd,
+				    enum atomisp_input_stream_id stream_id,
+				    enum atomisp_css_pipe_id css_pipe_id)
 {
 	struct atomisp_dis_buf *dis_buf;
 	unsigned long irqflags;
@@ -744,7 +744,7 @@ static void atomisp_subdev_init_struct(struct atomisp_sub_device *asd)
 /*
  * file operation functions
  */
-unsigned int atomisp_subdev_users(struct atomisp_sub_device *asd)
+static unsigned int atomisp_subdev_users(struct atomisp_sub_device *asd)
 {
 	return asd->video_out_preview.users +
 	       asd->video_out_vf.users +
-- 
2.7.4
