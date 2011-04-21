Return-path: <mchehab@pedra>
Received: from smtp206.alice.it ([82.57.200.102]:41541 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab1DUJvw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2011 05:51:52 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Drew Fisher <drew.m.fisher@gmail.com>
Subject: [PATCH 3/3] gspca - kinect: fix comments referring to color camera
Date: Thu, 21 Apr 2011 11:51:36 +0200
Message-Id: <1303379496-12899-4-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1303379496-12899-1-git-send-email-ospite@studenti.unina.it>
References: <4DADF1CB.4050504@redhat.com>
 <1303379496-12899-1-git-send-email-ospite@studenti.unina.it>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Use the expression "video stream" instead of "color camera" which is
more correct as the driver supports the RGB and IR image on the same
endpoint.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/media/video/gspca/kinect.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/gspca/kinect.c b/drivers/media/video/gspca/kinect.c
index b4f9e2b..2028c64 100644
--- a/drivers/media/video/gspca/kinect.c
+++ b/drivers/media/video/gspca/kinect.c
@@ -233,7 +233,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 
 	sd->cam_tag = 0;
 
-	/* Only color camera is supported for now,
+	/* Only video stream is supported for now,
 	 * which has stream flag = 0x80 */
 	sd->stream_flag = 0x80;
 
@@ -243,7 +243,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	cam->nmodes = ARRAY_SIZE(video_camera_mode);
 
 #if 0
-	/* Setting those values is not needed for color camera */
+	/* Setting those values is not needed for video stream */
 	cam->npkt = 15;
 	gspca_dev->pkt_size = 960 * 2;
 #endif
-- 
1.7.4.4

