Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:58649 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421Ab3ETNlv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 May 2013 09:41:51 -0400
Received: by mail-ea0-f173.google.com with SMTP id n15so3879409ead.4
        for <linux-media@vger.kernel.org>; Mon, 20 May 2013 06:41:49 -0700 (PDT)
Message-ID: <519A287C.9010804@googlemail.com>
Date: Mon, 20 May 2013 15:43:24 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: 3.9.2 kernel - IR / em28xx_rc broken?
References: <1368885450.24433.YahooMailNeo@web120306.mail.ne1.yahoo.com> <519791E2.4080804@googlemail.com> <1368890230.26016.YahooMailNeo@web120301.mail.ne1.yahoo.com> <5197B34A.8010700@googlemail.com> <1368910949.59547.YahooMailNeo@web120304.mail.ne1.yahoo.com> <5198D669.6030007@googlemail.com> <1368972692.46197.YahooMailNeo@web120301.mail.ne1.yahoo.com> <51990B63.5090402@googlemail.com> <1368993591.43913.YahooMailNeo@web120305.mail.ne1.yahoo.com> <51993DDE.4070800@googlemail.com> <1369004659.18393.YahooMailNeo@web120305.mail.ne1.yahoo.com> <519A1939.6030907@googlemail.com> <1369054869.78400.YahooMailNeo@web120305.mail.ne1.yahoo.com>
In-Reply-To: <1369054869.78400.YahooMailNeo@web120305.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 20.05.2013 15:01, schrieb Chris Rankin:
> ----- Original Message -----
>
>>> And this is me calling ir-keytable:
>>>
>>> [ 2183.812407] em28xx #0: Changing protocol: rc_type=1
>> So with 3.8 the same happens as with 3.9.
> Yes, that does appear to be part of the RC core ABI.
>
>> Well, if ir-keycode / the RC core requests RC_BIT_UNKNOWN, they get RC_BIT_UNKNOWN. ;)
>> If you expect the device to be configured for another protocol (RC5 ?),
>> you need to find out what's going wrong in the RC core and/or ir-keycode.
> Are other RCs affected by this? I have difficulty blaming RC core when its behaviour hasn't changed.

If I had to guess, I would say you should check your rc_maps.cfg /
keytable. ;)

>
>> The point is that 3.8 ignores rc_type=1, whereas 3.9 uses it to update a new ir->rc_type field - which in turn controls how em2874_polling_getkey() encodes its scancode.
>> Indeed, since 3.9
>> 1.) em2874_polling_getkey() cares about the rc_type
>> 2.) the new rc_type is saved back to ir->rc_type
>>
>> AFAICS both changes are correct.
> Except that given the current ABI, these changes break my RC.

No, the change that actually broke your RC is the third change.

>
>> But there was a third change:
>> 3.) the scancode passed to the RC core with rc_keypress() in case of
>> RC_BIT_UNKNOWN changed from a 16 bit value to 32 bit value (e.g.: old: 00 00 ab cd => new: ab cd xx xx).
>>
>> Hmm... isn't this an ABI break !?
> em28xx only used to support RC5 in 3.8, by the looks of things.

... and NEC.

>  The behaviour when configured for "RC_BIT_UNKNOWN" would therefore have been "undefined"... ;-).

With both kernels (3.8 and 3.9), the hardware is configured for RC5 when
RC_BIT_UNKNOWN is selected.
The only thing that changed in the configuration part (apart from the
new ir->rc_type field and RC& support) is,
that em28xx_ir_change_protocol() used to return -EINVAL for
RC_NIT_UNKNOWN and 3.9 now returns 0.
But that seems to be no issue here.

Regards,
Frank

>
> Cheers,
> Chris

