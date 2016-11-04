Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:35618 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933931AbcKDFLh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2016 01:11:37 -0400
Received: by mail-qk0-f169.google.com with SMTP id n204so74443934qke.2
        for <linux-media@vger.kernel.org>; Thu, 03 Nov 2016 22:11:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0e410f78-840b-842a-c9ab-bc0ffc159249@gentoo.org>
References: <CAJ_EiSRM=zn--oFV=7YTE-kipP_ctT2sgSzv64bGrh_MNJbYaQ@mail.gmail.com>
 <767cacf5-5f91-2596-90ef-31358b8e1db9@xs4all.nl> <CAJ_EiSQ-yf7hmnz1qqOAA-XcByCq9f12z=7h=+rCeWQbua+dOg@mail.gmail.com>
 <CAJ_EiSQRai=XqOryMW1WLKvFDPZUVVmkjXSF3TyxpPNMsVsR_Q@mail.gmail.com>
 <20161103142134.4a59dfc34c593391086c0508@kinali.ch> <0e410f78-840b-842a-c9ab-bc0ffc159249@gentoo.org>
From: Matt Ranostay <matt@ranostay.consulting>
Date: Thu, 3 Nov 2016 22:11:36 -0700
Message-ID: <CAJ_EiSSHjfpamgo9Ehu76iaemq9_P0fbxBWLNKRXsSGcadj6ww@mail.gmail.com>
Subject: Re: [RFC] v4l2 support for thermopile devices
To: Luca Barbato <lu_zero@gentoo.org>
Cc: Attila Kinali <attila@kinali.ch>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Marek Vasut <marex@denx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 3, 2016 at 8:11 AM, Luca Barbato <lu_zero@gentoo.org> wrote:
> On 03/11/2016 14:21, Attila Kinali wrote:
>> On Wed, 2 Nov 2016 23:10:41 -0700
>> Matt Ranostay <matt@ranostay.consulting> wrote:
>>
>>>
>>> So does anyone know of any software that is using V4L2_PIX_FMT_Y12
>>> currently? Want to test my driver but seems there isn't anything that
>>> uses that format (ffmpeg, mplayer, etc).
>>>
>>> Raw data seems correct but would like to visualize it :). Suspect I'll
>>> need to write a test case application though
>>
>> I was pretty sure that MPlayer supports 12bit greyscale, but I cannot
>> find where it was handled. You can of course pass it to the MPlayer
>> internas as 8bit greyscale, which would be IMGFMT_Y8 or just pass
>> it on as 16bit which would be IMGFMT_Y16_LE (LE = little endian).
>>
>> You can find the internal #defines of the image formats in
>> libmpcodecs/img_format.h and can use https://www.fourcc.org/yuv.php
>> to decode their meaning.
>>
>> The equivalent for libav would be libavutil/pixfmt.h
>>
>> Luca Barbato tells me that adding Y12 support to libav would be easy.
>>
>>                       Attila Kinali
>>
>
> So easy that is [done][1], it still needs to be tested/reviewed/polished
> though.

Cool. Although needs to be processed since it is signed value, and
because it it is really just 0C based readings with 0.25C steps.. But
will look into that when I get a chance.

Anyway did hack in basic support so v4l2grab so I could test the
sensor, and seems to work well but needs some colorized processing to
be useful of course.

Soldering iron about 1 meter from sensor -> http://imgur.com/a/8totG


>
> [1]:https://github.com/lu-zero/libav/commits/gray12
>
> lu
