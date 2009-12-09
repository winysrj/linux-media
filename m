Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:38675 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752783AbZLIJe1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2009 04:34:27 -0500
Received: from [172.23.170.147] (helo=anti-virus03-10)
	by smtp-out2.blueyonder.co.uk with smtp (Exim 4.52)
	id 1NIIwG-0001TP-Ey
	for linux-media@vger.kernel.org; Wed, 09 Dec 2009 09:34:28 +0000
Received: from [62.31.89.131] (helo=esdelle.homelinux.org)
	by asmtp-out6.blueyonder.co.uk with smtp (Exim 4.52)
	id 1NIIwF-0000jL-Rx
	for linux-media@vger.kernel.org; Wed, 09 Dec 2009 09:34:27 +0000
Message-ID: <4B1F6F1F.7010900@esdelle.co.uk>
Date: Wed, 09 Dec 2009 09:34:23 +0000
From: Rob Beard <rob@esdelle.co.uk>
MIME-Version: 1.0
To: Lukasz Sokol <el_es_cr@yahoo.co.uk>
CC: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: WinTV HVR-900 USB (B3C0)
References: <4B1E8E4D.9010101@esdelle.co.uk> <4B1F6AE3.20303@yahoo.co.uk>
In-Reply-To: <4B1F6AE3.20303@yahoo.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/12/2009 09:16, Lukasz Sokol wrote:
> Rob Beard wrote:
>    
>> Hi folks,
>>
>> I've borrowed a WinTV HVR-900 USB stick from a friend of mine to see if
>> I can get any reception in my area before forking out for one however
>> I've run in to a couple of problems and wondered if anyone had used one
>> of these sticks?
>>
>>      
> [snip]
>    
>> I just wondered if anyone else had one of these sticks actually working
>> under Ubuntu 9.10?  (I'm running kernel 2.6.31-16-generic-pae).
>>
>> Rob
>>
>>      
>
> Hi Rob,
> this device uses empia chips.
>
> I have a similar situation with Pinnacle Hybrid Pro 330e (yes, 3_3_0e) : the only
> driver that works (and was great at it) was Markus Rechberger's em28xx-new project.
> (my device has cx88 tuner IIRC). The em28xx-new project had some modifications to
> some tuner drivers too. They were based both on RE and documentation for which
> Markus had NDA's signed (a vague recollection of past googling).
>
> The mainline kernel unfortunately does not support it out of the box, and it is not only
> about the firmware you have to download; There is something severely nonfunctional.
>
> Why am I writing in past tense ?
> This driver (em28xx-new) has recently been abandoned, and its author went proprietary.
> I was using a ubuntu package prepared by some ubuntu user, named gborzi.
> Unfortunately the package cannot apply to more recent kernels any more.
> The last kernel it worked with, was 2.6.27-14 (Ubuntu terminology) and I'm stuck with it.
>
> I have emailed Markus but he seems to have lost any interest in the em28xx-new...
> can't blame him though, he gave his reasons, some of them unfortunately true.
>
> To v4l developers : as it is the case now that we can consider em28xx-new abandonware,
> could somebody see, what got devices like ours working in his driver, and push it to
> mainline, please ? Just the DVB support would be fine...
>
> To Markus : the above is not a call to _steal_your_code_ but merely to somebody have
> a look and modify the mainline drivers so it could support A 5 YEAR OLD DEVICE like mine.
> People could employ a 'clean room' like in alternative to Broadcom (b43) development.
>
> At least mine, is a 5 YEARS OLD design (bought in 2006).
> On my computer, which was middle spec 5 years ago, I've always had problems with this device
> under Windows (XP) : 100% CPU on max frequency (1.6GHz) all the time, when playing.
> Under Linux, stock Ubuntu 8.10 Kaffeine, and em28xx-new, it is max 30% CPU at lowest freq (800MHz)).
>
> Stock em28xx driver only supports analog (with no sound under stock tvtime, supposedly patched tvtime required).
>
> el es
>    

Thanks for the heads up, I think I'll have a look and see what else is 
available out there then, luckily I only borrowed it to test if it would 
work.

Regards,

Rob

