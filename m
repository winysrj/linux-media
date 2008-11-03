Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from helios.cedo.cz ([193.165.198.226] helo=postak.cedo.cz)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@drajsajtl.cz>) id 1KwtH5-0003MZ-7c
	for linux-dvb@linuxtv.org; Mon, 03 Nov 2008 07:50:58 +0100
Message-ID: <001201c93d80$a9df4620$7f79a8c0@tommy>
From: "Tomas Drajsajtl" <linux-dvb@drajsajtl.cz>
To: "Ruediger Dohmhardt" <ruediger.dohmhardt@freenet.de>
References: <001101c93ce7$23bcfdb0$7f79a8c0@tommy>
	<490E19B3.9090701@freenet.de>
Date: Mon, 3 Nov 2008 07:51:56 +0100
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT DVB-C 2300 and CAM,
	Was: Any DVB-C tuner with working CAM?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> > Hello,
> > I have bought and tested two DVB-C cards which are supported according
to
> > http://www.linuxtv.org/wiki/index.php/DVB-C_PCI_Cards
> > Both are perfectly working with FTA but none with the CAM.
> >
> > 1. TechnoTrend Premium DVB-C 2300
> >
> TT DVB-C 2300 works fine here with  AlphaCrypt -Light. This card has
> CI/CAM support for several years already.
> And it has worked here for several years with CI/CAM.

Interesting. I have Technisat Technicrypt CXV (Conax) inserted and none of
the channels is decrypted. Tried czap, vlc, vdr.

uname -a:
Linux pvr 2.6.23.17-88.fc7 #1 SMP Thu May 15 00:02:29 EDT 2008 x86_64 x86_64
x86_64 GNU/Linux

lspci -nvv:
01:00.0 0480: 1131:7146 (rev 01)
        Subsystem: 13c2:000a
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (3750ns min, 9500ns max)
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at eedff400 (32-bit, non-prefetchable) [size=512]

czap - no errors reported but no useful data output

vlc - reports detected CAM doesn't matter if it's really inserted or not:
[00000338] dvb access debug: Opening device /dev/dvb/adapter0/ca0
[00000338] dvb access debug: CAMInit: CA interface with 2 slots
[00000338] dvb access debug: CAMInit: CI link layer level interface type
[00000338] dvb access debug: CAMInit: built-in descrambler detected
[00000338] dvb access debug: CAMInit: 16 available descramblers (keys)
[00000338] dvb access debug: CAMInit: ECD scrambling system supported

vdr - says only
Nov  3 07:42:33 pvr vdr: [16467] ERROR: no useful data seen within 10627076
byte of video stream
I know that vdr should report something about detected CAM but nothing in
it's log file...

Tomas


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
