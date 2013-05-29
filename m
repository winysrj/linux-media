Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3615 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965716Ab3E2LBV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:01:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCHv1 35/38] cx18: fix register range check
Date: Wed, 29 May 2013 13:00:08 +0200
Message-Id: <1369825211-29770-36-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Ensure that the register is aligned to a dword, otherwise the range check
could fail since it assumes dword alignment.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/pci/cx18/cx18-ioctl.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index 414b0ec..1110bcb 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -367,6 +367,8 @@ static int cx18_g_register(struct file *file, void *fh,
 {
 	struct cx18 *cx = fh2id(fh)->cx;
 
+	if (reg->reg & 0x3)
+		return -EINVAL;
 	if (reg->reg >= CX18_MEM_OFFSET + CX18_MEM_SIZE)
 		return -EINVAL;
 	reg->size = 4;
@@ -379,6 +381,8 @@ static int cx18_s_register(struct file *file, void *fh,
 {
 	struct cx18 *cx = fh2id(fh)->cx;
 
+	if (reg->reg & 0x3)
+		return -EINVAL;
 	if (reg->reg >= CX18_MEM_OFFSET + CX18_MEM_SIZE)
 		return -EINVAL;
 	cx18_write_enc(cx, reg->val, reg->reg);
-- 
1.7.10.4

