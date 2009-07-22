Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53657 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbZGVFn0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 01:43:26 -0400
Date: Wed, 22 Jul 2009 02:43:20 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Steve Castellotti <sc@eyemagnet.com>
Cc: linux-media@vger.kernel.org, Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: offering bounty for GPL'd dual em28xx support
Message-ID: <20090722024320.2f1d9990@pedra.chehab.org>
In-Reply-To: <4A668BB9.1020700@eyemagnet.com>
References: <4A6666CC.7020008@eyemagnet.com>
	<829197380907211842p4c9886a3q96a8b50e58e63cbf@mail.gmail.com>
	<4A667735.40002@eyemagnet.com>
	<829197380907211932v6048d099h2ebb50da05959d89@mail.gmail.com>
	<4A668BB9.1020700@eyemagnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 21 Jul 2009 20:47:05 -0700
Steve Castellotti <sc@eyemagnet.com> escreveu:

> On 07/21/2009 07:32 PM, Devin Heitmueller wrote:
> > I agree that *in theory* you should be able to do two devices.  A back
> > of the envelope calculation of 640x480 at 30fps in YUVY capture should
> > be about 148Mbps.  That said, I don't think the scenario you are
> > describing has really been tested/debugged previously.  If I had to
> > guess, my suspicion would be a bug in the driver code that calculates
> > which USB alternate mode to operate in, which results in the driver
> > reserving more bandwidth than necessary.
> >
> > I would have dig into the code and do some testing in order to have a
> > better idea where the problem is.  Do you have a specific em28xx
> > product in mind that you intend to use?
> >

Steve,

I did last year some code optimizations and tests in order to support more than one
em28xx device:

	http://www.mail-archive.com/linux-usb@vger.kernel.org/msg01634.html

In summary, a 480 Mbps Usb 2.0 bus can be used up to 80% of its maximum
bandwidth, and a single video stream eats more than 40% of the maximum
available bandwidth, according with Usb 2.0 isoc transfer tables.

On that time, I did a patch that auto-adjusts the amount of used bandwidth
based on the resolution. So, in thesis, if you select 320x200, you'll eat less
bandwidth and you may have two devices connected at the same usb bus.

Before my patch, a video stream whose resolution is 720x480x30fps,16
bits/pixel, meaning about 166 Mbps stream rate (without USB oveheads) was
eating 60% of the maximum allowed bus speed (80% of 480 Mbps).

The rationale is that USB 2.0 has a limit on the maximum number of isoc packets
and packet size per second, based on timing issues.

I remember I did some tests that succeeded on eating less bandwidth, and that
it did work with more than one em28xx hardware.

There are a few missing features to allow the em28xx driver to eat less bandwidth:

1) As we now support formats with 8 and 12 bits per pixel, we may optimize the
code as well to consider the number of bpp at the calculus on
em28xx_set_alternate(). 

In thesis, all we need to do is to replace the magic number "2" on the first
calculus:

        unsigned int min_pkt_size = dev->width * 2 + 4;

        /* When image size is bigger than a certain value,
           the frame size should be increased, otherwise, only
           green screen will be received.
         */

        if (dev->width * 2 * dev->height > 720 * 240 * 2)
                min_pkt_size *= 2;

So, changing the first calculus to:
        unsigned int min_pkt_size = ((dev->width * dev->format->depth + 7) >> 3) + 4;

and being sure that the function is properly called at the proper places (it
should be, already) will probably eat about half of the bandwidth, if you
select an 8 bpp output format (currently, only bayer formats are supported).

There's one issue here: most apps don't support bayer format, so we need libv4l
to convert. However, I'm not sure if libv4l will select bayer format, or will
keep using yuy2 for input. It would be nice to add some control on libv4l to
allow controlling the input format based on the user needs (less bandwidth or
less quality). I'm copying Hans here, since he maintains libv4l.

The second calculus were obtained experimentally. Not sure what is needed
there. Maybe Devin can came up with a better formula.

2) to select also fps and calculate bandwidth accordingly. 

For this to work, we need to discover a way to slow down the frame rate and see
if this will really allow using more devices.

On my tests on implementing em28xx Silvercrest webcam support, some weeks ago,
I discovered that slowing down the frame rate at the sensor is enough to slow
it down at em28xx driver. So, it is on my TODO list to add fps selection at the
driver, at least for devices with mt9v011 sensor.

I wish I had more than one em28xx webcam here for tests, but I currently have
just one (thanks to Hans that borrowed it to Douglas, that borrowed it to me).

If this strategy of slowing down the fps by changing the sensos also works with
analog demods, grabber devices can also benefit of such gains. In this case,
the solution is to add, if possible, a frame rate selection at saa7115 and
tvp5150 drivers. At the time I wrote the tvp5150 driver, I haven't cared to
provide such controls. I'll need to double check its datasheets to be sure if
this is possible.



Cheers,
Mauro
