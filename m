Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:56474 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753677AbbEUJDD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 05:03:03 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com,
	hverkuil@xs4all.nl, rob.taylor@codethink.co.uk
Subject: [PATCH 13/20] media: soc_camera: v4l2-compliance fixes for querycap
Date: Wed, 20 May 2015 17:39:33 +0100
Message-Id: <1432139980-12619-14-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fill in bus_info field and zero reserved field.

Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
Reviewed-by: William Towle <william.towle@codethink.co.uk>
---
 drivers/media/platform/soc_camera/soc_camera.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index fd7497e..583c5e6 100644
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

