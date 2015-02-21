Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:55081 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbbBUSkx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2015 13:40:53 -0500
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	adi-buildroot-devel@lists.sourceforge.net
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 14/15] media: blackfin: bfin_capture: add support for VIDIOC_EXPBUF
Date: Sat, 21 Feb 2015 18:40:00 +0000
Message-Id: <1424544001-19045-15-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch adds support for VIDIOC_EXPBUF.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 4ad3c29..1fc4dbb1 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -759,6 +759,7 @@ static const struct v4l2_ioctl_ops bcap_ioctl_ops = {
 	.vidioc_querybuf         = vb2_ioctl_querybuf,
 	.vidioc_qbuf             = vb2_ioctl_qbuf,
 	.vidioc_dqbuf            = vb2_ioctl_dqbuf,
+	.vidioc_expbuf           = vb2_ioctl_expbuf,
 	.vidioc_streamon         = vb2_ioctl_streamon,
 	.vidioc_streamoff        = vb2_ioctl_streamoff,
 	.vidioc_g_parm           = bcap_g_parm,
-- 
2.1.0

