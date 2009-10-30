Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59128 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932071AbZJ3OAt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2009 10:00:49 -0400
Date: Fri, 30 Oct 2009 15:01:02 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 1/9] soc-camera: remove no longer needed struct members
In-Reply-To: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
Message-ID: <Pine.LNX.4.64.0910301402420.4378@axis700.grange>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/media/soc_camera.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 3d74e60..c5afc8c 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -24,8 +24,6 @@ struct soc_camera_device {
 	struct device *pdev;		/* Platform device */
 	s32 user_width;
 	s32 user_height;
-	unsigned short width_min;
-	unsigned short height_min;
 	unsigned short y_skip_top;	/* Lines to skip at the top */
 	unsigned char iface;		/* Host number */
 	unsigned char devnum;		/* Device number per host */
-- 
1.6.2.4

