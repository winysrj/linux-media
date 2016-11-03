Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:36806 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751882AbcKCGKm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2016 02:10:42 -0400
Received: by mail-qk0-f193.google.com with SMTP id h201so2006999qke.3
        for <linux-media@vger.kernel.org>; Wed, 02 Nov 2016 23:10:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ_EiSQ-yf7hmnz1qqOAA-XcByCq9f12z=7h=+rCeWQbua+dOg@mail.gmail.com>
References: <CAJ_EiSRM=zn--oFV=7YTE-kipP_ctT2sgSzv64bGrh_MNJbYaQ@mail.gmail.com>
 <767cacf5-5f91-2596-90ef-31358b8e1db9@xs4all.nl> <CAJ_EiSQ-yf7hmnz1qqOAA-XcByCq9f12z=7h=+rCeWQbua+dOg@mail.gmail.com>
From: Matt Ranostay <matt@ranostay.consulting>
Date: Wed, 2 Nov 2016 23:10:41 -0700
Message-ID: <CAJ_EiSQRai=XqOryMW1WLKvFDPZUVVmkjXSF3TyxpPNMsVsR_Q@mail.gmail.com>
Subject: Re: [RFC] v4l2 support for thermopile devices
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Attila Kinali <attila@kinali.ch>, Marek Vasut <marex@denx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 28, 2016 at 7:59 PM, Matt Ranostay <matt@ranostay.consulting> wrote:
> On Fri, Oct 28, 2016 at 2:53 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Matt,
>>
>> On 28/10/16 22:14, Matt Ranostay wrote:
>>>
>>> So want to toss a few thoughts on adding support for thermopile
>>> devices (could be used for FLIR Lepton as well) that output pixel
>>> data.
>>> These typically aren't DMA'able devices since they are low speed
>>> (partly to limiting the functionality to be in compliance with ITAR)
>>> and data is piped over i2c/spi.
>>>
>>> My question is that there doesn't seem to be an other driver that
>>> polls frames off of a device and pushes it to the video buffer, and
>>> wanted to be sure that this doesn't currently exist somewhere.
>>
>>
>> Not anymore, but if you go back to kernel 3.6 then you'll find this driver:
>>
>> drivers/media/video/bw-qcam.c
>>
>> It was for a grayscale parallel port webcam (which explains why it was
>> removed in 3.7 :-) ), and it used polling to get the pixels.
>
> Yikes parallel port, but I'll take a look at that for some reference :)


So does anyone know of any software that is using V4L2_PIX_FMT_Y12
currently? Want to test my driver but seems there isn't anything that
uses that format (ffmpeg, mplayer, etc).

Raw data seems correct but would like to visualize it :). Suspect I'll
need to write a test case application though


>
>>
>>> Also more importantly does the mailing list thinks it belongs in v4l2?
>>
>>
>> I think it fits. It's a sensor, just with a very small resolution and
>> infrared
>> instead of visible light.
>>
>>> We already came up the opinion on the IIO list that it doesn't belong
>>> in that subsystem since pushing raw pixel data to a buffer is a bit
>>> hacky. Also could be generically written with regmap so other devices
>>> (namely FLIR Lepton) could be easily supported.
>>>
>>> Need some input for the video pixel data types, which the device we
>>> are using (see datasheet links below) is outputting pixel data in
>>> little endian 16-bit of which a 12-bits signed value is used.  Does it
>>> make sense to do some basic processing on the data since greyscale is
>>> going to look weird with temperatures under 0C degrees? Namely a cold
>>> object is going to be brighter than the hottest object it could read.
>>
>>
>>> Or should a new V4L2_PIX_FMT_* be defined and processing done in
>>> software?
>>
>>
>> I would recommend that. It's no big deal, as long as the new format is
>> documented.
>>
>>> Another issue is how to report the scaling value of 0.25 C
>>> for each LSB of the pixels to the respecting recording application.
>>
>>
>> Probably through a read-only control, but I'm not sure.
>>
>> Regards,
>>
>>         Hans
>>
>>>
>>> Datasheet:
>>> http://media.digikey.com/pdf/Data%20Sheets/Panasonic%20Sensors%20PDFs/Grid-EYE_AMG88.pdf
>>> Datasheet:
>>> https://eewiki.net/download/attachments/13599167/Grid-EYE%20SPECIFICATIONS%28Reference%29.pdf?version=1&modificationDate=1380660426690&api=v2
>>>
>>> Thanks,
>>>
>>> Matt
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
