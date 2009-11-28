Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbZK1Jnn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 04:43:43 -0500
Message-ID: <4B10F0BC.60008@redhat.com>
Date: Sat, 28 Nov 2009 07:43:24 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Krzysztof Halasa <khc@pm.waw.pl>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <4B0A765F.7010204@redhat.com> <4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain> <4B0AB60B.2030006@s5r6.in-berlin.de> <4B0AC8C9.6080504@redhat.com> <m34oolrnwd.fsf@intrepid.localdomain> <4B0E71B6.4080808@redhat.com> <m3my29up3y.fsf@intrepid.localdomain> <4B0ED19B.9030409@redhat.com> <20091128003918.628d4b84@pedra> <20091128025437.GN6936@core.coreip.homeip.net>
In-Reply-To: <20091128025437.GN6936@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov wrote:
> On Sat, Nov 28, 2009 at 12:39:18AM -0200, Mauro Carvalho Chehab wrote:
>> Em Thu, 26 Nov 2009 17:06:03 -0200
>> Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:
>>
>>> Krzysztof Halasa wrote:
>>>> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
>>>>
>>>>> Technically, it is not hard to port this solution to the other
>>>>> drivers, but the issue is that we don't have all those IR's to know
>>>>> what is the complete scancode that each key produces. So, the hardest
>>>>> part is to find a way for doing it without causing regressions, and to
>>>>> find a group of people that will help testing the new way.
>>>> We don't want to "port it" to other drivers. We need to have a common
>>>> module which does all RCx decoding. The individual drivers should be as
>>>> simple as possible, something that I outlined in a previous mail.
>>> With the current 7bits mask applied to almost all devices, it is probably not very
>>> useful for those who want to use generic IRs. We really need to port the solution
>>> we've done on dvb-usb to the other drivers, allowing them to have the entire
>>> scancode at the tables while keep supporting table replacement. 
>>>
>>> The issue is that we currently have only 7bits of the scan codes produced by the IR's.
>>> So, we need to re-generate the keycode tables for each IR after the changes got applied.
>> Ok, I got some time to add support for tables with the full scan codes at the V4L drivers.
>> In order to not break all tables, I've confined the changes to just one device (HVR-950,
>> at the em28xx driver). The patches were already committed at the -hg development tree.
>>
>> In order to support tables with the full scan codes, all that is needed is to add the 
>> RC5 address + RC5 data when calling ir_input_keydown. So, the change is as simple as:
>>
>> -			ir_input_keydown(ir->input, &ir->ir,
>> -					 poll_result.rc_data[0]);
>> +			ir_input_keydown(ir->input, &ir->ir,
>> +					 poll_result.rc_address << 8 |
>> +					 poll_result.rc_data[0]);
>> +		else
>>
>> An example of such patch can be seen at:
>> 	http://linuxtv.org/hg/v4l-dvb/rev/9c38704cfd56
>>
>> There are still some work to do, since, currently, the drivers will use a table with a fixed
>> size. So, you can replace the current values, but it is not possible to add new keys.
>>
>> The fix for it is simple, but we need to think what would be the better way for it. There are
>> two alternatives:
>> 	- A table with a fixed size (like 128 or 256 entries - maybe a modprobe parameter
>> could be used to change its size);
>> 	- some way to increase/reduce the table size. In this case, we'll likely need some
>> ioctl for it.
>>
> 
> Hmm, why can't you just resize it when you get EVIOCSKEYCODE for
> scancode that would be out of bounds for the current table (if using
> table approach)?

For your reference, the code where EVIOGKEYCODE/EVIOSKEYCODE handling is done is at
this changeset:
	http://linuxtv.org/hg/v4l-dvb/rev/21e71d58cd2a

Dynamic resizing can be done, but there are a few different use cases for 
someone to touch on the keymaps:

1. People want to change the key assignment for a key at the shipped IR. In this case, 
the table won't need to change its size;

2. People want to use the shipped IR, plus a different one. In this case, table size needs
to be extended to store the newer codes;

3. People want to discard the shipped IR and use something else. 

Case 3 is the worse scenario. Let's suppose, for example that instead of using a 49 keys
IR, they want to use some programable IR with 55 keys, with different
scancodes. This means that they'll need to delete all 49 scancodes from the old IR 
and add 55 new scancodes. As there's no explicit call to delete a scan code, the solution
I found with the current API is to read the current scancode table and replace them with
KEY_UNKNOWN, allowing its re-use (this is what the driver currently does) or deleting
that scancode from the table. After deleting 49 keys, you'll need to add the 55 new keys.
If we do dynamic table resize for each operation, we'll do 104 sequences of kmalloc/kfree
for replacing one table. 

IMO, it would be better to have an ioctl to do the keycode table resize. An optional flag
at the ioctl (or a separate one) can be used to ask the driver to clean the current
keymap table and allocate a new one with the specified size. 
This will avoid playing with memory allocation for every new key and will provide a simple
way to say to the driver to discard the current keybable, since a new one will be used.

Cheers,
Mauro.


