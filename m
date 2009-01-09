Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1LLQ7j-0004MC-QN
	for linux-dvb@linuxtv.org; Fri, 09 Jan 2009 23:46:41 +0100
Date: Fri, 09 Jan 2009 23:46:06 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <1a297b360901091300w6078f926p5efaadeb912e8c03@mail.gmail.com>
Message-ID: <20090109224606.225290@gmx.net>
MIME-Version: 1.0
References: <1a297b360901091300w6078f926p5efaadeb912e8c03@mail.gmail.com>
To: "Manu Abraham" <abraham.manu@gmail.com>, linux-dvb@linuxtv.org
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

> Hi,
> =

> Can you all please provide me the following information for the Mantis /
> Hopper bridge
> based cards that you have in the following manner ?
> =

> 1) Card Name (As advertised on the cardboard box):

Azurewave AD-SP 400

> 2) lspci -vvn:

04:00.0 0480: 1822:4e35 (rev 01)
        Subsystem: 1822:0031
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (2000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at 99100000 (32-bit, prefetchable) [size=3D4K]

> 3) Chips on the card if you know them (only the basic chip description is
> required,
> not the complete batch no. etc)

Mantis K62323.1A-2
STB0899
STB6100
20-pin chip under heatsink (LNBP21?)
Portek PTK8706 18-pin 8-bit microcontroller
402B2GLI 8-pin
Nikos N2576 5-pin Voltage Regulator

Regards,
Hans

> =

> =

> Regards,
> Manu

-- =

Release early, release often.

Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit allen: =
http://www.gmx.net/de/go/multimessenger

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
