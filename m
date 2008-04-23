Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailgate.leissner.se ([212.3.1.210])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pf@leissner.se>) id 1JoYwo-00065f-Kl
	for linux-dvb@linuxtv.org; Wed, 23 Apr 2008 08:59:21 +0200
Date: Wed, 23 Apr 2008 08:59:08 +0200 (SST)
From: Peter Fassberg <pf@leissner.se>
To: =?UTF-8?B?TWFnbnVzIEjDtnJsaW4=?= <magnus@alefors.se>
In-Reply-To: <4808EDF2.3060002@alefors.se>
Message-ID: <Pine.BSF.4.58.0804230853380.16517@nic-i.leissner.se>
References: <4808EDF2.3060002@alefors.se>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] No frontend on VP-2040
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


Hej!

Vad har du f=F6r roligt projekt p=E5 g=E5ng som beh=F6ver 6 st kort? :-)

Jag har planerat ett streamingprojekt men jag f=E5r tyv=E4rr aldrig
n=E5gon tid =F6ver till att komma ig=E5ng.

Ett problem =E4r ju att g=F6ra descramblingen av programmen, utan att
beh=F6va ett fysiskt programkort f=F6r varje mottagare, men det borde
g=E5 att l=F6sa med n=E5gra av de allm=E4nt tillg=E4ngliga modulerna f=F6r
cardsharing.

Har du funderat p=E5 detta?



-- Peter F=E4ssberg




On Fri, 18 Apr 2008, [UTF-8] Magnus H=C3=B6rlin wrote:

> Hi. I just bought six Azurewave AD-CP400's (VP-2040) since I thought
> they should work after reading this list (for years). The fact that they
> suddenly dropped in price made me a little worried though. It has
> happend (many times) before that I have bought a new unsupported
> revision of a previously supported DVB card. And this time it seems to
> have happened again. If you want I can give you one of them, Manu. Or
> what can I do to help?
> /Magnus H
>
> dmesg:
> [   37.707361] found a UNKNOWN PCI UNKNOWN device on (01:05.0),
> [   37.707363]     Mantis Rev 1 [1822:0043], irq: 21, latency: 64
> [   37.707365]     memory: 0xdfeff000, mmio: 0xf8928000
>
> ls /dev/dvb/adapter0:
> ca0  demux0  dvr0  net0
>
> lspci -vvn:
> 01:05.0 0480: 1822:4e35 (rev 01)
>          Subsystem: 1822:0043
>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B-
>          Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium
>  >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>          Latency: 64 (2000ns min, 63750ns max)
>          Interrupt: pin A routed to IRQ 21
>          Region 0: Memory at dfeff000 (32-bit, prefetchable) [size=3D4K]
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
