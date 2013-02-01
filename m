Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:46513 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757984Ab3BAXCf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Feb 2013 18:02:35 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 8/8] saa7134: v4l2-compliance: clear reserved part of VBI structure
Date: Sat,  2 Feb 2013 00:01:21 +0100
Message-Id: <1359759681-27549-9-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1359759681-27549-1-git-send-email-linux@rainbow-software.org>
References: <1359759681-27549-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make saa7134 driver more V4L2 compliant: clear reserved space of VBI
structure to make sure no garbage is left there

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/pci/saa7134/saa7134-video.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index eeee8b4..0b23fc8 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1552,6 +1552,7 @@ static int saa7134_try_get_set_fmt_vbi_cap(struct file *file, void *priv,
 	struct saa7134_dev *dev = fh->dev;
 	struct saa7134_tvnorm *norm = dev->tvnorm;
 
+	memset(&f->fmt.vbi.reserved, 0, sizeof(f->fmt.vbi.reserved));
 	f->fmt.vbi.sampling_rate = 6750000 * 4;
 	f->fmt.vbi.samples_per_line = 2048 /* VBI_LINE_LENGTH */;
 	f->fmt.vbi.sample_format = V4L2_PIX_FMT_GREY;
-- 
Ondrej Zary

