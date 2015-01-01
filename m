Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:45702 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbbAARAg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Jan 2015 12:00:36 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so26824564wib.4
        for <linux-media@vger.kernel.org>; Thu, 01 Jan 2015 09:00:35 -0800 (PST)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mikhail Domrachev <mihail.domrychev@comexp.ru>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: pci: saa7134: saa7134-video.c:  Remove unused function
Date: Thu,  1 Jan 2015 18:03:35 +0100
Message-Id: <1420131815-31335-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the function saa7134_queue() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/media/pci/saa7134/saa7134-video.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index fc4a427..cf40573 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1098,11 +1098,6 @@ static int saa7134_s_ctrl(struct v4l2_ctrl *ctrl)
 
 /* ------------------------------------------------------------------ */
 
-static inline struct vb2_queue *saa7134_queue(struct file *file)
-{
-	return video_devdata(file)->queue;
-}
-
 static int video_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
-- 
1.7.10.4

