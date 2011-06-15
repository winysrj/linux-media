Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3394 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab1FOT4K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 15:56:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [RFCv2 PATCH 0/5] tuner-core: fix s_std and s_tuner
Date: Wed, 15 Jun 2011 21:55:57 +0200
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl> <201106111902.11384.hverkuil@xs4all.nl> <BANLkTi=XkLVOc6NfQvD66o-ppD9Fch42SQ@mail.gmail.com>
In-Reply-To: <BANLkTi=XkLVOc6NfQvD66o-ppD9Fch42SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106152155.57978.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, June 11, 2011 19:08:04 Devin Heitmueller wrote:
> On Sat, Jun 11, 2011 at 1:02 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > OK, but how do you get it into standby in the first place? (I must be missing
> > something here...)
> 
> The tuner core puts the chip into standby when the last V4L filehandle
> is closed.  Yes, I realize this violates the V4L spec since you should
> be able to make multiple calls with something like v4l2-ctl, but
> nobody has ever come up with a better mechanism for knowing when to
> put the device to sleep.

Why would that violate the spec? If the last filehandle is closed, then
you can safely poweroff the tuner. The only exception is when you have a radio
tuner whose audio output is hooked up to some line-in: there you can't power off
the tuner.

> 
> We've been forced to choose between the purist perspective, which is
> properly preserving state, never powering down the tuner and sucking
> up 500ma on the USB port when not using the tuner, versus powering
> down the tuner when the last party closes the filehandle, which
> preserves power but breaks v4l2 conformance and in some cases is
> highly noticeable with tuners that require firmware to be reloaded
> when being powered back up.

Seems fine to me. What isn't fine is that a driver like e.g. em28xx powers off
the tuner but doesn't power it on again on the next open. It won't do that
until the first S_FREQUENCY/S_TUNER/S_STD call.

Devin, Mauro, is there anything wrong with adding support for s_power(1) and
calling it in em28xx? A similar power up would be needed in cx23885, au0828,
cx88 and cx231xx.

Mauro, if you agree with this patch, then I'll add it to the tuner patch series.

Tested with em28xx.

Regards,

	Hans

diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index 7b6461d..6f3f51b 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -2111,6 +2111,7 @@ static int em28xx_v4l2_open(struct file *filp)
 		em28xx_wake_i2c(dev);
 
 	}
+	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 1);
 	if (fh->radio) {
 		em28xx_videodbg("video_open: setting radio device\n");
 		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_radio);
diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 9b0d833..9006c9a 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -1057,16 +1057,20 @@ static int tuner_s_radio(struct v4l2_subdev *sd)
 /**
  * tuner_s_power - controls the power state of the tuner
  * @sd: pointer to struct v4l2_subdev
- * @on: a zero value puts the tuner to sleep
+ * @on: a zero value puts the tuner to sleep, non-zero wakes it up
  */
 static int tuner_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct tuner *t = to_tuner(sd);
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
 
-	/* FIXME: Why this function don't wake the tuner if on != 0 ? */
-	if (on)
+	if (on) {
+		if (t->standby && set_mode(t, t->mode) == 0) {
+			tuner_dbg("Waking up tuner\n");
+			set_freq(t, 0);
+		}
 		return 0;
+	}
 
 	tuner_dbg("Putting tuner to sleep\n");
 	t->standby = true;
