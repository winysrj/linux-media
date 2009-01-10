Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.citynetwork.se ([62.95.110.81] helo=smtp05.citynetwork.se)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <reklam@holisticode.se>) id 1LLdMA-0002gy-O7
	for linux-dvb@linuxtv.org; Sat, 10 Jan 2009 13:54:28 +0100
From: =?iso-8859-1?Q?M=E5rten_Gustafsson?= <reklam@holisticode.se>
To: <abraham.manu@gmail.com>
References: <mailman.26.1231583624.829.linux-dvb@linuxtv.org>
Date: Sat, 10 Jan 2009 13:53:52 +0100
Message-ID: <C6C61C93827D422BB1EAEB04475D9DA3@xplap>
MIME-Version: 1.0
In-Reply-To: <mailman.26.1231583624.829.linux-dvb@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Mantis users
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> Date: Sat, 10 Jan 2009 01:00:43 +0400
> From: "Manu Abraham" <abraham.manu@gmail.com>
> Subject: [linux-dvb] Mantis users
> To: linux-dvb@linuxtv.org
> Message-ID:
> 	<1a297b360901091300w6078f926p5efaadeb912e8c03@mail.gmail.com>
> Content-Type: text/plain; charset=3D"utf-8"
> =

> Hi,
> =

> Can you all please provide me the following information for =

> the Mantis /
> Hopper bridge
> based cards that you have in the following manner ?
> =

> 1) Card Name (As advertised on the cardboard box):

AzureWave AD-CP300 on box
AD-CP300 2-T2033-A4 on sticker on PCB
VP-20330 Ver:1.4 on PCB

This board is still on sale in Sweden:
http://www.prisjakt.nu/produkt.php?p=3D200911

> 2) lspci -vvn:

05:07.0 0480: 1822:4e35 (rev 01)
    Subsystem: 1822:0008
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 32 (2000ns min, 63750ns max)
    Interrupt: pin A routed to IRQ 17
    Region 0: Memory at c6000000 (32-bit, prefetchable) [size=3D4K]
    Kernel driver in use: Mantis
    Kernel modules: mantis

> 3) Chips on the card if you know them (only the basic chip =

> description is
> required,
> not the complete batch no. etc)

Mantis k62323. 1a-2 061117
NXP 3139 147 24321A# CU1216LS/AGIGH-3 SV21 0708
20 pin chip, cannot read without magnfying glass, important?
2 pcs of 8 pin chips, cannot read without magnfying glass, important?

> Regards,
> Manu

M=E5rten


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
