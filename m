Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59979 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbZG2E5g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 00:57:36 -0400
Date: Wed, 29 Jul 2009 01:57:30 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: acano@fastmail.fm, Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx: enable usb audio for plextor px-tv100u
Message-ID: <20090729015730.34ab86c6@pedra.chehab.org>
In-Reply-To: <20090729000753.GA24496@localhost.localdomain>
References: <20090718173758.GA32708@localhost.localdomain>
	<20090727212811.5b7dc041@pedra.chehab.org>
	<20090729000753.GA24496@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 28 Jul 2009 20:07:53 -0400
acano@fastmail.fm escreveu:

> On Mon, Jul 27, 2009 at 09:28:11PM -0300, Mauro Carvalho Chehab wrote:
> > Hi Acano,
> 
> Tested-by: Angelo Cano <acano@fastmail.fm>
> 
> works great

Good!

> > > +		/*FIXME hack to unmute usb audio stream */
> > > +		em28xx_set_ctrl(dev, ctrl);
> >
> > Hmm... this function were removed. In thesis, you shouldn't need to
> > do anything to unmute.
> >
> 
> I still need it, see attachment.
> 
> >
> > Could you please try the enclosed patch and see if this is enough to fix for
> > Plextor? If so, please send me a Tested-by: tag for me to add it at
> > 2.6.31 fix patches.
> >
> 
> Like I said the patch works great, and also solves my audio volume
> problem.  With your patch the volume is set to a sane value
> (presumably 0db) and the distortion/clipping is gone.
> 
> Thanks man.  The volume problem was driving me crazy.

Ah, yes, there's a missing mute/unmute issue there. Instead of using your code,
I opted to duplicate part of ac97_set_ctrl code there. 

I opted to have a small duplicated code, but, IMO, it is now clearer to see why
we still need to call em28xx_audio_analog_set(). You will notice that I've
rearranged the place where I update volume and mute. The rationale is that 
v4l2_device_call_all() might eventually change a value for volume/mute.

Another reason is that, IMO, v4l2_device_call_all() should return values. In
the specific case of volume/mute, if the user tries to specify a value outside
the range, the -ERANGE should be returned.

I've already committed the patches at the tree. Please double-check.

Hans,

we need to fix the returned error value for v4l2_device_call_all(). I know that
this is an old issue that weren't changed by v4l dev/subdev conversion, but now
it is easier for us to fix. The idea here is to be sure that, if a sub-driver
with a proper handling for a function returns an error value, this would
be returned by v4l2_device_call_all(). Maybe we'll need to adjust some things
at the sub-drivers.



Cheers,
Mauro
