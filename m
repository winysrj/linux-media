Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:46887 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752078AbdLHBGF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Dec 2017 20:06:05 -0500
Subject: Re: [PATCH 0/9] media: imx: Add better OF graph support
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1509223009-6392-1-git-send-email-steve_longerbeam@mentor.com>
 <c20882c4-8a61-c2b1-6664-171f9bfbcaa6@xs4all.nl>
 <8feaf7ed-17f1-18bb-fa1f-2532fda8f829@gmail.com>
Message-ID: <c1a67ce0-301a-3028-58f0-293235b88f97@gmail.com>
Date: Thu, 7 Dec 2017 17:05:56 -0800
MIME-Version: 1.0
In-Reply-To: <8feaf7ed-17f1-18bb-fa1f-2532fda8f829@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 12/07/2017 03:23 PM, Steve Longerbeam wrote:
> Hi Hans,
>
>
> On 12/04/2017 05:44 AM, Hans Verkuil wrote:
>
> <snip>
>>
>> Of course, any such simplification can also be done after this series 
>> has
>> been applied, but I don't know what your thoughts are on this.
>
> I do prefer the sub-notifier approach to discovering fwnodes, so yes I 
> would
> like to switch to this.
>
> Since it is a distinct change (using sub-notifiers instead of 
> recursive graph
> walk), I would prefer to get this series applied first, and then 
> switch to
> sub-notifiers as distinct patches afterwards.
>
> Let me submit a v2 of this series first however. There are some minor 
> changes I
> would like to make so that the up-coming sub-notifier patches are 
> cleaner.
>

Hans,

Never mind, the sub-notifier patches should be fairly clean. I won't 
submit a
v2 of this series unless it is requested by reviewers.

Steve
