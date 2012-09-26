Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4509 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab2IZHD3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 03:03:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv1 API PATCH 4/4] tuner-core: map audmode to STEREO for radio devices.
Date: Wed, 26 Sep 2012 09:03:13 +0200
Cc: Hans Verkuil <hansverk@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
References: <1347621336-14108-1-git-send-email-hans.verkuil@cisco.com> <201209251545.00414.hansverk@cisco.com> <20120925232933.69c20987@redhat.com>
In-Reply-To: <20120925232933.69c20987@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201209260903.13572.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed September 26 2012 04:29:33 Mauro Carvalho Chehab wrote:
> Em Tue, 25 Sep 2012 15:45:00 +0200
> Hans Verkuil <hansverk@cisco.com> escreveu:
> 
> > On Tue 25 September 2012 15:33:40 Mauro Carvalho Chehab wrote:
> > > Em Fri, 14 Sep 2012 13:15:36 +0200
> > > Hans Verkuil <hans.verkuil@cisco.com> escreveu:
> > > 
> > > > Fixes a v4l2-compliance error: setting audmode to a value other than mono
> > > > or stereo for a radio device should map to MODE_STEREO.
> > > > 
> > > > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > > ---
> > > >  drivers/media/v4l2-core/tuner-core.c |    5 ++++-
> > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
> > > > index b5a819a..ea71371 100644
> > > > --- a/drivers/media/v4l2-core/tuner-core.c
> > > > +++ b/drivers/media/v4l2-core/tuner-core.c
> > > > @@ -1235,8 +1235,11 @@ static int tuner_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
> > > >  	if (set_mode(t, vt->type))
> > > >  		return 0;
> > > >  
> > > > -	if (t->mode == V4L2_TUNER_RADIO)
> > > > +	if (t->mode == V4L2_TUNER_RADIO) {
> > > >  		t->audmode = vt->audmode;
> > > > +		if (t->audmode > V4L2_TUNER_MODE_STEREO)
> > > > +			t->audmode = V4L2_TUNER_MODE_STEREO;
> > > 
> > > NACK. It is not a core's task to fix driver's bugs. It would be ok to have here a
> > > WARN_ON(), but, if a driver is reporting a wrong radio audmode, the fix should be
> > > there at the drivers, and not here at the core.
> > 
> > tuner-core *is* the driver.
> 
> Not really... it is a driver's glue between the real I2C driver and the bridge
> driver.
> 
> > A bridge driver just passes v4l2_tuner on to the
> > subdev driver(s), and it is the subdev driver such as tuner-core that needs to
> > process the audmode as specified by the user. Which in this case means mapping
> > audmodes that are invalid when in radio mode to something that is valid as per
> > the spec.
> 
> Well, when the user is requesting an invalid mode, it should just return -EINVAL.
> It makes sense to add a check there at tuner-core to reject audmode if userspace
> is requesting, for example, a second language[1]. 

My interpretation of the spec is that it will map invalid audmodes to valid audmodes.
>From the VIDIOC_S_TUNER documentation:

"The selected audio mode, see Table A.89, “Tuner Audio Modes” for valid values. The
audio mode does not affect audio subprogram detection, and like a control it does not
automatically change unless the requested mode is invalid or unsupported. See Table
A.90, “Tuner Audio Matrix” for possible results when the selected and received audio
programs do not match."

So my interpretation is that if an audmode is provided that is not valid for the
given device, then the device maps it to something valid rather than returning an
error. The error code list only states that -EINVAL is returned if the index field
is out-of-bounds, not for invalid audmodes.

I think this makes sense as well, otherwise apps would have to laboriously check
which audmodes are supported before they can call S_TUNER. It's much easier to
just give the 'best' audmode and let the driver downgrade if it isn't supported.
This is what happens today anyway, so we can't change that behavior. But the one
thing that should work is that the actual audmode is returned when calling G_TUNER,
which is why the current tuner-core fails with v4l2-compliance.

> [1] Yet, I think that digital audio standards allow more than one audio channels.
> So, this may require to be pushed down into the drivers in some future.
> 
> What is invalid actually depends on the device. For example, AM ISA drivers
> don't support stereo. Ok, all tuners supported by tuner-core are FM. Even so,
> some of them may not support stereo[2].
> 
> [2] afaikt, some designs with tuner xc2028 don't support stereo. The driver currently
> doesn't handle such border cases, but the point is that such checks should happen
> at driver's level.

99% of all those tuner drivers do support stereo, so let's do this simple check
in tuner-core so we don't have to fix all of them. The spec is also clear that
radio devices only support mono or stereo audmodes. Those tuner drivers that
only support mono can easily enforce that explicitly. Or they could, if tuner-core
would copy back the audmode value after calling analog_ops->set_params().

Just as we do basic checks in v4l2-ioctl.c, so we can do basic checks in tuner-core
as well.

Regards,

	Hans
