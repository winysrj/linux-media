Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2979 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965676Ab3E2LJL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:09:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCHv1 36/38] cx88: fix register mask.
Date: Wed, 29 May 2013 13:00:09 +0200
Message-Id: <1369825211-29770-37-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Ensure that the register is aligned to a dword, otherwise the read could
read out-of-range data.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/cx88/cx88-video.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 6b3a9ae..c3af4aa 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -1362,7 +1362,7 @@ static int vidioc_g_register (struct file *file, void *fh,
 	struct cx88_core *core = ((struct cx8800_fh*)fh)->dev->core;
 
 	/* cx2388x has a 24-bit register space */
-	reg->val = cx_read(reg->reg & 0xffffff);
+	reg->val = cx_read(reg->reg & 0xfffffc);
 	reg->size = 4;
 	return 0;
 }
@@ -1372,7 +1372,7 @@ static int vidioc_s_register (struct file *file, void *fh,
 {
 	struct cx88_core *core = ((struct cx8800_fh*)fh)->dev->core;
 
-	cx_write(reg->reg & 0xffffff, reg->val);
+	cx_write(reg->reg & 0xfffffc, reg->val);
 	return 0;
 }
 #endif
-- 
1.7.10.4

