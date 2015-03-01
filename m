Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37050 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbbCAUQ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Mar 2015 15:16:26 -0500
Received: by wivr20 with SMTP id r20so10583909wiv.2
        for <linux-media@vger.kernel.org>; Sun, 01 Mar 2015 12:16:25 -0800 (PST)
Message-ID: <54F37359.8030302@gmail.com>
Date: Sun, 01 Mar 2015 21:15:21 +0100
From: Gilles Risch <gilles.risch@gmail.com>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Basic support for the Elgato EyeTV Hybrid INT 2008 USB
 Stick
References: <54F32A6D.5090909@gmail.com> <54F32CAA.2040904@southpole.se>
In-Reply-To: <54F32CAA.2040904@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/01/2015 04:13 PM, Benjamin Larsson wrote:
> On 03/01/2015 04:04 PM, Gilles Risch wrote:
>> This patch will add basic support for the Elgato EyeTV Hybrid INT
>> 2008 USB Stick.
>>
>> Signed-off-by: Gilles Risch <gilles.risch@gmail.com>
>>
>
> [...]
>
>> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
>> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
>> @@ -41,7 +41,7 @@
>>   #include "mt352.h"
>>   #include "mt352_priv.h" /* FIXME */
>>   #include "tda1002x.h"
>> -#include "drx39xyj/drx39xxj.h"
>> +#include "drx39xxj.h"
>
> This change looks unrelated.

Probably due to an old kernel that I'm using on my machine 
(3.2.0-4-amd64 #1 SMP Debian 3.2.65-1+deb7u2 x86_64 GNU/Linux)

I'll change that and try it again.

>
> The rest looks ok.
>
> MvH
> Benjamin Larsson

Regards,
Gilles

