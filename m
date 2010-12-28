Return-path: <mchehab@gaivota>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56020 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab0L1IyW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 03:54:22 -0500
Received: by qwa26 with SMTP id 26so9115897qwa.19
        for <linux-media@vger.kernel.org>; Tue, 28 Dec 2010 00:54:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201012280857.35664@orion.escape-edv.de>
References: <4D1753CF.9010205@gmail.com> <201012272249.52358@orion.escape-edv.de>
 <201012280857.35664@orion.escape-edv.de>
From: Ludovic BOUE <ludovic.boue@gmail.com>
Date: Tue, 28 Dec 2010 09:54:01 +0100
Message-ID: <AANLkTi=JFPbOqDNit8vj5o-sCR3VYxhQP_qam=SQvMv6@mail.gmail.com>
Subject: Re: ngene & Satix-S2 dual problems
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Fist of all, I would thank you about your work,

I will re-test and report if I found an issue.


2010/12/28 Oliver Endriss <o.endriss@gmx.de>:
> On Monday 27 December 2010 22:49:51 Oliver Endriss wrote:
>> On Sunday 26 December 2010 15:40:15 Ludovic BOUÉ wrote:
>> > Hi all,
>> >
>> > I have a Satix-S2 Dual and I'm trying to get to work without his CI in a first time. I'm trying ngene-test2
>> > from http://linuxtv.org/hg/~endriss/ngene-test2/ under
>> > 2.6.32-21-generic.
>> >
>> > It contains too much nodes (extra demuxes, dvrs & nets):
>> > ...
>> > Is it connected to this commit (http://linuxtv.org/hg/~endriss/ngene-test2/rev/eb4142f0d0ac) about "Support up to 4 tuners for cineS2 v5, duoflex & mystique v2" ?
>>
>> Yes.
>>
>> Please note that this is an experimental repository.
>> This bug will be fixed before the code will be submitted upstream.
>> (It is more complicated that it might appear at the first glance.)
>
> Meanwhile I reworked channel initialisation and shutdown,
> and the device nodes should be correct for all configurations.
>
> Please re-test and report any remaining problems.
>
> CU
> Oliver
>
> --
> ----------------------------------------------------------------
> VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
> 4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
> Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
> ----------------------------------------------------------------
>



-- 
Ludovic BOUE
