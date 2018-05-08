Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:38903 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752088AbeEHNxB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2018 09:53:01 -0400
Received: by mail-wr0-f194.google.com with SMTP id 94-v6so31099928wrf.5
        for <linux-media@vger.kernel.org>; Tue, 08 May 2018 06:53:00 -0700 (PDT)
References: <20180507155655.1555-1-rui.silva@linaro.org> <CAOMZO5APU9CTGukYsQarPCvp=e8P6LgOWbNFx-dhnKM_3UHf+A@mail.gmail.com>
From: Rui Miguel Silva <rui.silva@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: Rui Miguel Silva <rui.silva@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Rob Herring <robh+dt@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        "open list\:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>, Ryan Harkin <ryan.harkin@linaro.org>
Subject: Re: [PATCH 0/4] media: ov2680: follow up from initial version
In-reply-to: <CAOMZO5APU9CTGukYsQarPCvp=e8P6LgOWbNFx-dhnKM_3UHf+A@mail.gmail.com>
Date: Tue, 08 May 2018 14:52:58 +0100
Message-ID: <m3muxa6ypx.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ola Fabio,
On Tue 08 May 2018 at 13:29, Fabio Estevam wrote:
> Hi Rui,
>
> On Mon, May 7, 2018 at 12:56 PM, Rui Miguel Silva 
> <rui.silva@linaro.org> wrote:
>> Sorry I have Out-of-Office some part of last week, I had v6 of 
>> the original
>> series ready but since I have received the notification from 
>> patchwork that the
>> v5 was accepted, I am sending this as a follow up tha address 
>> Fabio comments.
>>
>> - this adds the power supplies to this sensor
>> - fix gpio polarity and naming.
>>
>> Cheers,
>>    Rui
>>
>>
>> Rui Miguel Silva (4):
>>   media: ov2680: dt: add voltage supplies as required
>>   media: ov2680: dt: rename gpio to reset and fix polarity
>>   media: ov2680: rename powerdown gpio and fix polarity
>>   media: ov2680: add regulators to supply control
>
> As the initial ov2680 series has not been applied, I think it 
> would be
> better if you send a new version with all these fixes.

What I've got was this from patchwork:
Hello,

The following patches (submitted by you) have been updated in 
patchwork:

 * linux-media: [v5,1/2] media: ov2680: dt: Add bindings for 
 OV2680
     - http://patchwork.linuxtv.org/patch/48819/
     - for: Linux Media kernel patches
    was: New
    now: Accepted

 * linux-media: [v4,1/2] media: ov2680: dt: Add bindings for 
 OV2680
     - http://patchwork.linuxtv.org/patch/48357/
     - for: Linux Media kernel patches
    was: New
    now: Accepted

This email is a notification only - you do not need to respond.

-

Patches submitted to linux-media@vger.kernel.org have the 
following
possible states:

<snip>

Accepted: when some driver maintainer says that the patch will be 
applied
	  via his tree, or when everything is ok and it got 
	  applied
	  either at the main tree or via some other tree (fixes 
	  tree;
	  some other maintainer's tree - when it belongs to other 
	  subsystems,
	  etc);

So, my understand is that the patches will be applied or are 
already
applied to someone tree (strange patchwork does not send who or 
which
tree), but since I do not want to break someone workflow I will 
wait for
some maintainer word on this... If it is better to send the 
original series
or the follow up patches.

Thanks for your feedback.
---
Cheers,
	Rui
