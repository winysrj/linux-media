Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:32943 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756364AbcJ2C4s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Oct 2016 22:56:48 -0400
Received: by mail-qk0-f194.google.com with SMTP id x11so5963197qka.0
        for <linux-media@vger.kernel.org>; Fri, 28 Oct 2016 19:56:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <00f453e4-4a58-f01f-c68e-80c88554c3c1@denx.de>
References: <CAJ_EiSRM=zn--oFV=7YTE-kipP_ctT2sgSzv64bGrh_MNJbYaQ@mail.gmail.com>
 <CAGoCfiw0YJ-iPYG+ZZvdf=5Vh_7wCbB7oO61HU9T3z51kjORiw@mail.gmail.com> <00f453e4-4a58-f01f-c68e-80c88554c3c1@denx.de>
From: Matt Ranostay <matt@ranostay.consulting>
Date: Fri, 28 Oct 2016 19:56:47 -0700
Message-ID: <CAJ_EiSR=3w2mTsxgXaofE8t0QOYU=sH=D71JO4GFAcVSzpbNCg@mail.gmail.com>
Subject: Re: [RFC] v4l2 support for thermopile devices
To: Marek Vasut <marex@denx.de>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Attila Kinali <attila@kinali.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 28, 2016 at 1:40 PM, Marek Vasut <marex@denx.de> wrote:
> On 10/28/2016 10:30 PM, Devin Heitmueller wrote:
>> Hi Matt,
>>
>>> Need some input for the video pixel data types, which the device we
>>> are using (see datasheet links below) is outputting pixel data in
>>> little endian 16-bit of which a 12-bits signed value is used.  Does it
>>> make sense to do some basic processing on the data since greyscale is
>>> going to look weird with temperatures under 0C degrees? Namely a cold
>>> object is going to be brighter than the hottest object it could read.
>>> Or should a new V4L2_PIX_FMT_* be defined and processing done in
>>> software?  Another issue is how to report the scaling value of 0.25 C
>>> for each LSB of the pixels to the respecting recording application.
>>
>> Regarding the format for the pixel data:  I did some research into
>> this when doing some driver work for the Seek Thermal (a product
>> similar to the FLIR Lepton).  While it would be nice to be able to use
>> an existing application like VLC or gStreamer to just take the video
>> and capture from the V4L2 interface with no additional userland code,
>> the reality is that how you colorize the data is going to be highly
>> user specific (e.g. what thermal ranges to show with what colors,
>> etc).  If your goal is really to do a V4L2 driver which returns the
>> raw data, then you're probably best returning it in the native
>> greyscale format (whether that be an existing V4L2 PIX_FMT or a new
>> one needs to be defined), and then in software you can figure out how
>> to colorize it.
>
> All true, I also did my share of poking into SEEK Thermal USB and it is
> an excellent candidate for a V4L2 driver, that one. But I think this
> device here is producing much smaller images, something like 8x8 pixels.

Yes this is only 64 pixel (8x8 grid) but it is video still. Does have
some major pluses over a FLIR camera though, mainly power usage is
really low, and cost is lower (although that reason is decreasing
everyday).

>
> --
> Best regards,
> Marek Vasut
