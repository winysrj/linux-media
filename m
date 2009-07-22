Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f197.google.com ([209.85.210.197]:35771 "EHLO
	mail-yx0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbZGVQCu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 12:02:50 -0400
Received: by yxe35 with SMTP id 35so462524yxe.33
        for <linux-media@vger.kernel.org>; Wed, 22 Jul 2009 09:02:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090722024320.2f1d9990@pedra.chehab.org>
References: <4A6666CC.7020008@eyemagnet.com>
	 <829197380907211842p4c9886a3q96a8b50e58e63cbf@mail.gmail.com>
	 <4A667735.40002@eyemagnet.com>
	 <829197380907211932v6048d099h2ebb50da05959d89@mail.gmail.com>
	 <4A668BB9.1020700@eyemagnet.com>
	 <20090722024320.2f1d9990@pedra.chehab.org>
Date: Wed, 22 Jul 2009 12:02:48 -0400
Message-ID: <829197380907220902p5044e931jf54edcec48b4c26f@mail.gmail.com>
Subject: Re: offering bounty for GPL'd dual em28xx support
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Steve Castellotti <sc@eyemagnet.com>, linux-media@vger.kernel.org,
	Hans de Goede <j.w.r.degoede@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 22, 2009 at 1:43 AM, Mauro Carvalho
Chehab<mchehab@infradead.org> wrote:
> I did last year some code optimizations and tests in order to support more than one
> em28xx device:
>
>        http://www.mail-archive.com/linux-usb@vger.kernel.org/msg01634.html
>
> In summary, a 480 Mbps Usb 2.0 bus can be used up to 80% of its maximum
> bandwidth, and a single video stream eats more than 40% of the maximum
> available bandwidth, according with Usb 2.0 isoc transfer tables.
>
> On that time, I did a patch that auto-adjusts the amount of used bandwidth
> based on the resolution. So, in thesis, if you select 320x200, you'll eat less
> bandwidth and you may have two devices connected at the same usb bus.
>
> Before my patch, a video stream whose resolution is 720x480x30fps,16
> bits/pixel, meaning about 166 Mbps stream rate (without USB oveheads) was
> eating 60% of the maximum allowed bus speed (80% of 480 Mbps).
>
> The rationale is that USB 2.0 has a limit on the maximum number of isoc packets
> and packet size per second, based on timing issues.
>
> I remember I did some tests that succeeded on eating less bandwidth, and that
> it did work with more than one em28xx hardware.
>
> There are a few missing features to allow the em28xx driver to eat less bandwidth:
>
> 1) As we now support formats with 8 and 12 bits per pixel, we may optimize the
> code as well to consider the number of bpp at the calculus on
> em28xx_set_alternate().
>
> In thesis, all we need to do is to replace the magic number "2" on the first
> calculus:
>
>        unsigned int min_pkt_size = dev->width * 2 + 4;
>
>        /* When image size is bigger than a certain value,
>           the frame size should be increased, otherwise, only
>           green screen will be received.
>         */
>
>        if (dev->width * 2 * dev->height > 720 * 240 * 2)
>                min_pkt_size *= 2;
>
> So, changing the first calculus to:
>        unsigned int min_pkt_size = ((dev->width * dev->format->depth + 7) >> 3) + 4;
>
> and being sure that the function is properly called at the proper places (it
> should be, already) will probably eat about half of the bandwidth, if you
> select an 8 bpp output format (currently, only bayer formats are supported).
>
> There's one issue here: most apps don't support bayer format, so we need libv4l
> to convert. However, I'm not sure if libv4l will select bayer format, or will
> keep using yuy2 for input. It would be nice to add some control on libv4l to
> allow controlling the input format based on the user needs (less bandwidth or
> less quality). I'm copying Hans here, since he maintains libv4l.
>
> The second calculus were obtained experimentally. Not sure what is needed
> there. Maybe Devin can came up with a better formula.
>
> 2) to select also fps and calculate bandwidth accordingly.
>
> For this to work, we need to discover a way to slow down the frame rate and see
> if this will really allow using more devices.
>
> On my tests on implementing em28xx Silvercrest webcam support, some weeks ago,
> I discovered that slowing down the frame rate at the sensor is enough to slow
> it down at em28xx driver. So, it is on my TODO list to add fps selection at the
> driver, at least for devices with mt9v011 sensor.
>
> I wish I had more than one em28xx webcam here for tests, but I currently have
> just one (thanks to Hans that borrowed it to Douglas, that borrowed it to me).
>
> If this strategy of slowing down the fps by changing the sensos also works with
> analog demods, grabber devices can also benefit of such gains. In this case,
> the solution is to add, if possible, a frame rate selection at saa7115 and
> tvp5150 drivers. At the time I wrote the tvp5150 driver, I haven't cared to
> provide such controls. I'll need to double check its datasheets to be sure if
> this is possible.

Hello Mauro,

As far as I know, the em28xx has no capability to adjust the frame
rate.  It will forward the frames at whatever rate the ITU656 stream
is delivered from the decoder.  I also don't think the tvp5150 will
deliver frames at any rather other than the NTSC/PAL standard in
question (but I would have to double-check the tvp5150 datasheet to be
sure).

I would like to spend some time looking closer at the formula used to
calculate the set_alternate() call.  I just haven't had the time to
invest in such an investigation given all the other stuff I am working
on right now (in particular the three or four em28xx devices I am
adding support for, the xc4000 driver work, and hvr-950q analog
fixes).

I didn't know about the 80% utilization cap for isoc, so thanks for
providing the reference to that previous thread, which has some pretty
interesting information.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
