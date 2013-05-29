Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3205 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965699Ab3E2LBS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:01:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCHv1 26/38] saa7134: check register address in g_register.
Date: Wed, 29 May 2013 12:59:59 +0200
Message-Id: <1369825211-29770-27-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Prevent reading out-of-range register values.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/saa7134/saa7134-video.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 737e643..db4cc1c 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2258,7 +2258,7 @@ static int vidioc_g_register (struct file *file, void *priv,
 	struct saa7134_fh *fh = priv;
 	struct saa7134_dev *dev = fh->dev;
 
-	reg->val = saa_readb(reg->reg);
+	reg->val = saa_readb(reg->reg & 0xffffff);
 	reg->size = 1;
 	return 0;
 }
@@ -2269,7 +2269,7 @@ static int vidioc_s_register (struct file *file, void *priv,
 	struct saa7134_fh *fh = priv;
 	struct saa7134_dev *dev = fh->dev;
 
-	saa_writeb(reg->reg&0xffffff, reg->val);
+	saa_writeb(reg->reg & 0xffffff, reg->val);
 	return 0;
 }
 #endif
-- 
1.7.10.4

