Return-path: <mchehab@pedra>
Received: from smtp207.alice.it ([82.57.200.103]:47846 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab1DUJvw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2011 05:51:52 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Drew Fisher <drew.m.fisher@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH 2/3] gspca - kinect: fix a typo s/steram/stream/
Date: Thu, 21 Apr 2011 11:51:35 +0200
Message-Id: <1303379496-12899-3-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1303379496-12899-1-git-send-email-ospite@studenti.unina.it>
References: <4DADF1CB.4050504@redhat.com>
 <1303379496-12899-1-git-send-email-ospite@studenti.unina.it>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Drew Fisher <drew.m.fisher@gmail.com>

Signed-off-by: Drew Fisher <drew.m.fisher@gmail.com>
Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/media/video/gspca/kinect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/gspca/kinect.c b/drivers/media/video/gspca/kinect.c
index 79c4ef5..b4f9e2b 100644
--- a/drivers/media/video/gspca/kinect.c
+++ b/drivers/media/video/gspca/kinect.c
@@ -61,7 +61,7 @@ struct cam_hdr {
 struct sd {
 	struct gspca_dev gspca_dev; /* !! must be the first item */
 	uint16_t cam_tag;           /* a sequence number for packets */
-	uint8_t stream_flag;        /* to identify different steram types */
+	uint8_t stream_flag;        /* to identify different stream types */
 	uint8_t obuf[0x400];        /* output buffer for control commands */
 	uint8_t ibuf[0x200];        /* input buffer for control commands */
 };
-- 
1.7.4.4

