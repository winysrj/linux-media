Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab1K2LgB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 06:36:01 -0500
Message-ID: <4ED4C39C.2090209@redhat.com>
Date: Tue, 29 Nov 2011 09:35:56 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Fabio M. Di Nitto" <fdinitto@redhat.com>
CC: LMML <linux-media@vger.kernel.org>,
	Stefan Ringel <linuxtv@stefanringel.de>,
	Dmitri Belimov <d.belimov@gmail.com>
Subject: Re: HVR-900H dvb-t regression(s)
References: <4ED39D88.507@redhat.com> <4ED3F81F.303@redhat.com> <4ED4655F.5050905@redhat.com>
In-Reply-To: <4ED4655F.5050905@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29-11-2011 02:53, Fabio M. Di Nitto wrote:
> On 11/28/2011 10:07 PM, Mauro Carvalho Chehab wrote:
>> On 28-11-2011 12:41, Fabio M. Di Nitto wrote:
>>> Hi all,
>>>
>>> short summary is that dvb-t on $subject doesn´t work with head of the
>>> tree (for_3.3 branch) and scan or mplayer stop working.
>>>
>>> Here is the breakdown of what I found with all logs. Please let me know
>>> if you need any extra info. Can easily test patches and gather more logs
>>> if necessary.
>>>
>>> Also please note that I am no media guru of any kind. I had to work on
>>> some assumptions from time to time.
>>>
>>> Based on git bisect:
>>>
>>> The last known good commit is e872bb9a7ddfc025ed727cc922b0aa32a7582004
>>>
>>> The first known bad commit is f010dca2e52d8dcc0445d695192df19241afacdb
>>>
>>> commit f010dca2e52d8dcc0445d695192df19241afacdb
>>> Author: Stefan Ringel<stefan.ringel@arcor.de>
>>> Date:   Mon May 9 16:53:58 2011 -0300
>>>
>>>       [media] tm6000: move from tm6000_set_reg to tm6000_set_reg_mask
>>>
>>>       move from tm6000_set_reg to tm6000_set_reg_mask
>>>
>>>       Signed-off-by: Stefan Ringel<stefan.ringel@arcor.de>
>>>       Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>>>
>>> While this commit appears rather innocent, it changes the way some
>>> registries are set.
>>>
>>> the original code did:
>>>
>>> read_reg...
>>> change value
>>> write_reg.. (unconditionally)
>>>
>>> the new code path:
>>>
>>> read_reg...
>>> calculate new value
>>> check if it is same
>>> if not, write_reg...
>>>
>>> So I did the simplest test as possible by removing the conditional in
>>> tm6000_set_reg_mask and dvb-t started working again.
>>>
>>> something along those lines:
>>>
>>> diff --git a/drivers/media/video/tm6000/tm6000-core.c
>>> b/drivers/media/video/tm6000/tm6000-core.c
>>> index 9783616..818f542 100644
>>> --- a/drivers/media/video/tm6000/tm6000-core.c
>>> +++ b/drivers/media/video/tm6000/tm6000-core.c
>>> @@ -132,8 +132,8 @@ int tm6000_set_reg_mask(struct tm6000_core *dev, u8
>>> req, u16 value,
>>>
>>>           new_index = (buf[0]&   ~mask) | (index&   mask);
>>>
>>> -       if (new_index == index)
>>> -               return 0;
>>> +//     if (new_index == index)
>>> +//             return 0;
>>>
>>>           return tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR,
>>>                                         req, value, new_index, NULL, 0);
>>>
>>> but moving this change to the HEAD of for_v3.3 doesn´t solve the
>>> problem, possibly hinting to multiple regressions in the driver but at
>>> this point I am slightly lost because i can´t figure out what else is
>>> wrong. Some semi-random git bisect didn´t bring me anywhere useful at
>>> this point.
>>
>> Hmm... It occurred to me that HVR-900H has a bug at device initialization.
>> Sometimes, after a device connect it can't read anything from eeprom. As
>> result,
>> it will print:
>>
>> [ 7867.776612] tm6000: Found Generic tm6010 board
>> [ 7867.841177] tm6000 #1: i2c eeprom 00: 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00 00 00  ................
> [SNIP]
>> [ 7869.707769] Device has eeprom but is currently unknown
>>
>> and the device will be miss-detected.
>
> I don't think this was ever the case, but I can easily check the dmesg
> output that I collected.

This may affect your bisect tests.

>> You can fix it by forcing the driver to use "card=9" via modprobe option.
>>
>> Btw, Stefan sent some fixes to the ML. I'll test if the patch solves the
>> audio issue with HVR-900H on analog mode.
>
> Ok, I'll try to grab them. It appears that mail relay from linux-media
> to my inbox is not reliable.

I've applied them yesterday.

> As for the analog, I should be able to test it today.

On the tests I've made yesterday after applying Stefan and my patches,
analog is working fine. Audio got corrected by the patches for MSC
(the audio standard used on NTSC and PAL-M). I tested here with both NTSC
and PAL-M standards, and it worked as expected.

There are some fixes applied yesterday that are related to DTV. One of them
fixes the alloc function call used for the DVB streaming buffer inside the
USB stack:

- ret = usb_submit_urb(dvb->bulk_urb, GFP_KERNEL);
+ ret = usb_submit_urb(dvb->bulk_urb, GFP_ATOMIC);

The usage of GFP_KERNEL there may fail, causing failures at the DVB stream.

I'm now seeing if I can make the IR work on HVR-900H.

Regards,
Mauro
