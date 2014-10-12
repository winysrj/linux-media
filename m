Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:41499 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaJLUlG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Oct 2014 16:41:06 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 10/15] media: davinci: vpbe: add support for VIDIOC_CREATE_BUFS
Date: Sun, 12 Oct 2014 21:40:40 +0100
Message-Id: <1413146445-7304-11-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_display.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index c33b77e..fd8d4f0 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -1260,6 +1260,7 @@ static const struct v4l2_ioctl_ops vpbe_ioctl_ops = {
 	.vidioc_dqbuf		 = vb2_ioctl_dqbuf,
 	.vidioc_streamon	 = vb2_ioctl_streamon,
 	.vidioc_streamoff	 = vb2_ioctl_streamoff,
+	.vidioc_create_bufs	 = vb2_ioctl_create_bufs,
 
 	.vidioc_cropcap		 = vpbe_display_cropcap,
 	.vidioc_g_crop		 = vpbe_display_g_crop,
-- 
1.9.1

