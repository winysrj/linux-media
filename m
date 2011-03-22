Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57718 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab1CVUkb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 16:40:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: OMAP3 ISP outputs 5555 5555 5555 5555 ...
Date: Tue, 22 Mar 2011 21:40:28 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Jones <michael.jones@matrix-vision.de>
References: <AANLkTimdFVDLLz2o9Fb2OJM2EsJ9R9q-xKAP63g9uSi+@mail.gmail.com>
In-Reply-To: <AANLkTimdFVDLLz2o9Fb2OJM2EsJ9R9q-xKAP63g9uSi+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103222140.28674.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bastian,

On Tuesday 22 March 2011 17:11:04 Bastian Hecht wrote:
> Hello omap isp devs,
> 
> maybe you can help me, I am a bit desperate with my current cam problem:
> 
> I use a ov5642 chip and get only 0x55 in my data output when I use a
> camclk > 1 MHz. With 1 MHz data rate from the camera chip to the omap
> all works (well the colorspace is strange - it's greenish, but that is
> not my main concern).
> I looked up the data on the oscilloscope and all flanks seem to be
> fine at the isp. Very clear cuts with 4 MHz and 10MHz. Also the data
> pins are flickering fine. Looks like a picture.
> 
> I found that the isp stats module uses 0x55 as a magic number but I
> don't see why it should confuse my readout.
> 
> I use 2592x1944 raw bayer output via the ccdc. Next to the logical
> right config I tried all possible configurations of vs/hs active high
> and low on camera and isp. The isp gets the vs flanks right as the
> images come out in time (sometimes it misses 1 frame).
> 
> Anyone of you had this behaviour before?

How do you capture images ? yavta will fill buffers with 0x55 before queueing 
them, so this might indicate that no data is written to the buffer at all.

-- 
Regards,

Laurent Pinchart
