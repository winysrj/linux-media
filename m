Return-path: <linux-media-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:52724 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbZC3RGb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 13:06:31 -0400
Message-ID: <49D0FC14.6010109@rtr.ca>
Date: Mon, 30 Mar 2009 13:06:28 -0400
From: Mark Lord <lkml@rtr.ca>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: bttv ir patch from Mark Lord
References: <200903301835.55023.hverkuil@xs4all.nl> <49D0F5E1.2030108@linuxtv.org> <49D0F720.7060700@rtr.ca> <49D0F85D.20802@linuxtv.org> <49D0FBCE.8050408@rtr.ca>
In-Reply-To: <49D0FBCE.8050408@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Michael Krufky wrote:
> Mark Lord wrote:
>> Michael Krufky wrote:
>>> Hans Verkuil wrote:
>>>> Hi Mike,
>>>>
>>>> The attached patch should be queued for 2.6.29.X. It corresponds to changeset 11098 (v4l2-common: remove incorrect MODULE test) in our v4l-dvb tree and is part of the initial set of git patches going into 2.6.30.
>>>>
>>>> Without this patch loading ivtv as a module while v4l2-common is compiled into the kernel will cause a delayed load of the i2c modules that ivtv needs since request_module is never called directly.
>>>>
>>>> While it is nice to see the delayed load in action, it is not so nice in that ivtv fails to do a lot of necessary i2c initializations and will oops later on with a division-by-zero.
>>>>
>>>> Thanks to Mark Lord for reporting this and helping me figure out what was wrong.
>>>>
>>>> Regards,
>>>>
>>>>     Hans
>>>>
>>>>   
>>> Got it, thanks.
>>>
>>> In the future, please point to hash codes rather than revision ID's -- my rev IDs are not the same as yours, but hash codes are always unique.
>>>
>>> I'll queue this the moment Linus merges Mauro's pending request.
>> ..
>>
>> Can either of you guys figure out how to get this patch (or something
>> equivalent) merged?  It's been pending for some time now.
>>
>> Thanks.
>>
>> Message-ID: <49884CCB.3070309@rtr.ca>
>> Date: Tue, 03 Feb 2009 08:55:23 -0500
>> From: Mark Lord <lkml@rtr.ca>
>> MIME-Version: 1.0
>> To: video4linux-list@redhat.com, Linux Kernel <linux-kernel@vger.kernel.org>
>> Subject: [PATCH] ir-kbd-i2c: support Hauppauge HVR-1600 R/C port
>> Content-Type: text/plain; charset=UTF-8; format=flowed
>> Content-Transfer-Encoding: 7bit
>>
>> (resending, with video4linux-list@redhat.com this time)
>>
>> Update the ir-kbd-i2c driver to recognize the remote-control port
>> on the Hauppauge HV-1600 hybrid tuner card.
>>
>> Signed-off-by: Mark Lord <mlord@pobox.com>
>>
>> --- old/drivers/media/video/ir-kbd-i2c.c    2008-12-24 18:26:37.000000000 -0500
>> +++ linux/drivers/media/video/ir-kbd-i2c.c    2009-02-01 13:08:19.000000000 -0500
>> @@ -354,6 +354,11 @@
>>             } else {
>>                 ir_codes    = ir_codes_rc5_tv;
>>             }
>> +        } else if (adap->id == I2C_HW_B_CX2341X) {
>> +            name        = "Hauppauge";
>> +            ir_type     = IR_TYPE_RC5;
>> +            ir->get_key = get_key_haup_xvr;
>> +            ir_codes    = ir_codes_hauppauge_new;
>>         } else {
>>             /* Handled by saa7134-input */
>>             name        = "SAA713x remote";
>> @@ -449,7 +454,7 @@
>>        That's why we probe 0x1a (~0x34) first. CB
>>     */
>>
>> -    static const int probe_bttv[] = { 0x1a, 0x18, 0x4b, 0x64, 0x30, -1};
>> +    static const int probe_bttv[] = { 0x1a, 0x18, 0x4b, 0x64, 0x30, 0x71, -1};
>>     static const int probe_saa7134[] = { 0x7a, 0x47, 0x71, 0x2d, -1 };
>>     static const int probe_em28XX[] = { 0x30, 0x47, -1 };
>>     static const int probe_cx88[] = { 0x18, 0x6b, 0x71, -1 };
>>
>
> looks like a zilog, and you should use LIRC for that.
..

It's a Hauppauge remote port, just like the one on the (supported) PVR-250.
And I don't want the LIRC monstrosity when there's a perfectly good
kernel driver to run it directly.  The patch does not prevent others
from using LIRC.
> PLEASE  DO NOT HIJAAK unrelated threads with unrelated emails.
..

"Hijack", not "HIJAAK".   :) 

Resending to copy linux-kernel again.
Please do not edit/delete lists from the email headers, thanks.

thanks.

