Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2GCon5t016412
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 08:50:49 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.184])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2GCoG0P026543
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 08:50:17 -0400
Received: by nf-out-0910.google.com with SMTP id g13so1782291nfb.21
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 05:50:16 -0700 (PDT)
From: "Frej Drejhammar" <frej.drejhammar@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <8843d200ee091ef49579.1205671783@liva.fdsoft.se>
In-Reply-To: <patchbomb.1205671781@liva.fdsoft.se>
Date: Sun, 16 Mar 2008 13:49:43 +0100
To: video4linux-list@redhat.com
Cc: Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCH 2 of 2] cx88: Add user control for color killer
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

1 file changed, 15 insertions(+), 1 deletion(-)
linux/drivers/media/video/cx88/cx88-video.c |   16 +++++++++++++++-


# HG changeset patch
# User "Frej Drejhammar <frej.drejhammar@gmail.com>"
# Date 1205668146 -3600
# Node ID 8843d200ee091ef49579555ef6ae4de031986342
# Parent  ac2c307ae12abeb35b59dc0bb1aef95ac6f51798
cx88: Add user control for color killer

From: "Frej Drejhammar <frej.drejhammar@gmail.com>"

The cx2388x family has a color killer. This patch adds a user control,
"Color killer", controlling it. By default the color killer is
disabled, as in previous versions of the driver.

Signed-off-by: "Frej Drejhammar <frej.drejhammar@gmail.com>"

diff -r ac2c307ae12a -r 8843d200ee09 linux/drivers/media/video/cx88/cx88-video.c
--- a/linux/drivers/media/video/cx88/cx88-video.c	Sun Mar 16 12:47:49 2008 +0100
+++ b/linux/drivers/media/video/cx88/cx88-video.c	Sun Mar 16 12:49:06 2008 +0100
@@ -180,7 +180,8 @@ static struct cx8800_fmt* format_by_four
 /* Private controls for cx2388x */
 #define CX88_CID_PRIVATE_CLASS V4L2_CID_PRIVATE_BASE
 #define CX88_CID_CHROMA_AGC   (V4L2_CID_PRIVATE_BASE + 0)
-#define CX88_CID_LAST_PRIVATE (V4L2_CID_PRIVATE_BASE + 1)
+#define CX88_CID_COLOR_KILLER (V4L2_CID_PRIVATE_BASE + 1)
+#define CX88_CID_LAST_PRIVATE (V4L2_CID_PRIVATE_BASE + 2)
 
 static const struct v4l2_queryctrl no_ctl = {
 	.name  = "42",
@@ -261,6 +262,18 @@ static struct cx88_ctrl cx8800_ctls[] = 
 		.mask                  = 1 << 10,
 		.shift                 = 10,
 	}, {
+		.v = {
+			.id            = CX88_CID_COLOR_KILLER,
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
@@ -322,6 +335,7 @@ const u32 cx88_priv_ctrls[] = {
 const u32 cx88_priv_ctrls[] = {
 	CX88_CID_PRIVATE_CLASS,
 	CX88_CID_CHROMA_AGC,
+	CX88_CID_COLOR_KILLER,
 	0
 };
 EXPORT_SYMBOL(cx88_priv_ctrls);

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
