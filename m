Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50080 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab2ABNTo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 08:19:44 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LX600AM1ACUI5@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 02 Jan 2012 13:19:42 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LX600K2RACTRL@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 02 Jan 2012 13:19:42 +0000 (GMT)
Date: Mon, 02 Jan 2012 14:19:25 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] s5p-g2d: fixed a bug in controls setting function
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	Kamil Debski <k.debski@samsung.com>
Message-id: <1325510365-28595-1-git-send-email-k.debski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-g2d/g2d.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/video/s5p-g2d/g2d.c
index 1f156c8..22e15e5 100644
--- a/drivers/media/video/s5p-g2d/g2d.c
+++ b/drivers/media/video/s5p-g2d/g2d.c
@@ -184,6 +184,7 @@ static int g2d_s_ctrl(struct v4l2_ctrl *ctrl)
 			ctx->rop = ROP4_INVERT;
 		else
 			ctx->rop = ROP4_COPY;
+		break;
 	default:
 		v4l2_err(&ctx->dev->v4l2_dev, "unknown control\n");
 		return -EINVAL;
-- 
1.7.0.4

