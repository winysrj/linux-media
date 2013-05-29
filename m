Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3532 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965688Ab3E2LBD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:01:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv1 27/38] mxb: check register address when reading/writing a register.
Date: Wed, 29 May 2013 13:00:00 +0200
Message-Id: <1369825211-29770-28-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Prevent out-of-range register accesses.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7146/mxb.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/pci/saa7146/mxb.c b/drivers/media/pci/saa7146/mxb.c
index 8d17769..33abe33 100644
--- a/drivers/media/pci/saa7146/mxb.c
+++ b/drivers/media/pci/saa7146/mxb.c
@@ -669,6 +669,8 @@ static int vidioc_g_register(struct file *file, void *fh, struct v4l2_dbg_regist
 {
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 
+	if (reg->reg > pci_resource_len(dev->pci, 0) - 4)
+		return -EINVAL;
 	reg->val = saa7146_read(dev, reg->reg);
 	reg->size = 4;
 	return 0;
@@ -678,6 +680,8 @@ static int vidioc_s_register(struct file *file, void *fh, const struct v4l2_dbg_
 {
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 
+	if (reg->reg > pci_resource_len(dev->pci, 0) - 4)
+		return -EINVAL;
 	saa7146_write(dev, reg->reg, reg->val);
 	return 0;
 }
-- 
1.7.10.4

