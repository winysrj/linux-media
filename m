Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab1K2Lvk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 06:51:40 -0500
Message-ID: <4ED4C745.1060002@redhat.com>
Date: Tue, 29 Nov 2011 12:51:33 +0100
From: "Fabio M. Di Nitto" <fdinitto@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "Fabio M. Di Nitto" <fdinitto@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	Stefan Ringel <linuxtv@stefanringel.de>,
	Dmitri Belimov <d.belimov@gmail.com>
Subject: Re: HVR-900H dvb-t regression(s)
References: <4ED39D88.507@redhat.com> <4ED3F81F.303@redhat.com> <4ED4655F.5050905@redhat.com> <4ED4C39C.2090209@redhat.com>
In-Reply-To: <4ED4C39C.2090209@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/29/2011 12:35 PM, Mauro Carvalho Chehab wrote:
> On 29-11-2011 02:53, Fabio M. Di Nitto wrote:

>>> [ 7867.776612] tm6000: Found Generic tm6010 board
>>> [ 7867.841177] tm6000 #1: i2c eeprom 00: 00 00 00 00 00 00 00 00 00 00
>>> 00 00 00 00 00 00  ................
>> [SNIP]
>>> [ 7869.707769] Device has eeprom but is currently unknown
>>>
>>> and the device will be miss-detected.
>>
>> I don't think this was ever the case, but I can easily check the dmesg
>> output that I collected.
> 
> This may affect your bisect tests.

The eeprom was never 00 all the way.

> 
>>> You can fix it by forcing the driver to use "card=9" via modprobe
>>> option.
>>>
>>> Btw, Stefan sent some fixes to the ML. I'll test if the patch solves the
>>> audio issue with HVR-900H on analog mode.
>>
>> Ok, I'll try to grab them. It appears that mail relay from linux-media
>> to my inbox is not reliable.
> 
> I've applied them yesterday.

tested them already, I sent the results in another email.

> 
>> As for the analog, I should be able to test it today.
> 
> On the tests I've made yesterday after applying Stefan and my patches,
> analog is working fine. Audio got corrected by the patches for MSC
> (the audio standard used on NTSC and PAL-M). I tested here with both NTSC
> and PAL-M standards, and it worked as expected.
> 
> There are some fixes applied yesterday that are related to DTV. One of them
> fixes the alloc function call used for the DVB streaming buffer inside the
> USB stack:
> 
> - ret = usb_submit_urb(dvb->bulk_urb, GFP_KERNEL);
> + ret = usb_submit_urb(dvb->bulk_urb, GFP_ATOMIC);
> 
> The usage of GFP_KERNEL there may fail, causing failures at the DVB stream.
> 
> I'm now seeing if I can make the IR work on HVR-900H.

No luck with analog here, but I need to do more investigation as the
source might be broken all together.

Fabio

