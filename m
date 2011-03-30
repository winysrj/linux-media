Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59059 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184Ab1C3KI7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2011 06:08:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: OMAP3 ISP outputs 5555 5555 5555 5555 ...
Date: Wed, 30 Mar 2011 12:09:16 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <AANLkTimdFVDLLz2o9Fb2OJM2EsJ9R9q-xKAP63g9uSi+@mail.gmail.com> <201103291656.00189.laurent.pinchart@ideasonboard.com> <BANLkTi=+6Xo-sS=sd31mpzzihX0zMGDAPA@mail.gmail.com>
In-Reply-To: <BANLkTi=+6Xo-sS=sd31mpzzihX0zMGDAPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103301209.17497.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bastian,

On Wednesday 30 March 2011 11:41:44 Bastian Hecht wrote:
> 2011/3/29 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> > On Friday 25 March 2011 13:34:10 Bastian Hecht wrote:
> >> 2011/3/24 Bastian Hecht <hechtb@googlemail.com>:
> >> > 2011/3/24 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> >> >> On Thursday 24 March 2011 10:59:01 Bastian Hecht wrote:
> >> >>> 2011/3/22 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> >> >>> > On Tuesday 22 March 2011 17:11:04 Bastian Hecht wrote:
> >> >>> >> Hello omap isp devs,
> >> >>> >> 
> >> >>> >> maybe you can help me, I am a bit desperate with my current cam
> >> >>> >> problem:
> >> >>> >> 
> >> >>> >> I use a ov5642 chip and get only 0x55 in my data output when I
> >> >>> >> use a camclk > 1 MHz. With 1 MHz data rate from the camera chip
> >> >>> >> to the omap all works (well the colorspace is strange - it's
> >> >>> >> greenish, but that is not my main concern).
> >> >>> >> I looked up the data on the oscilloscope and all flanks seem to
> >> >>> >> be fine at the isp. Very clear cuts with 4 MHz and 10MHz. Also
> >> >>> >> the data pins are flickering fine. Looks like a picture.
> >> >>> >> 
> >> >>> >> I found that the isp stats module uses 0x55 as a magic number but
> >> >>> >> I don't see why it should confuse my readout.
> >> >>> >> 
> >> >>> >> I use 2592x1944 raw bayer output via the ccdc. Next to the
> >> >>> >> logical right config I tried all possible configurations of
> >> >>> >> vs/hs active high and low on camera and isp. The isp gets the vs
> >> >>> >> flanks right as the images come out in time (sometimes it misses
> >> >>> >> 1 frame).
> >> >>> >> 
> >> >>> >> Anyone of you had this behaviour before?
> >> >>> > 
> >> >>> > How do you capture images ? yavta will fill buffers with 0x55
> >> >>> > before queueing them, so this might indicate that no data is
> >> >>> > written to the buffer at all.
> >> >>> 
> >> >>> Yes I use yavta. So what does that all mean?
> >> >> 
> >> >> It means that the ISP doesn't write data to the buffer. I have no
> >> >> idea why.
> >> 
> >> This simple and clear statement directly led me to the problem :)
> >> 
> >> There was no cam_wen (write enable) pin on both my camera boards. The
> >> ISP on the other hand is configured by default to expect it. So I only
> >> captured images when my data lanes luckily pulled up the omap wen pin
> >> by induction.
> >> 
> >> In ccdc_config_sync_if() I added:
> >> 
> >>         /* HACK */
> >>         printk(KERN_ALERT "Disable wen\n");
> >>         syn_mode &= ~ISPCCDC_SYN_MODE_WEN;
> >> 
> >> So is this something to add to the platform data? I can prepare my
> >> very first kernel patch :)
> > 
> > The WEN bit controls whether the CCDC module writes to memory or not.
> > It's not supposed to interact with the external cam_wen signal. If you
> > clear the WEN bit, the CCDC is supposed not to write data to memory at
> > all.
> > 
> > What you might need to check is the EXWEN bit in the same register. It
> > controls whether the CCDC uses the cam_wen signal or not. The EXWEN bit
> > should already be set to zero by the driver though.
> > 
> > Does clearing the WEN bit fix your issue ?
> 
> Hi Laurent,
> 
> As I remember (I currently haven't the datasheet available) the wen signal
> is an input from the camera

That's correct.

> and the SYN_MODE_WEN makes check this signal.

According to the TRM, SYN_MODE_EXWEN control whether the cam_wen signal is 
used or not, and SYN_MODE_WEN controls whether the CCDC captures data to 
memory or not.

> Disabling the SYN_MODE_WEN solved my problem and I can reliably read images
> with 24 MHz datarate on the parallel bus. Artefacts are gone that I had
> before with 1 MHz, too.

If you capture data at the CCDC output, clearing SYN_MODE_WEN is supposed to 
disable capture completely. Could you double-check your modifications ?

-- 
Regards,

Laurent Pinchart
