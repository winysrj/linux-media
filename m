Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2887 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab1I2LAT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 07:00:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH] Introduce a strict tuner type check for VIDIOC_S_FREQUENCY
Date: Thu, 29 Sep 2011 13:00:05 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201109291300.06047.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As per feature-removal-schedule.

If there are no comments, then I'll make a pull request in a few days.

Regards,

	Hans


For tuners the tuner type as passed by VIDIOC_S_FREQUENCY must match the
type of the device node. So setting the radio frequency through a video
node instead of the radio node is no longer allowed.

This is now implemented as per the feature removal schedule.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../DocBook/media/v4l/vidioc-g-frequency.xml       |    5 ++++-
 Documentation/feature-removal-schedule.txt         |   11 -----------
 drivers/media/video/v4l2-ioctl.c                   |    9 ++++++++-
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml b/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml
index 062d720..d18645c 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml
@@ -99,7 +99,10 @@ the &v4l2-output; <structfield>modulator</structfield> field and the
 	    <entry><structfield>type</structfield></entry>
 	    <entry>The tuner type. This is the same value as in the
 &v4l2-tuner; <structfield>type</structfield> field. The field is not
-applicable to modulators, &ie; ignored by drivers.</entry>
+applicable to modulators, &ie; ignored by drivers. The tuner type must
+match the type of the device node, &ie; you cannot specify V4L2_TUNER_RADIO
+for a video/vbi device node or V4L2_TUNER_ANALOG_TV for a radio device node.
+<errorcode>EINVAL</errorcode> will be returned in case of a mismatch.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index ead08f1..b0ed38c 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -530,17 +530,6 @@ Who:	Hans de Goede <hdegoede@redhat.com>
 
 ----------------------------
 
-What:	For VIDIOC_S_FREQUENCY the type field must match the device node's type.
-	If not, return -EINVAL.
-When:	3.2
-Why:	It makes no sense to switch the tuner to radio mode by calling
-	VIDIOC_S_FREQUENCY on a video node, or to switch the tuner to tv mode by
-	calling VIDIOC_S_FREQUENCY on a radio node. This is the first step of a
-	move to more consistent handling of tv and radio tuners.
-Who:	Hans Verkuil <hans.verkuil@cisco.com>
-
-----------------------------
-
 What:	Opening a radio device node will no longer automatically switch the
 	tuner mode from tv to radio.
 When:	3.3
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 21c49dc..4004b77 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1757,6 +1757,8 @@ static long __video_do_ioctl(struct file *file,
 	case VIDIOC_S_FREQUENCY:
 	{
 		struct v4l2_frequency *p = arg;
+		enum v4l2_tuner_type type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 
 		if (!ops->vidioc_s_frequency)
 			break;
@@ -1766,7 +1768,12 @@ static long __video_do_ioctl(struct file *file,
 		}
 		dbgarg(cmd, "tuner=%d, type=%d, frequency=%d\n",
 				p->tuner, p->type, p->frequency);
-		ret = ops->vidioc_s_frequency(file, fh, p);
+		/* type is ignored for modulators, so only do this check
+		   if there is no modulator support. */
+		if (ops->vidioc_s_modulator == NULL && type != p->type)
+			ret = -EINVAL;
+		else
+			ret = ops->vidioc_s_frequency(file, fh, p);
 		break;
 	}
 	case VIDIOC_G_SLICED_VBI_CAP:
-- 
1.7.5.4

