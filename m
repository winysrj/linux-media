Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:56983 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab1ASNUB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 08:20:01 -0500
Message-ID: <4D36E4EA.6040003@infradead.org>
Date: Wed, 19 Jan 2011 11:19:38 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PULL] request for 2.6.38-rc1
References: <alpine.LRH.2.00.1101141542460.6649@pub3.ifh.de> <4D330984.2010307@infradead.org> <alpine.LRH.2.00.1101191230510.351@pub4.ifh.de>
In-Reply-To: <alpine.LRH.2.00.1101191230510.351@pub4.ifh.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-01-2011 09:34, Patrick Boettcher escreveu:
> Hi Mauro,
> 
> On Sun, 16 Jan 2011, Mauro Carvalho Chehab wrote:
> 
>> Em 14-01-2011 12:51, Patrick Boettcher escreveu:
>>> Hi Mauro,
>>>
>>> if it is not too late, here is a pull request for some new devices from DiBcom. It would be nice to have it in 2.6.38-rc1.
>>>
>>> Pull from
>>>
>>> git://linuxtv.org/pb/media_tree.git staging/for_2.6.38-rc1.dibcom
>>>
>>> for
>>>
>>> DiBxxxx: Codingstype updates
>>
>>
>> Not sure if this is by purpose, but you're changing all
>> msleep(10) into msleep(20). This sounds very weird for a
>> CodingStyle fix:
>>
>> -    msleep(10);
>> +    msleep(20);
> 
> I was as surprised as you when I saw that changed, but in fact it is a checkpatch-fix: it seems that checkpatch is warning about msleep or less than 20ms.
> 
> Maybe it is not the right fix to put them to msleep(20), but I think this is better than to do udelay(10000).
> 
> What do you think?

Well, that is more a warning for the developer that the actual sleep time may/will vary, depending
on how CONFIG_HZ is set. See: http://lkml.org/lkml/2007/8/3/250

There's actually a new function that can be used to disable such warnings (also at linux/delay.h):
	usleep_range(unsigned long min, unsigned long max);

If the device is very sensible if sleeping for a long time, using usleep_range() is a good idea,
as it will rely on a different wake up implementation. Otherwise, if anything between 10-20ms is OK,
I would just use msleep(10).

>> +    if (request_firmware(&state->frontend_firmware, "dib9090.fw", &adap->dev->udev->dev)) {
>>
>> Where's dib9090.fw firmware is available? The better is to submit a patch to linux-firmware
>> with the firmware binary, with some license that allows end-users to use it with your device
>> and distros/distro partners to re-distribute it. While here, please add also the other
>> dibcom firmwares.
> 
> The dib0700-firmware is already available through a license. The dib9090-firmware will come later. It'll take a moment before everything is ready.

Hmm... on a quick search at the web, I found this:
	http://www.kernellabs.com/firmware/dib0700/README.dib0700

If those are the latest license terms, they are OK for linux-firmware tree submission. After your
OK, I'll be adding the dibcom firmwares to my linux-firmware tree and ask the upstream maintainer
to pull from it. It would be nice if dib9090 firmware could be licensed under similar terms, and
also be submitted to linux-firmware tree.

>> Vendors are free to use their own legal text for it. There are several examples for it
>> at:
>>
>> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=blob_plain;f=WHENCE;hb=HEAD
>>
>>
>> Btw, there are two alignment errors (one at dib7000p, for some cases, aligned with 4 chars),
>> and another at dib8000, where all statements after an if are aligned with 3 tabs plus one space.
>> I'm fixing those issues, c/c you at the fix patches.
> 
> Nice, thank you.

Unfortunately, I did one error with the last patch. Accidentally, I folded a checkpatch.pl
"shut up" patch. Due to that, I missed the merge window. I'll be sending an upstream request
for pulling it on a separate branch, together with two other improvement patches (vb2 and ngene).
Let's hope that those will be accepted for .38.

Cheers,
Mauro
