Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4656 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160Ab3CDJF5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 04:05:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sekhar Nori <nsekhar@ti.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	linux@arm.linux.org.uk, Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 09/11] davinci/vpfe_capture: remove current_norm
Date: Mon,  4 Mar 2013 10:05:03 +0100
Message-Id: <fd5a003b7dfa01578da8e0fc92a9c1df551cd594.1362387265.git.hans.verkuil@cisco.com>
In-Reply-To: <1362387905-3666-1-git-send-email-hverkuil@xs4all.nl>
References: <1362387905-3666-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <b14bb5bd725678bc0fadfa241b462b5d6487f099.1362387265.git.hans.verkuil@cisco.com>
References: <b14bb5bd725678bc0fadfa241b462b5d6487f099.1362387265.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Since vpfe_capture already provided a g_std op setting current_norm
does not actually do anything. Remove it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/davinci/vpfe_capture.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 70facc0..3d1af67 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -1884,7 +1884,6 @@ static int vpfe_probe(struct platform_device *pdev)
 	vfd->fops		= &vpfe_fops;
 	vfd->ioctl_ops		= &vpfe_ioctl_ops;
 	vfd->tvnorms		= 0;
-	vfd->current_norm	= V4L2_STD_PAL;
 	vfd->v4l2_dev 		= &vpfe_dev->v4l2_dev;
 	snprintf(vfd->name, sizeof(vfd->name),
 		 "%s_V%d.%d.%d",
-- 
1.7.10.4

