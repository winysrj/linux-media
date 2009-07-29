Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4264 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbZG2GJs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 02:09:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] em28xx: enable usb audio for plextor px-tv100u
Date: Wed, 29 Jul 2009 08:09:31 +0200
Cc: acano@fastmail.fm, linux-media@vger.kernel.org
References: <20090718173758.GA32708@localhost.localdomain> <20090729000753.GA24496@localhost.localdomain> <20090729015730.34ab86c6@pedra.chehab.org>
In-Reply-To: <20090729015730.34ab86c6@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907290809.32089.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 29 July 2009 06:57:30 Mauro Carvalho Chehab wrote:
> Em Tue, 28 Jul 2009 20:07:53 -0400
>
> acano@fastmail.fm escreveu:
> > On Mon, Jul 27, 2009 at 09:28:11PM -0300, Mauro Carvalho Chehab wrote:
> > > Hi Acano,
> >
> > Tested-by: Angelo Cano <acano@fastmail.fm>
> >
> > works great
>
> Good!
>
> > > > +		/*FIXME hack to unmute usb audio stream */
> > > > +		em28xx_set_ctrl(dev, ctrl);
> > >
> > > Hmm... this function were removed. In thesis, you shouldn't need to
> > > do anything to unmute.
> >
> > I still need it, see attachment.
> >
> > > Could you please try the enclosed patch and see if this is enough to
> > > fix for Plextor? If so, please send me a Tested-by: tag for me to add
> > > it at 2.6.31 fix patches.
> >
> > Like I said the patch works great, and also solves my audio volume
> > problem.  With your patch the volume is set to a sane value
> > (presumably 0db) and the distortion/clipping is gone.
> >
> > Thanks man.  The volume problem was driving me crazy.
>
> Ah, yes, there's a missing mute/unmute issue there. Instead of using your
> code, I opted to duplicate part of ac97_set_ctrl code there.
>
> I opted to have a small duplicated code, but, IMO, it is now clearer to
> see why we still need to call em28xx_audio_analog_set(). You will notice
> that I've rearranged the place where I update volume and mute. The
> rationale is that v4l2_device_call_all() might eventually change a value
> for volume/mute.
>
> Another reason is that, IMO, v4l2_device_call_all() should return values.
> In the specific case of volume/mute, if the user tries to specify a value
> outside the range, the -ERANGE should be returned.
>
> I've already committed the patches at the tree. Please double-check.
>
> Hans,
>
> we need to fix the returned error value for v4l2_device_call_all(). I
> know that this is an old issue that weren't changed by v4l dev/subdev
> conversion, but now it is easier for us to fix. The idea here is to be
> sure that, if a sub-driver with a proper handling for a function returns
> an error value, this would be returned by v4l2_device_call_all(). Maybe
> we'll need to adjust some things at the sub-drivers.

Use v4l2_device_call_until_err instead of v4l2_device_call_all. That macro 
checks for errors returned from the subdevs.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
