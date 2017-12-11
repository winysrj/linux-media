Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:51748 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751659AbdLKBdp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 10 Dec 2017 20:33:45 -0500
Subject: Re: [PATCH v8 2/2] media: i2c: Add the ov7740 image sensor driver
To: Philippe Ombredanne <pombredanne@nexb.com>
CC: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>,
        Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE"
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Songjun Wu <songjun.wu@microchip.com>
References: <20171208015542.15444-1-wenyou.yang@microchip.com>
 <20171208015542.15444-3-wenyou.yang@microchip.com>
 <CAOFm3uFASPpuMtGSetcYME0pQEmuzoLqY=Yhv5aaFu5AzJwaew@mail.gmail.com>
From: "Yang, Wenyou" <Wenyou.Yang@Microchip.com>
Message-ID: <d51138eb-0a59-034f-9810-dd72a1690ea2@Microchip.com>
Date: Mon, 11 Dec 2017 09:33:37 +0800
MIME-Version: 1.0
In-Reply-To: <CAOFm3uFASPpuMtGSetcYME0pQEmuzoLqY=Yhv5aaFu5AzJwaew@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philippe,


On 2017/12/8 21:14, Philippe Ombredanne wrote:
> Wenyou,
>
> On Fri, Dec 8, 2017 at 2:55 AM, Wenyou Yang <wenyou.yang@microchip.com> wrote:
>> The ov7740 (color) image sensor is a high performance VGA CMOS
>> image snesor, which supports for output formats: RAW RGB and YUV
>> and image sizes: VGA, and QVGA, CIF and any size smaller.
>>
>> Signed-off-by: Songjun Wu <songjun.wu@microchip.com>
>> Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
> []
>> --- /dev/null
>> +++ b/drivers/media/i2c/ov7740.c
>> @@ -0,0 +1,1226 @@
>> +/*
>> + * Copyright (c) 2017 Microchip Corporation.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License version
>> + * 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
>> + * GNU General Public License for more details.
>> + *
>> + */
> Have you considered using the new SPDX ids instead of this fine legalese?
> e.g.:
>
> // SPDX-License-Identifier: GPL-2.0
> // Copyright (c) 2017 Microchip Corporation.
>
> Short and neat! Check also Thomas doc patches and Linus comments on
> why he prefers the C++ comment style for these.
Thank you for your suggestion and information.


Best Regards,
Wenyou Yang
