Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:33382 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752221AbeDPXDR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 19:03:17 -0400
Received: by mail-it0-f50.google.com with SMTP id x144-v6so13091074itc.0
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 16:03:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9b255c35-f163-7db9-a7a8-88c1ac2ceeb1@gmail.com>
References: <CAFwsNOEF0rK+SeHQ618Rnuj2ZWaGZG2WY4keWmavqG_agSi+dw@mail.gmail.com>
 <4d87c28b-4adb-86d6-986b-e1ffdceb3138@xs4all.nl> <9b255c35-f163-7db9-a7a8-88c1ac2ceeb1@gmail.com>
From: Samuel Bobrowicz <sam@elite-embedded.com>
Date: Mon, 16 Apr 2018 16:03:16 -0700
Message-ID: <CAFwsNOE3bcGCmQ5VUYWMG28dxr9P9=cmi3VMrcXyb4gVTntA2A@mail.gmail.com>
Subject: Re: OV5640 with 12MHz xclk
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks all, that's what I was expecting. It clears some things up.

I'm going to check out Maxime's recent patches and see if those do the
trick, otherwise I'll get cracking on some patches myself.

Sam
-----------------------
Sam Bobrowicz
Elite Embedded Consulting LLC
elite-embedded.com


On Mon, Apr 16, 2018 at 11:44 AM, Steve Longerbeam
<slongerbeam@gmail.com> wrote:
> Hi Sam,
>
> On 04/16/2018 05:26 AM, Hans Verkuil wrote:
>>
>> On 04/16/2018 03:39 AM, Samuel Bobrowicz wrote:
>>>
>>> Can anyone verify if the OV5640 driver works with input clocks other
>>> than the typical 24MHz? The driver suggests anything from 6MHz-24MHz
>>> is acceptable, but I am running into issues while bringing up a module
>>> that uses a 12MHz oscillator. I'd expect that different xclk's would
>>> necessitate different register settings for the various resolutions
>>> (PLL settings, PCLK width, etc.), however the driver does not seem to
>>> modify nearly enough based on the frequency of xclk.
>>>
>>> Sam
>>>
>> I'm pretty sure it has never been tested with 12 MHz. The i.MX SabreLite
>> seems to use 22 MHz, and I can't tell from the code what the SabreSD uses
>> (probably 22 or 24 MHz). Steve will probably know.
>
>
> On i.MX6, the sabrelite uses the PWM3 clock at 22MHz for the OV5640 xclk.
> The SabreSD uses the i.MX6 CKO clock, which is default sourced from the
> 24 MHz oscillator.
>
> I wouldn't be surprised that there are issues with a 12MHz xclk in the
> ov5640 driver. There's probably some assumptions made about the
> xclk range in the hardcoded values in those huge register tables. Sorry
> I don't have the time to look into it more.
>
> Steve
>
