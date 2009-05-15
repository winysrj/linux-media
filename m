Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38582 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754270AbZEORTk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 13:19:40 -0400
Date: Fri, 15 May 2009 19:19:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 06/10 v2] soc-camera: remove unused .iface from struct
 soc_camera_platform_info
In-Reply-To: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
Message-ID: <Pine.LNX.4.64.0905151828030.4658@axis700.grange>
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/media/soc_camera_platform.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/media/soc_camera_platform.h b/include/media/soc_camera_platform.h
index b144f94..bb70401 100644
--- a/include/media/soc_camera_platform.h
+++ b/include/media/soc_camera_platform.h
@@ -17,7 +17,6 @@
 struct device;
 
 struct soc_camera_platform_info {
-	int iface;
 	const char *format_name;
 	unsigned long format_depth;
 	struct v4l2_pix_format format;
-- 
1.6.2.4

