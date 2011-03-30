Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58944 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab1C3Jlp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2011 05:41:45 -0400
Received: by iyb14 with SMTP id 14so1055035iyb.19
        for <linux-media@vger.kernel.org>; Wed, 30 Mar 2011 02:41:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201103291656.00189.laurent.pinchart@ideasonboard.com>
References: <AANLkTimdFVDLLz2o9Fb2OJM2EsJ9R9q-xKAP63g9uSi+@mail.gmail.com>
	<AANLkTimyQiG86LHW8-h+GHyXgMkvD-Zp6LP=G4LKHgHY@mail.gmail.com>
	<AANLkTimiOr+dsTM4DXEf31XBkQHD8tt7ZjHDUcRn_f0+@mail.gmail.com>
	<201103291656.00189.laurent.pinchart@ideasonboard.com>
Date: Wed, 30 Mar 2011 11:41:44 +0200
Message-ID: <BANLkTi=+6Xo-sS=sd31mpzzihX0zMGDAPA@mail.gmail.com>
Subject: Re: OMAP3 ISP outputs 5555 5555 5555 5555 ...
From: Bastian Hecht <hechtb@googlemail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/3/29 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Bastian,
>
> On Friday 25 March 2011 13:34:10 Bastian Hecht wrote:
>> 2011/3/24 Bastian Hecht <hechtb@googlemail.com>:
>> > 2011/3/24 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> >> On Thursday 24 March 2011 10:59:01 Bastian Hecht wrote:
>> >>> 2011/3/22 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> >>> > On Tuesday 22 March 2011 17:11:04 Bastian Hecht wrote:
>> >>> >> Hello omap isp devs,
>> >>> >>
>> >>> >> maybe you can help me, I am a bit desperate with my current cam
>> >>> >> problem:
>> >>> >>
>> >>> >> I use a ov5642 chip and get only 0x55 in my data output when I use a
>> >>> >> camclk > 1 MHz. With 1 MHz data rate from the camera chip to the
>> >>> >> omap all works (well the colorspace is strange - it's greenish, but
>> >>> >> that is not my main concern).
>> >>> >> I looked up the data on the oscilloscope and all flanks seem to be
>> >>> >> fine at the isp. Very clear cuts with 4 MHz and 10MHz. Also the data
>> >>> >> pins are flickering fine. Looks like a picture.
>> >>> >>
>> >>> >> I found that the isp stats module uses 0x55 as a magic number but I
>> >>> >> don't see why it should confuse my readout.
>> >>> >>
>> >>> >> I use 2592x1944 raw bayer output via the ccdc. Next to the logical
>> >>> >> right config I tried all possible configurations of vs/hs active
>> >>> >> high and low on camera and isp. The isp gets the vs flanks right as
>> >>> >> the images come out in time (sometimes it misses 1 frame).
>> >>> >>
>> >>> >> Anyone of you had this behaviour before?
>> >>> >
>> >>> > How do you capture images ? yavta will fill buffers with 0x55 before
>> >>> > queueing them, so this might indicate that no data is written to the
>> >>> > buffer at all.
>> >>>
>> >>> Yes I use yavta. So what does that all mean?
>> >>
>> >> It means that the ISP doesn't write data to the buffer. I have no idea
>> >> why.
>>
>> This simple and clear statement directly led me to the problem :)
>>
>> There was no cam_wen (write enable) pin on both my camera boards. The
>> ISP on the other hand is configured by default to expect it. So I only
>> captured images when my data lanes luckily pulled up the omap wen pin
>> by induction.
>>
>> In ccdc_config_sync_if() I added:
>>
>>         /* HACK */
>>         printk(KERN_ALERT "Disable wen\n");
>>         syn_mode &= ~ISPCCDC_SYN_MODE_WEN;
>>
>> So is this something to add to the platform data? I can prepare my
>> very first kernel patch :)
>
> The WEN bit controls whether the CCDC module writes to memory or not. It's not
> supposed to interact with the external cam_wen signal. If you clear the WEN
> bit, the CCDC is supposed not to write data to memory at all.
>
> What you might need to check is the EXWEN bit in the same register. It
> controls whether the CCDC uses the cam_wen signal or not. The EXWEN bit should
> already be set to zero by the driver though.
>
> Does clearing the WEN bit fix your issue ?

Hi Laurent,

As I remember (I currently haven't the datasheet available)  the wen
signal is an input from the camera and the SYN_MODE_WEN makes check
this signal. Disabling the SYN_MODE_WEN solved my problem and I can
reliably read images with 24 MHz datarate on the parallel bus.
Artefacts are gone that I had before with 1 MHz, too.
Is this too small for an own patch or could I send one?

best regards,

 Bastian

> --
> Regards,
>
> Laurent Pinchart
>
