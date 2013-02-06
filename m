Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1910 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203Ab3BFP4y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 10:56:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 09/17] bttv: fill in colorspace.
Date: Wed,  6 Feb 2013 16:56:27 +0100
Message-Id: <f95a9551e1eb85bb90779788144f2eea8334b0cf.1360165855.git.hans.verkuil@cisco.com>
In-Reply-To: <1360166195-18010-1-git-send-email-hverkuil@xs4all.nl>
References: <1360166195-18010-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c5d83e654c3cfd166ee832f83458c19904851980.1360165855.git.hans.verkuil@cisco.com>
References: <c5d83e654c3cfd166ee832f83458c19904851980.1360165855.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 3ba423e..70878e6 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2506,6 +2506,7 @@ static int bttv_g_fmt_vid_cap(struct file *file, void *priv,
 				fh->width, fh->height);
 	f->fmt.pix.field        = fh->cap.field;
 	f->fmt.pix.pixelformat  = fh->fmt->fourcc;
+	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
 
 	return 0;
 }
@@ -2577,6 +2578,7 @@ static int bttv_try_fmt_vid_cap(struct file *file, void *priv,
 	/* update data for the application */
 	f->fmt.pix.field = field;
 	pix_format_set_size(&f->fmt.pix, fmt, width, height);
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 
 	return 0;
 }
-- 
1.7.10.4

