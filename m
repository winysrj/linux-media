Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:50782 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756007AbbFCOAM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2015 10:00:12 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: guennadi liakhovetski <g.liakhovetski@gmx.de>,
	sergei shtylyov <sergei.shtylyov@cogentembedded.com>,
	hans verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 14/15] media: soc_camera: fill in bus_info field
Date: Wed,  3 Jun 2015 15:00:01 +0100
Message-Id: <1433340002-1691-15-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1433340002-1691-1-git-send-email-william.towle@codethink.co.uk>
References: <1433340002-1691-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Rob Taylor <rob.taylor@codethink.co.uk>

Adapt soc_camera_querycap() so that cap->bus_info is populated in
addition to cap->driver.

Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
Reviewed-by: William Towle <william.towle@codethink.co.uk>
---
 drivers/media/platform/soc_camera/soc_camera.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 4e59833..675cfc4 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -954,6 +954,7 @@ static int soc_camera_querycap(struct file *file, void  *priv,
 	WARN_ON(priv != file->private_data);
 
 	strlcpy(cap->driver, ici->drv_name, sizeof(cap->driver));
+	strlcpy(cap->bus_info, "platform:soc_camera", sizeof(cap->bus_info));
 	return ici->ops->querycap(ici, cap);
 }
 
-- 
1.7.10.4

