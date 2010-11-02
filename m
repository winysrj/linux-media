Return-path: <mchehab@gaivota>
Received: from d1.icnet.pl ([212.160.220.21]:50941 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab0KBPJY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Nov 2010 11:09:24 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 2.6.37-rc1] SoC Camera: OMAP1: update for recent framework changes
Date: Tue, 2 Nov 2010 16:08:51 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	e3-hacking@earth.li
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201011021608.52379.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The recently added OMAP1 camera driver was not ready for one video queue per 
device framework changes. Fix it.

Created and tested against linux-2.6.37-rc1.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---

 drivers/media/video/omap1_camera.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.37-rc1/drivers/media/video/omap1_camera.c.orig	2010-11-01 22:41:59.000000000 +0100
+++ linux-2.6.37-rc1/drivers/media/video/omap1_camera.c	2010-11-01 23:55:26.000000000 +0100
@@ -1386,7 +1386,7 @@ static void omap1_cam_init_videobuf(stru
 	}
 }
 
-static int omap1_cam_reqbufs(struct soc_camera_file *icf,
+static int omap1_cam_reqbufs(struct soc_camera_device *icd,
 			      struct v4l2_requestbuffers *p)
 {
 	int i;
@@ -1398,7 +1398,7 @@ static int omap1_cam_reqbufs(struct soc_
 	 * it hadn't triggered
 	 */
 	for (i = 0; i < p->count; i++) {
-		struct omap1_cam_buf *buf = container_of(icf->vb_vidq.bufs[i],
+		struct omap1_cam_buf *buf = container_of(icd->vb_vidq.bufs[i],
 						      struct omap1_cam_buf, vb);
 		buf->inwork = 0;
 		INIT_LIST_HEAD(&buf->vb.queue);
@@ -1485,10 +1485,10 @@ static int omap1_cam_set_bus_param(struc
 
 static unsigned int omap1_cam_poll(struct file *file, poll_table *pt)
 {
-	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = file->private_data;
 	struct omap1_cam_buf *buf;
 
-	buf = list_entry(icf->vb_vidq.stream.next, struct omap1_cam_buf,
+	buf = list_entry(icd->vb_vidq.stream.next, struct omap1_cam_buf,
 			 vb.stream);
 
 	poll_wait(file, &buf->vb.done, pt);
