Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37155 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab1FHFuh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 01:50:37 -0400
Received: by iyb14 with SMTP id 14so148263iyb.19
        for <linux-media@vger.kernel.org>; Tue, 07 Jun 2011 22:50:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110607230125.GA70704@triton8.kn-bremen.de>
References: <6C4E9A3B-EDC2-487B-90F9-734A0C349A4B@gmail.com>
 <20110604143409.GA75613@triton8.kn-bremen.de> <BANLkTindHbuKLc-+7orNCb1LqzgwRXAJ6g@mail.gmail.com>
 <20110607230125.GA70704@triton8.kn-bremen.de>
From: Andreas Steinel <a.steinel@googlemail.com>
Date: Wed, 8 Jun 2011 07:50:17 +0200
Message-ID: <BANLkTimCMOzqC6DCZeXyMK8_t2EZqvmD5Q@mail.gmail.com>
Subject: Re: Remote control TechnoTrend S2-3650 CI not working
To: Juergen Lock <nox@jelal.kn-bremen.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Jürgen, Hi List,

On Wed, Jun 8, 2011 at 1:01 AM, Juergen Lock <nox@jelal.kn-bremen.de> wrote:
> On Mon, Jun 06, 2011 at 11:55:44PM +0200, Andreas Steinel wrote:
>> Yet, i further investigated the errors and the source code and turned
>> on dvb-usb-debugging which yields:
>>
>> [11423.302006] key mapping failed - no appropriate key found in keymapping
>> [11423.501806] pctv452e_rc_query: cmd=0x26 sys=0x18
>> [11423.501815] key mapping failed - no appropriate key found in keymapping
>> [11423.701615] pctv452e_rc_query: cmd=0x26 sys=0x18
>> [11423.701628] key mapping failed - no appropriate key found in keymapping
>> [11424.001763] pctv452e_rc_query: cmd=0x26 sys=0x18
>> [11424.001775] key mapping failed - no appropriate key found in keymapping
>> [11424.102026] pctv452e_rc_query: cmd=0x26 sys=0x18
>> [11424.102034] key mapping failed - no appropriate key found in keymapping
>> [11424.202030] pctv452e_rc_query: cmd=0x26 sys=0x18
>> [11424.202038] key mapping failed - no appropriate key found in keymapping
>>
>> Which explains the error. I further debugged the problem and found this:
>>
>> [13242.485965] key mapping failed - no appropriate key found in keymapping
>> [13242.585948] pctv452e_rc_query: cmd=0x26 sys=0x18
>> [13242.585955]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
>> rc5_custom=0x01
>> [...]
>> [13242.586099]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
>> rc5_custom=0x3e
>> [13242.586103]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
>> rc5_custom=0x3f
>> [13242.586106] key mapping failed - no appropriate key found in keymapping
>>
>> I patched the file to get one key responding, but unfortunately
>> failed. The problem is not obvious to me:
>>
>> diff -r 41388e396e0f linux/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
>> --- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-remote.c  Mon May 23
>> 00:50:21 2011 +0300
>> +++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-remote.c  Mon Jun 06
>> 23:53:27 2011 +0200
>> @@ -272,6 +272,8 @@
>>                         }
>>                         /* See if we can match the raw key code. */
>>                         for (i = 0; i < d->props.rc_key_map_size; i++)
>> +        printk(" keycode is [1]=0x%02x vs rc5_custom=0x%02x,
>> [3]=0x%02x vs rc5_custom=0x%02x\n",
>> +                keybuf[1], rc5_custom(&keymap[i]), keybuf[3],
>> rc5_data(&keymap[i]));
>>                                 if (rc5_custom(&keymap[i]) == keybuf[1] &&
>>                                         rc5_data(&keymap[i]) == keybuf[3]) {
>>                                         *event = keymap[i].event;
>
>  You forgot the curly brackets there, now the for loop only runs
> the printf...

Argh... too obvious ... don't code near midnight :-/
I'll fix that and will incorporate all of "my new keyevents" and will
report back here.

Best,
Andreas
