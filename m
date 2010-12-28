Return-path: <mchehab@gaivota>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33601 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab0L1MWN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 07:22:13 -0500
Received: by wwa36 with SMTP id 36so9762948wwa.1
        for <linux-media@vger.kernel.org>; Tue, 28 Dec 2010 04:22:11 -0800 (PST)
Message-ID: <4D19D66D.4040108@gmail.com>
Date: Tue, 28 Dec 2010 13:22:05 +0100
From: =?ISO-8859-1?Q?Ludovic_BOU=C9?= <ludovic.boue@gmail.com>
MIME-Version: 1.0
To: Oliver Endriss <o.endriss@gmx.de>
CC: linux-media@vger.kernel.org, linux-media@dinkum.org.uk
Subject: Re: ngene & Satix-S2 dual problems
References: <4D1753CF.9010205@gmail.com> <201012272249.52358@orion.escape-edv.de> <201012280857.35664@orion.escape-edv.de>
In-Reply-To: <201012280857.35664@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Fist of all, I would thank you about your work.
I have done a test again and it seems to work with your last change. I
didn't found any major issue.

14:14 root@telstar /home/lboue # modprobe ngene one_adapter=0 debug=1

[  584.013474] nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
[  584.013495] ngene 0000:04:00.0: PCI INT A -> GSI 16 (level, low) ->
IRQ 16
[  584.013503] ngene: Found Mystique SaTiX-S2 Dual (v2)
[  584.014226] ngene 0000:04:00.0: setting latency timer to 64
[  584.014305] ngene: Device version 1
[  584.014339] ngene 0000:04:00.0: firmware: requesting ngene_18.fw
[  584.016649] ngene: Loading firmware file ngene_18.fw.
[  584.027625] ngene 0000:04:00.0: irq 33 for MSI/MSI-X
[  584.029106] error in i2c_read_reg
[  584.029179] No CXD2099 detected at 40
[  584.342566] LNBx2x attached on addr=a
[  584.342659] stv6110x_attach: Attaching STV6110x
[  584.342662] DVB: registering new adapter (nGene)
[  584.342667] DVB: registering adapter 0 frontend 0 (STV090x
Multistandard)...
[  584.343681] LNBx2x attached on addr=8
[  584.343774] stv6110x_attach: Attaching STV6110x
[  584.343777] DVB: registering new adapter (nGene)
[  584.343782] DVB: registering adapter 1 frontend 0 (STV090x
Multistandard)...

There is two adapters with one frontend into each:
14:06 lboue@telstar ~ % ls /dev/dvb/adapter0
demux0  dvr0  frontend0  net0
14:06 lboue@telstar ~ % ls /dev/dvb/adapter1
demux0  dvr0  frontend0  net0


14:12 root@telstar /home/lboue # modprobe ngene one_adapter=1

[  403.560150] nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
[  403.560169] ngene 0000:04:00.0: PCI INT A -> GSI 16 (level, low) ->
IRQ 16
[  403.560177] ngene: Found Mystique SaTiX-S2 Dual (v2)
[  403.560873] ngene 0000:04:00.0: setting latency timer to 64
[  403.560952] ngene: Device version 1
[  403.560963] ngene 0000:04:00.0: firmware: requesting ngene_18.fw
[  403.563416] ngene: Loading firmware file ngene_18.fw.
[  403.574393] ngene 0000:04:00.0: irq 33 for MSI/MSI-X
[  403.575874] error in i2c_read_reg
[  403.575948] No CXD2099 detected at 40
[  403.893231] LNBx2x attached on addr=a
[  403.893323] stv6110x_attach: Attaching STV6110x
[  403.893327] DVB: registering new adapter (nGene)
[  403.893332] DVB: registering adapter 0 frontend 0 (STV090x
Multistandard)...
[  403.894359] LNBx2x attached on addr=8
[  403.894451] stv6110x_attach: Attaching STV6110x
[  403.894456] DVB: registering adapter 0 frontend 0 (STV090x
Multistandard)...

14:13 root@telstar /home/lboue # ls /dev/dvb/adapter0/
demux0  demux1  dvr0  dvr1  frontend0  frontend1  net0  net1

The is only the needed adapters but I think there is a errror about the
frontend number. It should be
DVB: registering adapter 0 frontend 1 (STV090x Multistandard)
instead of: DVB: registering adapter 0 frontend 0 (STV090x Multistandard)

Best Regards

Le 28/12/2010 08:57, Oliver Endriss a écrit :
> On Monday 27 December 2010 22:49:51 Oliver Endriss wrote:
>> On Sunday 26 December 2010 15:40:15 Ludovic BOUÉ wrote:
>>> Hi all,
>>>
>>> I have a Satix-S2 Dual and I'm trying to get to work without his CI in a first time. I'm trying ngene-test2 
>>> from http://linuxtv.org/hg/~endriss/ngene-test2/ under 
>>> 2.6.32-21-generic.
>>>
>>> It contains too much nodes (extra demuxes, dvrs & nets):
>>> ...
>>> Is it connected to this commit (http://linuxtv.org/hg/~endriss/ngene-test2/rev/eb4142f0d0ac) about "Support up to 4 tuners for cineS2 v5, duoflex & mystique v2" ?
>> Yes.
>>
>> Please note that this is an experimental repository.
>> This bug will be fixed before the code will be submitted upstream.
>> (It is more complicated that it might appear at the first glance.)
> Meanwhile I reworked channel initialisation and shutdown,
> and the device nodes should be correct for all configurations.
>
> Please re-test and report any remaining problems.
>
> CU
> Oliver
>

-- 
Ludovic BOUÉ

