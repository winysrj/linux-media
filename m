Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx-001.topalis.com ([195.243.109.4]:10349 "EHLO
	mx-001.topalis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab0GQPS3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jul 2010 11:18:29 -0400
Message-ID: <4C41C9C3.9040506@topalis.com>
Date: Sat, 17 Jul 2010 17:18:27 +0200
From: Michael Kromer <michael.kromer@topalis.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Pete Eberlein <pete@sensoray.com>, linux-media@vger.kernel.org
Subject: Re: Chicony Electronics 04f2:b1b4 webcam device unsupported (yet)
References: <OF56E589E0.BB18B6B2-ONC1257762.005AE925-C1257762.005AE95B@topalis.com> <201007171057.27325.laurent.pinchart@ideasonboard.com> <4C41AF34.8060406@topalis.com> <201007171700.48576.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201007171700.48576.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Am 17.07.2010 17:00, schrieb Laurent Pinchart:
> Hi Michael,
> 
> On Saturday 17 July 2010 15:25:08 Michael Kromer wrote:
>> Am 17.07.2010 10:57, schrieb Laurent Pinchart:
>>> On Saturday 17 July 2010 10:34:20 Michael Kromer wrote:
>>>> On 07/16/2010 07:14 PM, Pete Eberlein wrote:
>>>>> On Fri, 2010-07-16 at 18:32 +0200, Michael Kromer wrote:
>>>>>> I have bought myself a rather new Lenovo Thinkpad X100e, and there is
>>>>>> no support for the webcam device in the current (2.6.34) kernel
>>>>>> (yet). 2.6.35 doesn't seem to have a driver for it either. Is there
>>>>>> any possibility for one of you guys to take a look at it?
>>>>>
>>>>> The descriptors look like a standard USB Video Class device.  Do you
>>>>> have the uvcvideo module loaded?  Then have a look at your dmesg output
>>>>> to see why it isn't working.
>>>>
>>>> my problem is:
>>>>
>>>> [ 2578.903972] uvcvideo: Found UVC 1.00 device Integrated Camera
>>>> (04f2:b1b4) [ 2578.905121] input: Integrated Camera as
>>>> /devices/pci0000:00/0000:00:13.2/usb2/2-2/2-2:1.0/input/input10
>>>> [ 2578.905224] usbcore: registered new interface driver uvcvideo
>>>> [ 2578.905228] USB Video Class driver (v0.1.0)
>>>>
>>>> It is indeed registred as video device, however, everytime i use some
>>>> program (i tried cheese) to use /dev/video0 I get the following:
>>>>
>>>> [ 2741.757993] uvcvideo: Failed to query (130) UVC control 5 (unit 3) :
>>>> -32 (exp. 1).
>>>
>>> Could you please send me the output of
>>>
>>> lsusb -v -d 04f2:b1b4
>>
>> Bus 002 Device 003: ID 04f2:b1b4 Chicony Electronics Co., Ltd
> 
> [snip]
> 
> Thanks. You're the second one in a few weeks to report a bug that has been 
> there for years. Could you please try the following patch ? It should end up 
> in the mainline kernel in 2.6.36 (2.6.35 might be possible, depending on when 
> Mauro comes back from holidays).
> 
> http://git.linuxtv.org/v4l-
> dvb.git?a=commitdiff;h=9c3b10b53875279306d8464fe9b24fa634329fc8;hp=f06b9bd4c62ef93f9467a1432acf2efa84aa3456

I've been looking at this issue as well, and have already seen the patch
you mentioned:

https://patchwork.kernel.org/patch/110187/

However, this problem didn't change anything - same error.

If it helps, I can provide you with an SSH session if this helps, so you
could investigate the problem directly.

- mike
