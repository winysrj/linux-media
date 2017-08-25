Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:32969 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932602AbdHYO5X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 10:57:23 -0400
MIME-Version: 1.0
In-Reply-To: <fe2c1de6-dd6c-378f-8a1e-d790807310b1@xs4all.nl>
References: <1501737812-24171-1-git-send-email-jacob-chen@iotwrt.com> <fe2c1de6-dd6c-378f-8a1e-d790807310b1@xs4all.nl>
From: Jacob Chen <jacobchen110@gmail.com>
Date: Fri, 25 Aug 2017 22:57:21 +0800
Message-ID: <CAFLEztQOyOxqPajzwANr7cG-EGqv813Wad3weeMGBB1BNNT2Ag@mail.gmail.com>
Subject: Re: [PATCH v7] rockchip/rga: v4l2 m2m support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        laurent.pinchart+renesas@ideasonboard.com,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

2017-08-21 22:16 GMT+08:00 Hans Verkuil <hverkuil@xs4all.nl>:
> Hi Jacob,
>
> On 08/03/2017 07:23 AM, Jacob Chen wrote:
>> Rockchip RGA is a separate 2D raster graphic acceleration unit. It
>> accelerates 2D graphics operations, such as point/line drawing, image
>> scaling, rotation, BitBLT, alpha blending and image blur/sharpness
>>
>> The drvier is mostly based on s5p-g2d v4l2 m2m driver
>> And supports various operations from the rendering pipeline.
>>  - copy
>>  - fast solid color fill
>>  - rotation
>>  - flip
>>  - alpha blending
>>
>> The code in rga-hw.c is used to configure regs according to operations
>> The code in rga-buf.c is used to create private mmu table for RGA.
>>
>> changes in V7:
>> - fix some warning reported by "checkpatch --strict"
>>
>> Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
>
> Can you post the v4l2-compliance output? I gather that there is at least one
> colorspace-related error that appears to be a v4l2-compliance bug, so I'd
> like to see the exact error it gives. I'll see if I can fix it so this driver
> has a clean compliance output.
>

OK, i will post it.

> I apologize that this driver probably won't make 4.14. Too much to review...
>

It doesn't matter,
I'm still writing the userspace for this driver ,
At peresent this driver might have a lot of bugs, since i didn't test
it much in production environment .

> I hope to do the v7 review within a week.
>
> Regards,
>
>         Hans
