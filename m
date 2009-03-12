Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57964 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbZCLLaF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 07:30:05 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 1/5] soc-camera: add board hook to specify the buswidth for camera sensors
Date: Thu, 12 Mar 2009 12:27:15 +0100
Message-Id: <1236857239-2146-2-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1236857239-2146-1-git-send-email-s.hauer@pengutronix.de>
References: <1236857239-2146-1-git-send-email-s.hauer@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Camera sensors have a native bus width say support, but on some
boards not all sensor data lines are connected to the image
interface and thus support a different bus width than the sensors
native one. Some boards even have a bus driver which dynamically
switches between different bus widths with a GPIO.

This patch adds a hook which board code can use to support different
bus widths.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 include/media/soc_camera.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 7440d92..62f07db 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -100,6 +100,13 @@ struct soc_camera_link {
 	/* Optional callbacks to power on or off and reset the sensor */
 	int (*power)(struct device *, int);
 	int (*reset)(struct device *);
+	/*
+	 * some platforms may support different data widths than the sensors
+	 * native ones due to different data line routing. Let the board code
+	 * overwrite the width flags.
+	 */
+	int (*set_bus_param)(struct soc_camera_link *, unsigned long flags);
+	unsigned long (*query_bus_param)(struct soc_camera_link *);
 };
 
 static inline struct soc_camera_device *to_soc_camera_dev(struct device *dev)
-- 
1.5.6.5

