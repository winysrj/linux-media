Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:36826 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbZEKJhX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2009 05:37:23 -0400
Received: by ewy24 with SMTP id 24so3288513ewy.37
        for <linux-media@vger.kernel.org>; Mon, 11 May 2009 02:37:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200905091141.57865.dkuhlen@gmx.net>
References: <ecc945da0905040929g828133ha7b1542dad9a1ca8@mail.gmail.com>
	 <200905091141.57865.dkuhlen@gmx.net>
Date: Mon, 11 May 2009 11:37:22 +0200
Message-ID: <ecc945da0905110237n38f6868eoe847d1fe1056f0c@mail.gmail.com>
Subject: Re: TT-3200: locks init. and timeout
From: pierre gronlier <ticapix@gmail.com>
To: Dominik Kuhlen <dkuhlen@gmx.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/5/9 Dominik Kuhlen <dkuhlen@gmx.net>:
> Hi,
> On Monday 04 May 2009, you wrote:
>> Hello,
>>
>> I have a TT-3200 card and the b40d628f830d revision of v4l-dvb (april 24th)
>> I have this two szap config files:
>> $ cat channels_astra_fta.conf
>> LCP:11479:v:0:22000:161:84:6402
>>
>> $ cat channels_hotbird_fta.conf
>> 4FunTv:10719:v:1:27500:163:92:4404
>>
>> My problem is that to lock on hotbird I have to lock first on astra
>> and them quickly launch szap on hotbird.
>> If I'm waiting few seconds after the lock of astra then the lock on
>> hotbird doesn't work.
> Just out of curiosity: Could you please try to set the frequencies a few (about 4) MHz lower or higher?
> (e.g. 11475 instead of 11479 for the Astra channel)


I tried minus/plus 4-5Mhz with this config file:
LCP:11479:v:0:22000:161:84:6402
LCPm5:11474:v:0:22000:161:84:6402
LCPm4:11475:v:0:22000:161:84:6402
LCPp4:11483:v:0:22000:161:84:6402
LCPp5:11484:v:0:22000:161:84:6402

All the szap went fine. The lock is done one the correct channel (LCP)


Here are the logs:
http://pierre.gronlier.fr/tmp/astra_11474.log
http://pierre.gronlier.fr/tmp/astra_11475.log
http://pierre.gronlier.fr/tmp/astra_11479.log
http://pierre.gronlier.fr/tmp/astra_11483.log
http://pierre.gronlier.fr/tmp/astra_11484.log


-- 
pierre

>
>> To lock on astra, I use this command
>> $ szap -a 0 -f 0 -d 0 -c channels_astra_fta.conf -xr -n 1
>> To lock on hotbird, I use this command
>> $ szap -a 0 -f 0 -d 0 -c channels_hotbird_fta.conf -xr -n 1
>>
>>
>> I enclose to the mail three logs:
>> - when astra locks
>> - when hotbird failed to lock
>> - when hotbird locks
>>
>> The logs are big but the diffs are really small so I hope that someone
>> who is familiar with the hardware could answer me.
>>
>> http://pierre.gronlier.fr/tmp/astra_ok_small.log
>> http://pierre.gronlier.fr/tmp/hotbird_failed_small.log
>> http://pierre.gronlier.fr/tmp/hotbird_ok_small.log
>>
>>
>> --
>> Pierre
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
> Dominik
>



-- 
Pierre Gronlier
