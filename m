Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:52106 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab3AENva (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Jan 2013 08:51:30 -0500
Received: by mail-ea0-f180.google.com with SMTP id f13so7011456eai.11
        for <linux-media@vger.kernel.org>; Sat, 05 Jan 2013 05:51:29 -0800 (PST)
Message-ID: <50E82FFB.7050301@googlemail.com>
Date: Sat, 05 Jan 2013 14:51:55 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/6] em28xx: make remote controls of devices with external
 IR IC working again
References: <1356649368-5426-1-git-send-email-fschaefer.oss@googlemail.com> <1356649368-5426-4-git-send-email-fschaefer.oss@googlemail.com> <20130104191252.4aec9646@redhat.com> <50E8236C.6070702@googlemail.com> <20130105112617.79c3c57a@redhat.com>
In-Reply-To: <20130105112617.79c3c57a@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 05.01.2013 14:26, schrieb Mauro Carvalho Chehab:
> Em Sat, 05 Jan 2013 13:58:20 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Am 04.01.2013 22:12, schrieb Mauro Carvalho Chehab:
>>> Em Fri, 28 Dec 2012 00:02:45 +0100
>>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>>
>>>> Tested with device "Terratec Cinergy 200 USB".
>>> Sorry, but this patch is completely wrong ;)
>> Completely wrong ? That's not helpful...
>> Please elaborate a bit more on this so that I can do things right next
>> time. ;)
> Sorry, I was too busy yesterday with the tests to elaborate it more.
>
> In general, big patches like that to fix bug fixes are generally wrong:
> they touch on a lot of the code and it is hard to be sure that it doesn't
> come with regressions on it.

Ok, I think you are right.
The patch description was definitely insufficient. I should have
explained the issues I tried to address in more details.
Maybe I should have split this into several smaller patches, too.

> In this particular case, it was:
> 	- mixing bug fixes with some other random stuff;
> 	- moving only one part of the IR needed data elsewhere (it were
> 	  moving the IR tables, to the board descriptions, keeping them on
> 	  a separate part of the code, obfuscating the code);
> 	- putting a large amount of the code inside an if, increasing the
> 	  driver's complexity with no need;
> 	- initializing some data for IR that are never used, at em28xx_ir_init;
> 	- not fixing the snapshot button.
>
> The bug fix was as simple as:
> 	1) move snapshot button register to happen before IR;
> 	2) move I2C init to happen before the em2860/2874 IR init.

See the mail I've sent a few minutes ago.

> ...
>
> Btw, I really prefer to have the RC tables for the I2C devices inside
> em28xx-input, as:
>
> 	1) there are other board-specific platform_data that needed to
> 	   be filled for the IR to work there;

Sure.

> 	2) we want to keep all those platform_data initialization together,
> 	   to make the code simpler to maintain;

platform_data initialization is kept together, no changes here.
To me it seems to be important to keep all _board_ specific stuff
together as much as possible.

> 	3) moving all those data to em28xx cards struct is a bad idea, as
> 	   newer em28xx won't use I2C IR's, as the new chipsets have already
> 	   its own IR decoder. Moving those 4-5 fields to the board struct
> 	   would increase its size for every board. So, it would be a waste
> 	   of space.

Im my opinion, having board specifc code spread all over the code is a
desease. It makes the code bug prone.
Actually, this was one of the reasons why the i2c rc got broken...
Sure, it's hard to avoid, especially for the DVB stuff. But we should at
least reduce it to a minimum.

For the RC map, it's easy to do this, as the corresponding field is
already there.

Regards,
Frank

>
> Regards,
> Mauro

