Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f49.google.com ([209.85.208.49]:41776 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732956AbeHNTjH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 15:39:07 -0400
Received: by mail-ed1-f49.google.com with SMTP id s24-v6so10449274edr.8
        for <linux-media@vger.kernel.org>; Tue, 14 Aug 2018 09:51:11 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] media: i2c: ov5640: Re-work MIPI startup sequence
To: jacopo mondi <jacopo@jmondi.org>,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        maxime.ripard@bootlin.com, sam@elite-embedded.com,
        jagan@amarulasolutions.com, festevam@gmail.com, pza@pengutronix.de,
        hugues.fruchet@st.com, loic.poulain@linaro.org, daniel@zonque.org,
        linux-media@vger.kernel.org
References: <1531247768-15362-1-git-send-email-jacopo@jmondi.org>
 <e9057214-2e1a-df78-8983-c63c80448cb1@mentor.com>
 <20180711072148.GH8180@w540> <bc50c3d7-d6ba-e73f-6156-341e1ce3099a@gmail.com>
 <b1369576-2193-bc57-0716-ca08098a2eca@gmail.com>
 <71f4b589-2c82-7e87-22fe-8b6373947b13@gmail.com> <20180716082929.GM8180@w540>
 <71bc3ff6-8db2-af63-f9af-72696f7d075c@gmail.com>
 <20180814153559.GA16428@w540>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <cd3e2e96-0968-99cd-1417-05ffdd771341@gmail.com>
Date: Tue, 14 Aug 2018 09:51:04 -0700
MIME-Version: 1.0
In-Reply-To: <20180814153559.GA16428@w540>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,


On 08/14/2018 08:35 AM, jacopo mondi wrote:
> Hi Steve,
>     sorry for resurecting this.
>
> <snip>
>>> I'm sorry I'm not sur I'm following. Does this mean that with that bug
>>> you are referring to up here fixed by my last patch you have capture
>>> working?
>> No, capture still not working for me on SabreSD, even after fixing
>> the bug in 476dec0 "media: ov5640: Add horizontal and vertical totals",
>> by either using your patchset, or by running version 476dec0 of ov5640.c
>> with the call to ov5640_set_timings() moved to the correct places as
>> described below.
>>
> I've been reported a bug on exposure handling that makes the first
> captured frames all black. Both me and Hugues have tried to fix the
> issue (him with a more complete series, but that's another topic).
> See [1] and [2]
>
> It might be possible that you're getting blank frames with this series
> applied? I never seen them as I'm skipping the first frames when
> capturing, but I've now tested and without the exposure fixes (either
> [1] or [2]) I actually have blank frames.
>
> If that's the case for you too (which I hope so much) would you be
> available to test again this series with exposure fixes on top?
> On my platform that actually makes all frames correct.
>
> Thanks
>     j
>
> [1] [PATCH 0/2] media: ov5640: Fix set_timings and auto-exposure
> [2] [PATCH v2 0/5] Fix OV5640 exposure & gain
>

It's not clear to me which patch sets you would like me to test.
Just [1] and [2], or [1], [2], and "media: i2c: ov5640: Re-work MIPI 
startup sequence"?

Steve
