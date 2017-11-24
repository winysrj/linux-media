Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:37316 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752619AbdKXN5y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 08:57:54 -0500
MIME-Version: 1.0
In-Reply-To: <861b94c4-9ee2-322a-19de-17c7c866faf3@xs4all.nl>
References: <20171026181942.9516-1-phh@phh.me> <75adf743-18a2-2c55-b4bb-95d83bd26f03@xs4all.nl>
 <0cf328e7-772b-f634-e1b1-6653b513f2ec@codeaurora.org> <861b94c4-9ee2-322a-19de-17c7c866faf3@xs4all.nl>
From: Pierre-Hugues Husson <phh@phh.me>
Date: Fri, 24 Nov 2017 14:57:33 +0100
Message-ID: <CAJ-oXjQgf7EBuxx84uG0heY3ebxc23GV4KRh=CuNM8eEALVqqQ@mail.gmail.com>
Subject: Re: [PATCH v3] drm: bridge: synopsys/dw-hdmi: Enable cec clock
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Archit Taneja <architt@codeaurora.org>,
        linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-media <linux-media@vger.kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrzej Hajda <a.hajda@samsung.com>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

>> On 11/20/2017 06:00 PM, Hans Verkuil wrote:
>>> I didn't see this merged for 4.15, is it too late to include this?
>>> All other changes needed to get CEC to work on rk3288 and rk3399 are all merged.
>>
>> Sorry for the late reply. I was out last week.
>>
>> Dave recently sent the second pull request for 4.15, so I think it would be hard to get it
>> in the merge window now. We could target it for the 4.15-rcs since it is preventing the
>> feature from working. Is it possible to rephrase the commit message a bit so that it's clear
>> that we need it for CEC to work?
>
> While it is not my patch I would propose something like this:
>
> "Support the "cec" optional clock. The documentation already mentions "cec"
> optional clock and it is used by several boards, but currently the driver
> doesn't enable it, thus preventing cec from working on those boards.
>
> And even worse: a /dev/cecX device will appear for those boards, but it
> won't be functioning without configuring this clock."
>
> I hadn't realized that last sentence until I started thinking about it,
> but this patch is really needed.
This change looks good to me.

Archit, I can send this as a new version of the patch tomorrow if you need it.

Regards,
