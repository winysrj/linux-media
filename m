Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab2IZC3h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 22:29:37 -0400
Date: Tue, 25 Sep 2012 23:29:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Subject: Re: [RFCv1 API PATCH 4/4] tuner-core: map audmode to STEREO for
 radio devices.
Message-ID: <20120925232933.69c20987@redhat.com>
In-Reply-To: <201209251545.00414.hansverk@cisco.com>
References: <1347621336-14108-1-git-send-email-hans.verkuil@cisco.com>
	<97c2130954d0c14e16e0e7b08b29405e48a9687e.1347620872.git.hans.verkuil@cisco.com>
	<20120925103340.76a5db3c@redhat.com>
	<201209251545.00414.hansverk@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 25 Sep 2012 15:45:00 +0200
Hans Verkuil <hansverk@cisco.com> escreveu:

> On Tue 25 September 2012 15:33:40 Mauro Carvalho Chehab wrote:
> > Em Fri, 14 Sep 2012 13:15:36 +0200
> > Hans Verkuil <hans.verkuil@cisco.com> escreveu:
> > 
> > > Fixes a v4l2-compliance error: setting audmode to a value other than mono
> > > or stereo for a radio device should map to MODE_STEREO.
> > > 
> > > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > ---
> > >  drivers/media/v4l2-core/tuner-core.c |    5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
> > > index b5a819a..ea71371 100644
> > > --- a/drivers/media/v4l2-core/tuner-core.c
> > > +++ b/drivers/media/v4l2-core/tuner-core.c
> > > @@ -1235,8 +1235,11 @@ static int tuner_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
> > >  	if (set_mode(t, vt->type))
> > >  		return 0;
> > >  
> > > -	if (t->mode == V4L2_TUNER_RADIO)
> > > +	if (t->mode == V4L2_TUNER_RADIO) {
> > >  		t->audmode = vt->audmode;
> > > +		if (t->audmode > V4L2_TUNER_MODE_STEREO)
> > > +			t->audmode = V4L2_TUNER_MODE_STEREO;
> > 
> > NACK. It is not a core's task to fix driver's bugs. It would be ok to have here a
> > WARN_ON(), but, if a driver is reporting a wrong radio audmode, the fix should be
> > there at the drivers, and not here at the core.
> 
> tuner-core *is* the driver.

Not really... it is a driver's glue between the real I2C driver and the bridge
driver.

> A bridge driver just passes v4l2_tuner on to the
> subdev driver(s), and it is the subdev driver such as tuner-core that needs to
> process the audmode as specified by the user. Which in this case means mapping
> audmodes that are invalid when in radio mode to something that is valid as per
> the spec.

Well, when the user is requesting an invalid mode, it should just return -EINVAL.
It makes sense to add a check there at tuner-core to reject audmode if userspace
is requesting, for example, a second language[1]. 

[1] Yet, I think that digital audio standards allow more than one audio channels.
So, this may require to be pushed down into the drivers in some future.

What is invalid actually depends on the device. For example, AM ISA drivers
don't support stereo. Ok, all tuners supported by tuner-core are FM. Even so,
some of them may not support stereo[2].

[2] afaikt, some designs with tuner xc2028 don't support stereo. The driver currently
doesn't handle such border cases, but the point is that such checks should happen
at driver's level.

> So this is a real tuner-core bug, not a bridge driver bug since they don't
> generally touch the audmode field, they just pass it along. And the vt->audmode
> value comes straight from userspace, not from the bridge driver.

Well, tuner-core is just an unified way to talk to the real tuner device.
The is elsewhere (tuner-simple, tea5***, ...).

IMHO, the better is to put such fix at the real device, instead of hacking the
code with something that doesn't really belong there.

Regards,
Mauro
