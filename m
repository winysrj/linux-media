Return-path: <mchehab@gaivota>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:54912 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752812Ab0LOPwb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Dec 2010 10:52:31 -0500
Message-ID: <4D08E43C.8080002@arcor.de>
Date: Wed, 15 Dec 2010 16:52:28 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Felipe Sanches <juca@members.fsf.org>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: tm6000 and IR
References: <4CAD5A78.3070803@redhat.com>	<20101008150301.2e3ceaff@glory.local>	<4CAF0602.6050002@redhat.com>	<20101012142856.2b4ee637@glory.local>	<4CB492D4.1000609@arcor.de>	<20101129174412.08f2001c@glory.local>	<4CF51C9E.6040600@arcor.de>	<20101201144704.43b58f2c@glory.local>	<4CF67AB9.6020006@arcor.de>	<20101202134128.615bbfa0@glory.local>	<4CF71CF6.7080603@redhat.com>	<20101206010934.55d07569@glory.local>	<4CFBF62D.7010301@arcor.de>	<20101206190230.2259d7ab@glory.local>	<4CFEA3D2.4050309@arcor.de>	<20101208125539.739e2ed2@glory.local>	<4CFFAD1E.7040004@arcor.de>	<20101214122325.5cdea67e@glory.local>	<4D079ADF.2000705@arcor.de> <20101215164634.44846128@glory.local>
In-Reply-To: <20101215164634.44846128@glory.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Am 15.12.2010 08:46, schrieb Dmitri Belimov:
> Hi Stefan
>
>> Am 14.12.2010 04:23, schrieb Dmitri Belimov:
>>> Hi
>>>
>>> What about my last patch?? This is OK or bad?
>>> Our customers kick me every day with IR remotes.
>>>
>>> With my best regards, Dmitry.
>> I think, you use the second variant, Dmitry.
>> Why you doesn't use this key map - RCMAP_BEHOLD.
> No this remotes is different. RCMAP_BEHOLD has more buttons and some other scancodes.
> People from linux community who was made this keymap and function for reading data from
> IR decoder has error with scancode.
> Our true address of scancode is
> 0x86 0x6B
> They wrote
> 0x6B 0x86
> Need fix some code of the saa7134-input and RCMAP_BEHOLD keytable.
>
> RCMAP_BEHOLD_WANDER same as RCMAP_BEHOLD_COLUMBUS but
> from IR decoder the saa7134 received only one byte of scancode.
> Need rework saa7134-input too for get address and restore full scancodes for extended NEC full
> scancodes.
>
> I'll make it after some time.
>
>> The power led we can change to a separate function, right.
> Ok
>
>> The nec initiation looks right and must adding code for tm5600/6000 (going
>> over message pipe).
> I haven't USB stick with tm5600/6000 for test. Need people with this TV cards.
>
then add a todo line.
>> rc5 need some code for tm6010 (for tm5600/6000 are the hack).
> I didn't touch this code because I haven't RC5 remotes and tm5600/6000
>
>> And the logic for your remote control is unused  for
>> the second variant, but ir->rc_type = rc_type are o.k.
but the line ir->rc_type = rc_type; are o.k.

> I think your mean is wrong. Our IR remotes send extended NEC it is 4 bytes.
> We removed inverted 4 byte and now we have 3 bytes from remotes. I think we
> must have full RCMAP with this 3 bytes from remotes. And use this remotes with some
> different IR recievers like some TV cards and LIRC-hardware and other.
> No need different RCMAP for the same remotes to different IR recievers like now.
Your change doesn't work with my terratec remote control !!
> If we use second variant I can't use RCMAP_BEHOLD because it has full 3 bytes scancodes.
> As you wrote.
>
And if you use two bytes rc map table. We have add filter for address 
and commands to pass all. With an external tool can change the map ( 
ir_keytable). Why you will use more than two bytes.
>> Then the function call usb_set_interface in tm6000_video, can write
>> for example:
>>
>> stop_ir_pipe
>> usb_set_interface
>> start_ir_pipe
> Ok, I'll try.
>
>> I will adding vbi_buffer and device in the next, and isoc calculating
>> without video_buffer size.
> I try add radio.
>
> With my best regards, Dmitry.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

