Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47310 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbaFWXyL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jun 2014 19:54:11 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 16/23] v4l: vsp1: wpf: Clear RPF to WPF association at stream off time
Date: Tue, 24 Jun 2014 01:54:22 +0200
Message-Id: <1403567669-18539-17-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VSP1 stores the video pipelines' input (RPF) to output (WPF)
mappings in a WPF register. An RPF must never be associated with
multiple WPFs, even if all of those WPFs but one are unused, otherwise
the hardware won't function properly.

The driver doesn't ensure this correctly as it never clears the
mappings. An RPF used with one WPF and later with a different WPF will
lead to malfunction, as it will be associated with two WPFs. Clear the
mappings at stream off time to fix this.

Reported-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_wpf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 591f09c..d330865 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -54,6 +54,7 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 
 	if (!enable) {
 		vsp1_write(vsp1, VI6_WPF_IRQ_ENB(wpf->entity.index), 0);
+		vsp1_wpf_write(wpf, VI6_WPF_SRCRPF, 0);
 		return 0;
 	}
 
-- 
1.8.5.5

