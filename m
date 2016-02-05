Return-path: <linux-media-owner@vger.kernel.org>
Received: from v-smtpgw2.han.skanova.net ([81.236.60.205]:39540 "EHLO
	v-smtpgw2.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbcBETHe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Feb 2016 14:07:34 -0500
Subject: Re: PCTV 292e weirdness
To: Rune Petersen <rune@megahurts.dk>,
	Russel Winder <russel@itzinteractive.com>,
	Antti Palosaari <crope@iki.fi>,
	DVB_Linux_Media <linux-media@vger.kernel.org>
References: <1454523447.1970.15.camel@itzinteractive.com>
 <56B378F0.6020301@iki.fi> <1454612780.4401.66.camel@itzinteractive.com>
 <56B46E25.7070405@megahurts.dk>
From: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Message-ID: <56B4F2FF.5080206@mbox200.swipnet.se>
Date: Fri, 5 Feb 2016 20:07:43 +0100
MIME-Version: 1.0
In-Reply-To: <56B46E25.7070405@megahurts.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is probably the problems i have seen.
my usb based card also have a si2168.

since i don't have any good physical machine i used a vm (kvm) and 
attached the usb device there.
this works best if the device is in cold state, if driver finds it in 
warm state things dont work very well.

but at the moment i also got another issue with the last round of 
updates to media_build.
a few weeks ago modueles was loading properly and earlier in the week 
when i tested the modules dont load at all and errors during loading.
can test again and post output of dmesg
this is a new issue.

kernel modules from a few weeks ago loads but tuning only works once 
after module load.
then there is no signal at all and it doesnt lock on to the signa.

On 2016-02-05 10:40, Rune Petersen wrote:
> (sent email again since I managed to reply only to Russel)
>
> I have the same issue - haven't had time to look into it much.
>
> the problem is that si2157 & si2168 doesn't resume properly from suspend.
>
> I have attached 2 patches that disable suspend.
>
> What i have found out:
> I can resume the si2157 from suspend by replacing "goto warm" with "goto
> skip_fw_download" in si2157_init()
>
> I can 'resume' the si2168 from suspend if I set "dev->fw_loaded = 0" in
> si2168_sleep()
>
>
> Rune
>
>
> On 04/02/16 20:06, Russel Winder wrote:
>> On Thu, 2016-02-04 at 18:14 +0200, Antti Palosaari wrote:
>> […]
>>>
>>> Are you using DVB-T, T2 or C? I quickly tested T and T2 with dvbv5-
>>> zap
>>> and it worked (kernel media 4.5.0-rc1+).
>>
>> Definitely T and T2. I had been assuming dvbv5-zap switched mode based
>> on the entry in the virtual channel file. In this case "BBC NEWS" is in
>> a T multiplex.
>>
>>> PCTV 282e seems to be dibcom based DVB-T only device, so you are
>>> using
>>> DVB-T?
>>
>> Yes, 282e is T only, ditto Terratec XXS. I haven't been able to get
>> anything working with WinTVSoloHD or WinTVdualHD as yet.
>>

