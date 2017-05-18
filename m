Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43860 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754085AbdERNvj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 09:51:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: mchehab@s-opensource.com, alan@linux.intel.com
Cc: Guru Das Srinagesh <gurooodas@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 08/13] staging: media: atomisp: Make undeclared symbols static
Date: Thu, 18 May 2017 15:50:17 +0200
Message-Id: <20170518135022.6069-9-gregkh@linuxfoundation.org>
In-Reply-To: <20170518135022.6069-1-gregkh@linuxfoundation.org>
References: <20170518135022.6069-1-gregkh@linuxfoundation.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guru Das Srinagesh <gurooodas@gmail.com>

Fix sparse warnings: "symbol not declared; should it be static?"

Signed-off-by: Guru Das Srinagesh <gurooodas@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
index 7ce8803cf6f9..c151c848cf8f 100644
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
2.13.0
