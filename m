Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:39375 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab0CRLwv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Mar 2010 07:52:51 -0400
Received: from localhost.localdomain (unknown [192.100.124.156])
	by perceval.irobotique.be (Postfix) with ESMTPSA id 318FC35AD8
	for <linux-media@vger.kernel.org>; Thu, 18 Mar 2010 11:52:49 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] uvcvideo: Support iris absolute and relative controls
Date: Thu, 18 Mar 2010 12:55:03 +0100
Message-Id: <1268913303-30565-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1268913303-30565-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1268913303-30565-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index 3b2e780..3697d72 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -561,6 +561,26 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] = {
 		.data_type	= UVC_CTRL_DATA_TYPE_BOOLEAN,
 	},
 	{
+		.id		= V4L2_CID_IRIS_ABSOLUTE,
+		.name		= "Iris, Absolute",
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= UVC_CT_IRIS_ABSOLUTE_CONTROL,
+		.size		= 16,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
+		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
+	},
+	{
+		.id		= V4L2_CID_IRIS_RELATIVE,
+		.name		= "Iris, Relative",
+		.entity		= UVC_GUID_UVC_CAMERA,
+		.selector	= UVC_CT_IRIS_RELATIVE_CONTROL,
+		.size		= 8,
+		.offset		= 0,
+		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
+		.data_type	= UVC_CTRL_DATA_TYPE_SIGNED,
+	},
+	{
 		.id		= V4L2_CID_ZOOM_ABSOLUTE,
 		.name		= "Zoom, Absolute",
 		.entity		= UVC_GUID_UVC_CAMERA,
-- 
1.6.4.4

