Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:49261 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900Ab3A1OMI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 09:12:08 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 9/7] saa7134: v4l2-compliance: initialize VBI structure
Date: Mon, 28 Jan 2013 15:11:53 +0100
Cc: linux-media@vger.kernel.org
References: <1359315912-1767-1-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1359315912-1767-1-git-send-email-linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201301281511.53915.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make saa7134 driver more V4L2 compliant: clear VBI structure completely
before assigning values to make sure any reserved space is cleared

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/pci/saa7134/saa7134-video.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c 
b/drivers/media/pci/saa7134/saa7134-video.c
index 3e88041..adb83b5 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1552,6 +1552,7 @@ static int saa7134_try_get_set_fmt_vbi_cap(struct file 
*file, void *priv,
 	struct saa7134_dev *dev = fh->dev;
 	struct saa7134_tvnorm *norm = dev->tvnorm;
 
+	memset(&f->fmt.vbi, 0, sizeof(f->fmt.vbi));
 	f->fmt.vbi.sampling_rate = 6750000 * 4;
 	f->fmt.vbi.samples_per_line = 2048 /* VBI_LINE_LENGTH */;
 	f->fmt.vbi.sample_format = V4L2_PIX_FMT_GREY;
-- 
Ondrej Zary

