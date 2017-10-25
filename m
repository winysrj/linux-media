Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:34620 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750747AbdJYMSZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Oct 2017 08:18:25 -0400
Subject: Re: [PATCH v4 04/21] doc: media/v4l-drivers: Add Qualcomm Camera
 Subsystem driver document
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, s.nawrocki@samsung.com,
        sakari.ailus@iki.fi, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
 <1502199018-28250-5-git-send-email-todor.tomov@linaro.org>
 <de3c02a1-5c04-977d-fd51-186a5d39c32a@zonque.org>
 <7483f716-4240-899f-f9c5-23c6408f39ff@linaro.org>
 <bfd290f4-4fb7-40b0-2d58-8b2a04a9aeca@zonque.org>
 <3c042974-4118-957b-c9e8-411b30ed5909@linaro.org>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <bd38c9fb-d42a-ed1c-dee2-52eb35788c0c@zonque.org>
Date: Wed, 25 Oct 2017 14:18:22 +0200
MIME-Version: 1.0
In-Reply-To: <3c042974-4118-957b-c9e8-411b30ed5909@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On Wednesday, October 25, 2017 02:07 PM, Todor Tomov wrote:
> On 16.10.2017 18:01, Daniel Mack wrote:
>> I'd be grateful for any pointer about what I could investigate on.
>>
> 
> Everything that you have described seems correct.
> 
> As you say that frames do not contain any data, do
> VFE_0_IRQ_STATUS_0_IMAGE_MASTER_n_PING_PONG
> fire at all or not?
> 
> Do you see any interrupts on the ISPIF? Which?
> 
> Could you please share what hardware setup you have - mezzanine and camera module.

Thanks for your reply!

I now got it working, at least as far as camss is concerned. I can
confirm the camss driver is working for 4 lanes, and that the DTS
settings described above are correct.

Some of the problems I had were related to the sensor driver reporting
wrong clock values, which in turn caused camss to not configure its
hardware clocks correctly.

Linux userspace does not seem to be prepared for Bayer 10bit packed
formats at all however, but that's out of scope for this list I guess.



Thanks again!
Daniel
