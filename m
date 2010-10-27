Return-path: <mchehab@pedra>
Received: from chybek.jannau.net ([83.169.20.219]:54643 "EHLO
	chybek.jannau.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab0J0KtF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 06:49:05 -0400
Date: Wed, 27 Oct 2010 12:49:33 +0200
From: Janne Grunau <j@jannau.net>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mitar <mmitar@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Too slow libv4l MJPEG decoding with HD cameras
Message-ID: <20101027104933.GC15291@aniel.fritz.box>
References: <AANLkTikGT6m9Ji3bBrwUB-yJY9dT0j8eCP_RNAvh3deG@mail.gmail.com>
 <4CC7EC13.1080008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC7EC13.1080008@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Oct 27, 2010 at 11:08:35AM +0200, Hans de Goede wrote:
> Hi,
> 
> On 10/27/2010 01:51 AM, Mitar wrote:
> > Hi!
> >
> > On Sun, Oct 24, 2010 at 6:04 PM, Mitar<mmitar@gmail.com>  wrote:
> >> Has anybody tried to improve MJPEG support in libv4l? With newer
> >> cameras this becomes important.
> >
> > I have made a patch which makes libv4l uses ffmpeg's avcodec library
> > for MJPEG decoding. Performance improvements are unbelievable.
> >
> 
> Thanks for the patch!
> 
> > I have been testing with Logitech HD Pro Webcam C910 and
> > 2.6.36-rc6-amd64 and Intel(R) Core(TM)2 Quad CPU Q9400 @ 2.66GHz.
> > Camera supports 2592x1944 at 10 FPS MJPEG stream.
> >
> > With using original MJPEG code it takes my computer on average 129.614
> > ms to decode the frame what is 0.0257 us per pixel.
> >
> > With using ffmpeg MJPEG decoding it takes my computer on average
> > 43.616 ms to decode the frame what is 0.0087 us per pixel.
> 
> That is a great improvement, but using ffmpeg in libv4l is not an option
> for multiple reasons:
> 
> 1) It is GPL licensed not LGPL

FFmpeg is mostly LGPL licensed, only a few optimizations and interfaces
to GPL libraries. Running FFmpeg's configure without options and
especially without --enable-gpl will only use lgpl or compatible
licensed code.

> 2) It has various other legal issues which means it is not available
>     in most distro's main repository.

FUD, Ubuntu doesn't seem to have a problem with it.

> So I'm afraid that using ffmpeg really is out of the question. What
> would be interesting is to see how libjpeg performs and then esp. the
> turbo-libjpeg version:
> http://libjpeg-turbo.virtualgl.org/
> 
> I would love to see a patch to use that instead of tiny jpeg, leaving
> tinyjpeg usage only for the pixart jpeg variant stuff.
> 
> Note that some cameras generate what I call planar jpeg, this means
> that they send 3 SOS markers with one component per scan. I don't know
> if libjpeg will grok this (I had to patch libv4l's tinyjpeg copy for
> this). But first lets see how libjpeg performs, and then we can always
> use tinyjpeg to parse the header and depending on the header decide to
> use tinyjpeg or libjpeg.
> 
> Sorry about nacking your ffmpeg patch,

While the patch is not the cleanest, there shouldn't be a problem of
making ffmpeg mjpeg decoding optional.

Janne
