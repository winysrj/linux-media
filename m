Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35790 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753057AbZEORTH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 13:19:07 -0400
Date: Fri, 15 May 2009 19:19:20 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 03/10 v2] soc_camera_platform: pass device pointer from
 soc-camera core on .add_device()
In-Reply-To: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
Message-ID: <Pine.LNX.4.64.0905151826050.4658@axis700.grange>
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a struct device pointer to struct soc_camera_platform_info and let the user
(ap325rxa) pass it down to soc_camera_platform.c in its .add_device() method.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Paul, another mixed one, should be quite easy to review though:-)

 arch/sh/boards/board-ap325rxa.c     |    2 ++
 include/media/soc_camera_platform.h |    3 +++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/sh/boards/board-ap325rxa.c b/arch/sh/boards/board-ap325rxa.c
index 0a5f97b..ac964e4 100644
--- a/arch/sh/boards/board-ap325rxa.c
+++ b/arch/sh/boards/board-ap325rxa.c
@@ -339,6 +339,8 @@ static int ap325rxa_camera_add(struct soc_camera_link *icl,
 	if (icl != &camera_info.link || camera_probe() <= 0)
 		return -ENODEV;
 
+	camera_info.dev = dev;
+
 	return platform_device_register(&camera_device);
 }
 
diff --git a/include/media/soc_camera_platform.h b/include/media/soc_camera_platform.h
index af224de..3e8f020 100644
--- a/include/media/soc_camera_platform.h
+++ b/include/media/soc_camera_platform.h
@@ -14,6 +14,8 @@
 #include <linux/videodev2.h>
 #include <media/soc_camera.h>
 
+struct device;
+
 struct soc_camera_platform_info {
 	int iface;
 	char *format_name;
@@ -21,6 +23,7 @@ struct soc_camera_platform_info {
 	struct v4l2_pix_format format;
 	unsigned long bus_param;
 	void (*power)(int);
+	struct device *dev;
 	int (*set_capture)(struct soc_camera_platform_info *info, int enable);
 	struct soc_camera_link link;
 };
-- 
1.6.2.4

