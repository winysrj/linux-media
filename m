Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935536Ab3DPRgg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 13:36:36 -0400
Message-ID: <516D8C1E.2080704@redhat.com>
Date: Tue, 16 Apr 2013 14:36:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v3.10] Camera sensors patches
References: <3775187.HOcoQVPfEE@avalon> <8085333.TIMqcSUBaO@avalon> <20130415094248.2272db90@redhat.com> <1471330.zeTIWizKy8@avalon>
In-Reply-To: <1471330.zeTIWizKy8@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 16-04-2013 12:30, Laurent Pinchart escreveu:
> Hi Mauro,
>
> On Monday 15 April 2013 09:42:48 Mauro Carvalho Chehab wrote:
>> Em Mon, 15 Apr 2013 12:19:23 +0200 Laurent Pinchart escreveu:
>>> On Sunday 14 April 2013 16:59:58 Mauro Carvalho Chehab wrote:
>>>> Em Fri, 12 Apr 2013 11:13:06 +0200 Laurent Pinchart escreveu:
>>>>> Hi Mauro,
>>>>>
>>>>> The following changes since commit
>>>
>>> 81e096c8ac6a064854c2157e0bf802dc4906678c:
>>>>>    [media] budget: Add support for Philips Semi Sylt PCI ref. design
>>>>>
>>>>> (2013-04-08 07:28:01 -0300)
>>>>>
>>>>> are available in the git repository at:
>>>>>    git://linuxtv.org/pinchartl/media.git sensors/next
>>>>>
>>>>> for you to fetch changes up to
> c890926a06339944790c5c265e21e8547aa55e49:
>>>>>    mt9p031: Use the common clock framework (2013-04-12 11:07:07 +0200)
>>>>>
>>>>> ----------------------------------------------------------------
>>>>>
>>>>> Laurent Pinchart (5):
>>>>>        mt9m032: Fix PLL setup
>>>>>        mt9m032: Define MT9M032_READ_MODE1 bits
>>>>>        mt9p031: Use devm_* managed helpers
>>>>>        mt9p031: Add support for regulators
>>>>>        mt9p031: Use the common clock framework
>>>>
>>>> Hmm... It seems ugly to have regulators and clock framework and other
>>>> SoC calls inside an i2c driver that can be used by a device that doesn't
>>>> have regulators.
>>>>
>>>> I'm not sure what's the best solution for it, so, I'll be adding those
>>>> two patches, but it seems that we'll need to restrict the usage of those
>>>> calls only if the caller driver is a platform driver.
>>>
>>> The MT9P031 needs power supplies and a clock on all platforms, regardless
>>> of the bridge bus type.
>>
>> Well, all digital devices require clock and power. If power is either a
>> simple electric circuit, a battery or a regulator, that depends on the
>> board.
>>
>>> I suppose the use case that mostly concerns you here is
>>> USB webcams
>>
>> Yes.
>>
>>> where the power supplies and the clock are controlled automatically by the
>>> device.
>>
>> Or could be not controlled at all. It could be a simple XTAL attached to the
>> sensor or a clock signal provided by the bridge obtained from a fixed XTAL,
>> and a resistor bridge or a Zenner diode providing the needed power voltage.
>>
>>> If we ever need to support such a device in the future we can of course
>>> revisit the driver then, and one possible solution would be to register
>>> fixed voltage regulators and a fixed clock.
>>
>> That is an overkill: devices were the power supply/xtal clock can't be
>> controlled should not require extra software that pretend to control it.
>
> If I'm not mistaken that's however the recommended way on embedded devices at
> the moment. I don't have a strong opinion on the subject for now, but this
> will need to be at least discussed with core clock and regulator developers.


Well, a customer's webcam is not an embedded device at all. That's why
I think that putting it at the I2C driver is wrong: those drivers are
not to be used only by embedded hardware.

Regards,
Mauro

>

