Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:36372 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab2EPVmx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 May 2012 17:42:53 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: [PATCH 1/3] gspca_kinect: remove traces of the gspca control mechanism
Date: Wed, 16 May 2012 23:42:44 +0200
Message-Id: <1337204566-2212-2-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1337204566-2212-1-git-send-email-ospite@studenti.unina.it>
References: <1337204566-2212-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver has no controls, so there is no need to convert it to the
control framework.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/media/video/gspca/kinect.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/media/video/gspca/kinect.c b/drivers/media/video/gspca/kinect.c
index e8e8f2f..f71ec0c 100644
--- a/drivers/media/video/gspca/kinect.c
+++ b/drivers/media/video/gspca/kinect.c
@@ -63,12 +63,6 @@ struct sd {
 	uint8_t ibuf[0x200];        /* input buffer for control commands */
 };
 
-/* V4L2 controls supported by the driver */
-/* controls prototypes here */
-
-static const struct ctrl sd_ctrls[] = {
-};
-
 #define MODE_640x480   0x0001
 #define MODE_640x488   0x0002
 #define MODE_1280x1024 0x0004
@@ -373,15 +367,12 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev, u8 *__data, int len)
 /* sub-driver description */
 static const struct sd_desc sd_desc = {
 	.name      = MODULE_NAME,
-	.ctrls     = sd_ctrls,
-	.nctrls    = ARRAY_SIZE(sd_ctrls),
 	.config    = sd_config,
 	.init      = sd_init,
 	.start     = sd_start,
 	.stopN     = sd_stopN,
 	.pkt_scan  = sd_pkt_scan,
 	/*
-	.querymenu = sd_querymenu,
 	.get_streamparm = sd_get_streamparm,
 	.set_streamparm = sd_set_streamparm,
 	*/
-- 
1.7.10

