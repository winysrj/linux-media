Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52804 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbZG3EGT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 00:06:19 -0400
Date: Thu, 30 Jul 2009 01:06:09 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: acano@fastmail.fm
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx: enable usb audio for plextor px-tv100u
Message-ID: <20090730010609.72dbe1eb@pedra.chehab.org>
In-Reply-To: <20090729221336.GA4352@localhost.localdomain>
References: <20090718173758.GA32708@localhost.localdomain>
	<20090727212811.5b7dc041@pedra.chehab.org>
	<20090729000753.GA24496@localhost.localdomain>
	<20090729015730.34ab86c6@pedra.chehab.org>
	<20090729221336.GA4352@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 29 Jul 2009 18:13:36 -0400
acano@fastmail.fm escreveu:

> On Wed, Jul 29, 2009 at 01:57:30AM -0300, Mauro Carvalho Chehab wrote:
> > Ah, yes, there's a missing mute/unmute issue there. Instead of using
> > your code, I opted to duplicate part of ac97_set_ctrl code there.
> >
> > I opted to have a small duplicated code, but, IMO, it is now clearer
> > to see why we still need to call em28xx_audio_analog_set(). You will
> > notice that I've rearranged the place where I update volume and
> > mute. The rationale is that v4l2_device_call_all() might eventually
> > change a value for volume/mute.
> >
> > Another reason is that, IMO, v4l2_device_call_all() should return values. In
> > the specific case of volume/mute, if the user tries to specify a
> > value outside the range, the -ERANGE should be returned.
> >
> > I've already committed the patches at the tree. Please double-check.
> >
> 
> It doesn't work.  Mplayer locks up.  There's no video window, but sound
> works.  The only way to kill mplayer is rebooting the machine.

Hmm... a small mistake that kept mutex locked. The enclosed patch should fix.



Cheers,
Mauro
