Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f179.google.com ([209.85.213.179]:34857 "EHLO
        mail-yb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751392AbdFHLyK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 07:54:10 -0400
Received: by mail-yb0-f179.google.com with SMTP id f192so8945559yba.2
        for <linux-media@vger.kernel.org>; Thu, 08 Jun 2017 04:54:10 -0700 (PDT)
Received: from mail-yw0-f170.google.com (mail-yw0-f170.google.com. [209.85.161.170])
        by smtp.gmail.com with ESMTPSA id f66sm1910499ywh.47.2017.06.08.04.54.07
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Jun 2017 04:54:07 -0700 (PDT)
Received: by mail-yw0-f170.google.com with SMTP id l75so11919417ywc.3
        for <linux-media@vger.kernel.org>; Thu, 08 Jun 2017 04:54:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <17c4779b-1064-5e89-4f4c-b071e27f5f72@soulik.info>
References: <2890f845-eef2-5689-f154-fc76ae6abc8b@st.com> <816ba2d8-f1e7-ce34-3524-b2a3f1bf3d74@xs4all.nl>
 <fb4a4815-e1ff-081e-787a-0213e32a5405@st.com> <8f93f4f2df49431cb2750963c2f7b168@SFHDAG5NODE2.st.com>
 <48b04997-bd80-5640-4272-2c4d69c25a97@st.com> <CACHYQ-pb9tRaWq9c0h7OXTmpUVH16i3d6-8B_Y+YSzAqWGPEqA@mail.gmail.com>
 <CAPBb6MWtOaOKm5aaRTx2afFW=NOBk_NZz6-d2JiUS2DtXaW_EQ@mail.gmail.com>
 <c0dfd7fb-112a-a395-452d-5bc15e1edb06@xs4all.nl> <17c4779b-1064-5e89-4f4c-b071e27f5f72@soulik.info>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 8 Jun 2017 20:53:46 +0900
Message-ID: <CAAFQd5Dj42eZz=xvwWJUpwqLgrQMN360pgUaqwPLZxemNxm05Q@mail.gmail.com>
Subject: Re: [RFC] V4L2 unified low-level decoder API
To: ayaka <ayaka@soulik.info>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Alexandre Courbot <acourbot@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        Hugues FRUCHET <hugues.fruchet@st.com>,
        "florent.revest@free-electrons.com"
        <florent.revest@free-electrons.com>,
        "jung.zhao@rock-chips.com" <jung.zhao@rock-chips.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 8, 2017 at 8:11 PM, ayaka <ayaka@soulik.info> wrote:
>
>
> On 06/08/2017 06:56 PM, Hans Verkuil wrote:
>>
>> Hi Alexandre,
>>
>> On 08/06/17 11:59, Alexandre Courbot wrote:
>>>
>>> On Thu, Jun 8, 2017 at 5:56 PM, Pawel Osciak <posciak@chromium.org>
>>> wrote:
>>>>
>>>> Hi,
>>>>
>>>> On Fri, May 19, 2017 at 1:08 AM, Hugues FRUCHET <hugues.fruchet@st.com>
>>>> wrote:
>>>>>
>>>>> Before merging this work Hans would like to have feedback from peers,
>>>>> in
>>>>> order to be sure that this is inline with other SoC vendors drivers
>>>>> expectations.
>>>>>
>>>>> Thomasz, Pawel, could you give your view regarding ChromeOS and
>>>>> Rockchip
>>>>> driver ?
>>>>
>>>> The drivers for Rockchip codecs are submitted to the public Chromium OS
>>>> kernel
>>>> and working on our RK-based platforms. We have also since added a VP9
>>>> API as
>
> That driver still lacks a number of feature comparing to the rockchip
> android driver, since google never requests them. Also the performance is
> not as good as the android one.

I'm not sure exactly what features or performance problems you're
mentioning, but that's not the point. It's a reasonably simple driver
without too much complexity, written with good V4L2 codec API
compliance in mind and proven in the industry. I see it as a good
starting point.

> That is why I start to write a new driver myself.

I think it would make sense to work on incrementally adding those
missing features and performance optimizations, instead of spending
time on unnecessary effort of doing the same basic work, which is
already done in our driver.

> Also the rockchip platform is very complex, that driver won't be work on all
> the SoCs without a large of modification(now only two chips are supported)

This is another story. The rockchip-vpu driver in ChromeOS 4.4 should
be actually refactored into generic V4L2 stateless codec helpers (most
of the shared code in current driver) + few separate drivers using
those helpers, one for each physical IP block. Current design is there
only because we thought there is more similarity between those IP
blocks and we didn't have more time to actually clean it up later,
after we realized that the assumption was false.

Best regards,
Tomasz
