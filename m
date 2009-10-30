Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34846 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932093AbZJ3OBL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2009 10:01:11 -0400
Date: Fri, 30 Oct 2009 15:01:18 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 5/9] soc-camera: add a private field to struct soc_camera_link
In-Reply-To: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
Message-ID: <Pine.LNX.4.64.0910301408510.4378@axis700.grange>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Up to now, if a client driver needed platform data apart from those contained
in struct soc_camera_link, it had to embed the struct into its own object. This
makes the use of such a driver in configurations other than soc-camera
difficult. This patch adds a private field to struct soc_camera_link to make
the use of such private data arbitrary.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/media/soc_camera.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 218639f..831efff 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -104,6 +104,8 @@ struct soc_camera_link {
 	int i2c_adapter_id;
 	struct i2c_board_info *board_info;
 	const char *module_name;
+	void *priv;
+
 	/*
 	 * For non-I2C devices platform platform has to provide methods to
 	 * add a device to the system and to remove
-- 
1.6.2.4

