Return-path: <mchehab@pedra>
Received: from bonnie-vm4.ifh.de ([141.34.50.21]:53913 "EHLO smtp.ifh.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753636Ab1ASLeN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 06:34:13 -0500
Date: Wed, 19 Jan 2011 12:34:04 +0100 (CET)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PULL] request for 2.6.38-rc1
In-Reply-To: <4D330984.2010307@infradead.org>
Message-ID: <alpine.LRH.2.00.1101191230510.351@pub4.ifh.de>
References: <alpine.LRH.2.00.1101141542460.6649@pub3.ifh.de> <4D330984.2010307@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Sun, 16 Jan 2011, Mauro Carvalho Chehab wrote:

> Em 14-01-2011 12:51, Patrick Boettcher escreveu:
>> Hi Mauro,
>>
>> if it is not too late, here is a pull request for some new devices from DiBcom. It would be nice to have it in 2.6.38-rc1.
>>
>> Pull from
>>
>> git://linuxtv.org/pb/media_tree.git staging/for_2.6.38-rc1.dibcom
>>
>> for
>>
>> DiBxxxx: Codingstype updates
>
>
> Not sure if this is by purpose, but you're changing all
> msleep(10) into msleep(20). This sounds very weird for a
> CodingStyle fix:
>
> -	msleep(10);
> +	msleep(20);

I was as surprised as you when I saw that changed, but in fact it is a 
checkpatch-fix: it seems that checkpatch is warning about msleep or less 
than 20ms.

Maybe it is not the right fix to put them to msleep(20), but I think this 
is better than to do udelay(10000).

What do you think?


> +	if (request_firmware(&state->frontend_firmware, "dib9090.fw", &adap->dev->udev->dev)) {
>
> Where's dib9090.fw firmware is available? The better is to submit a patch to linux-firmware
> with the firmware binary, with some license that allows end-users to use it with your device
> and distros/distro partners to re-distribute it. While here, please add also the other
> dibcom firmwares.

The dib0700-firmware is already available through a license. The 
dib9090-firmware will come later. It'll take a moment before everything is 
ready.


> Vendors are free to use their own legal text for it. There are several examples for it
> at:
>
> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=blob_plain;f=WHENCE;hb=HEAD
>
>
> Btw, there are two alignment errors (one at dib7000p, for some cases, aligned with 4 chars),
> and another at dib8000, where all statements after an if are aligned with 3 tabs plus one space.
> I'm fixing those issues, c/c you at the fix patches.

Nice, thank you.

best regards,
--

Patrick
