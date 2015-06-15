Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:33775 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932108AbbFOLeN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 07:34:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, william.towle@codethink.co.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 08/14] sh_mobile_ceu_camera: set field to FIELD_NONE
Date: Mon, 15 Jun 2015 13:33:35 +0200
Message-Id: <1434368021-7467-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
References: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Make sure that 'field' isn't FIELD_ANY when the driver is
first loaded. Fixes a v4l2-compliance failure.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 8881efe..efdeea4 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -1775,6 +1775,7 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
 		pcdev->max_height = pcdev->pdata->max_height;
 		pcdev->flags = pcdev->pdata->flags;
 	}
+	pcdev->field = V4L2_FIELD_NONE;
 
 	if (!pcdev->max_width) {
 		unsigned int v;
-- 
2.1.4

