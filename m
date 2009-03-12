Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49168 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbZCLLbf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 07:31:35 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 5/5] soc-camera: remove now unused gpio member of struct soc_camera_link
Date: Thu, 12 Mar 2009 12:27:19 +0100
Message-Id: <1236857239-2146-6-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1236857239-2146-5-git-send-email-s.hauer@pengutronix.de>
References: <1236857239-2146-1-git-send-email-s.hauer@pengutronix.de>
 <1236857239-2146-2-git-send-email-s.hauer@pengutronix.de>
 <1236857239-2146-3-git-send-email-s.hauer@pengutronix.de>
 <1236857239-2146-4-git-send-email-s.hauer@pengutronix.de>
 <1236857239-2146-5-git-send-email-s.hauer@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 include/media/soc_camera.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 62f07db..c7a6f42 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -93,8 +93,6 @@ struct soc_camera_host_ops {
 struct soc_camera_link {
 	/* Camera bus id, used to match a camera and a bus */
 	int bus_id;
-	/* GPIO number to switch between 8 and 10 bit modes */
-	unsigned int gpio;
 	/* Per camera SOCAM_SENSOR_* bus flags */
 	unsigned long flags;
 	/* Optional callbacks to power on or off and reset the sensor */
-- 
1.5.6.5

