Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:52957 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933736AbbDYPnk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Apr 2015 11:43:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 11/12] dt3155v4l: support inputs VID0-3
Date: Sat, 25 Apr 2015 17:42:50 +0200
Message-Id: <1429976571-34872-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
References: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The dt3155 together with the J1 breakout cable supports 4 inputs. Add
support for all inputs VID0 - VID3. Note that input VID0 is shared with
input J2.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c | 18 ++++++++++++++----
 drivers/staging/media/dt3155v4l/dt3155v4l.h |  2 ++
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 450728f..43c9e0f 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -370,9 +370,12 @@ static int dt3155_s_std(struct file *filp, void *p, v4l2_std_id norm)
 
 static int dt3155_enum_input(struct file *filp, void *p, struct v4l2_input *input)
 {
-	if (input->index)
+	if (input->index > 3)
 		return -EINVAL;
-	strcpy(input->name, "Coax in");
+	if (input->index)
+		snprintf(input->name, sizeof(input->name), "VID%d", input->index);
+	else
+		strlcpy(input->name, "J2/VID0", sizeof(input->name));
 	input->type = V4L2_INPUT_TYPE_CAMERA;
 	input->std = V4L2_STD_ALL;
 	input->status = 0;
@@ -381,14 +384,21 @@ static int dt3155_enum_input(struct file *filp, void *p, struct v4l2_input *inpu
 
 static int dt3155_g_input(struct file *filp, void *p, unsigned int *i)
 {
-	*i = 0;
+	struct dt3155_priv *pd = video_drvdata(filp);
+
+	*i = pd->input;
 	return 0;
 }
 
 static int dt3155_s_input(struct file *filp, void *p, unsigned int i)
 {
-	if (i)
+	struct dt3155_priv *pd = video_drvdata(filp);
+
+	if (i > 3)
 		return -EINVAL;
+	pd->input = i;
+	write_i2c_reg(pd->regs, AD_ADDR, AD_CMD_REG);
+	write_i2c_reg(pd->regs, AD_CMD, (i << 6) | (i << 4) | SYNC_LVL_3);
 	return 0;
 }
 
diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.h b/drivers/staging/media/dt3155v4l/dt3155v4l.h
index 75c7281..bcf7b5e 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.h
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.h
@@ -168,6 +168,7 @@
  * @std:		input standard
  * @width:		frame width
  * @height:		frame height
+ * @input:		current input
  * @sequence:		frame counter
  * @stats:		statistics structure
  * @regs:		local copy of mmio base register
@@ -186,6 +187,7 @@ struct dt3155_priv {
 	spinlock_t lock;
 	v4l2_std_id std;
 	unsigned width, height;
+	unsigned input;
 	unsigned int sequence;
 	void __iomem *regs;
 	u8 csr2, config;
-- 
2.1.4

