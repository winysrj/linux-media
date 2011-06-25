Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1911 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab1FYOrX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jun 2011 10:47:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: RFC tuner-core: how to set vt->type in g_tuner?
Date: Sat, 25 Jun 2011 16:47:13 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201106251602.45572.hverkuil@xs4all.nl> <4E05EDEE.1000201@redhat.com>
In-Reply-To: <4E05EDEE.1000201@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106251647.13900.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, June 25, 2011 16:17:18 Mauro Carvalho Chehab wrote:
> Em 25-06-2011 11:02, Hans Verkuil escreveu:
> > Hi all,
> > 
> > The tuner-core.c implementation does this at the start of g_tuner:
> > 
> >         if (check_mode(t, vt->type) == -EINVAL)
> >                 return 0;
> >         vt->type = t->mode;
> > 
> > The idea is that the vt->type is set depending on whether the VIDIOC_G_TUNER
> > ioctl is called from a radio device node or a video device node. If we have a
> > tuner that can do both radio and TV, then the type is set to whatever the
> > current tuner mode is.
> > 
> > This seems reasonable, but it will actually run into problems when g_tuner
> > is called for audio demodulators like msp3400 or cx25840. These need to know
> > the correct vt->type in order to fill in the right fields.
> > 
> > The problem here is that the tuner subdevices are not necessarily called first.
> > In fact, the msp3400/cx25840 are actually called first by ivtv.
> > 
> > So the msp3400 will get called with type TV, and later the tuner may change that
> > to type RADIO. This causes inconsistencies. This has actually been observed when
> > testing with ivtv and a PVR-500.
> > 
> > There are two solutions:
> > 
> > 1) Audit the drivers and ensure that the tuner subdevices are registered first.
> > 
> > 2) Do not allow the tuner to switch the type.
> 
> (2) is the right thing to do. A VIDIOC_GET_foo should not change anything. They are
> supposed to be read only access.

Great!

Can you review this patch? This implements solution 2. I think it's correct, but
it's tuner code, so you never know :-)

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 9006c9a..706fc11 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -1119,8 +1119,7 @@ static int tuner_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 
 	if (check_mode(t, f->type) == -EINVAL)
 		return 0;
-	f->type = t->mode;
-	if (fe_tuner_ops->get_frequency && !t->standby) {
+	if (f->type == t->mode && fe_tuner_ops->get_frequency && !t->standby) {
 		u32 abs_freq;
 
 		fe_tuner_ops->get_frequency(&t->fe, &abs_freq);
@@ -1128,7 +1127,7 @@ static int tuner_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 			DIV_ROUND_CLOSEST(abs_freq * 2, 125) :
 			DIV_ROUND_CLOSEST(abs_freq, 62500);
 	} else {
-		f->frequency = (V4L2_TUNER_RADIO == t->mode) ?
+		f->frequency = (V4L2_TUNER_RADIO == f->type) ?
 			t->radio_freq : t->tv_freq;
 	}
 	return 0;
@@ -1152,32 +1151,33 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 
 	if (check_mode(t, vt->type) == -EINVAL)
 		return 0;
-	vt->type = t->mode;
-	if (analog_ops->get_afc)
+	if (vt->type == t->mode && analog_ops->get_afc)
 		vt->afc = analog_ops->get_afc(&t->fe);
-	if (t->mode == V4L2_TUNER_ANALOG_TV)
+	if (vt->type == V4L2_TUNER_ANALOG_TV)
 		vt->capability |= V4L2_TUNER_CAP_NORM;
-	if (t->mode != V4L2_TUNER_RADIO) {
+	if (vt->type != V4L2_TUNER_RADIO) {
 		vt->rangelow = tv_range[0] * 16;
 		vt->rangehigh = tv_range[1] * 16;
 		return 0;
 	}
 
 	/* radio mode */
-	vt->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
-	if (fe_tuner_ops->get_status) {
-		u32 tuner_status;
-
-		fe_tuner_ops->get_status(&t->fe, &tuner_status);
-		vt->rxsubchans =
-			(tuner_status & TUNER_STATUS_STEREO) ?
-			V4L2_TUNER_SUB_STEREO :
-			V4L2_TUNER_SUB_MONO;
+	if (vt->type == t->mode) {
+		vt->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
+		if (fe_tuner_ops->get_status) {
+			u32 tuner_status;
+
+			fe_tuner_ops->get_status(&t->fe, &tuner_status);
+			vt->rxsubchans =
+				(tuner_status & TUNER_STATUS_STEREO) ?
+				V4L2_TUNER_SUB_STEREO :
+				V4L2_TUNER_SUB_MONO;
+		}
+		if (analog_ops->has_signal)
+			vt->signal = analog_ops->has_signal(&t->fe);
+		vt->audmode = t->audmode;
 	}
-	if (analog_ops->has_signal)
-		vt->signal = analog_ops->has_signal(&t->fe);
 	vt->capability |= V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
-	vt->audmode = t->audmode;
 	vt->rangelow = radio_range[0] * 16000;
 	vt->rangehigh = radio_range[1] * 16000;
 
