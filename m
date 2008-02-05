Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m15Hkvmw007399
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 12:46:57 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.1/8.13.1) with SMTP id m15HkQkN016770
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 12:46:27 -0500
Date: Tue, 5 Feb 2008 18:46:39 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0802051833300.5882@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/6] Add chip IDs for Micron mt9m001 and mt9v022 CMOS cameras
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Add V4L2_IDENT chip IDs for mt9m001 and mt9v022 cameras, will be used by 
future patches, primarily to implement the g_chip_ident ioctl.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

---

 include/media/v4l2-chip-ident.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index 032bb75..0ea0bd8 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -153,6 +153,12 @@ enum {
 	V4L2_IDENT_MSP4428G = 44287,
 	V4L2_IDENT_MSP4448G = 44487,
 	V4L2_IDENT_MSP4458G = 44587,
+
+	/* Micron CMOS sensor chips: 45000-45099 */
+	V4L2_IDENT_MT9M001C12ST		= 45000,
+	V4L2_IDENT_MT9M001C12STM	= 45005,
+	V4L2_IDENT_MT9V022IX7ATC	= 45010, /* No way to detect "normal" I77ATx */
+	V4L2_IDENT_MT9V022IX7ATM	= 45015, /* and "lead free" IA7ATx chips */
 };
 
 #endif
-- 
1.5.3.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
