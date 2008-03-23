Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2NMidas018776
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 18:44:39 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2NMi6sN019505
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 18:44:07 -0400
Received: by fg-out-1718.google.com with SMTP id e12so2174184fga.7
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 15:44:05 -0700 (PDT)
From: "Frej Drejhammar" <frej.drejhammar@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <5033bd266fb9e90d4d75.1206312201@liva.fdsoft.se>
In-Reply-To: <patchbomb.1206312199@liva.fdsoft.se>
Date: Sun, 23 Mar 2008 23:43:21 +0100
To: video4linux-list@redhat.com
Cc: Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCH 2 of 6] cx88: Add user control for chroma AGC
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

4 files changed, 37 insertions(+), 6 deletions(-)
linux/drivers/media/video/cx88/cx88-blackbird.c |    4 +--
linux/drivers/media/video/cx88/cx88-core.c      |    6 +++-
linux/drivers/media/video/cx88/cx88-video.c     |   30 +++++++++++++++++++++--
linux/drivers/media/video/cx88/cx88.h           |    3 +-


# HG changeset patch
# User "Frej Drejhammar <frej.drejhammar@gmail.com>"
# Date 1206311637 -3600
# Node ID 5033bd266fb9e90d4d7568013a373fa83061bce0
# Parent  d758888cf4a466cd2d44a54a0a9e9467d72267fa
cx88: Add user control for chroma AGC

From: "Frej Drejhammar <frej.drejhammar@gmail.com>"

The cx2388x family has support for chroma AGC. This patch implements a
the V4L2_CID_CHROMA_AGC control for the cx2388x family. By default
chroma AGC is disabled, as in previous versions of the driver.

Signed-off-by: "Frej Drejhammar <frej.drejhammar@gmail.com>"

diff -r d758888cf4a4 -r 5033bd266fb9 linux/drivers/media/video/cx88/cx88-blackbird.c
--- a/linux/drivers/media/video/cx88/cx88-blackbird.c	Sun Mar 23 23:31:36 2008 +0100
+++ b/linux/drivers/media/video/cx88/cx88-blackbird.c	Sun Mar 23 23:33:57 2008 +0100
@@ -711,7 +711,7 @@ static int blackbird_queryctrl(struct cx
 		return -EINVAL;
 
 	/* Standard V4L2 controls */
-	if (cx8800_ctrl_query(qctrl) == 0)
+	if (cx8800_ctrl_query(dev->core, qctrl) == 0)
 		return 0;
 
 	/* MPEG V4L2 controls */
@@ -959,7 +959,7 @@ static int vidioc_queryctrl (struct file
 	qctrl->id = v4l2_ctrl_next(ctrl_classes, qctrl->id);
 	if (unlikely(qctrl->id == 0))
 		return -EINVAL;
-	return cx8800_ctrl_query(qctrl);
+	return cx8800_ctrl_query(dev->core, qctrl);
 }
 
 static int vidioc_enum_input (struct file *file, void *priv,
diff -r d758888cf4a4 -r 5033bd266fb9 linux/drivers/media/video/cx88/cx88-core.c
--- a/linux/drivers/media/video/cx88/cx88-core.c	Sun Mar 23 23:31:36 2008 +0100
+++ b/linux/drivers/media/video/cx88/cx88-core.c	Sun Mar 23 23:33:57 2008 +0100
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
diff -r d758888cf4a4 -r 5033bd266fb9 linux/drivers/media/video/cx88/cx88-video.c
--- a/linux/drivers/media/video/cx88/cx88-video.c	Sun Mar 23 23:31:36 2008 +0100
+++ b/linux/drivers/media/video/cx88/cx88-video.c	Sun Mar 23 23:33:57 2008 +0100
@@ -244,6 +244,18 @@ static struct cx88_ctrl cx8800_ctls[] = 
 		.mask                  = 0x00ff,
 		.shift                 = 0,
 	},{
+		.v = {
+			.id            = V4L2_CID_CHROMA_AGC,
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
@@ -298,6 +310,7 @@ const u32 cx88_user_ctrls[] = {
 	V4L2_CID_AUDIO_VOLUME,
 	V4L2_CID_AUDIO_BALANCE,
 	V4L2_CID_AUDIO_MUTE,
+	V4L2_CID_CHROMA_AGC,
 	0
 };
 EXPORT_SYMBOL(cx88_user_ctrls);
@@ -307,7 +320,7 @@ static const u32 *ctrl_classes[] = {
 	NULL
 };
 
-int cx8800_ctrl_query(struct v4l2_queryctrl *qctrl)
+int cx8800_ctrl_query(struct cx88_core *core, struct v4l2_queryctrl *qctrl)
 {
 	int i;
 
@@ -322,6 +335,11 @@ int cx8800_ctrl_query(struct v4l2_queryc
 		return 0;
 	}
 	*qctrl = cx8800_ctls[i].v;
+	/* Report chroma AGC as inactive when SECAM is selected */
+	if (cx8800_ctls[i].v.id == V4L2_CID_CHROMA_AGC &&
+	    core->tvnorm & V4L2_STD_SECAM)
+		qctrl->flags |= V4L2_CTRL_FLAG_INACTIVE;
+
 	return 0;
 }
 EXPORT_SYMBOL(cx8800_ctrl_query);
@@ -1225,6 +1243,12 @@ int cx88_set_control(struct cx88_core *c
 		}
 		mask=0xffff;
 		break;
+	case V4L2_CID_CHROMA_AGC:
+		/* Do not allow chroma AGC to be enabled for SECAM */
+		value = ((ctl->value - c->off) << c->shift) & c->mask;
+		if (core->tvnorm & V4L2_STD_SECAM && value)
+			return -EINVAL;
+		break;
 	default:
 		value = ((ctl->value - c->off) << c->shift) & c->mask;
 		break;
@@ -1549,10 +1573,12 @@ static int vidioc_queryctrl (struct file
 static int vidioc_queryctrl (struct file *file, void *priv,
 				struct v4l2_queryctrl *qctrl)
 {
+	struct cx88_core *core = ((struct cx8800_fh *)priv)->dev->core;
+
 	qctrl->id = v4l2_ctrl_next(ctrl_classes, qctrl->id);
 	if (unlikely(qctrl->id == 0))
 		return -EINVAL;
-	return cx8800_ctrl_query(qctrl);
+	return cx8800_ctrl_query(core, qctrl);
 }
 
 static int vidioc_g_ctrl (struct file *file, void *priv,
diff -r d758888cf4a4 -r 5033bd266fb9 linux/drivers/media/video/cx88/cx88.h
--- a/linux/drivers/media/video/cx88/cx88.h	Sun Mar 23 23:31:36 2008 +0100
+++ b/linux/drivers/media/video/cx88/cx88.h	Sun Mar 23 23:33:57 2008 +0100
@@ -681,7 +681,8 @@ void cx8802_cancel_buffers(struct cx8802
 /* ----------------------------------------------------------- */
 /* cx88-video.c*/
 extern const u32 cx88_user_ctrls[];
-extern int cx8800_ctrl_query(struct v4l2_queryctrl *qctrl);
+extern int cx8800_ctrl_query(struct cx88_core *core,
+			     struct v4l2_queryctrl *qctrl);
 int cx88_enum_input (struct cx88_core  *core,struct v4l2_input *i);
 int cx88_set_freq (struct cx88_core  *core,struct v4l2_frequency *f);
 int cx88_get_control(struct cx88_core *core, struct v4l2_control *ctl);

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
