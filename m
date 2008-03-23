Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2NMifkN018784
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 18:44:41 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.154])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2NMi7DC019518
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 18:44:10 -0400
Received: by fg-out-1718.google.com with SMTP id e12so2174200fga.7
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 15:44:07 -0700 (PDT)
From: "Frej Drejhammar" <frej.drejhammar@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <f11b3fd53145c7ce1b9d.1206312202@liva.fdsoft.se>
In-Reply-To: <patchbomb.1206312199@liva.fdsoft.se>
Date: Sun, 23 Mar 2008 23:43:22 +0100
To: video4linux-list@redhat.com
Cc: Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCH 3 of 6] cx88: Enable chroma AGC by default for all non-SECAM
	modes
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

2 files changed, 5 insertions(+), 6 deletions(-)
linux/drivers/media/video/cx88/cx88-core.c  |    9 ++++-----
linux/drivers/media/video/cx88/cx88-video.c |    2 +-


# HG changeset patch
# User "Frej Drejhammar <frej.drejhammar@gmail.com>"
# Date 1206311942 -3600
# Node ID f11b3fd53145c7ce1b9dbde7e83cbaf6478576bc
# Parent  5033bd266fb9e90d4d7568013a373fa83061bce0
cx88: Enable chroma AGC by default for all non-SECAM modes

From: "Frej Drejhammar <frej.drejhammar@gmail.com>"

An enabled chroma AGC will not degrade picture quality if enabled on a
color PAL or NTSC signal with nominal signal levels. It will give a
significant color reproduction improvement if the chroma signals
diverge from nominal levels. Therefore enable chroma AGC by default
for PAL and NTSC standards.

Signed-off-by: "Frej Drejhammar <frej.drejhammar@gmail.com>"

diff -r 5033bd266fb9 -r f11b3fd53145 linux/drivers/media/video/cx88/cx88-core.c
--- a/linux/drivers/media/video/cx88/cx88-core.c	Sun Mar 23 23:33:57 2008 +0100
+++ b/linux/drivers/media/video/cx88/cx88-core.c	Sun Mar 23 23:39:02 2008 +0100
@@ -958,11 +958,10 @@ int cx88_set_tvnorm(struct cx88_core *co
 
 	dprintk(1,"set_tvnorm: MO_INPUT_FORMAT  0x%08x [old=0x%08x]\n",
 		cxiformat, cx_read(MO_INPUT_FORMAT) & 0x0f);
-	/* Chroma AGC must be disabled if SECAM is used */
-	if (norm & V4L2_STD_SECAM)
-		cx_andor(MO_INPUT_FORMAT, 0x40f, cxiformat);
-	else
-		cx_andor(MO_INPUT_FORMAT, 0xf, cxiformat);
+	/* Chroma AGC must be disabled if SECAM is used, we enable it
+	   by default on PAL and NTSC */
+	cx_andor(MO_INPUT_FORMAT, 0x40f,
+		 norm & V4L2_STD_SECAM ? cxiformat : cxiformat | 0x400);
 
 #if 1
 	// FIXME: as-is from DScaler
diff -r 5033bd266fb9 -r f11b3fd53145 linux/drivers/media/video/cx88/cx88-video.c
--- a/linux/drivers/media/video/cx88/cx88-video.c	Sun Mar 23 23:33:57 2008 +0100
+++ b/linux/drivers/media/video/cx88/cx88-video.c	Sun Mar 23 23:39:02 2008 +0100
@@ -249,7 +249,7 @@ static struct cx88_ctrl cx8800_ctls[] = 
 			.name          = "Chroma AGC",
 			.minimum       = 0,
 			.maximum       = 1,
-			.default_value = 0x0,
+			.default_value = 0x1,
 			.type          = V4L2_CTRL_TYPE_BOOLEAN,
 		},
 		.reg                   = MO_INPUT_FORMAT,

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
