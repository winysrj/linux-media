Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:35653 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753077AbeDPSo2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 14:44:28 -0400
Received: by mail-pf0-f169.google.com with SMTP id j5so1422594pfh.2
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 11:44:27 -0700 (PDT)
Subject: Re: OV5640 with 12MHz xclk
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        linux-media@vger.kernel.org
References: <CAFwsNOEF0rK+SeHQ618Rnuj2ZWaGZG2WY4keWmavqG_agSi+dw@mail.gmail.com>
 <4d87c28b-4adb-86d6-986b-e1ffdceb3138@xs4all.nl>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <9b255c35-f163-7db9-a7a8-88c1ac2ceeb1@gmail.com>
Date: Mon, 16 Apr 2018 11:44:20 -0700
MIME-Version: 1.0
In-Reply-To: <4d87c28b-4adb-86d6-986b-e1ffdceb3138@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sam,

On 04/16/2018 05:26 AM, Hans Verkuil wrote:
> On 04/16/2018 03:39 AM, Samuel Bobrowicz wrote:
>> Can anyone verify if the OV5640 driver works with input clocks other
>> than the typical 24MHz? The driver suggests anything from 6MHz-24MHz
>> is acceptable, but I am running into issues while bringing up a module
>> that uses a 12MHz oscillator. I'd expect that different xclk's would
>> necessitate different register settings for the various resolutions
>> (PLL settings, PCLK width, etc.), however the driver does not seem to
>> modify nearly enough based on the frequency of xclk.
>>
>> Sam
>>
> I'm pretty sure it has never been tested with 12 MHz. The i.MX SabreLite
> seems to use 22 MHz, and I can't tell from the code what the SabreSD uses
> (probably 22 or 24 MHz). Steve will probably know.

On i.MX6, the sabrelite uses the PWM3 clock at 22MHz for the OV5640 xclk.
The SabreSD uses the i.MX6 CKO clock, which is default sourced from the
24 MHz oscillator.

I wouldn't be surprised that there are issues with a 12MHz xclk in the
ov5640 driver. There's probably some assumptions made about the
xclk range in the hardcoded values in those huge register tables. Sorry
I don't have the time to look into it more.

Steve
