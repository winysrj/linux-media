Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2NMipCL018821
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 18:44:51 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.157])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2NMiGXr019600
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 18:44:19 -0400
Received: by fg-out-1718.google.com with SMTP id e12so2174223fga.7
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 15:44:12 -0700 (PDT)
From: "Frej Drejhammar" <frej.drejhammar@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <77bef451d41348f8e5ca.1206312204@liva.fdsoft.se>
In-Reply-To: <patchbomb.1206312199@liva.fdsoft.se>
Date: Sun, 23 Mar 2008 23:43:24 +0100
To: video4linux-list@redhat.com
Cc: Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCH 5 of 6] cx88: Add user control for color killer
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

1 file changed, 13 insertions(+)
linux/drivers/media/video/cx88/cx88-video.c |   13 +++++++++++++


# HG changeset patch
# User "Frej Drejhammar <frej.drejhammar@gmail.com>"
# Date 1206312016 -3600
# Node ID 77bef451d41348f8e5ca6b24fe402199ac243ead
# Parent  b3a7ec84ad4959869d50710bfcbfb997fb39850d
cx88: Add user control for color killer

From: "Frej Drejhammar <frej.drejhammar@gmail.com>"

The cx2388x family has a color killer. This patch implements the
V4L2_CID_COLOR_KILLER control for the cx2388x family. By default the
color killer is disabled, as in previous versions of the driver.

Signed-off-by: "Frej Drejhammar <frej.drejhammar@gmail.com>"

diff -r b3a7ec84ad49 -r 77bef451d413 linux/drivers/media/video/cx88/cx88-video.c
--- a/linux/drivers/media/video/cx88/cx88-video.c	Sun Mar 23 23:39:29 2008 +0100
+++ b/linux/drivers/media/video/cx88/cx88-video.c	Sun Mar 23 23:40:16 2008 +0100
@@ -256,6 +256,18 @@ static struct cx88_ctrl cx8800_ctls[] = 
 		.mask                  = 1 << 10,
 		.shift                 = 10,
 	}, {
+		.v = {
+			.id            = V4L2_CID_COLOR_KILLER,
+			.name          = "Color killer",
+			.minimum       = 0,
+			.maximum       = 1,
+			.default_value = 0x0,
+			.type          = V4L2_CTRL_TYPE_BOOLEAN,
+		},
+		.reg                   = MO_INPUT_FORMAT,
+		.mask                  = 1 << 9,
+		.shift                 = 9,
+	}, {
 	/* --- audio --- */
 		.v = {
 			.id            = V4L2_CID_AUDIO_MUTE,
@@ -311,6 +323,7 @@ const u32 cx88_user_ctrls[] = {
 	V4L2_CID_AUDIO_BALANCE,
 	V4L2_CID_AUDIO_MUTE,
 	V4L2_CID_CHROMA_AGC,
+	V4L2_CID_COLOR_KILLER,
 	0
 };
 EXPORT_SYMBOL(cx88_user_ctrls);

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
