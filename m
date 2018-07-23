Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:47024 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388652AbeGWR5G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 13:57:06 -0400
Subject: Re: [PATCH 16/16] media: imx: add mem2mem device
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        <linux-media@vger.kernel.org>
CC: <kernel@pengutronix.de>
References: <20180622155217.29302-1-p.zabel@pengutronix.de>
 <20180622155217.29302-17-p.zabel@pengutronix.de>
 <8b4ea4ab-0500-9daa-e6e1-031e7d7a0517@mentor.com>
 <1531750331.18173.21.camel@pengutronix.de>
 <0d10c8dc-1406-1ba6-f615-d60ae9c20c58@gmail.com>
 <1532331117.3501.2.camel@pengutronix.de>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <4605540f-5050-87b0-d938-2d2822b3ed73@mentor.com>
Date: Mon, 23 Jul 2018 09:54:53 -0700
MIME-Version: 1.0
In-Reply-To: <1532331117.3501.2.camel@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/23/2018 12:31 AM, Philipp Zabel wrote:
>>>
>>> ipu_image_convert_adjust tries to adjust both input and output image at
>>> the same time, here we just have the format of either input or output
>>> image. Do you suggest to split this function into an input and an output
>>> version?
>> See b4362162c0 ("media: imx: mem2mem: Use ipu_image_convert_adjust
>> in try format")
> Alright, this looks fine to me. I was worried about inter-format
> limitations, but the only one seems to be the output size lower bound to
> 1/4 of the input size. Should S_FMT(OUT) also update the capture format
> if adjustments were made to keep a consistent state?

That's a good question, I don't know if the mem2mem API allows for
that, but if it does we should do that for consistent state as you said.

In b4362162c0, the current capture format is used to adjust output
format during S_FMT(OUT) but any capture format changes are
dropped, and vice-versa.

Steve
