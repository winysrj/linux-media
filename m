Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.135]:53792 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967321AbeCAKOs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2018 05:14:48 -0500
Reply-To: zhengsq@rock-chips.com
Subject: Re: [PATCH] media: ov2685: Not delay latch for gain
To: Tomasz Figa <tfiga@chromium.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <1519893856-4738-1-git-send-email-zhengsq@rock-chips.com>
 <CAAFQd5AteVDQgHaov2Jqjbx5bAjmJJiXv-7R0HG+AcE3GH-JTw@mail.gmail.com>
From: Shunqian Zheng <zhengsq@rock-chips.com>
Message-ID: <d91922a4-656a-1998-6176-592f343aee5a@rock-chips.com>
Date: Thu, 1 Mar 2018 18:14:40 +0800
MIME-Version: 1.0
In-Reply-To: <CAAFQd5AteVDQgHaov2Jqjbx5bAjmJJiXv-7R0HG+AcE3GH-JTw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,


On 2018年03月01日 16:53, Tomasz Figa wrote:
> Hi Shunqian,
>
> On Thu, Mar 1, 2018 at 5:44 PM, Shunqian Zheng <zhengsq@rock-chips.com> wrote:
>> Update the register 0x3503 to use 'no delay latch' for gain.
>> This makes sensor to output the first frame as normal rather
>> than a very dark one.
> I'm not 100% sure on how this setting works, but wouldn't it mean that
> setting the gain mid-frame would result in half of the frame having
> old gain and another half new? Depending how this works, perhaps we
> should set this during initial register settings, but reset after
> streaming starts?
Thank you.

I'm not quite sure too. Then I try to change gain during capture by:
    capture_10_frames.sh & while sleep .01; do v4l2-ctl -d /dev/video4 
--set-ctrl=analogue_gain=54; sleep .01; v4l2-ctl -d /dev/video4 
--set-ctrl=analogue_gain=1024; done

The gain setting takes effect for every single frame, not in mid-frame 
from my test.

Best wishes,
- Shunqian
>
> Best regards,
> Tomasz
>
>
>
