Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:6343 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbZBOUyW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2009 15:54:22 -0500
Received: by yw-out-2324.google.com with SMTP id 5so871638ywh.1
        for <linux-media@vger.kernel.org>; Sun, 15 Feb 2009 12:54:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49987D43.2000805@rogers.com>
References: <200902152115.58993.aspeltami@gmail.com>
	 <49987D43.2000805@rogers.com>
Date: Sun, 15 Feb 2009 15:54:20 -0500
Message-ID: <412bdbff0902151254u14474393id1d7c9bee98515df@mail.gmail.com>
Subject: Re: firmware
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: CityK <cityk@rogers.com>
Cc: Michele <aspeltami@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 15, 2009 at 3:38 PM, CityK <cityk@rogers.com> wrote:
> Michele wrote:
>> Hi,
>> I'm new here and i'm trying TM6061 driver from your repo. Actually I'm now
>> able to make the module tm6000 and I find my card (wintv-hvr-900h) as card 9.
>> But when today for the first time my gentoo system recognize it I discovered
>> that I need a firmware called "xc3028L-v36.fw".
>>  I searched a while over the net and it seems to be in vendor CD but it isn't,
>> even downloading drivers from webpage I find a sys file but it is not
>> tridvid.sys, it is called hcw66xxx.sys (and also it seems to be a 64bit
>> version called  hcw66x64.sys). I tried both of them but nothing happend, I
>> also try to find that file over internet but everytime file checks fail.
>> Someone have some suggestion about where to find it?
>>
>
> Follow the rabbit: http://www.linuxtv.org/wiki/index.php/Firmware
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

CityK,

That actually wasn't a very helpful link you sent.  The user would
have to know he has a Xceive 3028L tuner, and even if he had been able
to figure that out, the page on the XC3028 and XC2028 pointed to on
that page makes no reference to getting the firmware for the low power
version of the chip.

Michele,

You can get the firmware here:

http://steventoth.net/linux/hvr1400/xc3028L-v36.fw

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
