Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:57860 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752105AbbFHGUW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2015 02:20:22 -0400
Message-ID: <5575341F.9060405@xs4all.nl>
Date: Mon, 08 Jun 2015 08:20:15 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-sh@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 08/11] sh-vou: add support for log_status
References: <1433667485-35711-1-git-send-email-hverkuil@xs4all.nl> <1433667485-35711-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433667485-35711-9-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Changes since v2: drop the duplicate PSELA register)

Dump the VOU registers in log_status.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/sh_vou.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 9479c44..9319a64 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -949,6 +949,33 @@ static int sh_vou_g_std(struct file *file, void *priv, v4l2_std_id *std)
 	return 0;
 }
 
+static int sh_vou_log_status(struct file *file, void *priv)
+{
+	struct sh_vou_device *vou_dev = video_drvdata(file);
+
+	pr_info("VOUER:   0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUER));
+	pr_info("VOUCR:   0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUCR));
+	pr_info("VOUSTR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUSTR));
+	pr_info("VOUVCR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUVCR));
+	pr_info("VOUISR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUISR));
+	pr_info("VOUBCR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUBCR));
+	pr_info("VOUDPR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUDPR));
+	pr_info("VOUDSR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUDSR));
+	pr_info("VOUVPR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUVPR));
+	pr_info("VOUIR:   0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUIR));
+	pr_info("VOUSRR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUSRR));
+	pr_info("VOUMSR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUMSR));
+	pr_info("VOUHIR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUHIR));
+	pr_info("VOUDFR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUDFR));
+	pr_info("VOUAD1R: 0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUAD1R));
+	pr_info("VOUAD2R: 0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUAD2R));
+	pr_info("VOUAIR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUAIR));
+	pr_info("VOUSWR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOUSWR));
+	pr_info("VOURCR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOURCR));
+	pr_info("VOURPR:  0x%08x\n", sh_vou_reg_a_read(vou_dev, VOURPR));
+	return 0;
+}
+
 static int sh_vou_g_selection(struct file *file, void *fh,
 			      struct v4l2_selection *sel)
 {
@@ -1287,6 +1314,7 @@ static const struct v4l2_ioctl_ops sh_vou_ioctl_ops = {
 	.vidioc_g_std			= sh_vou_g_std,
 	.vidioc_g_selection		= sh_vou_g_selection,
 	.vidioc_s_selection		= sh_vou_s_selection,
+	.vidioc_log_status		= sh_vou_log_status,
 };
 
 static const struct v4l2_file_operations sh_vou_fops = {
-- 
2.1.4

