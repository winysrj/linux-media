Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:44646 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751495AbdLVIqY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Dec 2017 03:46:24 -0500
Received: by mail-wm0-f68.google.com with SMTP id t8so20317611wmc.3
        for <linux-media@vger.kernel.org>; Fri, 22 Dec 2017 00:46:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFLEztTxXRQu-VJ2FzYbA_vkYZtkDur1nQ6goftdZdnbn63aQQ@mail.gmail.com>
References: <1513060095-29588-1-git-send-email-leo.wen@rock-chips.com>
 <1513060095-29588-2-git-send-email-leo.wen@rock-chips.com> <CAFLEztTxXRQu-VJ2FzYbA_vkYZtkDur1nQ6goftdZdnbn63aQQ@mail.gmail.com>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Fri, 22 Dec 2017 09:45:42 +0100
Message-ID: <CAOFm3uGWgYs06NRrrjJSrvDG5ebR_K0y2e_qQeOALMSsNnpXsQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] [media] Add Rockchip RK1608 driver
To: Leo Wen <leo.wen@rock-chips.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rdunlap@infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Eddie Cai <eddie.cai@rock-chips.com>,
        Jacob Chen <jacobchen110@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Leo,

On Fri, Dec 22, 2017 at 5:33 AM, Jacob Chen <jacobchen110@gmail.com> wrote:
> Hi leo,
>
>
> 2017-12-12 14:28 GMT+08:00 Leo Wen <leo.wen@rock-chips.com>:
>> Rk1608 is used as a PreISP to link on Soc, which mainly has two functions.
>> One is to download the firmware of RK1608, and the other is to match the
>> extra sensor such as camera and enable sensor by calling sensor's s_power.
>>
>> use below v4l2-ctl command to capture frames.
>>
>>     v4l2-ctl --verbose -d /dev/video1 --stream-mmap=2
>>     --stream-to=/tmp/stream.out --stream-count=60 --stream-poll
>>
>> use below command to playback the video on your PC.
>>
>>     mplayer ./stream.out -loop 0 -demuxer rawvideo -rawvideo
>>     w=640:h=480:size=$((640*480*3/2)):format=NV12
>>
>> Signed-off-by: Leo Wen <leo.wen@rock-chips.com>

<snip>

>> --- /dev/null
>> +++ b/drivers/media/spi/rk1608.c
>> @@ -0,0 +1,1165 @@
>> +/**
>> + * Rockchip rk1608 driver
>> + *
>> + * Copyright (C) 2017 Rockchip Electronics Co., Ltd.
>> + *
>> + * This software is available to you under a choice of one of two
>> + * licenses.  You may choose to be licensed under the terms of the GNU
>> + * General Public License (GPL) Version 2, available from the file
>> + * COPYING in the main directory of this source tree, or the
>> + * OpenIB.org BSD license below:
>> + *
>> + *     Redistribution and use in source and binary forms, with or
>> + *     without modification, are permitted provided that the following
>> + *     conditions are met:
>> + *
>> + *      - Redistributions of source code must retain the above
>> + *        copyright notice, this list of conditions and the following
>> + *        disclaimer.
>> + *
>> + *      - Redistributions in binary form must reproduce the above
>> + *        copyright notice, this list of conditions and the following
>> + *        disclaimer in the documentation and/or other materials
>> + *        provided with the distribution.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>> + * SOFTWARE.
>> + */

Have you considered using the new SPDX tags instead of this fine but
long legalese?
I know what you are about to say: everyone loves legalese so much that
it is hard to let go of so much of it and replace all this only with a
single SPDX tag line ;)
But then everyone loves code much more than legalese too! so you would
be making the world a service anyway.

And if other contributors in your team could follow suit and you could
spread the word that would be even better!

See Thomas doc patches [1] for details.

[1] https://lkml.org/lkml/2017/12/4/934

-- 
Cordially
Philippe Ombredanne
