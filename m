Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:52418 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751587AbbE0QLA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2015 12:11:00 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 14/15] media: soc_camera: v4l2-compliance fixes for querycap
Date: Wed, 27 May 2015 17:10:52 +0100
Message-Id: <1432743053-13479-15-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432743053-13479-1-git-send-email-william.towle@codethink.co.uk>
References: <1432743053-13479-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Rob Taylor <rob.taylor@codethink.co.uk>

Fill in bus_info field and zero reserved field - v4l2-compliance
complained it wasn't zero (v4l2-compliance.cpp:308 in v4l-utils v1.6.2)

Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
Reviewed-by: William Towle <william.towle@codethink.co.uk>
---
 drivers/media/platform/soc_camera/soc_camera.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index a80cde5..7307924 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -954,6 +954,8 @@ static int soc_camera_querycap(struct file *file, void  *priv,
 	WARN_ON(priv != file->private_data);
 
 	strlcpy(cap->driver, ici->drv_name, sizeof(cap->driver));
+	strlcpy(cap->bus_info, "platform:soc_camera", sizeof(cap->bus_info));
+	memset(cap->reserved, 0, sizeof(cap->reserved));
 	return ici->ops->querycap(ici, cap);
 }
 
-- 
1.7.10.4

