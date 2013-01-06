Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:50126 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab3AFMdM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Jan 2013 07:33:12 -0500
Received: by mail-ee0-f54.google.com with SMTP id c13so9052335eek.41
        for <linux-media@vger.kernel.org>; Sun, 06 Jan 2013 04:33:11 -0800 (PST)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] s5p-tv: mixer: fix handling of VIDIOC_S_FMT
Date: Sun,  6 Jan 2013 13:33:00 +0100
Message-Id: <1357475581-680-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tomasz Stanislawski <t.stanislaws@samsung.com>

The VIDIOC_S_FMT ioctl must not fail if 4cc is invalid.
It should adjust proposed 4cc to the available one.
The s5p-mixer fails on s_fmt if unsupported 4cc is used.
This patch fixes this issue by using the default format
for a given layer.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/s5p-tv/mixer_video.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 7379e77..405414f 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -324,10 +324,9 @@ static int mxr_s_fmt(struct file *file, void *priv,
 	pix = &f->fmt.pix_mp;
 	fmt = find_format_by_fourcc(layer, pix->pixelformat);
 	if (fmt == NULL) {
-		mxr_warn(mdev, "not recognized fourcc: %08x\n",
+		mxr_dbg(mdev, "not recognized fourcc: %08x\n",
 			pix->pixelformat);
-		return -EINVAL;
+		fmt = layer->fmt_array[0];
 	}
 	layer->fmt = fmt;
 	/* set source size to highest accepted value */
--
1.7.4.1

