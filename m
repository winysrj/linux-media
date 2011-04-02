Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:45156 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750879Ab1DBLVb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Apr 2011 07:21:31 -0400
Message-ID: <4D9706AC.7000704@gmx.net>
Date: Sat, 02 Apr 2011 13:21:16 +0200
From: Jos Hoekstra <joshoekstra@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Technisat Cablestar HD2 not automatically detected by kernel
 > 2.6.33?
References: <4D9390FA.9040402@gmx.net> <8762qz79o7.fsf@nemi.mork.no>
In-Reply-To: <8762qz79o7.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Op 31-3-2011 14:32, Bjørn Mork schreef:
> Jos Hoekstra<joshoekstra@gmx.net>  writes:
>
>> I got this card and it doesn't seem to be detected by Ubuntu 10.4.2
>> with kernel 2.6.35(-25-generic #44~lucid1-Ubuntu SMP Tue Jan 25
>> 19:17:25 UTC 2011 x86_64 GNU/Linux)
>>
>> The wiki seems to indicate that this card is supported as of kernel
>> 2.6.33, however it doesn't show up as a dvb-adapter.
> [..]
>> After rebooting it however seems I need to manually modprobe mantis
>> and restart the backend to have mythtv work with this card. Is there a
>> way to make these modules load automatically after a reboot?
> The best way to work around the problem until you upgrade your kernel to
> 2.6.38 or newer, is probably just adding mantis to /etc/modules.
>
>
> Bjørn

This work-around solved this little issue for me, thanks :)

Is there a how-to for handing in initial scan-files or complete scans? 
I'm on fiber and afaik this goes for the whole network excluding local 
stations.

Thanks,

Jos Hoekstra
