Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36609 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbcFURRr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2016 13:17:47 -0400
Received: by mail-pa0-f53.google.com with SMTP id wo6so8096523pac.3
        for <linux-media@vger.kernel.org>; Tue, 21 Jun 2016 10:17:32 -0700 (PDT)
Subject: Re: [19/38] ARM: dts: imx6-sabrelite: add video capture ports and
 connections
To: Jack Mitchell <ml@embed.me.uk>,
	Gary Bisson <gary.bisson@boundarydevices.com>
References: <1465944574-15745-20-git-send-email-steve_longerbeam@mentor.com>
 <20160616083231.GA6548@t450s.lan> <20160617151814.GA16378@t450s.lan>
 <57644915.3010006@gmail.com> <20160620093351.GA24310@t450s.lan>
 <d9bd2b49-e36b-6082-e31a-99d6c8c70b2c@embed.me.uk>
 <20160620101603.GA817@t450s.lan>
 <92b3d1fc-1e4d-db42-625b-4751fcb3ff10@embed.me.uk>
Cc: linux-media@vger.kernel.org
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <576976A4.2090406@gmail.com>
Date: Tue, 21 Jun 2016 10:17:24 -0700
MIME-Version: 1.0
In-Reply-To: <92b3d1fc-1e4d-db42-625b-4751fcb3ff10@embed.me.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/20/2016 03:44 AM, Jack Mitchell wrote:
>
>
> On 20/06/16 11:16, Gary Bisson wrote:
>> Jack, All,
>>
>> On Mon, Jun 20, 2016 at 10:44:44AM +0100, Jack Mitchell wrote:
>>> <snip>
>>>> I've tried that patch have a some comments:
>>>> - When applied, no capture shows up any more, instead I have two m2m
>>>>   v4l2 devices [1].
>>>> - OV5640 Mipi is assigned the same address as OV5642, therefore both
>>>
>>> Yes, I only have one device attached in my scenario.
>>
>> Thanks for confirming.
>>
>>>>   can't work at the same time right now. There's a register in the
>>>>   camera that allows to modify its I2C address, see this patch [2].
>>>> - How is the mclk working in this patch? It should be using the PWM3
>>>
>>> As mentioned I have an eCon sensor board [1] which generates it's own clock
>>> on the board and as such I don't need the PWM signal, just the two GPIOs.
>>
>> Oh ok, thanks I didn't this sensor board was different than ours [1].
>>
>> But in your patch, you specifically disable pwm3, what's the reason for
>> it?
>
> Yes, it uses the GPIO on the PWM3 pin (beats me why...) so I had to specifically disable it to stop the pin muxing clash.
>

Hi Jack, in your patch, the PWM3 pin (which is SD1_DAT1 operating as GPIO1_IO17)
is being used as the power-down pin for your OV5640 board.

Anyway, I didn't realize this was a different camera from the boundary-devices
module (https://boundarydevices.com/product/nit6x_5mp_mipi/).

I would like to add support in the DT for the BD module, but I am unable to test/debug
as I don't have one. I'm wondering if someone could lend me one, along with the
schematics. I have the OV5642 parallel interface module for the SabreLite, so I'd love
to get my hands on the OV5640 mipi module as that would allow testing of multiple
camera capture which I've never been able to do before.

In the meantime I am going to omit support for this module in the sabrelite DT (there's
also the problem of the i2c bus address conflict on the same i2c2 bus with the ov5642).

Or if someone can add support for the BD module later that would be great.


Steve

>>
>>>>   output to generate a ~22MHz clock. I would expect the use of a
>>>>   pwm-clock node [3].
>>>>
>>>> Also another remark on both OV5642 and OV5640 patches, is it recommended
>>>> to use 0x80000000 pin muxing value? This leaves it to the bootloader to
>>>
>>> I also wondered about this, but didn't know if the pinmux driver did this
>>> based on the define name? I tried it both ways and it worked so I just left
>>> it as it was.
>>
>> Actually my phrasing is wrong, the muxing is ok. Yes depending on the
>> name a pin will be muxed to one function or another. The problem is the
>> pad configuration (pull-up, pull-down etc..). I am not surprised that it
>> works, because the bootloader should properly set those. But it would be
>> safer IMO not to rely on it.
>
> Ah ok, makes sense.
>
>>
>> Regards,
>> Gary
>>
>> [1] https://boundarydevices.com/product/nit6x_5mp_mipi/
>>

