Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55976 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZG2OmT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 10:42:19 -0400
Date: Wed, 29 Jul 2009 11:42:11 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: acano@fastmail.fm, linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx: enable usb audio for plextor px-tv100u
Message-ID: <20090729114211.065ed01f@pedra.chehab.org>
In-Reply-To: <7aa4c771a5b1cf3117cf9faf027cc05c.squirrel@webmail.xs4all.nl>
References: <20090718173758.GA32708@localhost.localdomain>
	<20090729000753.GA24496@localhost.localdomain>
	<20090729015730.34ab86c6@pedra.chehab.org>
	<200907290809.32089.hverkuil@xs4all.nl>
	<20090729094009.6dc01728@pedra.chehab.org>
	<7aa4c771a5b1cf3117cf9faf027cc05c.squirrel@webmail.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 29 Jul 2009 15:14:22 +0200
"Hans Verkuil" <hverkuil@xs4all.nl> escreveu:

> 
> > Em Wed, 29 Jul 2009 08:09:31 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >
> >> On Wednesday 29 July 2009 06:57:30 Mauro Carvalho Chehab wrote:
> >> > Em Tue, 28 Jul 2009 20:07:53 -0400
> >> >
> >> > acano@fastmail.fm escreveu:
> >> > > On Mon, Jul 27, 2009 at 09:28:11PM -0300, Mauro Carvalho Chehab
> >> wrote:
> >> > > > Hi Acano,
> >> > >
> >> > > Tested-by: Angelo Cano <acano@fastmail.fm>
> >> > >
> >> > > works great
> >> >
> >> > Good!
> >> >
> >> > > > > +		/*FIXME hack to unmute usb audio stream */
> >> > > > > +		em28xx_set_ctrl(dev, ctrl);
> >> > > >
> >> > > > Hmm... this function were removed. In thesis, you shouldn't need
> >> to
> >> > > > do anything to unmute.
> >> > >
> >> > > I still need it, see attachment.
> >> > >
> >> > > > Could you please try the enclosed patch and see if this is enough
> >> to
> >> > > > fix for Plextor? If so, please send me a Tested-by: tag for me to
> >> add
> >> > > > it at 2.6.31 fix patches.
> >> > >
> >> > > Like I said the patch works great, and also solves my audio volume
> >> > > problem.  With your patch the volume is set to a sane value
> >> > > (presumably 0db) and the distortion/clipping is gone.
> >> > >
> >> > > Thanks man.  The volume problem was driving me crazy.
> >> >
> >> > Ah, yes, there's a missing mute/unmute issue there. Instead of using
> >> your
> >> > code, I opted to duplicate part of ac97_set_ctrl code there.
> >> >
> >> > I opted to have a small duplicated code, but, IMO, it is now clearer
> >> to
> >> > see why we still need to call em28xx_audio_analog_set(). You will
> >> notice
> >> > that I've rearranged the place where I update volume and mute. The
> >> > rationale is that v4l2_device_call_all() might eventually change a
> >> value
> >> > for volume/mute.
> >> >
> >> > Another reason is that, IMO, v4l2_device_call_all() should return
> >> values.
> >> > In the specific case of volume/mute, if the user tries to specify a
> >> value
> >> > outside the range, the -ERANGE should be returned.
> >> >
> >> > I've already committed the patches at the tree. Please double-check.
> >> >
> >> > Hans,
> >> >
> >> > we need to fix the returned error value for v4l2_device_call_all(). I
> >> > know that this is an old issue that weren't changed by v4l dev/subdev
> >> > conversion, but now it is easier for us to fix. The idea here is to be
> >> > sure that, if a sub-driver with a proper handling for a function
> >> returns
> >> > an error value, this would be returned by v4l2_device_call_all().
> >> Maybe
> >> > we'll need to adjust some things at the sub-drivers.
> >>
> >> Use v4l2_device_call_until_err instead of v4l2_device_call_all. That
> >> macro
> >> checks for errors returned from the subdevs.
> >
> > It doesn't work as expected. If I use it for queryctl, for example, it
> > returns
> > an empty set of controls. If I use it for g_ctrl, it returns:
> >
> > error 22 getting ctrl Brightness
> > error 22 getting ctrl Contrast
> > error 22 getting ctrl Saturation
> > error 22 getting ctrl Hue
> > error 22 getting ctrl Volume
> > error 22 getting ctrl Balance
> > error 22 getting ctrl Bass
> > error 22 getting ctrl Treble
> > error 22 getting ctrl Mute
> > error 22 getting ctrl Loudness
> >
> > The issue here is we need something that discards errors for
> > non-implemented
> > controls.
> >
> > As the sub-drivers are returning -EINVAL for non-implemented controls (and
> > probably other stuff that aren't implemented there), the function will not
> > work
> > for some ioctls.
> >
> > The proper fix seems to elect an error condition to be returned by driver
> > when
> > a function is not implemented, and such errors to be discarded by the
> > macro.
> >
> > It seems that the proper error code for such case is this one:
> >
> > #define ENOSYS          38      /* Function not implemented */
> 
> You are right, this macro doesn't work for these control functions. It it
> is possible to implement a define like ENOSYS, but I prefer to work on
> generic control processing code that is embedded in the v4l2 framework. It
> looks like I'll finally have time to work on that this weekend.


I did some tests here: if we replace -EINVAL with -ENOIOCTLCMD, we can properly
make v4l2_device_call_until_err() to work, fixing the lack of a proper error
report at the drivers. This error code seems also appropriate for this case.

This means several trivial patches on each v4l device driver, just replacing
the error codes for 3 ioctl handlers (s_ctrl, g_ctrl, queryctrl).

I'll try to write such patches for v4l devices, since I want to get rid of this
bug on 2.6.31, at least on em28xx driver. If I have more time, I'll fix other
bridge drivers as well.

> Currently the control handling code in our v4l drivers is, to be blunt, a
> pile of crap. And it is ideal to move this into the v4l2 framework since
> 90% of this is common code.

Hmm, except for a few places that still implement this at the old way, most of
the common code is already at v4l2 core. So, I'm not sure what you're referring.

Cheers,
Mauro
