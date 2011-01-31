Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58821 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab1AaOqh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Jan 2011 09:46:37 -0500
Received: by wyb28 with SMTP id 28so5573805wyb.19
        for <linux-media@vger.kernel.org>; Mon, 31 Jan 2011 06:46:36 -0800 (PST)
Message-ID: <4D46CB46.7040604@gmail.com>
Date: Mon, 31 Jan 2011 15:46:30 +0100
From: =?ISO-8859-1?Q?Ludovic_BOU=C9?= <ludovic.boue@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: ngene & Satix-S2 dual problems
References: <4D1753CF.9010205@gmail.com> <201012280857.35664@orion.escape-edv.de> <4D19D66D.4040108@gmail.com> <201012281601.06586@orion.escape-edv.de>
In-Reply-To: <201012281601.06586@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Oliver,

Are you planning to merge your ngene development repository to the
V4L-DVB Upstream repository ?

Ludovic,

Le 28/12/2010 16:01, Oliver Endriss a écrit :
> Hi,
>
> On Tuesday 28 December 2010 13:22:05 Ludovic BOUÉ wrote:
>> ...
>> [  403.893231] LNBx2x attached on addr=a
>> [  403.893323] stv6110x_attach: Attaching STV6110x
>> [  403.893327] DVB: registering new adapter (nGene)
>> [  403.893332] DVB: registering adapter 0 frontend 0 (STV090x
>> Multistandard)...
>> [  403.894359] LNBx2x attached on addr=8
>> [  403.894451] stv6110x_attach: Attaching STV6110x
>> [  403.894456] DVB: registering adapter 0 frontend 0 (STV090x
>> Multistandard)...
>>
>> 14:13 root@telstar /home/lboue # ls /dev/dvb/adapter0/
>> demux0  demux1  dvr0  dvr1  frontend0  frontend1  net0  net1
>>
>> The is only the needed adapters but I think there is a errror about the
>> frontend number. It should be
>> DVB: registering adapter 0 frontend 1 (STV090x Multistandard)
>> instead of: DVB: registering adapter 0 frontend 0 (STV090x Multistandard)
> Confirmed. There is a harmless bug in dvb_core:
> The message is printed before the frontend number has been assigned.
> I will commit a fix for that later.
>
> CU
> Oliver
>

-- 
Ludovic BOUÉ

