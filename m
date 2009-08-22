Return-path: <linux-media-owner@vger.kernel.org>
Received: from mis07.de ([93.186.196.80]:44403 "EHLO mis07.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932613AbZHVPhk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2009 11:37:40 -0400
Message-ID: <32154E4DCAB64D3BB2B8C6CC3576EE9E@pcvirus>
From: "Rath" <mailings@hardware-datenbank.de>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	<linux-media@vger.kernel.org>
References: <FC97AC6037164F67B001AA702AC80B11@pcvirus> <200908211027.14081.laurent.pinchart@ideasonboard.com>
Subject: Re: Philips webcam support
Date: Sat, 22 Aug 2009 17:37:19 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




> Hi,
>
> On Thursday 20 August 2009 16:48:16 Rath wrote:
>>
>> are the Philips SPC1330NC and SPC2050NC supported by v4l?
>
> The SPC1330NC is supported by the uvcvideo driver. I haven't heard about 
> the
> SPC2050NC yet. My guess is that it would be a UVC device as well. Could 
> you
> please post the output of
>
> lsusb -v
>
> for your camera (using usbutils 0.72 or newer, 0.73+ preferred) ? Thanks.
>

I dont't have a SPC1330 oder a SPC2050.

>> Can I get higher framerates than 30fps (The webcam supports framerates up
>> to 90fps)?
>
> Not with the SPC1330NC. 90fps is just a marketing claim achieved by 
> software
> interpolation. The camera itself supports frame rates up to 30fps.
>

But I can't find anything in the datasheet regarding interpolation of the 
framerate. There's only mentioned that the 8Mpix picture resolution is 
interpolated.

>> I want to use one of them with a Beagleboard when they are supported.
>
> -- 
> Regards,
>
> Laurent Pinchart
> 

