Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2GCojE3016406
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 08:50:45 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2GCoE8g026516
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 08:50:14 -0400
Received: by fg-out-1718.google.com with SMTP id e12so3946405fga.7
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 05:50:13 -0700 (PDT)
From: "Frej Drejhammar" <frej.drejhammar@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <ac2c307ae12abeb35b59.1205671782@liva.fdsoft.se>
In-Reply-To: <patchbomb.1205671781@liva.fdsoft.se>
Date: Sun, 16 Mar 2008 13:49:42 +0100
To: video4linux-list@redhat.com
Cc: Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCH 1 of 2] cx88: Add user control for chroma AGC
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

4 files changed, 42 insertions(+), 3 deletions(-)
linux/drivers/media/video/cx88/cx88-blackbird.c |    1 
linux/drivers/media/video/cx88/cx88-core.c      |    6 +++
linux/drivers/media/video/cx88/cx88-video.c     |   37 +++++++++++++++++++++--
linux/drivers/media/video/cx88/cx88.h           |    1 


# HG changeset patch
# User "Frej Drejhammar <frej.drejhammar@gmail.com>"
# Date 1205668069 -3600
# Node ID ac2c307ae12abeb35b59dc0bb1aef95ac6f51798
# Parent  11fdae6654e804fdd000b0c3c9f3a4a7344ffd69
cx88: Add user control for chroma AGC

From: "Frej Drejhammar <frej.drejhammar@gmail.com>"

The cx2388x family has support for chroma AGC. This patch adds a user
control, "Chroma AGC", controlling it. By default chroma AGC is
disabled, as in previous versions of the driver.

Signed-off-by: "Frej Drejhammar <frej.drejhammar@gmail.com>"

diff -r 11fdae6654e8 -r ac2c307ae12a linux/drivers/media/video/cx88/cx88-blackbird.c
--- a/linux/drivers/media/video/cx88/cx88-blackbird.c	Fri Mar 14 00:38:24 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-blackbird.c	Sun Mar 16 12:47:49 2008 +0100
@@ -701,6 +701,7 @@ static const u32 *ctrl_classes[] = {
 static const u32 *ctrl_classes[] = {
 	cx88_user_ctrls,
 	cx2341x_mpeg_ctrls,
+	cx88_priv_ctrls,
 	NULL
 };
 
diff -r 11fdae6654e8 -r ac2c307ae12a linux/drivers/media/video/cx88/cx88-core.c
--- a/linux/drivers/media/video/cx88/cx88-core.c	Fri Mar 14 00:38:24 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-core.c	Sun Mar 16 12:47:49 2008 +0100
@@ -958,7 +958,11 @@ int cx88_set_tvnorm(struct cx88_core *co
 
 	dprintk(1,"set_tvnorm: MO_INPUT_FORMAT  0x%08x [old=0x%08x]\n",
 		cxiformat, cx_read(MO_INPUT_FORMAT) & 0x0f);
-	cx_andor(MO_INPUT_FORMAT, 0xf, cxiformat);
+	/* Chroma AGC must be disabled if SECAM is used */
+	if (norm & V4L2_STD_SECAM)
+		cx_andor(MO_INPUT_FORMAT, 0x40f, cxiformat);
+	else
+		cx_andor(MO_INPUT_FORMAT, 0xf, cxiformat);
 
 #if 1
 	// FIXME: as-is from DScaler
diff -r 11fdae6654e8 -r ac2c307ae12a linux/drivers/media/video/cx88/cx88-video.c
--- a/linux/drivers/media/video/cx88/cx88-video.c	Fri Mar 14 00:38:24 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-video.c	Sun Mar 16 12:47:49 2008 +0100
@@ -177,6 +177,11 @@ static struct cx8800_fmt* format_by_four
 
 /* ------------------------------------------------------------------- */
 
+/* Private controls for cx2388x */
+#define CX88_CID_PRIVATE_CLASS V4L2_CID_PRIVATE_BASE
+#define CX88_CID_CHROMA_AGC   (V4L2_CID_PRIVATE_BASE + 0)
+#define CX88_CID_LAST_PRIVATE (V4L2_CID_PRIVATE_BASE + 1)
+
 static const struct v4l2_queryctrl no_ctl = {
 	.name  = "42",
 	.flags = V4L2_CTRL_FLAG_DISABLED,
@@ -244,6 +249,18 @@ static struct cx88_ctrl cx8800_ctls[] = 
 		.mask                  = 0x00ff,
 		.shift                 = 0,
 	},{
+		.v = {
+			.id            = CX88_CID_CHROMA_AGC,
+			.name          = "Chroma AGC",
+			.minimum       = 0,
+			.maximum       = 1,
+			.default_value = 0x0,
+			.type          = V4L2_CTRL_TYPE_BOOLEAN,
+		},
+		.reg                   = MO_INPUT_FORMAT,
+		.mask                  = 1 << 10,
+		.shift                 = 10,
+	}, {
 	/* --- audio --- */
 		.v = {
 			.id            = V4L2_CID_AUDIO_MUTE,
@@ -302,8 +319,16 @@ const u32 cx88_user_ctrls[] = {
 };
 EXPORT_SYMBOL(cx88_user_ctrls);
 
+const u32 cx88_priv_ctrls[] = {
+	CX88_CID_PRIVATE_CLASS,
+	CX88_CID_CHROMA_AGC,
+	0
+};
+EXPORT_SYMBOL(cx88_priv_ctrls);
+
 static const u32 *ctrl_classes[] = {
 	cx88_user_ctrls,
+	cx88_priv_ctrls,
 	NULL
 };
 
@@ -311,8 +336,10 @@ int cx8800_ctrl_query(struct v4l2_queryc
 {
 	int i;
 
-	if (qctrl->id < V4L2_CID_BASE ||
-	    qctrl->id >= V4L2_CID_LASTP1)
+	if ((qctrl->id < V4L2_CID_BASE ||
+	     qctrl->id >= V4L2_CID_LASTP1) &&
+	    (qctrl->id < V4L2_CID_PRIVATE_BASE ||
+	     qctrl->id >= CX88_CID_LAST_PRIVATE))
 		return -EINVAL;
 	for (i = 0; i < CX8800_CTLS; i++)
 		if (cx8800_ctls[i].v.id == qctrl->id)
@@ -1225,6 +1252,12 @@ int cx88_set_control(struct cx88_core *c
 		}
 		mask=0xffff;
 		break;
+	case CX88_CID_CHROMA_AGC:
+		/* Do not allow chroma AGC to be enabled for SECAM */
+		value = ((ctl->value - c->off) << c->shift) & c->mask;
+		if (core->tvnorm & V4L2_STD_SECAM && value)
+			return -EINVAL;
+		break;
 	default:
 		value = ((ctl->value - c->off) << c->shift) & c->mask;
 		break;
diff -r 11fdae6654e8 -r ac2c307ae12a linux/drivers/media/video/cx88/cx88.h
--- a/linux/drivers/media/video/cx88/cx88.h	Fri Mar 14 00:38:24 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88.h	Sun Mar 16 12:47:49 2008 +0100
@@ -681,6 +681,7 @@ void cx8802_cancel_buffers(struct cx8802
 /* ----------------------------------------------------------- */
 /* cx88-video.c*/
 extern const u32 cx88_user_ctrls[];
+extern const u32 cx88_priv_ctrls[];
 extern int cx8800_ctrl_query(struct v4l2_queryctrl *qctrl);
 int cx88_enum_input (struct cx88_core  *core,struct v4l2_input *i);
 int cx88_set_freq (struct cx88_core  *core,struct v4l2_frequency *f);

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
