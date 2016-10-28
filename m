Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:50632 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753955AbcJ1VyA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Oct 2016 17:54:00 -0400
Subject: Re: [RFC] v4l2 support for thermopile devices
To: Matt Ranostay <matt@ranostay.consulting>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
References: <CAJ_EiSRM=zn--oFV=7YTE-kipP_ctT2sgSzv64bGrh_MNJbYaQ@mail.gmail.com>
Cc: Attila Kinali <attila@kinali.ch>, Marek Vasut <marex@denx.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <767cacf5-5f91-2596-90ef-31358b8e1db9@xs4all.nl>
Date: Fri, 28 Oct 2016 23:53:52 +0200
MIME-Version: 1.0
In-Reply-To: <CAJ_EiSRM=zn--oFV=7YTE-kipP_ctT2sgSzv64bGrh_MNJbYaQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matt,

On 28/10/16 22:14, Matt Ranostay wrote:
> So want to toss a few thoughts on adding support for thermopile
> devices (could be used for FLIR Lepton as well) that output pixel
> data.
> These typically aren't DMA'able devices since they are low speed
> (partly to limiting the functionality to be in compliance with ITAR)
> and data is piped over i2c/spi.
>
> My question is that there doesn't seem to be an other driver that
> polls frames off of a device and pushes it to the video buffer, and
> wanted to be sure that this doesn't currently exist somewhere.

Not anymore, but if you go back to kernel 3.6 then you'll find this driver:

drivers/media/video/bw-qcam.c

It was for a grayscale parallel port webcam (which explains why it was
removed in 3.7 :-) ), and it used polling to get the pixels.

> Also more importantly does the mailing list thinks it belongs in v4l2?

I think it fits. It's a sensor, just with a very small resolution and 
infrared
instead of visible light.

> We already came up the opinion on the IIO list that it doesn't belong
> in that subsystem since pushing raw pixel data to a buffer is a bit
> hacky. Also could be generically written with regmap so other devices
> (namely FLIR Lepton) could be easily supported.
>
> Need some input for the video pixel data types, which the device we
> are using (see datasheet links below) is outputting pixel data in
> little endian 16-bit of which a 12-bits signed value is used.  Does it
> make sense to do some basic processing on the data since greyscale is
> going to look weird with temperatures under 0C degrees? Namely a cold
> object is going to be brighter than the hottest object it could read.

> Or should a new V4L2_PIX_FMT_* be defined and processing done in
> software?

I would recommend that. It's no big deal, as long as the new format is
documented.

> Another issue is how to report the scaling value of 0.25 C
> for each LSB of the pixels to the respecting recording application.

Probably through a read-only control, but I'm not sure.

Regards,

	Hans

>
> Datasheet: http://media.digikey.com/pdf/Data%20Sheets/Panasonic%20Sensors%20PDFs/Grid-EYE_AMG88.pdf
> Datasheet: https://eewiki.net/download/attachments/13599167/Grid-EYE%20SPECIFICATIONS%28Reference%29.pdf?version=1&modificationDate=1380660426690&api=v2
>
> Thanks,
>
> Matt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
