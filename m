Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from fmmailgate03.web.de ([217.72.192.234])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hubblest@web.de>) id 1JPEaB-0006PY-6b
	for linux-dvb@linuxtv.org; Wed, 13 Feb 2008 11:11:15 +0100
From: Peter Meszmer <hubblest@web.de>
To: Matthias Schwarzott <zzam@gentoo.org>
Date: Wed, 13 Feb 2008 11:05:49 +0100
References: <47AB228E.3080303@gmail.com> <200802072219.40759.hubblest@web.de>
	<200802122206.30369.zzam@gentoo.org>
In-Reply-To: <200802122206.30369.zzam@gentoo.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802131105.49910.hubblest@web.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] AVerMedia DVB-S Hybrid+FM and DVB-S Pro [A700]
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Am Dienstag, 12. Februar 2008 schrieben Sie:
> I added this to the wiki-page about A700:
> http://www.linuxtv.org/wiki/index.php/AVerMedia_AVerTV_DVB-S_Pro_(A700)
>
> Maybe we should rename the page to AverMedia_AverTV_DVB-S_A700 or anything
> similar.
>
> * Could you load saa7134 module of unpatched driver, but with parameter
> i2c_scan=1.
> * lspci -vvnn also should be interesting
> * If you have a camera, could you do a picture, so we can get info about
> the used analog tuner. I guess it is some XC30??. But to get it running you
> should contact video4linux mailinglist.
>
>
> Regards
> Matthias


Hello Matthias,

if I load the saa7134 module of unpatched driver, but with parameter 
i2c_scan=1, dmesg shows (Kernel 2.6.24-gentoo-r2)

saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:02:07.0, rev: 209, irq: 18, latency: 64, mmio: 
0xd3024000
saa7133[0]: subsystem: 1461:a7a2, board: UNKNOWN/GENERIC [card=0,autodetected]
saa7133[0]: board init: gpio is 6da00
saa7133[0]: i2c eeprom 00: 61 14 a2 a7 ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c scan: found device @ 0x1c  [???]
saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0

and lspci -vvnn returns

02:07.0 Multimedia controller [0480]: Philips Semiconductors SAA7133/SAA7135 
Video Broadcast Decoder [1131:7133] (rev d1)
        Subsystem: Avermedia Technologies Inc Unknown device [1461:a7a2]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (63750ns min, 63750ns max)
        Interrupt: pin A Route to IRQ 18
        Region 0: Memory at d3024000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=3 PME-
        Kernel driver in use: saa7134
        Kernel modules: saa7134

I did some pictures too... the link to them is in a PM for you. The analog 
tuner seems to be a XC2028, but I don't see any possibilities to test the 
tuner.

Regards
Peter

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
