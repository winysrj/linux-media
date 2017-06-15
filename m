Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:53433 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752409AbdFOOu1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 10:50:27 -0400
Subject: Re: [RFC 2/2] [media] bcm2835-unicam: Driver for CCP2/CSI2 camera
 interface
To: Dave Stevenson <dave.stevenson@raspberrypi.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <cover.1497452006.git.dave.stevenson@raspberrypi.org>
 <e268d99095dea34a049d9cacf9c18e855050abe1.1497452006.git.dave.stevenson@raspberrypi.org>
 <ec774750-d6a9-d8b7-9b38-0fd97fe7678d@xs4all.nl>
 <CAAoAYcNPk==5=sNZRuVvShPv+ky=ewdg7O7G4xGp6qLFaMTvYQ@mail.gmail.com>
From: Stefan Wahren <stefan.wahren@i2se.com>
Message-ID: <2de5b0c1-2408-2a12-8c4c-fa91658e0c0b@i2se.com>
Date: Thu, 15 Jun 2017 16:49:51 +0200
MIME-Version: 1.0
In-Reply-To: <CAAoAYcNPk==5=sNZRuVvShPv+ky=ewdg7O7G4xGp6qLFaMTvYQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: de-DE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dave,

Am 15.06.2017 um 15:38 schrieb Dave Stevenson:
> Hi Hans.
>
> "On 15 June 2017 at 08:12, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Dave,
>>
>> Here is a quick review of this driver. Once a v2 is posted I'll do a more
>> thorough
>> check.
> Thank you. I wasn't expecting such a quick response.
>
>> On 06/14/2017 05:15 PM, Dave Stevenson wrote:
>>> ...
>>>
>>> +
>>> +struct bayer_fmt {
>>> +       u32 fourcc;
>>> +       u8 depth;
>>> +};
>>> +
>>> +const struct bayer_fmt all_bayer_bggr[] = {
>>> +       {V4L2_PIX_FMT_SBGGR8,   8},
>>> +       {V4L2_PIX_FMT_SBGGR10P, 10},
>>> +       {V4L2_PIX_FMT_SBGGR12,  12},
>>> +       {V4L2_PIX_FMT_SBGGR16,  16},
>>> +       {0,                     0}
>>> +};
>>> +
>>> +const struct bayer_fmt all_bayer_rggb[] = {
>>> +       {V4L2_PIX_FMT_SRGGB8,   8},
>>> +       {V4L2_PIX_FMT_SRGGB10P, 10},
>>> +       {V4L2_PIX_FMT_SRGGB12,  12},
>>> +       /* V4L2_PIX_FMT_SRGGB16,        16},*/
>>
>> Why is this commented out? Either uncomment, add a proper comment explaining
>> why
>> or remove it.
> I was developing this against the Pi specific tree, and that is still
> on 4.9 which didn't have several of the 16 bit Bayer formats. I see
> that Sakari has added them (thank you Sakari), so I can uncomment
> them.

does this series work with Linux Mainline (incl. bcm283x dts files)?

In case not, please tell what is missing?

Regards
Stefan
