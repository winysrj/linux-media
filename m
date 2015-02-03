Return-path: <linux-media-owner@vger.kernel.org>
Received: from relaycp02.dominioabsoluto.net ([217.116.26.74]:40314 "EHLO
	relaycp02.dominioabsoluto.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752040AbbBCT02 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2015 14:26:28 -0500
From: "dCrypt" <dcrypt@telefonica.net>
To: <linux-media@vger.kernel.org>
Cc: <stoth@kernellabs.com>
References: <54472CB702988260@smtp.movistar.es> (added by	    postmaster@movistar.es) <02ee01d031ec$283a80f0$78af82d0$@net> <006301d03b58$0181a9a0$0484fce0$@net>
In-Reply-To: <006301d03b58$0181a9a0$0484fce0$@net>
Subject: RE: [possible BUG, cx23885] Dual tuner TV card, works using one tuner only, doesn't work if both tuners are used 
Date: Tue, 3 Feb 2015 20:26:25 +0100
Message-ID: <006e01d03fe7$4cf3dd70$e6db9850$@net>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_006F_01D03FEF.AEB84570"
Content-Language: es
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

------=_NextPart_000_006F_01D03FEF.AEB84570
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Steve,

Maybe you can help me tracking down my other card's problem, as I saw =
you were owner of the (c) in the cx23885 source code.

BR

> -----Mensaje original-----
> De: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] En nombre de dCrypt
> Enviado el: jueves, 29 de enero de 2015 1:11
> Para: linux-media@vger.kernel.org
> CC: stoth@linuxtv.org
> Asunto: RE: [possible BUG, cx23885] Dual tuner TV card, works using =
one
> tuner only, doesn't work if both tuners are used
>=20
> Hi,
>=20
> I have attached four excerpts from /var/log/kern.log with debug=3D9
> option for module cx23885. The test flow is the following:
>=20
> 0) Ubuntu 14.04/kernel 3.13 just installed, latest V4L source code
> compiled and installed Test 1.1)
> 	- Reboot
> 	- sudo tzap -a 0 -x -H -c channelsv3.conf "La 1 HD.", using first
> tuner, it locks and works
> 	- log excerpt extracted -> test1.1-adap0-ok.log
>=20
> Test 1.2)
> 	- sudo tzap -a 1 -x -H -c channelsv3.conf "La 1 HD.", using
> second tuner after first tuner lock, it doesn't lock and doesn't work
> 	- log excerpt extracted -> test1.2-adap1-ko.log
>=20
> Test 2.1)
> 	- Reboot
> 	- sudo tzap -a 1 -x -H -c channelsv3.conf "La 1 HD.", using
> second tuner, it locks and works
> 	- log excerpt extracted -> test2.1-adap1-ok.log
>=20
> Test 2.2)
> 	- sudo tzap -a 0 -x -H -c channelsv3.conf "La 1 HD.", using first
> tuner after second tuner lock, it doesn't lock and doesn't work
> 	- log excerpt extracted -> test2.2-adap0-ko.log
>=20
> From the logs, I interpret that, after one tuner is used and locked =
the
> signal, trying to use the other tuner no IRQs are fired after
> cx23885_start_dma(), so the driver immediately cancels buffers and
> stops dma. However, I am not an expert and I can't follow the full
> workflow, so I could be wrong.
>=20
> I would like to help as much as I can, but I'm afraid I need some
> guidance.
>=20
> BR
>=20
> -----Mensaje original-----
> De: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] En nombre de dCrypt Enviado el: s=C3=A1bado, 17 =
de
> enero de 2015 1:26
> Para: james@ejbdigital.com.au
> CC: linux-media@vger.kernel.org; hverkuil@xs4all.nl
> Asunto: RE: [possible BUG, cx23885] Dual tuner TV card, works using =
one
> tuner only, doesn't work if both tuners are used
>=20
> Hi, James.
>=20
> After searching for somebody posting some issues similar to mine, I
> think this one you posted to the mailing list can be related:
>=20
> https://www.mail-archive.com/linux-
> media%40vger.kernel.org/msg80078.html
>=20
> I'm having problems using both tuners in a dual tuner card (Terratec
> Cinergy T PCIe Dual), also based on cx23885, but it uses different
> frontends/tuners than yours.
>=20
> In summary, my problem is that I started getting signal/locking errors
> in VDR if I tuned one frontend, and VDR scanned EIT/EPG using the
> second tuner in the background; by disabling the second tuner it =
works.
> I managed to reproduce the problem by simply using dvbzap/dvbv5-zap in
> command line. And it suddenly started failing on the 1st of Dec 2014
> (after a frequency change in DVB-T in Spain). I tested different =
Ubuntu
> distros wich previously worked, but I can't manage to make it work now
> using the default kernel included in the Ubuntu ISO image that I had
> installed.
>=20
> I am testing now with Ubuntu 15.04 nightly, kernel 3.18, in a separate
> hw platform. I also tested with MythTV and TVHedaend, but as I managed
> to reproduce it with the dvb command line tools, I don't test any GUI
> anymore. I've also tested it in Windows 7, and it works tuning both
> tuners simultaneously, so I discarded a hardware problem. I've also
> tested with the latest git from the v4l repo by following this guide
> ("basic" approach):
> =
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-
> DVB_Device_Drivers with the same result.
>=20
> My guess is that something in the cx23885 driver does not like the
> current DVB-T signal in Spain. Is it possible that something similar
> happened where you live?
>=20
> The problem is that I don't know how to proceed to debug the issue, so
> any advice is welcome.
>=20
> BR
>=20
> -----Mensaje original-----
> De: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] En nombre de dCrypt Enviado el: viernes, 09 de
> enero de 2015 8:16
> Para: blind Pete
> CC: linux-media@vger.kernel.org
> Asunto: RE: [BUG] Dual tuner TV card, works using one tuner only,
> doesn't work if both tuners are used
>=20
> Hi, blind Pete.
>=20
> Thank you for taking your time to answer.
>=20
> Yes, I tried different kernels focusing con Ubuntu distro. I don't
> remember the exact kernel version, but at least those included by
> default in the Ubuntu 12.04 lts and 14.04 lts ISO image, which worked
> for me. The latest Ubuntu version I tested was the nightly 15.04 from
> the 7th of January.
>=20
> BREl 9/1/2015 4:46, blind Pete <0123peter@gmail.com> escribi=C3=B3:
> >
> > Hi dCrypt,
> >
> > I'm not a developer at all.  I'm not even sure why I read this list,
> > but can you determine if the problem is associated with a particular
> > kernel version?  i.e. if it works on x.y.z but fails on x.y.(z+1) =
you
> > have a starting point.  If you use the word "regression" and a =
kernel
> > version number you might get more attention - but I'm only guessing.
> >
> > Good luck,
> > blind Pete
> >
> > dCrypt wrote:
> >
> > > Hi again,
> > >
> > > I'm sorry if I sound quite rude, but I'm not sure if I am doing it
> > > right or not. I subscribed to this mailing list in order to ask =
for
> > > help, or to help with a bug that I've found (as instructed in the
> > > wiki http://linuxtv.org/wiki/index.php/Bug_Report), but it seems =
to
> > > me that the mailing list is filled up with developing messages. I
> > > don't want to participate in the development, I am a developer but
> I
> > > don't have the skills nor the knowledge.
> > >
> > > If this is not the right place to direct my questions, I would
> > > appreciate some advice.
> > >
> > > Thank you very much, and best regards.
> > >
> > > -----Mensaje original-----
> > > De: linux-media-owner@vger.kernel.org
> > > [mailto:linux-media-owner@vger.kernel.org] En nombre de dCrypt
> > > Enviado el: jueves, 01 de enero de 2015 22:04
> > > Para: linux-media@vger.kernel.org
> > > Asunto: [BUG] Dual tuner TV card, works using one tuner only,
> > > doesn't work if both tuners are used
> > >
> > > Hi,
> > >
> > > I just subscribed to the mailing list to submit information on the
> > > bug which is driving me crazy since one month ago.
> > >
> > > I have a VDR based PVR at home, installed over an Ubuntu 14.04 =
LTS.
> > > Everything was working perfectly, until beginning of December. It
> > > seems to me that something changed that broke my PVR pretty bad.
> > >
> > > The problem is the following: tuning (zap) both tuners (it's not
> > > needed that both are tuned simultaneously, only one after the
> other,
> > > in no particular order) makes the tuners to enter an state where
> > > they can't lock the signal anymore.
> > >
> > > Facts:
> > >
> > > - My TV card is a Cinergy T PCIe Dual from Terratec
> > >
> (http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_T_PCIe_dual).
> > > - The problem arose in the form of "frontend x/0 timed out while
> > > tuning to channel ..." in /var/log/syslog. It happened when both
> > > tuners are active, during EPG scan. The problem does not happen if
> > > VDR is run with -D parameter to limit the number of frontends
> > > enabled. Disabling the EPG scan with both frontends enabled
> > > minimizes the problem, but doesn't solve it because tuning both
> > > frontends without any EPG scan makes the error happen again. - I
> > > initially thought about a problem in the DVB-T signal, because it
> > > all started the 1st of December, during the transition to a new =
set
> of frequencies in Spain.
> > > - Everything was working perfectly before the 1st, and the =
problems
> > > started suddenly.
> > > - I setup testing board for debugging, different board and
> > > processor, less memory, lots of Linux distros tested, Windows
> tested as well.
> > > - Both tuners works in windows without problems. Confirmed.
> > > - I have completely discarded problems/errors in hardware (because
> > > in Windows I can enable both tuners without problems) and VDR
> > > (because I can reproduce the problems at OS level, without even
> having VDR installed).
> > > - I have almost narrowed the problem at the cx23885 driver, =
because
> > > when it happens, I can restart the TV card to working conditions =
by
> > > executing "rmmod cx23885" and "modprobe cx23885"; however, as with
> > > "rmmod" several dependencies are unloaded as well, I am stuck and =
I
> > > am unable to go on with debugging to find out where the problem
> really is.
> > > - Tools used to test and confirm the problem are: VDR, MythTV,
> > > TVHeadend, dvbscan, dvbv5-scan, dvbv5-zap and others
> > > - Linux distros tested: Ubuntu, Fedora, Suse, yaVDR (not sure if
> the
> > > card worked at all), MythBuntu ("dvb-fe-tool -a 1 -c DVBT" was
> > > required to force DVB-T mode for the second tuner), and probably
> > > others
> > > - I have a Sony PlayTV also with dual tuners, which works without
> > > any problem.
> > > http://www.linuxtv.org/wiki/index.php/Sony_PlayTV_dual_tuner_DVB-T
> > >
> > > So, that's why I ask for your help. How can I further debug the
> problem?
> > > Is there something I can do?
> > >
> > > BR, and happy new year!
> > >
> > >
> > > INFO & TEST:
> > >
> > > =
-------------------------------------------------------------------
> ->
> > >
> > > pvr@prueba:~$ sudo lspci -vvv -s 03:00.0 03:00.0 Multimedia video
> > > controller: Conexant Systems, Inc. CX23885 PCI Video and Audio
> > >Decoder  (rev 04)
> > >         Subsystem: TERRATEC Electronic GmbH Cinergy T PCIe Dual
> > >         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- =
VGASnoop-
> > >         ParErr-
> > > Stepping- SERR- FastB2B- DisINTx-
> > >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast
> > >>TAbort-
> > > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > >         Latency: 0, Cache Line Size: 4 bytes
> > >         Interrupt: pin A routed to IRQ 16
> > >         Region 0: Memory at fba00000 (64-bit, non-prefetchable)
> > >[size=3D2M]
> > >         Capabilities: [40] Express (v1) Endpoint, MSI 00
> > >                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency
> > >L0s  <64ns, L1 <1us
> > >                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE-
> > >FLReset-
> > >                 DevCtl: Report errors: Correctable- Non-Fatal-
> > >Fatal-
> > > Unsupported-
> > >                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr-
> NoSnoop+
> > >                         MaxPayload 128 bytes, MaxReadReq 512 bytes
> > >                 DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+
> > >AuxPwr-
> > > TransPend-
> > >                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s
> > >L1,
> > >                 Exit
> > > Latency L0s <2us, L1 <4us
> > >                         ClockPM- Surprise- LLActRep- BwNot-
> > >                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> > >CommClk+
> > >                         ExtSynch- ClockPM- AutWidDis- BWInt-
> > >AutBWInt-
> > >                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
> > >SlotClk+
> > > DLActive- BWMgmt- ABWMgmt-
> > >         Capabilities: [80] Power Management version 2
> > >                 Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=3D0mA
> > > PME(D0+,D1+,D2+,D3hot+,D3cold-)
> > >                 Status: D0 NoSoftRst- PME-Enable- DSel=3D0 =
DScale=3D0
> > >PME-
> > >         Capabilities: [90] Vital Product Data
> > >                 Product Name: "
> > >                 End
> > >         Capabilities: [a0] MSI: Enable- Count=3D1/1 Maskable- =
64bit+
> > >                 Address: 0000000000000000  Data: 0000
> > >         Capabilities: [100 v1] Advanced Error Reporting
> > >                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> > >UnxCmplt-
> > > RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
> > >                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> > >UnxCmplt-
> > > RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> > >                 UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
> > >UnxCmplt-
> > > RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
> > >                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> > > NonFatalErr-
> > >                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> > > NonFatalErr-
> > >                 AERCap: First Error Pointer: 14, GenCap- CGenEn-
> > >ChkCap-
> > > ChkEn-
> > >         Capabilities: [200 v1] Virtual Channel
> > >                 Caps:   LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
> > >                 Arb:    Fixed+ WRR32+ WRR64+ WRR128-
> > >                 Ctrl:   ArbSelect=3DWRR64
> > >                 Status: InProgress-
> > >                 Port Arbitration Table [240] <?>
> > >                 VC0:    Caps:   PATOffset=3D00 MaxTimeSlots=3D1
> > >RejSnoopTrans-
> > >                         Arb:    Fixed- WRR32- WRR64- WRR128-
> > >TWRR128-
> > > WRR256-
> > >                         Ctrl:   Enable+ ID=3D0 ArbSelect=3DFixed
> > >TC/VC=3Dff
> > >                         Status: NegoPending- InProgress-
> > >         Kernel driver in use: cx23885
> > >
> > > =
-------------------------------------------------------------------
> ->
> > >
> > > pvr@prueba:~$ dmesg | grep cx
> > > [   12.812789] cx23885 driver version 0.0.3 loaded [   12.812997]
> > > CORE cx23885[0]: subsystem: 153b:117e, board: TerraTec Cinergy T
> > > PCIe Dual [card=3D34,autodetected] [   12.949340] cx25840 11-0044:
> > > cx23885 A/V decoder found @ 0x88
> > > (cx23885[0])
> > > [   13.723953] cx25840 11-0044: loaded v4l-cx23885-avcore-01.fw
> > > firmware
> > > (16382 bytes)
> > > [   13.739701] cx23885_dvb_register() allocating 1 frontend(s) [
> > > 13.739704] cx23885[0]: cx23885 based dvb card [   13.852565] DVB:
> > > registering new adapter (cx23885[0]) [   13.852569] cx23885
> > > 0000:03:00.0: DVB: registering adapter 0 frontend 0 (DRXK =
DVB-T)...
> > > [   13.852749] cx23885_dvb_register() allocating 1 frontend(s) [
> > > 13.852750] cx23885[0]: cx23885 based dvb card [   13.958613] DVB:
> > > registering new adapter (cx23885[0]) [   13.958618] cx23885
> > > 0000:03:00.0: DVB: registering adapter 1 frontend 0 (DRXK DVB-C
> > > DVB-T)...
> > > [   13.958934] cx23885_dev_checkrevision() Hardware revision =3D =
0xa5
> > > [   13.958939] cx23885[0]/0: found at 0000:03:00.0, rev: 4, irq:
> 16,
> > > latency: 0, mmio: 0xfba00000
> > >
> > > =
-------------------------------------------------------------------
> ->
> > >
> > > pvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c channelsv5.conf -a 0 -x
> > >using  demux '/dev/dvb/adapter0/demux0'
> > > reading channels from file 'channelsv5.conf'
> > > service has pid type 05:  115
> > > tuning to 770000000 Hz
> > >        (0x00) Quality=3D Good Signal=3D 100,00% C/N=3D 11,30dB =
UCB=3D 2
> > >postBER=3D 0  preBER=3D 57,9x10^-6 PER=3D 48,8x10^-6  Lock   (0x1f)
> > >Quality=3D Good Signal=3D 100,00% C/N=3D 11,80dB UCB=3D 3 =
postBER=3D 0
> preBER=3D
> > >55,1x10^-6 PER=3D 0  pvr@prueba:~$  pvr@prueba:~$ sudo dvbv5-zap =
"La 1
> > >HD." -c channelsv5.conf -a 0 -x using  demux
> > >'/dev/dvb/adapter0/demux0'
> > > reading channels from file 'channelsv5.conf'
> > > service has pid type 05:  115
> > > tuning to 770000000 Hz
> > >        (0x00) Quality=3D Good Signal=3D 100,00% C/N=3D 11,80dB =
UCB=3D 3
> > >postBER=3D 0  preBER=3D 63,6x10^-6 PER=3D 56,3x10^-6  Lock   (0x1f)
> > >Quality=3D Good Signal=3D 100,00% C/N=3D 12,20dB UCB=3D 4 =
postBER=3D
> > > 5,39x10^-6 preBER=3D 0 PER=3D 0
> > > pvr@prueba:~$
> > > pvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c channelsv5.conf -a 0 -x
> > >using  demux '/dev/dvb/adapter0/demux0'
> > > reading channels from file 'channelsv5.conf'
> > > service has pid type 05:  115
> > > tuning to 770000000 Hz
> > >        (0x00) Quality=3D Good Signal=3D 100,00% C/N=3D 12,20dB =
UCB=3D 4
> > >postBER=3D
> > > 1,01x10^-6 preBER=3D 58,6x10^-6 PER=3D 61,0x10^-6  Lock   (0x1f)
> > >Quality=3D Good Signal=3D 100,00% C/N=3D 12,10dB UCB=3D 4 =
postBER=3D 0
> preBER=3D
> > >55,1x10^-6 PER=3D 0  pvr@prueba:~$  pvr@prueba:~$ sudo dvbv5-zap =
"La 1
> > >HD." -c channelsv5.conf -a 1 -x using  demux
> > >'/dev/dvb/adapter1/demux0'
> > > reading channels from file 'channelsv5.conf'
> > > service has pid type 05:  115
> > > tuning to 770000000 Hz
> > >        (0x00) Signal=3D 0,00%
> > > Viterbi(0x07) Signal=3D 100,00% C/N=3D 10,00dB
> > > Viterbi(0x07) Signal=3D 100,00% C/N=3D 0,00dB
> > > Viterbi(0x07) Signal=3D 100,00% C/N=3D 0,00dB
> > > Viterbi(0x07) Signal=3D 100,00% C/N=3D 0,00dB
> > > Viterbi(0x07) Signal=3D 100,00% C/N=3D 0,00dB
> > > Viterbi(0x07) Signal=3D 100,00% C/N=3D 0,00dB
> > >
> > > ^Cpvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c channelsv5.conf -a 0 =
-
> x
> > >using  demux '/dev/dvb/adapter0/demux0'
> > > reading channels from file 'channelsv5.conf'
> > > service has pid type 05:  115
> > > tuning to 770000000 Hz
> > >        (0x00) Quality=3D Good Signal=3D 100,00% C/N=3D 12,10dB =
UCB=3D 4
> > >postBER=3D
> > > 850x10^-9 preBER=3D 58,0x10^-6 PER=3D 51,4x10^-6
> > > Viterbi(0x07) Signal=3D 100,00% C/N=3D 0,00dB
> > > Viterbi(0x07) Signal=3D 100,00% C/N=3D 0,00dB
> > > Viterbi(0x07) Signal=3D 100,00% C/N=3D 0,00dB
> > > Viterbi(0x07) Signal=3D 100,00% C/N=3D 8,80dB
> > > Viterbi(0x07) Signal=3D 100,00% C/N=3D 10,00dB
> > >
> > > ^Cpvr@prueba:~$ sudo rmmod cx23885
> > > pvr@prueba:~$ sudo modprobe cx23885  pvr@prueba:~$  pvr@prueba:~$
> > >pvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c channelsv5.conf -a 1 -x
> > >using  demux '/dev/dvb/adapter1/demux0'
> > > reading channels from file 'channelsv5.conf'
> > > service has pid type 05:  115
> > > tuning to 770000000 Hz
> > >        (0x00) Signal=3D 0,00%
> > > Lock   (0x1f) Quality=3D Good Signal=3D 100,00% C/N=3D 10,40dB =
UCB=3D 0
> > >postBER=3D 0  preBER=3D 55,1x10^-6 PER=3D 0  pvr@prueba:~$ sudo =
dvbv5-zap
> > >"La 1 HD." -c channelsv5.conf -a 1 -x using  demux
> > >'/dev/dvb/adapter1/demux0'
> > > reading channels from file 'channelsv5.conf'
> > > service has pid type 05:  115
> > > tuning to 770000000 Hz
> > >        (0x00) Quality=3D Good Signal=3D 100,00% C/N=3D 10,40dB =
UCB=3D 0
> > >postBER=3D 0  preBER=3D 36,7x10^-6 PER=3D 0  Lock   (0x1f) =
Quality=3D Good
> > >Signal=3D 100,00% C/N=3D 11,90dB UCB=3D 1 postBER=3D 0  preBER=3D =
331x10^-6
> > >PER=3D 0  pvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c =
channelsv5.conf -
> a
> > >1 -x using  demux '/dev/dvb/adapter1/demux0'
> > > reading channels from file 'channelsv5.conf'
> > > service has pid type 05:  115
> > > tuning to 770000000 Hz
> > >        (0x00) Quality=3D Good Signal=3D 100,00% C/N=3D 11,90dB =
UCB=3D 1
> > >postBER=3D 0  preBER=3D 175x10^-6 PER=3D 40,7x10^-6  Lock   (0x1f)
> Quality=3D
> > >Good Signal=3D 100,00% C/N=3D 12,30dB UCB=3D 2 postBER=3D 0  =
preBER=3D
> > >55,1x10^-6 PER=3D 0  pvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c
> > >channelsv5.conf -a 0 -x using  demux '/dev/dvb/adapter0/demux0'
> > > reading channels from file 'channelsv5.conf'
> > > service has pid type 05:  115
> > > tuning to 770000000 Hz
> > >        (0x00) Signal=3D 0,00%
> > > Viterbi(0x07) Signal=3D 100,00% C/N=3D 11,60dB
> > > Viterbi(0x07) Signal=3D 100,00% C/N=3D 0,00dB
> > > Viterbi(0x07) Signal=3D 100,00% C/N=3D 0,00dB
> > > Viterbi(0x07) Signal=3D 100,00% C/N=3D 0,00dB
> > >
> > > ^Cpvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c channelsv5.conf -a 1 =
-
> x
> > >using  demux '/dev/dvb/adapter1/demux0'
> > > reading channels from file 'channelsv5.conf'
> > > service has pid type 05:  115
> > > tuning to 770000000 Hz
> > >        (0x00) Quality=3D Good Signal=3D 100,00% C/N=3D 12,30dB =
UCB=3D 2
> > >postBER=3D 0  preBER=3D 138x10^-6 PER=3D 54,3x10^-6
> > > Viterbi(0x07) Signal=3D 100,00% C/N=3D 10,20dB
> > > Viterbi(0x07) Signal=3D 100,00% C/N=3D 11,70dB
> > > Viterbi(0x07) Signal=3D 100,00% C/N=3D 0,00dB
> > > Viterbi(0x07) Signal=3D 100,00% C/N=3D 10,40dB
> > >
> > > ^Cpvr@prueba:~$
> > >
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe
> > > linux-media" in the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at http://vger.kernel.org/majordomo-info.html
> > --
> > blind Pete
> > Sig goes here...
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> media"
> > in the body of a message to majordomo@vger.kernel.org More majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
> N     r  y   b X  =C7=A7v ^ )=DE=BA{.n +    {   bj)   w*jg   =1E     =
=DD=A2j/   z =DE=96  2 =DE=99
> & )=DF=A1 a  =7F  =1E G   h =0F j:+v   w =D9=A5
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

------=_NextPart_000_006F_01D03FEF.AEB84570
Content-Type: application/octet-stream;
	name="test2.2-adap0-ko.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="test2.2-adap0-ko.log"

Jan 28 21:37:29 prueba kernel: [  128.489027] mt2063: detected a mt2063 =
B3=0A=
Jan 28 21:37:29 prueba kernel: [  128.530043] cx23885[0]: =
cx23885_buf_prepare: ffff8800565b8c00=0A=
Jan 28 21:37:29 prueba kernel: [  128.530048] cx23885[0]: =
cx23885_buf_prepare: ffff8800565b8400=0A=
Jan 28 21:37:29 prueba kernel: [  128.530050] cx23885[0]: =
cx23885_buf_prepare: ffff8800565bb400=0A=
Jan 28 21:37:29 prueba kernel: [  128.530051] cx23885[0]: =
cx23885_buf_prepare: ffff8800565bec00=0A=
Jan 28 21:37:29 prueba kernel: [  128.530053] cx23885[0]: =
cx23885_buf_prepare: ffff8800565bc400=0A=
Jan 28 21:37:29 prueba kernel: [  128.530055] cx23885[0]: =
cx23885_buf_prepare: ffff8800565be800=0A=
Jan 28 21:37:29 prueba kernel: [  128.530056] cx23885[0]: =
cx23885_buf_prepare: ffff8800565b8000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530065] cx23885[0]: =
cx23885_buf_prepare: ffff880057021800=0A=
Jan 28 21:37:29 prueba kernel: [  128.530067] cx23885[0]: =
cx23885_buf_prepare: ffff880057022400=0A=
Jan 28 21:37:29 prueba kernel: [  128.530069] cx23885[0]: =
cx23885_buf_prepare: ffff880059799000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530070] cx23885[0]: =
cx23885_buf_prepare: ffff88005979a400=0A=
Jan 28 21:37:29 prueba kernel: [  128.530072] cx23885[0]: =
cx23885_buf_prepare: ffff88005979dc00=0A=
Jan 28 21:37:29 prueba kernel: [  128.530073] cx23885[0]: =
cx23885_buf_prepare: ffff880059798800=0A=
Jan 28 21:37:29 prueba kernel: [  128.530075] cx23885[0]: =
cx23885_buf_prepare: ffff88005979d000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530076] cx23885[0]: =
cx23885_buf_prepare: ffff88005979fc00=0A=
Jan 28 21:37:29 prueba kernel: [  128.530078] cx23885[0]: =
cx23885_buf_prepare: ffff88005979b800=0A=
Jan 28 21:37:29 prueba kernel: [  128.530079] cx23885[0]: =
cx23885_buf_prepare: ffff88005979d800=0A=
Jan 28 21:37:29 prueba kernel: [  128.530081] cx23885[0]: =
cx23885_buf_prepare: ffff880059798000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530082] cx23885[0]: =
cx23885_buf_prepare: ffff88005979f000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530084] cx23885[0]: =
cx23885_buf_prepare: ffff88005979cc00=0A=
Jan 28 21:37:29 prueba kernel: [  128.530086] cx23885[0]: =
cx23885_buf_prepare: ffff880036627c00=0A=
Jan 28 21:37:29 prueba kernel: [  128.530087] cx23885[0]: =
cx23885_buf_prepare: ffff880055da0800=0A=
Jan 28 21:37:29 prueba kernel: [  128.530089] cx23885[0]: =
cx23885_buf_prepare: ffff880055da6400=0A=
Jan 28 21:37:29 prueba kernel: [  128.530090] cx23885[0]: =
cx23885_buf_prepare: ffff880055da3000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530092] cx23885[0]: =
cx23885_buf_prepare: ffff880055da0000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530094] cx23885[0]: =
cx23885_buf_prepare: ffff880055da3c00=0A=
Jan 28 21:37:29 prueba kernel: [  128.530095] cx23885[0]: =
cx23885_buf_prepare: ffff88003684f400=0A=
Jan 28 21:37:29 prueba kernel: [  128.530097] cx23885[0]: =
cx23885_buf_prepare: ffff88003684f000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530098] cx23885[0]: =
cx23885_buf_prepare: ffff88003684ec00=0A=
Jan 28 21:37:29 prueba kernel: [  128.530100] cx23885[0]: =
cx23885_buf_prepare: ffff88003684fc00=0A=
Jan 28 21:37:29 prueba kernel: [  128.530101] cx23885[0]: =
cx23885_buf_prepare: ffff880057033800=0A=
Jan 28 21:37:29 prueba kernel: [  128.530103] cx23885[0]: =
cx23885_buf_prepare: ffff880057037000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530106] cx23885[0]: =
[ffff8800565b8c00/0] cx23885_buf_queue - first active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530107] cx23885[0]: =
[ffff8800565b8400/1] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530108] cx23885[0]: =
[ffff8800565bb400/2] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530109] cx23885[0]: =
[ffff8800565bec00/3] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530111] cx23885[0]: =
[ffff8800565bc400/4] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530112] cx23885[0]: =
[ffff8800565be800/5] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530113] cx23885[0]: =
[ffff8800565b8000/6] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530114] cx23885[0]: =
[ffff880057021800/7] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530115] cx23885[0]: =
[ffff880057022400/8] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530116] cx23885[0]: =
[ffff880059799000/9] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530118] cx23885[0]: =
[ffff88005979a400/10] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530119] cx23885[0]: =
[ffff88005979dc00/11] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530120] cx23885[0]: =
[ffff880059798800/12] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530121] cx23885[0]: =
[ffff88005979d000/13] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530122] cx23885[0]: =
[ffff88005979fc00/14] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530123] cx23885[0]: =
[ffff88005979b800/15] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530124] cx23885[0]: =
[ffff88005979d800/16] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530126] cx23885[0]: =
[ffff880059798000/17] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530127] cx23885[0]: =
[ffff88005979f000/18] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530128] cx23885[0]: =
[ffff88005979cc00/19] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530129] cx23885[0]: =
[ffff880036627c00/20] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530130] cx23885[0]: =
[ffff880055da0800/21] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530132] cx23885[0]: =
[ffff880055da6400/22] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530133] cx23885[0]: =
[ffff880055da3000/23] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530134] cx23885[0]: =
[ffff880055da0000/24] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530135] cx23885[0]: =
[ffff880055da3c00/25] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530136] cx23885[0]: =
[ffff88003684f400/26] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530138] cx23885[0]: =
[ffff88003684f000/27] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530139] cx23885[0]: =
[ffff88003684ec00/28] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530140] cx23885[0]: =
[ffff88003684fc00/29] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530141] cx23885[0]: =
[ffff880057033800/30] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530142] cx23885[0]: =
[ffff880057037000/31] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:29 prueba kernel: [  128.530144] cx23885[0]: =
cx23885_start_dma() w: 0, h: 0, f: 0=0A=
Jan 28 21:37:29 prueba kernel: [  128.530147] cx23885[0]: =
cx23885_sram_channel_setup() Configuring channel [TS1 B]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530149] cx23885[0]: =
cx23885_sram_channel_setup() 0x00010580 <- 0x00005000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530151] cx23885[0]: =
cx23885_sram_channel_setup() 0x00010590 <- 0x000052f0=0A=
Jan 28 21:37:29 prueba kernel: [  128.530152] cx23885[0]: =
cx23885_sram_channel_setup() 0x000105a0 <- 0x000055e0=0A=
Jan 28 21:37:29 prueba kernel: [  128.530153] cx23885[0]: =
cx23885_sram_channel_setup() 0x000105b0 <- 0x000058d0=0A=
Jan 28 21:37:29 prueba kernel: [  128.530154] cx23885[0]: =
cx23885_sram_channel_setup() 0x000105c0 <- 0x00005bc0=0A=
Jan 28 21:37:29 prueba kernel: [  128.530159] cx23885[0]: [bridge 885] =
sram setup TS1 B: bpl=3D752 lines=3D5=0A=
Jan 28 21:37:29 prueba kernel: [  128.530160] cx23885[0]: TS1 B - dma =
channel status dump=0A=
Jan 28 21:37:29 prueba kernel: [  128.530180] cx23885[0]:   cmds: init =
risc lo   : 0x57ec7000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530183] cx23885[0]:   cmds: init =
risc hi   : 0x00000000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530186] cx23885[0]:   cmds: cdt =
base       : 0x00010580=0A=
Jan 28 21:37:29 prueba kernel: [  128.530190] cx23885[0]:   cmds: cdt =
size       : 0x0000000a=0A=
Jan 28 21:37:29 prueba kernel: [  128.530193] cx23885[0]:   cmds: iq =
base        : 0x00010400=0A=
Jan 28 21:37:29 prueba kernel: [  128.530196] cx23885[0]:   cmds: iq =
size        : 0x00000010=0A=
Jan 28 21:37:29 prueba kernel: [  128.530199] cx23885[0]:   cmds: risc =
pc lo     : 0x00000000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530202] cx23885[0]:   cmds: risc =
pc hi     : 0x00000000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530205] cx23885[0]:   cmds: iq wr =
ptr      : 0x00000000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530208] cx23885[0]:   cmds: iq rd =
ptr      : 0x00000000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530211] cx23885[0]:   cmds: cdt =
current    : 0x00000000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530214] cx23885[0]:   cmds: pci =
target lo  : 0x00000000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530217] cx23885[0]:   cmds: pci =
target hi  : 0x00000000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530220] cx23885[0]:   cmds: line / =
byte    : 0x00000000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530224] cx23885[0]:   risc0: =
0x00000000 [ INVALID count=3D0 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530228] cx23885[0]:   risc1: =
0x00000000 [ INVALID count=3D0 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530232] cx23885[0]:   risc2: =
0x00000000 [ INVALID count=3D0 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530235] cx23885[0]:   risc3: =
0x00000000 [ INVALID count=3D0 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530239] cx23885[0]:   (0x00010400) =
iq 0: 0x00000000 [ INVALID count=3D0 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530242] cx23885[0]:   (0x00010404) =
iq 1: 0x1c0002f0 [ write sol eol count=3D752 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530247] cx23885[0]:   iq 2: =
0x55c3cf50 [ arg #1 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530250] cx23885[0]:   iq 3: =
0x00000000 [ arg #2 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530252] cx23885[0]:   (0x00010410) =
iq 4: 0x00000000 [ INVALID count=3D0 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530258] cx23885[0]:   (0x00010414) =
iq 5: 0x1c0002f0 [ write sol eol count=3D752 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530262] cx23885[0]:   iq 6: =
0x55c3c390 [ arg #1 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530265] cx23885[0]:   iq 7: =
0x00000000 [ arg #2 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530268] cx23885[0]:   (0x00010420) =
iq 8: 0x1c0002f0 [ write sol eol count=3D752 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530272] cx23885[0]:   iq 9: =
0x55c3c680 [ arg #1 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530275] cx23885[0]:   iq a: =
0x00000000 [ arg #2 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530278] cx23885[0]:   (0x0001042c) =
iq b: 0x1c0002f0 [ write sol eol count=3D752 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530282] cx23885[0]:   iq c: =
0x55c3c970 [ arg #1 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530285] cx23885[0]:   iq d: =
0x00000000 [ arg #2 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530288] cx23885[0]:   (0x00010438) =
iq e: 0x1c0002f0 [ write sol eol count=3D752 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530292] cx23885[0]:   iq f: =
0x55c3cc60 [ arg #1 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530296] cx23885[0]:   iq 10: =
0x00000000 [ arg #2 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530297] cx23885[0]: fifo: =
0x00005000 -> 0x6000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530298] cx23885[0]: ctrl: =
0x00010400 -> 0x10460=0A=
Jan 28 21:37:29 prueba kernel: [  128.530301] cx23885[0]:   ptr1_reg: =
0x00005000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530304] cx23885[0]:   ptr2_reg: =
0x00010588=0A=
Jan 28 21:37:29 prueba kernel: [  128.530307] cx23885[0]:   cnt1_reg: =
0x00000000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530309] cx23885[0]:   cnt2_reg: =
0x00000009=0A=
Jan 28 21:37:29 prueba kernel: [  128.530310] cx23885[0]: risc disasm: =
ffff880057ec7000 [dma=3D0x57ec7000]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530311] cx23885[0]:   0000: =
0x70000000 [ jump count=3D0 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530313] cx23885[0]:   0001: =
0x57ec700c [ arg #1 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530314] cx23885[0]:   0002: =
0x00000000 [ arg #2 ]=0A=
Jan 28 21:37:29 prueba kernel: [  128.530519] cx23885[0]: =
cx23885_start_dma() enabling TS int's and DMA=0A=
Jan 28 21:37:29 prueba kernel: [  128.530528] cx23885[0]: =
cx23885_tsport_reg_dump() Register Dump=0A=
Jan 28 21:37:29 prueba kernel: [  128.530532] cx23885[0]: =
cx23885_tsport_reg_dump() DEV_CNTRL2               0x00000020=0A=
Jan 28 21:37:29 prueba kernel: [  128.530536] cx23885[0]: =
cx23885_tsport_reg_dump() PCI_INT_MSK              0x00001F06=0A=
Jan 28 21:37:29 prueba kernel: [  128.530539] cx23885[0]: =
cx23885_tsport_reg_dump() AUD_INT_INT_MSK          0x00000000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530542] cx23885[0]: =
cx23885_tsport_reg_dump() AUD_INT_DMA_CTL          0x00000000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530545] cx23885[0]: =
cx23885_tsport_reg_dump() AUD_EXT_INT_MSK          0x00000000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530548] cx23885[0]: =
cx23885_tsport_reg_dump() AUD_EXT_DMA_CTL          0x00000000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530551] cx23885[0]: =
cx23885_tsport_reg_dump() PAD_CTRL                 0x00500300=0A=
Jan 28 21:37:29 prueba kernel: [  128.530554] cx23885[0]: =
cx23885_tsport_reg_dump() ALT_PIN_OUT_SEL          0x00000000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530557] cx23885[0]: =
cx23885_tsport_reg_dump() GPIO2                    0xC7CADA5F=0A=
Jan 28 21:37:29 prueba kernel: [  128.530560] cx23885[0]: =
cx23885_tsport_reg_dump() gpcnt(0x00130120)          0x00000000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530563] cx23885[0]: =
cx23885_tsport_reg_dump() gpcnt_ctl(0x00130134)      0x00000000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530567] cx23885[0]: =
cx23885_tsport_reg_dump() dma_ctl(0x00130140)        0x00000011=0A=
Jan 28 21:37:29 prueba kernel: [  128.530571] cx23885[0]: =
cx23885_tsport_reg_dump() src_sel(0x00130144)        0x00000001=0A=
Jan 28 21:37:29 prueba kernel: [  128.530574] cx23885[0]: =
cx23885_tsport_reg_dump() lngth(0x00130150)          0x000002f0=0A=
Jan 28 21:37:29 prueba kernel: [  128.530577] cx23885[0]: =
cx23885_tsport_reg_dump() hw_sop_ctrl(0x00130154)    0x00470bc0=0A=
Jan 28 21:37:29 prueba kernel: [  128.530580] cx23885[0]: =
cx23885_tsport_reg_dump() gen_ctrl(0x00130158)       0x0000000c=0A=
Jan 28 21:37:29 prueba kernel: [  128.530583] cx23885[0]: =
cx23885_tsport_reg_dump() bd_pkt_status(0x0013015C)  0x00000000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530586] cx23885[0]: =
cx23885_tsport_reg_dump() sop_status(0x00130160)     0x00000000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530589] cx23885[0]: =
cx23885_tsport_reg_dump() fifo_ovfl_stat(0x00130164) 0x00000000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530592] cx23885[0]: =
cx23885_tsport_reg_dump() vld_misc(0x00130168)       0x00000000=0A=
Jan 28 21:37:29 prueba kernel: [  128.530596] cx23885[0]: =
cx23885_tsport_reg_dump() ts_clk_en(0x0013016C)      0x00000001=0A=
Jan 28 21:37:29 prueba kernel: [  128.530599] cx23885[0]: =
cx23885_tsport_reg_dump() ts_int_msk(0x00040030)     0x00001111=0A=
Jan 28 21:37:33 prueba kernel: [  132.287617] cx23885[0]: =
cx23885_cancel_buffers()=0A=
Jan 28 21:37:33 prueba kernel: [  132.287621] cx23885[0]: =
cx23885_stop_dma()=0A=
Jan 28 21:37:33 prueba kernel: [  132.287631] cx23885[0]: =
[ffff8800565b8c00/0] cancel - dma=3D0x57ec7000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287633] cx23885[0]: =
[ffff8800565b8400/1] cancel - dma=3D0x563e8000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287636] cx23885[0]: =
[ffff8800565bb400/2] cancel - dma=3D0x563eb000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287638] cx23885[0]: =
[ffff8800565bec00/3] cancel - dma=3D0x51460000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287640] cx23885[0]: =
[ffff8800565bc400/4] cancel - dma=3D0x5699a000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287642] cx23885[0]: =
[ffff8800565be800/5] cancel - dma=3D0x5144d000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287644] cx23885[0]: =
[ffff8800565b8000/6] cancel - dma=3D0x5725f000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287646] cx23885[0]: =
[ffff880057021800/7] cancel - dma=3D0x585fc000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287649] cx23885[0]: =
[ffff880057022400/8] cancel - dma=3D0x36a01000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287651] cx23885[0]: =
[ffff880059799000/9] cancel - dma=3D0x51462000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287653] cx23885[0]: =
[ffff88005979a400/10] cancel - dma=3D0x57232000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287655] cx23885[0]: =
[ffff88005979dc00/11] cancel - dma=3D0x36b11000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287657] cx23885[0]: =
[ffff880059798800/12] cancel - dma=3D0x51407000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287659] cx23885[0]: =
[ffff88005979d000/13] cancel - dma=3D0x36661000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287661] cx23885[0]: =
[ffff88005979fc00/14] cancel - dma=3D0x3668b000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287663] cx23885[0]: =
[ffff88005979b800/15] cancel - dma=3D0x57d02000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287665] cx23885[0]: =
[ffff88005979d800/16] cancel - dma=3D0x57c75000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287668] cx23885[0]: =
[ffff880059798000/17] cancel - dma=3D0x36b35000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287670] cx23885[0]: =
[ffff88005979f000/18] cancel - dma=3D0x514a4000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287672] cx23885[0]: =
[ffff88005979cc00/19] cancel - dma=3D0x56144000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287674] cx23885[0]: =
[ffff880036627c00/20] cancel - dma=3D0x56243000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287676] cx23885[0]: =
[ffff880055da0800/21] cancel - dma=3D0x56331000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287678] cx23885[0]: =
[ffff880055da6400/22] cancel - dma=3D0x51435000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287680] cx23885[0]: =
[ffff880055da3000/23] cancel - dma=3D0x57207000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287682] cx23885[0]: =
[ffff880055da0000/24] cancel - dma=3D0x57d1d000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287685] cx23885[0]: =
[ffff880055da3c00/25] cancel - dma=3D0x5844b000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287687] cx23885[0]: =
[ffff88003684f400/26] cancel - dma=3D0x560e2000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287689] cx23885[0]: =
[ffff88003684f000/27] cancel - dma=3D0x5777f000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287691] cx23885[0]: =
[ffff88003684ec00/28] cancel - dma=3D0x563be000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287693] cx23885[0]: =
[ffff88003684fc00/29] cancel - dma=3D0x57783000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287695] cx23885[0]: =
[ffff880057033800/30] cancel - dma=3D0x56101000=0A=
Jan 28 21:37:33 prueba kernel: [  132.287697] cx23885[0]: =
[ffff880057037000/31] cancel - dma=3D0x561af000=0A=

------=_NextPart_000_006F_01D03FEF.AEB84570
Content-Type: application/octet-stream;
	name="test1.1-adap0-ok.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="test1.1-adap0-ok.log"

Jan 28 21:34:00 prueba kernel: [ 2146.427014] mt2063: detected a mt2063 =
B3=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468122] cx23885[0]: =
cx23885_buf_prepare: ffff880056823000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468127] cx23885[0]: =
cx23885_buf_prepare: ffff880056825000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468129] cx23885[0]: =
cx23885_buf_prepare: ffff880056821400=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468131] cx23885[0]: =
cx23885_buf_prepare: ffff880056825800=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468132] cx23885[0]: =
cx23885_buf_prepare: ffff880056824400=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468134] cx23885[0]: =
cx23885_buf_prepare: ffff880056822800=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468136] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8c800=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468137] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8b000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468139] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8d800=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468140] cx23885[0]: =
cx23885_buf_prepare: ffff880056f89400=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468142] cx23885[0]: =
cx23885_buf_prepare: ffff880056f89000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468144] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8a800=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468145] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8ac00=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468147] cx23885[0]: =
cx23885_buf_prepare: ffff880056f88400=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468148] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8e400=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468150] cx23885[0]: =
cx23885_buf_prepare: ffff880036875800=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468151] cx23885[0]: =
cx23885_buf_prepare: ffff880055c71c00=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468153] cx23885[0]: =
cx23885_buf_prepare: ffff880055c72000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468155] cx23885[0]: =
cx23885_buf_prepare: ffff880055c75800=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468156] cx23885[0]: =
cx23885_buf_prepare: ffff880055c72800=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468158] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7b400=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468159] cx23885[0]: =
cx23885_buf_prepare: ffff880055c79000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468161] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7c000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468163] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7c400=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468164] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7e400=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468166] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7f000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468167] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7d400=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468169] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7ec00=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468171] cx23885[0]: =
cx23885_buf_prepare: ffff880055c79800=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468172] cx23885[0]: =
cx23885_buf_prepare: ffff880055c78000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468174] cx23885[0]: =
cx23885_buf_prepare: ffff880055c79c00=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468175] cx23885[0]: =
cx23885_buf_prepare: ffff880055c78800=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468178] cx23885[0]: =
[ffff880056823000/0] cx23885_buf_queue - first active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468180] cx23885[0]: =
[ffff880056825000/1] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468181] cx23885[0]: =
[ffff880056821400/2] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468182] cx23885[0]: =
[ffff880056825800/3] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468183] cx23885[0]: =
[ffff880056824400/4] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468185] cx23885[0]: =
[ffff880056822800/5] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468186] cx23885[0]: =
[ffff880056f8c800/6] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468187] cx23885[0]: =
[ffff880056f8b000/7] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468189] cx23885[0]: =
[ffff880056f8d800/8] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468190] cx23885[0]: =
[ffff880056f89400/9] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468191] cx23885[0]: =
[ffff880056f89000/10] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468193] cx23885[0]: =
[ffff880056f8a800/11] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468194] cx23885[0]: =
[ffff880056f8ac00/12] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468195] cx23885[0]: =
[ffff880056f88400/13] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468197] cx23885[0]: =
[ffff880056f8e400/14] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468198] cx23885[0]: =
[ffff880036875800/15] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468199] cx23885[0]: =
[ffff880055c71c00/16] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468200] cx23885[0]: =
[ffff880055c72000/17] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468201] cx23885[0]: =
[ffff880055c75800/18] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468203] cx23885[0]: =
[ffff880055c72800/19] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468204] cx23885[0]: =
[ffff880055c7b400/20] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468205] cx23885[0]: =
[ffff880055c79000/21] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468206] cx23885[0]: =
[ffff880055c7c000/22] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468207] cx23885[0]: =
[ffff880055c7c400/23] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468208] cx23885[0]: =
[ffff880055c7e400/24] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468210] cx23885[0]: =
[ffff880055c7f000/25] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468211] cx23885[0]: =
[ffff880055c7d400/26] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468212] cx23885[0]: =
[ffff880055c7ec00/27] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468213] cx23885[0]: =
[ffff880055c79800/28] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468214] cx23885[0]: =
[ffff880055c78000/29] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468215] cx23885[0]: =
[ffff880055c79c00/30] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468217] cx23885[0]: =
[ffff880055c78800/31] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468218] cx23885[0]: =
cx23885_start_dma() w: 0, h: 0, f: 0=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468222] cx23885[0]: =
cx23885_sram_channel_setup() Configuring channel [TS1 B]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468223] cx23885[0]: =
cx23885_sram_channel_setup() 0x00010580 <- 0x00005000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468225] cx23885[0]: =
cx23885_sram_channel_setup() 0x00010590 <- 0x000052f0=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468226] cx23885[0]: =
cx23885_sram_channel_setup() 0x000105a0 <- 0x000055e0=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468227] cx23885[0]: =
cx23885_sram_channel_setup() 0x000105b0 <- 0x000058d0=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468228] cx23885[0]: =
cx23885_sram_channel_setup() 0x000105c0 <- 0x00005bc0=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468233] cx23885[0]: [bridge 885] =
sram setup TS1 B: bpl=3D752 lines=3D5=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468234] cx23885[0]: TS1 B - dma =
channel status dump=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468241] cx23885[0]:   cmds: init =
risc lo   : 0x56fad000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468244] cx23885[0]:   cmds: init =
risc hi   : 0x00000000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468247] cx23885[0]:   cmds: cdt =
base       : 0x00010580=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468250] cx23885[0]:   cmds: cdt =
size       : 0x0000000a=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468253] cx23885[0]:   cmds: iq =
base        : 0x00010400=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468256] cx23885[0]:   cmds: iq =
size        : 0x00000010=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468259] cx23885[0]:   cmds: risc =
pc lo     : 0x00000000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468263] cx23885[0]:   cmds: risc =
pc hi     : 0x00000000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468266] cx23885[0]:   cmds: iq wr =
ptr      : 0x00000000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468269] cx23885[0]:   cmds: iq rd =
ptr      : 0x00000000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468272] cx23885[0]:   cmds: cdt =
current    : 0x00000000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468275] cx23885[0]:   cmds: pci =
target lo  : 0x00000000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468278] cx23885[0]:   cmds: pci =
target hi  : 0x00000000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468281] cx23885[0]:   cmds: line / =
byte    : 0x00000000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468284] cx23885[0]:   risc0: =
0x00000000 [ INVALID count=3D0 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468288] cx23885[0]:   risc1: =
0x00000000 [ INVALID count=3D0 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468291] cx23885[0]:   risc2: =
0x00000000 [ INVALID count=3D0 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468295] cx23885[0]:   risc3: =
0x00000000 [ INVALID count=3D0 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468299] cx23885[0]:   (0x00010400) =
iq 0: 0x56a46c10 [ writec eol irq2 23 21 18 14 13 count=3D3088 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468305] cx23885[0]:   (0x00010404) =
iq 1: 0x00000000 [ INVALID count=3D0 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468308] cx23885[0]:   (0x00010408) =
iq 2: 0x1c0002f0 [ write sol eol count=3D752 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468313] cx23885[0]:   iq 3: =
0x56a46f00 [ arg #1 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468316] cx23885[0]:   iq 4: =
0x00000000 [ arg #2 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468319] cx23885[0]:   (0x00010414) =
iq 5: 0x1c0002f0 [ write sol eol count=3D752 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468323] cx23885[0]:   iq 6: =
0x56a471f0 [ arg #1 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468326] cx23885[0]:   iq 7: =
0x00000000 [ arg #2 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468329] cx23885[0]:   (0x00010420) =
iq 8: 0x00000000 [ INVALID count=3D0 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468333] cx23885[0]:   (0x00010424) =
iq 9: 0x1c0002f0 [ write sol eol count=3D752 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468337] cx23885[0]:   iq a: =
0x56a46630 [ arg #1 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468340] cx23885[0]:   iq b: =
0x00000000 [ arg #2 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468343] cx23885[0]:   (0x00010430) =
iq c: 0x1c0002f0 [ write sol eol count=3D752 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468347] cx23885[0]:   iq d: =
0x56a46920 [ arg #1 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468350] cx23885[0]:   iq e: =
0x00000000 [ arg #2 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468352] cx23885[0]:   (0x0001043c) =
iq f: 0x1c0002f0 [ write sol eol count=3D752 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468357] cx23885[0]:   iq 10: =
0x1c0002f0 [ arg #1 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468360] cx23885[0]:   iq 11: =
0x569600a0 [ arg #2 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468361] cx23885[0]: fifo: =
0x00005000 -> 0x6000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468362] cx23885[0]: ctrl: =
0x00010400 -> 0x10460=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468367] cx23885[0]:   ptr1_reg: =
0x00005000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468371] cx23885[0]:   ptr2_reg: =
0x00010588=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468373] cx23885[0]:   cnt1_reg: =
0x00000000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468376] cx23885[0]:   cnt2_reg: =
0x00000009=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468377] cx23885[0]: risc disasm: =
ffff880056fad000 [dma=3D0x56fad000]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468378] cx23885[0]:   0000: =
0x70000000 [ jump count=3D0 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468380] cx23885[0]:   0001: =
0x56fad00c [ arg #1 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468381] cx23885[0]:   0002: =
0x00000000 [ arg #2 ]=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468586] cx23885[0]: =
cx23885_start_dma() enabling TS int's and DMA=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468595] cx23885[0]: =
cx23885_tsport_reg_dump() Register Dump=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468598] cx23885[0]: =
cx23885_tsport_reg_dump() DEV_CNTRL2               0x00000020=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468602] cx23885[0]: =
cx23885_tsport_reg_dump() PCI_INT_MSK              0x00001F02=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468604] cx23885[0]: =
cx23885_tsport_reg_dump() AUD_INT_INT_MSK          0x00000000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468607] cx23885[0]: =
cx23885_tsport_reg_dump() AUD_INT_DMA_CTL          0x00000000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468611] cx23885[0]: =
cx23885_tsport_reg_dump() AUD_EXT_INT_MSK          0x00000000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468615] cx23885[0]: =
cx23885_tsport_reg_dump() AUD_EXT_DMA_CTL          0x00000000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468618] cx23885[0]: =
cx23885_tsport_reg_dump() PAD_CTRL                 0x00500300=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468621] cx23885[0]: =
cx23885_tsport_reg_dump() ALT_PIN_OUT_SEL          0x00000000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468624] cx23885[0]: =
cx23885_tsport_reg_dump() GPIO2                    0xC7CADA5F=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468627] cx23885[0]: =
cx23885_tsport_reg_dump() gpcnt(0x00130120)          0x00000000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468630] cx23885[0]: =
cx23885_tsport_reg_dump() gpcnt_ctl(0x00130134)      0x00000000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468633] cx23885[0]: =
cx23885_tsport_reg_dump() dma_ctl(0x00130140)        0x00000011=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468637] cx23885[0]: =
cx23885_tsport_reg_dump() src_sel(0x00130144)        0x00000001=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468640] cx23885[0]: =
cx23885_tsport_reg_dump() lngth(0x00130150)          0x000002f0=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468643] cx23885[0]: =
cx23885_tsport_reg_dump() hw_sop_ctrl(0x00130154)    0x00470bc0=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468647] cx23885[0]: =
cx23885_tsport_reg_dump() gen_ctrl(0x00130158)       0x0000000c=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468650] cx23885[0]: =
cx23885_tsport_reg_dump() bd_pkt_status(0x0013015C)  0x00000000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468653] cx23885[0]: =
cx23885_tsport_reg_dump() sop_status(0x00130160)     0x00000000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468656] cx23885[0]: =
cx23885_tsport_reg_dump() fifo_ovfl_stat(0x00130164) 0x00000000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468659] cx23885[0]: =
cx23885_tsport_reg_dump() vld_misc(0x00130168)       0x00000000=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468662] cx23885[0]: =
cx23885_tsport_reg_dump() ts_clk_en(0x0013016C)      0x00000001=0A=
Jan 28 21:34:00 prueba kernel: [ 2146.468666] cx23885[0]: =
cx23885_tsport_reg_dump() ts_int_msk(0x00040030)     0x00001111=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.908018] cx23885[0]: pci_status: =
0x003f8002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.908022] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.908024] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.908026] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x1=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.908028] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.908029] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.908031] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.908036] cx23885[0]: =
[ffff880056823000/0] wakeup reg=3D1 buf=3D1=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.908075] cx23885[0]: =
cx23885_buf_prepare: ffff880056823000=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.908080] cx23885[0]: =
[ffff880056823000/0] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.917496] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.917500] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.917502] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.917504] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x2=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.917506] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.917508] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.917509] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.917514] cx23885[0]: =
[ffff880056825000/1] wakeup reg=3D2 buf=3D2=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.917540] cx23885[0]: =
cx23885_buf_prepare: ffff880056825000=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.917546] cx23885[0]: =
[ffff880056825000/1] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.927288] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.927293] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.927295] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.927297] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x3=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.927298] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.927300] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.927301] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.927306] cx23885[0]: =
[ffff880056821400/2] wakeup reg=3D3 buf=3D3=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.927332] cx23885[0]: =
cx23885_buf_prepare: ffff880056821400=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.927338] cx23885[0]: =
[ffff880056821400/2] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.936753] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.936757] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.936759] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.936761] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x4=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.936763] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.936764] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.936766] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.936770] cx23885[0]: =
[ffff880056825800/3] wakeup reg=3D4 buf=3D4=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.936796] cx23885[0]: =
cx23885_buf_prepare: ffff880056825800=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.936801] cx23885[0]: =
[ffff880056825800/3] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.946559] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.946563] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.946565] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.946567] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x5=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.946569] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.946570] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.946572] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.946577] cx23885[0]: =
[ffff880056824400/4] wakeup reg=3D5 buf=3D5=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.946602] cx23885[0]: =
cx23885_buf_prepare: ffff880056824400=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.946608] cx23885[0]: =
[ffff880056824400/4] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.956366] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.956371] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.956373] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.956375] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x6=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.956376] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.956378] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.956380] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.956384] cx23885[0]: =
[ffff880056822800/5] wakeup reg=3D6 buf=3D6=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.956410] cx23885[0]: =
cx23885_buf_prepare: ffff880056822800=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.956415] cx23885[0]: =
[ffff880056822800/5] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.965992] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.965997] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.965999] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.966000] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x7=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.966002] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.966004] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.966005] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.966010] cx23885[0]: =
[ffff880056f8c800/6] wakeup reg=3D7 buf=3D7=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.966036] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8c800=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.966041] cx23885[0]: =
[ffff880056f8c800/6] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.975723] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.975727] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.975730] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.975731] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x8=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.975733] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.975735] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.975736] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.975741] cx23885[0]: =
[ffff880056f8b000/7] wakeup reg=3D8 buf=3D8=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.975767] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8b000=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.975772] cx23885[0]: =
[ffff880056f8b000/7] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.985507] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.985511] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.985513] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.985515] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x9=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.985517] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.985518] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.985520] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.985525] cx23885[0]: =
[ffff880056f8d800/8] wakeup reg=3D9 buf=3D9=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.985550] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8d800=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.985556] cx23885[0]: =
[ffff880056f8d800/8] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.995467] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.995471] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.995473] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.995475] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0xa=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.995477] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.995478] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.995480] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.995485] cx23885[0]: =
[ffff880056f89400/9] wakeup reg=3D10 buf=3D10=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.995511] cx23885[0]: =
cx23885_buf_prepare: ffff880056f89400=0A=
Jan 28 21:34:01 prueba kernel: [ 2146.995516] cx23885[0]: =
[ffff880056f89400/9] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.005184] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.005189] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.005191] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.005193] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0xb=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.005194] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.005196] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.005197] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.005202] cx23885[0]: =
[ffff880056f89000/10] wakeup reg=3D11 buf=3D11=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.005228] cx23885[0]: =
cx23885_buf_prepare: ffff880056f89000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.005234] cx23885[0]: =
[ffff880056f89000/10] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.014715] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.014719] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.014721] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.014723] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0xc=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.014725] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.014726] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.014728] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.014733] cx23885[0]: =
[ffff880056f8a800/11] wakeup reg=3D12 buf=3D12=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.014758] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8a800=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.014764] cx23885[0]: =
[ffff880056f8a800/11] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.024287] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.024292] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.024294] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.024295] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0xd=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.024297] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.024299] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.024300] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.024305] cx23885[0]: =
[ffff880056f8ac00/12] wakeup reg=3D13 buf=3D13=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.024331] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8ac00=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.024336] cx23885[0]: =
[ffff880056f8ac00/12] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.033907] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.033911] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.033914] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.033915] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0xe=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.033917] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.033919] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.033920] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.033925] cx23885[0]: =
[ffff880056f88400/13] wakeup reg=3D14 buf=3D14=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.033951] cx23885[0]: =
cx23885_buf_prepare: ffff880056f88400=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.033956] cx23885[0]: =
[ffff880056f88400/13] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.043645] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.043649] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.043652] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.043653] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0xf=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.043655] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.043657] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.043658] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.043663] cx23885[0]: =
[ffff880056f8e400/14] wakeup reg=3D15 buf=3D15=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.043689] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8e400=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.043694] cx23885[0]: =
[ffff880056f8e400/14] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.053366] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.053370] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.053372] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.053374] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x10=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.053376] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.053377] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.053379] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.053384] cx23885[0]: =
[ffff880036875800/15] wakeup reg=3D16 buf=3D16=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.053409] cx23885[0]: =
cx23885_buf_prepare: ffff880036875800=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.053415] cx23885[0]: =
[ffff880036875800/15] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.063073] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.063077] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.063080] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.063081] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x11=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.063083] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.063085] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.063086] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.063091] cx23885[0]: =
[ffff880055c71c00/16] wakeup reg=3D17 buf=3D17=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.063116] cx23885[0]: =
cx23885_buf_prepare: ffff880055c71c00=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.063122] cx23885[0]: =
[ffff880055c71c00/16] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.072762] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.072766] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.072768] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.072770] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x12=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.072772] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.072774] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.072775] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.072780] cx23885[0]: =
[ffff880055c72000/17] wakeup reg=3D18 buf=3D18=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.072806] cx23885[0]: =
cx23885_buf_prepare: ffff880055c72000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.072811] cx23885[0]: =
[ffff880055c72000/17] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.082464] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.082468] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.082470] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.082472] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x13=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.082474] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.082475] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.082477] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.082482] cx23885[0]: =
[ffff880055c75800/18] wakeup reg=3D19 buf=3D19=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.082507] cx23885[0]: =
cx23885_buf_prepare: ffff880055c75800=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.082513] cx23885[0]: =
[ffff880055c75800/18] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.092152] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.092157] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.092159] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.092161] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x14=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.092163] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.092164] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.092166] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.092170] cx23885[0]: =
[ffff880055c72800/19] wakeup reg=3D20 buf=3D20=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.092196] cx23885[0]: =
cx23885_buf_prepare: ffff880055c72800=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.092201] cx23885[0]: =
[ffff880055c72800/19] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.101837] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.101841] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.101843] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.101845] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x15=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.101847] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.101848] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.101850] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.101855] cx23885[0]: =
[ffff880055c7b400/20] wakeup reg=3D21 buf=3D21=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.101881] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7b400=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.101886] cx23885[0]: =
[ffff880055c7b400/20] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.111516] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.111521] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.111523] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.111525] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x16=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.111527] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.111528] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.111530] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.111534] cx23885[0]: =
[ffff880055c79000/21] wakeup reg=3D22 buf=3D22=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.111561] cx23885[0]: =
cx23885_buf_prepare: ffff880055c79000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.111566] cx23885[0]: =
[ffff880055c79000/21] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.121201] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.121205] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.121207] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.121209] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x17=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.121211] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.121212] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.121214] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.121219] cx23885[0]: =
[ffff880055c7c000/22] wakeup reg=3D23 buf=3D23=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.121245] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7c000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.121250] cx23885[0]: =
[ffff880055c7c000/22] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.130879] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.130883] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.130885] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.130887] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x18=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.130889] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.130891] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.130892] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.130897] cx23885[0]: =
[ffff880055c7c400/23] wakeup reg=3D24 buf=3D24=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.130922] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7c400=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.130928] cx23885[0]: =
[ffff880055c7c400/23] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.140560] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.140564] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.140566] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.140568] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x19=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.140570] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.140571] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.140573] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.140578] cx23885[0]: =
[ffff880055c7e400/24] wakeup reg=3D25 buf=3D25=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.140603] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7e400=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.140609] cx23885[0]: =
[ffff880055c7e400/24] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.150266] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.150271] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.150273] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.150275] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x1a=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.150276] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.150278] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.150279] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.150284] cx23885[0]: =
[ffff880055c7f000/25] wakeup reg=3D26 buf=3D26=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.150310] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7f000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.150315] cx23885[0]: =
[ffff880055c7f000/25] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.159977] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.159982] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.159984] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.159986] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x1b=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.159988] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.159989] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.159991] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.159996] cx23885[0]: =
[ffff880055c7d400/26] wakeup reg=3D27 buf=3D27=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.160021] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7d400=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.160027] cx23885[0]: =
[ffff880055c7d400/26] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.169668] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.169672] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.169675] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.169676] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x1c=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.169678] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.169680] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.169681] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.169686] cx23885[0]: =
[ffff880055c7ec00/27] wakeup reg=3D28 buf=3D28=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.169712] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7ec00=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.169717] cx23885[0]: =
[ffff880055c7ec00/27] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.179377] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.179382] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.179384] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.179386] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x1d=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.179388] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.179389] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.179391] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.179395] cx23885[0]: =
[ffff880055c79800/28] wakeup reg=3D29 buf=3D29=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.179421] cx23885[0]: =
cx23885_buf_prepare: ffff880055c79800=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.179427] cx23885[0]: =
[ffff880055c79800/28] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.189067] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.189072] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.189074] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.189076] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x1e=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.189078] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.189079] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.189081] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.189086] cx23885[0]: =
[ffff880055c78000/29] wakeup reg=3D30 buf=3D30=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.189111] cx23885[0]: =
cx23885_buf_prepare: ffff880055c78000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.189117] cx23885[0]: =
[ffff880055c78000/29] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.198753] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.198757] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.198760] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.198761] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x1f=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.198763] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.198765] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.198766] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.198771] cx23885[0]: =
[ffff880055c79c00/30] wakeup reg=3D31 buf=3D31=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.198797] cx23885[0]: =
cx23885_buf_prepare: ffff880055c79c00=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.198802] cx23885[0]: =
[ffff880055c79c00/30] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.208434] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.208438] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.208440] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.208442] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x20=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.208444] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.208446] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.208447] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.208452] cx23885[0]: =
[ffff880055c78800/31] wakeup reg=3D32 buf=3D32=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.208478] cx23885[0]: =
cx23885_buf_prepare: ffff880055c78800=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.208483] cx23885[0]: =
[ffff880055c78800/31] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.218109] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.218114] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.218116] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.218118] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x21=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.218119] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.218121] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.218123] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.218127] cx23885[0]: =
[ffff880056823000/0] wakeup reg=3D33 buf=3D33=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.218153] cx23885[0]: =
cx23885_buf_prepare: ffff880056823000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.218158] cx23885[0]: =
[ffff880056823000/0] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.227797] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.227802] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.227804] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.227806] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x22=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.227807] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.227809] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.227811] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.227815] cx23885[0]: =
[ffff880056825000/1] wakeup reg=3D34 buf=3D34=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.227841] cx23885[0]: =
cx23885_buf_prepare: ffff880056825000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.227846] cx23885[0]: =
[ffff880056825000/1] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.237476] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.237481] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.237483] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.237485] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x23=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.237487] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.237488] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.237490] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.237495] cx23885[0]: =
[ffff880056821400/2] wakeup reg=3D35 buf=3D35=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.237520] cx23885[0]: =
cx23885_buf_prepare: ffff880056821400=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.237525] cx23885[0]: =
[ffff880056821400/2] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.247155] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.247159] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.247161] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.247163] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x24=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.247165] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.247166] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.247168] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.247173] cx23885[0]: =
[ffff880056825800/3] wakeup reg=3D36 buf=3D36=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.247198] cx23885[0]: =
cx23885_buf_prepare: ffff880056825800=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.247204] cx23885[0]: =
[ffff880056825800/3] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.256805] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.256809] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.256811] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.256813] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x25=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.256815] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.256816] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.256818] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.256823] cx23885[0]: =
[ffff880056824400/4] wakeup reg=3D37 buf=3D37=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.256849] cx23885[0]: =
cx23885_buf_prepare: ffff880056824400=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.256854] cx23885[0]: =
[ffff880056824400/4] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.266513] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.266518] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.266520] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.266522] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x26=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.266523] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.266525] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.266527] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.266531] cx23885[0]: =
[ffff880056822800/5] wakeup reg=3D38 buf=3D38=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.266557] cx23885[0]: =
cx23885_buf_prepare: ffff880056822800=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.266562] cx23885[0]: =
[ffff880056822800/5] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.276191] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.276196] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.276198] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.276200] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x27=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.276202] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.276203] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.276205] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.276210] cx23885[0]: =
[ffff880056f8c800/6] wakeup reg=3D39 buf=3D39=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.276235] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8c800=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.276240] cx23885[0]: =
[ffff880056f8c800/6] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.285869] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.285873] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.285876] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.285878] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x28=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.285879] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.285881] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.285882] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.285887] cx23885[0]: =
[ffff880056f8b000/7] wakeup reg=3D40 buf=3D40=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.285913] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8b000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.285918] cx23885[0]: =
[ffff880056f8b000/7] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.295545] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.295550] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.295552] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.295554] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x29=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.295555] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.295557] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.295559] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.295563] cx23885[0]: =
[ffff880056f8d800/8] wakeup reg=3D41 buf=3D41=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.295589] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8d800=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.295594] cx23885[0]: =
[ffff880056f8d800/8] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.305223] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.305227] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.305229] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.305231] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x2a=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.305233] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.305234] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.305236] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.305241] cx23885[0]: =
[ffff880056f89400/9] wakeup reg=3D42 buf=3D42=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.305266] cx23885[0]: =
cx23885_buf_prepare: ffff880056f89400=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.305272] cx23885[0]: =
[ffff880056f89400/9] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.314901] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.314905] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.314908] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.314909] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x2b=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.314911] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.314913] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.314914] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.314919] cx23885[0]: =
[ffff880056f89000/10] wakeup reg=3D43 buf=3D43=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.314945] cx23885[0]: =
cx23885_buf_prepare: ffff880056f89000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.314951] cx23885[0]: =
[ffff880056f89000/10] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.324580] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.324584] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.324586] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.324588] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x2c=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.324590] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.324592] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.324593] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.324598] cx23885[0]: =
[ffff880056f8a800/11] wakeup reg=3D44 buf=3D44=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.324623] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8a800=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.324629] cx23885[0]: =
[ffff880056f8a800/11] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.334255] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.334259] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.334261] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.334263] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x2d=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.334265] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.334266] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.334268] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.334273] cx23885[0]: =
[ffff880056f8ac00/12] wakeup reg=3D45 buf=3D45=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.334298] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8ac00=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.334303] cx23885[0]: =
[ffff880056f8ac00/12] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.343934] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.343938] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.343940] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.343942] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x2e=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.343944] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.343945] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.343947] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.343952] cx23885[0]: =
[ffff880056f88400/13] wakeup reg=3D46 buf=3D46=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.343978] cx23885[0]: =
cx23885_buf_prepare: ffff880056f88400=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.343983] cx23885[0]: =
[ffff880056f88400/13] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.353614] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.353618] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.353621] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.353622] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x2f=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.353624] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.353626] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.353627] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.353632] cx23885[0]: =
[ffff880056f8e400/14] wakeup reg=3D47 buf=3D47=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.353658] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8e400=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.353663] cx23885[0]: =
[ffff880056f8e400/14] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.363291] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.363296] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.363298] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.363300] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x30=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.363301] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.363303] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.363304] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.363309] cx23885[0]: =
[ffff880036875800/15] wakeup reg=3D48 buf=3D48=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.363335] cx23885[0]: =
cx23885_buf_prepare: ffff880036875800=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.363341] cx23885[0]: =
[ffff880036875800/15] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.372969] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.372973] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.372975] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.372977] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x31=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.372979] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.372980] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.372982] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.372987] cx23885[0]: =
[ffff880055c71c00/16] wakeup reg=3D49 buf=3D49=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.373013] cx23885[0]: =
cx23885_buf_prepare: ffff880055c71c00=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.373019] cx23885[0]: =
[ffff880055c71c00/16] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.382646] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.382650] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.382652] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.382654] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x32=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.382656] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.382657] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.382659] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.382664] cx23885[0]: =
[ffff880055c72000/17] wakeup reg=3D50 buf=3D50=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.382690] cx23885[0]: =
cx23885_buf_prepare: ffff880055c72000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.382696] cx23885[0]: =
[ffff880055c72000/17] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.392324] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.392328] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.392330] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.392332] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x33=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.392334] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.392336] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.392337] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.392342] cx23885[0]: =
[ffff880055c75800/18] wakeup reg=3D51 buf=3D51=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.392368] cx23885[0]: =
cx23885_buf_prepare: ffff880055c75800=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.392373] cx23885[0]: =
[ffff880055c75800/18] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.402002] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.402006] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.402008] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.402010] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x34=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.402012] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.402014] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.402015] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.402020] cx23885[0]: =
[ffff880055c72800/19] wakeup reg=3D52 buf=3D52=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.402046] cx23885[0]: =
cx23885_buf_prepare: ffff880055c72800=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.402051] cx23885[0]: =
[ffff880055c72800/19] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.411680] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.411684] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.411686] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.411688] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x35=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.411690] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.411691] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.411693] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.411698] cx23885[0]: =
[ffff880055c7b400/20] wakeup reg=3D53 buf=3D53=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.411723] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7b400=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.411729] cx23885[0]: =
[ffff880055c7b400/20] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.421357] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.421361] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.421364] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.421365] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x36=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.421367] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.421369] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.421370] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.421375] cx23885[0]: =
[ffff880055c79000/21] wakeup reg=3D54 buf=3D54=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.421401] cx23885[0]: =
cx23885_buf_prepare: ffff880055c79000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.421406] cx23885[0]: =
[ffff880055c79000/21] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.431032] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.431036] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.431039] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.431040] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x37=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.431042] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.431044] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.431045] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.431050] cx23885[0]: =
[ffff880055c7c000/22] wakeup reg=3D55 buf=3D55=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.431076] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7c000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.431082] cx23885[0]: =
[ffff880055c7c000/22] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.440680] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.440685] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.440687] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.440689] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x38=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.440691] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.440692] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.440694] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.440699] cx23885[0]: =
[ffff880055c7c400/23] wakeup reg=3D56 buf=3D56=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.440724] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7c400=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.440730] cx23885[0]: =
[ffff880055c7c400/23] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.450390] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.450394] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.450396] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.450398] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x39=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.450400] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.450401] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.450403] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.450408] cx23885[0]: =
[ffff880055c7e400/24] wakeup reg=3D57 buf=3D57=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.450434] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7e400=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.450439] cx23885[0]: =
[ffff880055c7e400/24] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.460065] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.460069] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.460071] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.460073] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x3a=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.460075] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.460077] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.460078] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.460083] cx23885[0]: =
[ffff880055c7f000/25] wakeup reg=3D58 buf=3D58=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.460109] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7f000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.460115] cx23885[0]: =
[ffff880055c7f000/25] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.469745] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.469749] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.469751] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.469753] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x3b=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.469755] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.469756] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.469758] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.469763] cx23885[0]: =
[ffff880055c7d400/26] wakeup reg=3D59 buf=3D59=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.469788] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7d400=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.469794] cx23885[0]: =
[ffff880055c7d400/26] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.479422] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.479426] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.479428] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.479430] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x3c=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.479432] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.479434] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.479435] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.479440] cx23885[0]: =
[ffff880055c7ec00/27] wakeup reg=3D60 buf=3D60=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.479466] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7ec00=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.479471] cx23885[0]: =
[ffff880055c7ec00/27] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.489081] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.489085] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.489087] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.489089] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x3d=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.489091] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.489093] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.489094] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.489099] cx23885[0]: =
[ffff880055c79800/28] wakeup reg=3D61 buf=3D61=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.489124] cx23885[0]: =
cx23885_buf_prepare: ffff880055c79800=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.489130] cx23885[0]: =
[ffff880055c79800/28] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.498778] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.498782] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.498784] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.498786] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x3e=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.498788] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.498790] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.498791] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.498796] cx23885[0]: =
[ffff880055c78000/29] wakeup reg=3D62 buf=3D62=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.498821] cx23885[0]: =
cx23885_buf_prepare: ffff880055c78000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.498826] cx23885[0]: =
[ffff880055c78000/29] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.508455] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.508459] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.508461] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.508463] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x3f=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.508465] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.508466] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.508468] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.508473] cx23885[0]: =
[ffff880055c79c00/30] wakeup reg=3D63 buf=3D63=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.508498] cx23885[0]: =
cx23885_buf_prepare: ffff880055c79c00=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.508503] cx23885[0]: =
[ffff880055c79c00/30] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.518133] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.518137] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.518139] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.518141] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x40=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.518143] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.518144] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.518146] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.518151] cx23885[0]: =
[ffff880055c78800/31] wakeup reg=3D64 buf=3D64=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.518176] cx23885[0]: =
cx23885_buf_prepare: ffff880055c78800=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.518181] cx23885[0]: =
[ffff880055c78800/31] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.527811] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.527815] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.527817] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.527819] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x41=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.527821] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.527822] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.527824] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.527829] cx23885[0]: =
[ffff880056823000/0] wakeup reg=3D65 buf=3D65=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.527854] cx23885[0]: =
cx23885_buf_prepare: ffff880056823000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.527859] cx23885[0]: =
[ffff880056823000/0] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.537487] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.537492] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.537494] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.537496] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x42=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.537497] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.537499] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.537501] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.537505] cx23885[0]: =
[ffff880056825000/1] wakeup reg=3D66 buf=3D66=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.537531] cx23885[0]: =
cx23885_buf_prepare: ffff880056825000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.537536] cx23885[0]: =
[ffff880056825000/1] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.547167] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.547171] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.547173] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.547175] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x43=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.547177] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.547178] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.547180] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.547185] cx23885[0]: =
[ffff880056821400/2] wakeup reg=3D67 buf=3D67=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.547210] cx23885[0]: =
cx23885_buf_prepare: ffff880056821400=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.547216] cx23885[0]: =
[ffff880056821400/2] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.556841] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.556846] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.556848] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.556850] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x44=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.556851] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.556853] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.556855] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.556859] cx23885[0]: =
[ffff880056825800/3] wakeup reg=3D68 buf=3D68=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.556885] cx23885[0]: =
cx23885_buf_prepare: ffff880056825800=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.556890] cx23885[0]: =
[ffff880056825800/3] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.566522] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.566526] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.566529] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.566531] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x45=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.566532] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.566534] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.566535] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.566540] cx23885[0]: =
[ffff880056824400/4] wakeup reg=3D69 buf=3D69=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.566565] cx23885[0]: =
cx23885_buf_prepare: ffff880056824400=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.566571] cx23885[0]: =
[ffff880056824400/4] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.576199] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.576204] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.576206] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.576208] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x46=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.576210] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.576211] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.576213] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.576217] cx23885[0]: =
[ffff880056822800/5] wakeup reg=3D70 buf=3D70=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.576243] cx23885[0]: =
cx23885_buf_prepare: ffff880056822800=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.576248] cx23885[0]: =
[ffff880056822800/5] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.585852] cx23885[0]: pci_status: =
0x00008002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.585857] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.585859] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.585861] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x47=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.585863] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.585864] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.585866] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.585871] cx23885[0]: =
[ffff880056f8c800/6] wakeup reg=3D71 buf=3D71=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.585896] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8c800=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.585901] cx23885[0]: =
[ffff880056f8c800/6] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.595518] cx23885[0]: pci_status: =
0x00038002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.595522] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.595524] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.595526] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x48=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.595528] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.595529] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.595531] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.595536] cx23885[0]: =
[ffff880056f8b000/7] wakeup reg=3D72 buf=3D72=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.595563] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8b000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.595568] cx23885[0]: =
[ffff880056f8b000/7] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.605196] cx23885[0]: pci_status: =
0x00038002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.605201] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.605203] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.605205] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x49=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.605207] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.605208] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.605210] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.605215] cx23885[0]: =
[ffff880056f8d800/8] wakeup reg=3D73 buf=3D73=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.605242] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8d800=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.605247] cx23885[0]: =
[ffff880056f8d800/8] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.614870] cx23885[0]: pci_status: =
0x00038002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.614873] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.614874] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.614875] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x4a=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.614877] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.614877] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.614878] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.614882] cx23885[0]: =
[ffff880056f89400/9] wakeup reg=3D74 buf=3D74=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.614898] cx23885[0]: =
cx23885_buf_prepare: ffff880056f89400=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.614902] cx23885[0]: =
[ffff880056f89400/9] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.624550] cx23885[0]: pci_status: =
0x00038002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.624553] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.624554] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.624555] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x4b=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.624556] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.624557] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.624558] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.624562] cx23885[0]: =
[ffff880056f89000/10] wakeup reg=3D75 buf=3D75=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.624578] cx23885[0]: =
cx23885_buf_prepare: ffff880056f89000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.624582] cx23885[0]: =
[ffff880056f89000/10] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.634230] cx23885[0]: pci_status: =
0x00038002  pci_mask: 0x00001f02=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.634233] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.634234] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.634235] cx23885[0]: ts1_status: =
0x00000001  ts1_mask: 0x00001111 count: 0x4c=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.634236] cx23885[0]: ts2_status: =
0x00000000  ts2_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.634237] cx23885[0]:  =
(PCI_MSK_VID_B     0x00000002)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.634238] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.634242] cx23885[0]: =
[ffff880056f8a800/11] wakeup reg=3D76 buf=3D76=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.634258] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8a800=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.634262] cx23885[0]: =
[ffff880056f8a800/11] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641286] cx23885[0]: =
cx23885_cancel_buffers()=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641288] cx23885[0]: =
cx23885_stop_dma()=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641297] cx23885[0]: =
[ffff880056f8ac00/12] cancel - dma=3D0x597de000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641298] cx23885[0]: =
[ffff880056f88400/13] cancel - dma=3D0x57dd9000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641300] cx23885[0]: =
[ffff880056f8e400/14] cancel - dma=3D0x3679f000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641301] cx23885[0]: =
[ffff880036875800/15] cancel - dma=3D0x56fba000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641302] cx23885[0]: =
[ffff880055c71c00/16] cancel - dma=3D0x518b7000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641304] cx23885[0]: =
[ffff880055c72000/17] cancel - dma=3D0x56fd8000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641305] cx23885[0]: =
[ffff880055c75800/18] cancel - dma=3D0x586da000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641307] cx23885[0]: =
[ffff880055c72800/19] cancel - dma=3D0x5717e000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641308] cx23885[0]: =
[ffff880055c7b400/20] cancel - dma=3D0x55c39000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641309] cx23885[0]: =
[ffff880055c79000/21] cancel - dma=3D0x51836000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641311] cx23885[0]: =
[ffff880055c7c000/22] cancel - dma=3D0x56f02000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641312] cx23885[0]: =
[ffff880055c7c400/23] cancel - dma=3D0x369ae000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641313] cx23885[0]: =
[ffff880055c7e400/24] cancel - dma=3D0x51867000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641315] cx23885[0]: =
[ffff880055c7f000/25] cancel - dma=3D0x518c2000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641316] cx23885[0]: =
[ffff880055c7d400/26] cancel - dma=3D0x5976f000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641317] cx23885[0]: =
[ffff880055c7ec00/27] cancel - dma=3D0x36baf000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641319] cx23885[0]: =
[ffff880055c79800/28] cancel - dma=3D0x56743000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641320] cx23885[0]: =
[ffff880055c78000/29] cancel - dma=3D0x56224000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641321] cx23885[0]: =
[ffff880055c79c00/30] cancel - dma=3D0x518d3000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641323] cx23885[0]: =
[ffff880055c78800/31] cancel - dma=3D0x56370000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641324] cx23885[0]: =
[ffff880056823000/0] cancel - dma=3D0x56fad000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641325] cx23885[0]: =
[ffff880056825000/1] cancel - dma=3D0x51923000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641327] cx23885[0]: =
[ffff880056821400/2] cancel - dma=3D0x55c14000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641328] cx23885[0]: =
[ffff880056825800/3] cancel - dma=3D0x57296000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641329] cx23885[0]: =
[ffff880056824400/4] cancel - dma=3D0x51877000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641331] cx23885[0]: =
[ffff880056822800/5] cancel - dma=3D0x56261000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641332] cx23885[0]: =
[ffff880056f8c800/6] cancel - dma=3D0x56317000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641333] cx23885[0]: =
[ffff880056f8b000/7] cancel - dma=3D0x5624a000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641335] cx23885[0]: =
[ffff880056f8d800/8] cancel - dma=3D0x563eb000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641336] cx23885[0]: =
[ffff880056f89400/9] cancel - dma=3D0x57173000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641337] cx23885[0]: =
[ffff880056f89000/10] cancel - dma=3D0x51946000=0A=
Jan 28 21:34:01 prueba kernel: [ 2147.641339] cx23885[0]: =
[ffff880056f8a800/11] cancel - dma=3D0x36902000=0A=

------=_NextPart_000_006F_01D03FEF.AEB84570
Content-Type: application/octet-stream;
	name="test2.1-adap1-ok.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="test2.1-adap1-ok.log"

Jan 28 21:37:16 prueba kernel: [  115.281440] mt2063: detected a mt2063 =
B3=0A=
Jan 28 21:37:16 prueba kernel: [  115.321361] cx23885[0]: =
cx23885_buf_prepare: ffff88005975b400=0A=
Jan 28 21:37:16 prueba kernel: [  115.321366] cx23885[0]: =
cx23885_buf_prepare: ffff88005975cc00=0A=
Jan 28 21:37:16 prueba kernel: [  115.321367] cx23885[0]: =
cx23885_buf_prepare: ffff88005975ec00=0A=
Jan 28 21:37:16 prueba kernel: [  115.321369] cx23885[0]: =
cx23885_buf_prepare: ffff8800565d0800=0A=
Jan 28 21:37:16 prueba kernel: [  115.321370] cx23885[0]: =
cx23885_buf_prepare: ffff8800565d0000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321372] cx23885[0]: =
cx23885_buf_prepare: ffff8800565d0400=0A=
Jan 28 21:37:16 prueba kernel: [  115.321373] cx23885[0]: =
cx23885_buf_prepare: ffff8800565d1000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321375] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d6400=0A=
Jan 28 21:37:16 prueba kernel: [  115.321376] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d7000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321378] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d4800=0A=
Jan 28 21:37:16 prueba kernel: [  115.321379] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d7400=0A=
Jan 28 21:37:16 prueba kernel: [  115.321381] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d1800=0A=
Jan 28 21:37:16 prueba kernel: [  115.321382] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d7c00=0A=
Jan 28 21:37:16 prueba kernel: [  115.321384] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d5800=0A=
Jan 28 21:37:16 prueba kernel: [  115.321386] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d5c00=0A=
Jan 28 21:37:16 prueba kernel: [  115.321387] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d1000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321389] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d5000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321390] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d2c00=0A=
Jan 28 21:37:16 prueba kernel: [  115.321392] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d0400=0A=
Jan 28 21:37:16 prueba kernel: [  115.321393] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d0c00=0A=
Jan 28 21:37:16 prueba kernel: [  115.321395] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d1c00=0A=
Jan 28 21:37:16 prueba kernel: [  115.321396] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d2000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321398] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d7800=0A=
Jan 28 21:37:16 prueba kernel: [  115.321399] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d5400=0A=
Jan 28 21:37:16 prueba kernel: [  115.321401] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d0000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321403] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d6000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321404] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d6800=0A=
Jan 28 21:37:16 prueba kernel: [  115.321406] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d3800=0A=
Jan 28 21:37:16 prueba kernel: [  115.321407] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d6c00=0A=
Jan 28 21:37:16 prueba kernel: [  115.321409] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d3c00=0A=
Jan 28 21:37:16 prueba kernel: [  115.321410] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d3000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321412] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d4c00=0A=
Jan 28 21:37:16 prueba kernel: [  115.321415] cx23885[0]: =
[ffff88005975b400/0] cx23885_buf_queue - first active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321417] cx23885[0]: =
[ffff88005975cc00/1] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321418] cx23885[0]: =
[ffff88005975ec00/2] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321419] cx23885[0]: =
[ffff8800565d0800/3] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321420] cx23885[0]: =
[ffff8800565d0000/4] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321421] cx23885[0]: =
[ffff8800565d0400/5] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321422] cx23885[0]: =
[ffff8800565d1000/6] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321423] cx23885[0]: =
[ffff8800585d6400/7] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321425] cx23885[0]: =
[ffff8800585d7000/8] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321426] cx23885[0]: =
[ffff8800585d4800/9] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321427] cx23885[0]: =
[ffff8800585d7400/10] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321428] cx23885[0]: =
[ffff8800585d1800/11] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321429] cx23885[0]: =
[ffff8800585d7c00/12] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321430] cx23885[0]: =
[ffff8800585d5800/13] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321432] cx23885[0]: =
[ffff8800585d5c00/14] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321433] cx23885[0]: =
[ffff8800585d1000/15] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321434] cx23885[0]: =
[ffff8800585d5000/16] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321435] cx23885[0]: =
[ffff8800585d2c00/17] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321436] cx23885[0]: =
[ffff8800585d0400/18] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321437] cx23885[0]: =
[ffff8800585d0c00/19] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321438] cx23885[0]: =
[ffff8800585d1c00/20] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321439] cx23885[0]: =
[ffff8800585d2000/21] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321441] cx23885[0]: =
[ffff8800585d7800/22] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321442] cx23885[0]: =
[ffff8800585d5400/23] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321443] cx23885[0]: =
[ffff8800585d0000/24] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321444] cx23885[0]: =
[ffff8800585d6000/25] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321445] cx23885[0]: =
[ffff8800585d6800/26] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321446] cx23885[0]: =
[ffff8800585d3800/27] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321447] cx23885[0]: =
[ffff8800585d6c00/28] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321448] cx23885[0]: =
[ffff8800585d3c00/29] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321450] cx23885[0]: =
[ffff8800585d3000/30] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321451] cx23885[0]: =
[ffff8800585d4c00/31] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:16 prueba kernel: [  115.321452] cx23885[0]: =
cx23885_start_dma() w: 0, h: 0, f: 0=0A=
Jan 28 21:37:16 prueba kernel: [  115.321456] cx23885[0]: =
cx23885_sram_channel_setup() Configuring channel [TS2 C]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321457] cx23885[0]: =
cx23885_sram_channel_setup() 0x000105e0 <- 0x00006000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321459] cx23885[0]: =
cx23885_sram_channel_setup() 0x000105f0 <- 0x000062f0=0A=
Jan 28 21:37:16 prueba kernel: [  115.321460] cx23885[0]: =
cx23885_sram_channel_setup() 0x00010600 <- 0x000065e0=0A=
Jan 28 21:37:16 prueba kernel: [  115.321461] cx23885[0]: =
cx23885_sram_channel_setup() 0x00010610 <- 0x000068d0=0A=
Jan 28 21:37:16 prueba kernel: [  115.321462] cx23885[0]: =
cx23885_sram_channel_setup() 0x00010620 <- 0x00006bc0=0A=
Jan 28 21:37:16 prueba kernel: [  115.321467] cx23885[0]: [bridge 885] =
sram setup TS2 C: bpl=3D752 lines=3D5=0A=
Jan 28 21:37:16 prueba kernel: [  115.321468] cx23885[0]: TS2 C - dma =
channel status dump=0A=
Jan 28 21:37:16 prueba kernel: [  115.321476] cx23885[0]:   cmds: init =
risc lo   : 0x5619c000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321480] cx23885[0]:   cmds: init =
risc hi   : 0x00000000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321483] cx23885[0]:   cmds: cdt =
base       : 0x000105e0=0A=
Jan 28 21:37:16 prueba kernel: [  115.321486] cx23885[0]:   cmds: cdt =
size       : 0x0000000a=0A=
Jan 28 21:37:16 prueba kernel: [  115.321489] cx23885[0]:   cmds: iq =
base        : 0x00010440=0A=
Jan 28 21:37:16 prueba kernel: [  115.321492] cx23885[0]:   cmds: iq =
size        : 0x00000010=0A=
Jan 28 21:37:16 prueba kernel: [  115.321495] cx23885[0]:   cmds: risc =
pc lo     : 0x00000000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321498] cx23885[0]:   cmds: risc =
pc hi     : 0x00000000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321501] cx23885[0]:   cmds: iq wr =
ptr      : 0x00000000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321504] cx23885[0]:   cmds: iq rd =
ptr      : 0x00000000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321507] cx23885[0]:   cmds: cdt =
current    : 0x00000000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321510] cx23885[0]:   cmds: pci =
target lo  : 0x00000000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321514] cx23885[0]:   cmds: pci =
target hi  : 0x00000000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321517] cx23885[0]:   cmds: line / =
byte    : 0x00000000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321520] cx23885[0]:   risc0: =
0x00000000 [ INVALID count=3D0 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321524] cx23885[0]:   risc1: =
0x00000000 [ INVALID count=3D0 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321527] cx23885[0]:   risc2: =
0x00000000 [ INVALID count=3D0 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321531] cx23885[0]:   risc3: =
0x00000000 [ INVALID count=3D0 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321534] cx23885[0]:   (0x00010440) =
iq 0: 0x70000000 [ jump count=3D0 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321538] cx23885[0]:   iq 1: =
0x1c0002f0 [ arg #1 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321541] cx23885[0]:   iq 2: =
0x562cc000 [ arg #2 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321544] cx23885[0]:   (0x0001044c) =
iq 3: 0x00000000 [ INVALID count=3D0 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321548] cx23885[0]:   (0x00010450) =
iq 4: 0x1c0002f0 [ write sol eol count=3D752 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321552] cx23885[0]:   iq 5: =
0x562cc2f0 [ arg #1 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321555] cx23885[0]:   iq 6: =
0x00000000 [ arg #2 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321558] cx23885[0]:   (0x0001045c) =
iq 7: 0x1c0002f0 [ write sol eol count=3D752 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321562] cx23885[0]:   iq 8: =
0x562cc5e0 [ arg #1 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321565] cx23885[0]:   iq 9: =
0x00000000 [ arg #2 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321568] cx23885[0]:   (0x00010468) =
iq a: 0x1c0002f0 [ write sol eol count=3D752 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321572] cx23885[0]:   iq b: =
0x562cc8d0 [ arg #1 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321575] cx23885[0]:   iq c: =
0x00000000 [ arg #2 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321578] cx23885[0]:   (0x00010474) =
iq d: 0x1c0002f0 [ write sol eol count=3D752 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321582] cx23885[0]:   iq e: =
0x562ccbc0 [ arg #1 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321585] cx23885[0]:   iq f: =
0x00000000 [ arg #2 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321586] cx23885[0]: fifo: =
0x00006000 -> 0x7000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321587] cx23885[0]: ctrl: =
0x00010440 -> 0x104a0=0A=
Jan 28 21:37:16 prueba kernel: [  115.321590] cx23885[0]:   ptr1_reg: =
0x00006000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321593] cx23885[0]:   ptr2_reg: =
0x000105e8=0A=
Jan 28 21:37:16 prueba kernel: [  115.321596] cx23885[0]:   cnt1_reg: =
0x00000000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321599] cx23885[0]:   cnt2_reg: =
0x00000009=0A=
Jan 28 21:37:16 prueba kernel: [  115.321600] cx23885[0]: risc disasm: =
ffff88005619c000 [dma=3D0x5619c000]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321601] cx23885[0]:   0000: =
0x70000000 [ jump count=3D0 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321603] cx23885[0]:   0001: =
0x5619c00c [ arg #1 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321604] cx23885[0]:   0002: =
0x00000000 [ arg #2 ]=0A=
Jan 28 21:37:16 prueba kernel: [  115.321808] cx23885[0]: =
cx23885_start_dma() enabling TS int's and DMA=0A=
Jan 28 21:37:16 prueba kernel: [  115.321818] cx23885[0]: =
cx23885_tsport_reg_dump() Register Dump=0A=
Jan 28 21:37:16 prueba kernel: [  115.321822] cx23885[0]: =
cx23885_tsport_reg_dump() DEV_CNTRL2               0x00000020=0A=
Jan 28 21:37:16 prueba kernel: [  115.321826] cx23885[0]: =
cx23885_tsport_reg_dump() PCI_INT_MSK              0x00001F04=0A=
Jan 28 21:37:16 prueba kernel: [  115.321829] cx23885[0]: =
cx23885_tsport_reg_dump() AUD_INT_INT_MSK          0x00000000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321832] cx23885[0]: =
cx23885_tsport_reg_dump() AUD_INT_DMA_CTL          0x00000000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321835] cx23885[0]: =
cx23885_tsport_reg_dump() AUD_EXT_INT_MSK          0x00000000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321838] cx23885[0]: =
cx23885_tsport_reg_dump() AUD_EXT_DMA_CTL          0x00000000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321841] cx23885[0]: =
cx23885_tsport_reg_dump() PAD_CTRL                 0x00500300=0A=
Jan 28 21:37:16 prueba kernel: [  115.321844] cx23885[0]: =
cx23885_tsport_reg_dump() ALT_PIN_OUT_SEL          0x00000000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321848] cx23885[0]: =
cx23885_tsport_reg_dump() GPIO2                    0xC7CADA5F=0A=
Jan 28 21:37:16 prueba kernel: [  115.321851] cx23885[0]: =
cx23885_tsport_reg_dump() gpcnt(0x00130220)          0x00000000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321854] cx23885[0]: =
cx23885_tsport_reg_dump() gpcnt_ctl(0x00130230)      0x00000000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321857] cx23885[0]: =
cx23885_tsport_reg_dump() dma_ctl(0x00130240)        0x00000011=0A=
Jan 28 21:37:16 prueba kernel: [  115.321861] cx23885[0]: =
cx23885_tsport_reg_dump() lngth(0x00130250)          0x000002f0=0A=
Jan 28 21:37:16 prueba kernel: [  115.321864] cx23885[0]: =
cx23885_tsport_reg_dump() hw_sop_ctrl(0x00130254)    0x00470bc0=0A=
Jan 28 21:37:16 prueba kernel: [  115.321867] cx23885[0]: =
cx23885_tsport_reg_dump() gen_ctrl(0x00130258)       0x0000000c=0A=
Jan 28 21:37:16 prueba kernel: [  115.321870] cx23885[0]: =
cx23885_tsport_reg_dump() bd_pkt_status(0x0013025C)  0x00000000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321874] cx23885[0]: =
cx23885_tsport_reg_dump() sop_status(0x00130260)     0x00000000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321877] cx23885[0]: =
cx23885_tsport_reg_dump() fifo_ovfl_stat(0x00130264) 0x00000000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321880] cx23885[0]: =
cx23885_tsport_reg_dump() vld_misc(0x00130268)       0x00000000=0A=
Jan 28 21:37:16 prueba kernel: [  115.321883] cx23885[0]: =
cx23885_tsport_reg_dump() ts_clk_en(0x0013026C)      0x00000001=0A=
Jan 28 21:37:16 prueba kernel: [  115.321886] cx23885[0]: =
cx23885_tsport_reg_dump() ts_int_msk(0x00040040)     0x00001111=0A=
Jan 28 21:37:17 prueba kernel: [  115.788068] cx23885[0]: pci_status: =
0x003f8004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  115.788073] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.788075] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.788077] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.788079] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x1=0A=
Jan 28 21:37:17 prueba kernel: [  115.788080] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  115.788082] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  115.788087] cx23885[0]: =
[ffff88005975b400/0] wakeup reg=3D1 buf=3D1=0A=
Jan 28 21:37:17 prueba kernel: [  115.788128] cx23885[0]: =
cx23885_buf_prepare: ffff88005975b400=0A=
Jan 28 21:37:17 prueba kernel: [  115.788134] cx23885[0]: =
[ffff88005975b400/0] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  115.797549] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  115.797554] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.797556] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.797558] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.797560] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x2=0A=
Jan 28 21:37:17 prueba kernel: [  115.797561] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  115.797563] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  115.797567] cx23885[0]: =
[ffff88005975cc00/1] wakeup reg=3D2 buf=3D2=0A=
Jan 28 21:37:17 prueba kernel: [  115.797594] cx23885[0]: =
cx23885_buf_prepare: ffff88005975cc00=0A=
Jan 28 21:37:17 prueba kernel: [  115.797600] cx23885[0]: =
[ffff88005975cc00/1] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  115.807343] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  115.807347] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.807349] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.807351] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.807353] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x3=0A=
Jan 28 21:37:17 prueba kernel: [  115.807354] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  115.807356] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  115.807360] cx23885[0]: =
[ffff88005975ec00/2] wakeup reg=3D3 buf=3D3=0A=
Jan 28 21:37:17 prueba kernel: [  115.807387] cx23885[0]: =
cx23885_buf_prepare: ffff88005975ec00=0A=
Jan 28 21:37:17 prueba kernel: [  115.807392] cx23885[0]: =
[ffff88005975ec00/2] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  115.817133] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  115.817138] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.817140] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.817142] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.817144] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x4=0A=
Jan 28 21:37:17 prueba kernel: [  115.817145] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  115.817147] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  115.817151] cx23885[0]: =
[ffff8800565d0800/3] wakeup reg=3D4 buf=3D4=0A=
Jan 28 21:37:17 prueba kernel: [  115.817178] cx23885[0]: =
cx23885_buf_prepare: ffff8800565d0800=0A=
Jan 28 21:37:17 prueba kernel: [  115.817183] cx23885[0]: =
[ffff8800565d0800/3] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  115.826584] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  115.826589] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.826591] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.826592] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.826594] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x5=0A=
Jan 28 21:37:17 prueba kernel: [  115.826596] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  115.826597] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  115.826602] cx23885[0]: =
[ffff8800565d0000/4] wakeup reg=3D5 buf=3D5=0A=
Jan 28 21:37:17 prueba kernel: [  115.826628] cx23885[0]: =
cx23885_buf_prepare: ffff8800565d0000=0A=
Jan 28 21:37:17 prueba kernel: [  115.826634] cx23885[0]: =
[ffff8800565d0000/4] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  115.836417] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  115.836421] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.836423] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.836425] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.836427] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x6=0A=
Jan 28 21:37:17 prueba kernel: [  115.836428] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  115.836430] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  115.836435] cx23885[0]: =
[ffff8800565d0400/5] wakeup reg=3D6 buf=3D6=0A=
Jan 28 21:37:17 prueba kernel: [  115.836461] cx23885[0]: =
cx23885_buf_prepare: ffff8800565d0400=0A=
Jan 28 21:37:17 prueba kernel: [  115.836466] cx23885[0]: =
[ffff8800565d0400/5] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  115.845998] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  115.846003] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.846005] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.846007] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.846009] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x7=0A=
Jan 28 21:37:17 prueba kernel: [  115.846010] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  115.846012] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  115.846017] cx23885[0]: =
[ffff8800565d1000/6] wakeup reg=3D7 buf=3D7=0A=
Jan 28 21:37:17 prueba kernel: [  115.846042] cx23885[0]: =
cx23885_buf_prepare: ffff8800565d1000=0A=
Jan 28 21:37:17 prueba kernel: [  115.846047] cx23885[0]: =
[ffff8800565d1000/6] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  115.855798] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  115.855803] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.855805] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.855807] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.855808] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x8=0A=
Jan 28 21:37:17 prueba kernel: [  115.855810] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  115.855812] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  115.855816] cx23885[0]: =
[ffff8800585d6400/7] wakeup reg=3D8 buf=3D8=0A=
Jan 28 21:37:17 prueba kernel: [  115.855842] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d6400=0A=
Jan 28 21:37:17 prueba kernel: [  115.855847] cx23885[0]: =
[ffff8800585d6400/7] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  115.865554] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  115.865558] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.865560] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.865562] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.865564] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x9=0A=
Jan 28 21:37:17 prueba kernel: [  115.865565] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  115.865567] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  115.865571] cx23885[0]: =
[ffff8800585d7000/8] wakeup reg=3D9 buf=3D9=0A=
Jan 28 21:37:17 prueba kernel: [  115.865598] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d7000=0A=
Jan 28 21:37:17 prueba kernel: [  115.865603] cx23885[0]: =
[ffff8800585d7000/8] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  115.875474] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  115.875478] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.875480] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.875482] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.875484] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0xa=0A=
Jan 28 21:37:17 prueba kernel: [  115.875485] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  115.875487] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  115.875492] cx23885[0]: =
[ffff8800585d4800/9] wakeup reg=3D10 buf=3D10=0A=
Jan 28 21:37:17 prueba kernel: [  115.875518] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d4800=0A=
Jan 28 21:37:17 prueba kernel: [  115.875523] cx23885[0]: =
[ffff8800585d4800/9] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  115.885266] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  115.885270] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.885272] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.885274] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.885276] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0xb=0A=
Jan 28 21:37:17 prueba kernel: [  115.885277] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  115.885279] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  115.885284] cx23885[0]: =
[ffff8800585d7400/10] wakeup reg=3D11 buf=3D11=0A=
Jan 28 21:37:17 prueba kernel: [  115.885310] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d7400=0A=
Jan 28 21:37:17 prueba kernel: [  115.885316] cx23885[0]: =
[ffff8800585d7400/10] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  115.894817] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  115.894822] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.894824] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.894826] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.894827] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0xc=0A=
Jan 28 21:37:17 prueba kernel: [  115.894829] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  115.894830] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  115.894835] cx23885[0]: =
[ffff8800585d1800/11] wakeup reg=3D12 buf=3D12=0A=
Jan 28 21:37:17 prueba kernel: [  115.894861] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d1800=0A=
Jan 28 21:37:17 prueba kernel: [  115.894867] cx23885[0]: =
[ffff8800585d1800/11] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  115.904402] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  115.904406] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.904408] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.904410] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.904412] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0xd=0A=
Jan 28 21:37:17 prueba kernel: [  115.904413] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  115.904415] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  115.904419] cx23885[0]: =
[ffff8800585d7c00/12] wakeup reg=3D13 buf=3D13=0A=
Jan 28 21:37:17 prueba kernel: [  115.904446] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d7c00=0A=
Jan 28 21:37:17 prueba kernel: [  115.904451] cx23885[0]: =
[ffff8800585d7c00/12] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  115.913972] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  115.913976] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.913979] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.913980] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.913982] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0xe=0A=
Jan 28 21:37:17 prueba kernel: [  115.913984] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  115.913985] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  115.913990] cx23885[0]: =
[ffff8800585d5800/13] wakeup reg=3D14 buf=3D14=0A=
Jan 28 21:37:17 prueba kernel: [  115.914016] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d5800=0A=
Jan 28 21:37:17 prueba kernel: [  115.914022] cx23885[0]: =
[ffff8800585d5800/13] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  115.923642] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  115.923646] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.923648] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.923650] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.923652] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0xf=0A=
Jan 28 21:37:17 prueba kernel: [  115.923653] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  115.923655] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  115.923660] cx23885[0]: =
[ffff8800585d5c00/14] wakeup reg=3D15 buf=3D15=0A=
Jan 28 21:37:17 prueba kernel: [  115.923686] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d5c00=0A=
Jan 28 21:37:17 prueba kernel: [  115.923691] cx23885[0]: =
[ffff8800585d5c00/14] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  115.933349] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  115.933353] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.933355] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.933357] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.933359] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x10=0A=
Jan 28 21:37:17 prueba kernel: [  115.933361] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  115.933362] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  115.933367] cx23885[0]: =
[ffff8800585d1000/15] wakeup reg=3D16 buf=3D16=0A=
Jan 28 21:37:17 prueba kernel: [  115.933393] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d1000=0A=
Jan 28 21:37:17 prueba kernel: [  115.933398] cx23885[0]: =
[ffff8800585d1000/15] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  115.943055] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  115.943060] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.943062] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.943064] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.943065] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x11=0A=
Jan 28 21:37:17 prueba kernel: [  115.943067] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  115.943069] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  115.943073] cx23885[0]: =
[ffff8800585d5000/16] wakeup reg=3D17 buf=3D17=0A=
Jan 28 21:37:17 prueba kernel: [  115.943099] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d5000=0A=
Jan 28 21:37:17 prueba kernel: [  115.943105] cx23885[0]: =
[ffff8800585d5000/16] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  115.952750] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  115.952754] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.952756] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.952758] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.952760] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x12=0A=
Jan 28 21:37:17 prueba kernel: [  115.952761] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  115.952763] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  115.952768] cx23885[0]: =
[ffff8800585d2c00/17] wakeup reg=3D18 buf=3D18=0A=
Jan 28 21:37:17 prueba kernel: [  115.952794] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d2c00=0A=
Jan 28 21:37:17 prueba kernel: [  115.952799] cx23885[0]: =
[ffff8800585d2c00/17] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  115.962442] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  115.962447] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.962449] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.962451] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.962453] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x13=0A=
Jan 28 21:37:17 prueba kernel: [  115.962454] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  115.962456] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  115.962461] cx23885[0]: =
[ffff8800585d0400/18] wakeup reg=3D19 buf=3D19=0A=
Jan 28 21:37:17 prueba kernel: [  115.962486] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d0400=0A=
Jan 28 21:37:17 prueba kernel: [  115.962492] cx23885[0]: =
[ffff8800585d0400/18] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  115.972130] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  115.972134] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.972136] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.972138] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.972140] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x14=0A=
Jan 28 21:37:17 prueba kernel: [  115.972141] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  115.972143] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  115.972148] cx23885[0]: =
[ffff8800585d0c00/19] wakeup reg=3D20 buf=3D20=0A=
Jan 28 21:37:17 prueba kernel: [  115.972174] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d0c00=0A=
Jan 28 21:37:17 prueba kernel: [  115.972179] cx23885[0]: =
[ffff8800585d0c00/19] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  115.981815] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  115.981819] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.981821] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.981823] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.981825] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x15=0A=
Jan 28 21:37:17 prueba kernel: [  115.981827] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  115.981828] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  115.981833] cx23885[0]: =
[ffff8800585d1c00/20] wakeup reg=3D21 buf=3D21=0A=
Jan 28 21:37:17 prueba kernel: [  115.981859] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d1c00=0A=
Jan 28 21:37:17 prueba kernel: [  115.981865] cx23885[0]: =
[ffff8800585d1c00/20] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  115.991496] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  115.991501] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.991503] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.991505] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  115.991506] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x16=0A=
Jan 28 21:37:17 prueba kernel: [  115.991508] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  115.991510] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  115.991514] cx23885[0]: =
[ffff8800585d2000/21] wakeup reg=3D22 buf=3D22=0A=
Jan 28 21:37:17 prueba kernel: [  115.991541] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d2000=0A=
Jan 28 21:37:17 prueba kernel: [  115.991546] cx23885[0]: =
[ffff8800585d2000/21] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.001182] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.001186] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.001188] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.001190] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.001192] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x17=0A=
Jan 28 21:37:17 prueba kernel: [  116.001193] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.001195] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.001200] cx23885[0]: =
[ffff8800585d7800/22] wakeup reg=3D23 buf=3D23=0A=
Jan 28 21:37:17 prueba kernel: [  116.001226] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d7800=0A=
Jan 28 21:37:17 prueba kernel: [  116.001231] cx23885[0]: =
[ffff8800585d7800/22] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.010865] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.010869] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.010871] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.010873] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.010875] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x18=0A=
Jan 28 21:37:17 prueba kernel: [  116.010877] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.010878] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.010883] cx23885[0]: =
[ffff8800585d5400/23] wakeup reg=3D24 buf=3D24=0A=
Jan 28 21:37:17 prueba kernel: [  116.010909] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d5400=0A=
Jan 28 21:37:17 prueba kernel: [  116.010914] cx23885[0]: =
[ffff8800585d5400/23] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.020547] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.020552] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.020554] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.020555] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.020557] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x19=0A=
Jan 28 21:37:17 prueba kernel: [  116.020559] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.020560] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.020565] cx23885[0]: =
[ffff8800585d0000/24] wakeup reg=3D25 buf=3D25=0A=
Jan 28 21:37:17 prueba kernel: [  116.020591] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d0000=0A=
Jan 28 21:37:17 prueba kernel: [  116.020597] cx23885[0]: =
[ffff8800585d0000/24] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.030227] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.030231] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.030233] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.030235] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.030237] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x1a=0A=
Jan 28 21:37:17 prueba kernel: [  116.030238] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.030240] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.030245] cx23885[0]: =
[ffff8800585d6000/25] wakeup reg=3D26 buf=3D26=0A=
Jan 28 21:37:17 prueba kernel: [  116.030271] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d6000=0A=
Jan 28 21:37:17 prueba kernel: [  116.030277] cx23885[0]: =
[ffff8800585d6000/25] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.039904] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.039908] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.039911] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.039912] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.039914] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x1b=0A=
Jan 28 21:37:17 prueba kernel: [  116.039916] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.039917] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.039922] cx23885[0]: =
[ffff8800585d6800/26] wakeup reg=3D27 buf=3D27=0A=
Jan 28 21:37:17 prueba kernel: [  116.039948] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d6800=0A=
Jan 28 21:37:17 prueba kernel: [  116.039953] cx23885[0]: =
[ffff8800585d6800/26] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.049564] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.049569] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.049571] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.049573] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.049574] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x1c=0A=
Jan 28 21:37:17 prueba kernel: [  116.049576] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.049577] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.049582] cx23885[0]: =
[ffff8800585d3800/27] wakeup reg=3D28 buf=3D28=0A=
Jan 28 21:37:17 prueba kernel: [  116.049608] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d3800=0A=
Jan 28 21:37:17 prueba kernel: [  116.049613] cx23885[0]: =
[ffff8800585d3800/27] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.059264] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.059268] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.059270] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.059272] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.059274] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x1d=0A=
Jan 28 21:37:17 prueba kernel: [  116.059275] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.059277] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.059282] cx23885[0]: =
[ffff8800585d6c00/28] wakeup reg=3D29 buf=3D29=0A=
Jan 28 21:37:17 prueba kernel: [  116.059307] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d6c00=0A=
Jan 28 21:37:17 prueba kernel: [  116.059313] cx23885[0]: =
[ffff8800585d6c00/28] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.068940] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.068944] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.068946] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.068948] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.068950] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x1e=0A=
Jan 28 21:37:17 prueba kernel: [  116.068951] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.068953] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.068958] cx23885[0]: =
[ffff8800585d3c00/29] wakeup reg=3D30 buf=3D30=0A=
Jan 28 21:37:17 prueba kernel: [  116.068984] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d3c00=0A=
Jan 28 21:37:17 prueba kernel: [  116.068989] cx23885[0]: =
[ffff8800585d3c00/29] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.078617] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.078622] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.078624] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.078626] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.078628] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x1f=0A=
Jan 28 21:37:17 prueba kernel: [  116.078629] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.078631] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.078636] cx23885[0]: =
[ffff8800585d3000/30] wakeup reg=3D31 buf=3D31=0A=
Jan 28 21:37:17 prueba kernel: [  116.078661] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d3000=0A=
Jan 28 21:37:17 prueba kernel: [  116.078666] cx23885[0]: =
[ffff8800585d3000/30] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.088296] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.088300] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.088302] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.088304] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.088306] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x20=0A=
Jan 28 21:37:17 prueba kernel: [  116.088308] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.088309] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.088314] cx23885[0]: =
[ffff8800585d4c00/31] wakeup reg=3D32 buf=3D32=0A=
Jan 28 21:37:17 prueba kernel: [  116.088340] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d4c00=0A=
Jan 28 21:37:17 prueba kernel: [  116.088345] cx23885[0]: =
[ffff8800585d4c00/31] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.097965] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.097969] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.097971] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.097973] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.097975] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x21=0A=
Jan 28 21:37:17 prueba kernel: [  116.097976] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.097978] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.097983] cx23885[0]: =
[ffff88005975b400/0] wakeup reg=3D33 buf=3D33=0A=
Jan 28 21:37:17 prueba kernel: [  116.098009] cx23885[0]: =
cx23885_buf_prepare: ffff88005975b400=0A=
Jan 28 21:37:17 prueba kernel: [  116.098014] cx23885[0]: =
[ffff88005975b400/0] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.107654] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.107658] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.107660] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.107662] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.107664] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x22=0A=
Jan 28 21:37:17 prueba kernel: [  116.107666] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.107667] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.107672] cx23885[0]: =
[ffff88005975cc00/1] wakeup reg=3D34 buf=3D34=0A=
Jan 28 21:37:17 prueba kernel: [  116.107698] cx23885[0]: =
cx23885_buf_prepare: ffff88005975cc00=0A=
Jan 28 21:37:17 prueba kernel: [  116.107703] cx23885[0]: =
[ffff88005975cc00/1] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.117329] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.117333] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.117336] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.117337] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.117339] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x23=0A=
Jan 28 21:37:17 prueba kernel: [  116.117341] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.117342] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.117347] cx23885[0]: =
[ffff88005975ec00/2] wakeup reg=3D35 buf=3D35=0A=
Jan 28 21:37:17 prueba kernel: [  116.117373] cx23885[0]: =
cx23885_buf_prepare: ffff88005975ec00=0A=
Jan 28 21:37:17 prueba kernel: [  116.117379] cx23885[0]: =
[ffff88005975ec00/2] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.127009] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.127014] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.127016] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.127018] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.127020] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x24=0A=
Jan 28 21:37:17 prueba kernel: [  116.127021] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.127023] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.127028] cx23885[0]: =
[ffff8800565d0800/3] wakeup reg=3D36 buf=3D36=0A=
Jan 28 21:37:17 prueba kernel: [  116.127053] cx23885[0]: =
cx23885_buf_prepare: ffff8800565d0800=0A=
Jan 28 21:37:17 prueba kernel: [  116.127059] cx23885[0]: =
[ffff8800565d0800/3] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.136687] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.136691] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.136693] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.136695] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.136697] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x25=0A=
Jan 28 21:37:17 prueba kernel: [  116.136698] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.136700] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.136705] cx23885[0]: =
[ffff8800565d0000/4] wakeup reg=3D37 buf=3D37=0A=
Jan 28 21:37:17 prueba kernel: [  116.136730] cx23885[0]: =
cx23885_buf_prepare: ffff8800565d0000=0A=
Jan 28 21:37:17 prueba kernel: [  116.136736] cx23885[0]: =
[ffff8800565d0000/4] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.146364] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.146369] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.146371] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.146373] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.146375] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x26=0A=
Jan 28 21:37:17 prueba kernel: [  116.146376] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.146378] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.146383] cx23885[0]: =
[ffff8800565d0400/5] wakeup reg=3D38 buf=3D38=0A=
Jan 28 21:37:17 prueba kernel: [  116.146409] cx23885[0]: =
cx23885_buf_prepare: ffff8800565d0400=0A=
Jan 28 21:37:17 prueba kernel: [  116.146414] cx23885[0]: =
[ffff8800565d0400/5] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.156041] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.156045] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.156048] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.156049] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.156051] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x27=0A=
Jan 28 21:37:17 prueba kernel: [  116.156053] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.156054] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.156059] cx23885[0]: =
[ffff8800565d1000/6] wakeup reg=3D39 buf=3D39=0A=
Jan 28 21:37:17 prueba kernel: [  116.156084] cx23885[0]: =
cx23885_buf_prepare: ffff8800565d1000=0A=
Jan 28 21:37:17 prueba kernel: [  116.156090] cx23885[0]: =
[ffff8800565d1000/6] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.165719] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.165723] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.165725] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.165727] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.165729] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x28=0A=
Jan 28 21:37:17 prueba kernel: [  116.165731] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.165732] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.165737] cx23885[0]: =
[ffff8800585d6400/7] wakeup reg=3D40 buf=3D40=0A=
Jan 28 21:37:17 prueba kernel: [  116.165763] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d6400=0A=
Jan 28 21:37:17 prueba kernel: [  116.165768] cx23885[0]: =
[ffff8800585d6400/7] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.175395] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.175400] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.175402] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.175404] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.175405] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x29=0A=
Jan 28 21:37:17 prueba kernel: [  116.175407] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.175409] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.175413] cx23885[0]: =
[ffff8800585d7000/8] wakeup reg=3D41 buf=3D41=0A=
Jan 28 21:37:17 prueba kernel: [  116.175439] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d7000=0A=
Jan 28 21:37:17 prueba kernel: [  116.175445] cx23885[0]: =
[ffff8800585d7000/8] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.185075] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.185079] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.185081] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.185083] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.185085] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x2a=0A=
Jan 28 21:37:17 prueba kernel: [  116.185086] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.185088] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.185093] cx23885[0]: =
[ffff8800585d4800/9] wakeup reg=3D42 buf=3D42=0A=
Jan 28 21:37:17 prueba kernel: [  116.185119] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d4800=0A=
Jan 28 21:37:17 prueba kernel: [  116.185124] cx23885[0]: =
[ffff8800585d4800/9] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.194742] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.194746] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.194749] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.194750] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.194752] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x2b=0A=
Jan 28 21:37:17 prueba kernel: [  116.194754] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.194755] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.194760] cx23885[0]: =
[ffff8800585d7400/10] wakeup reg=3D43 buf=3D43=0A=
Jan 28 21:37:17 prueba kernel: [  116.194787] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d7400=0A=
Jan 28 21:37:17 prueba kernel: [  116.194792] cx23885[0]: =
[ffff8800585d7400/10] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.204431] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.204435] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.204437] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.204439] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.204441] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x2c=0A=
Jan 28 21:37:17 prueba kernel: [  116.204443] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.204444] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.204449] cx23885[0]: =
[ffff8800585d1800/11] wakeup reg=3D44 buf=3D44=0A=
Jan 28 21:37:17 prueba kernel: [  116.204475] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d1800=0A=
Jan 28 21:37:17 prueba kernel: [  116.204481] cx23885[0]: =
[ffff8800585d1800/11] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.214105] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.214110] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.214112] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.214114] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.214116] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x2d=0A=
Jan 28 21:37:17 prueba kernel: [  116.214117] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.214119] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.214124] cx23885[0]: =
[ffff8800585d7c00/12] wakeup reg=3D45 buf=3D45=0A=
Jan 28 21:37:17 prueba kernel: [  116.214150] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d7c00=0A=
Jan 28 21:37:17 prueba kernel: [  116.214155] cx23885[0]: =
[ffff8800585d7c00/12] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.223786] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.223791] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.223793] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.223794] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.223796] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x2e=0A=
Jan 28 21:37:17 prueba kernel: [  116.223798] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.223800] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.223804] cx23885[0]: =
[ffff8800585d5800/13] wakeup reg=3D46 buf=3D46=0A=
Jan 28 21:37:17 prueba kernel: [  116.223830] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d5800=0A=
Jan 28 21:37:17 prueba kernel: [  116.223836] cx23885[0]: =
[ffff8800585d5800/13] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.233463] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.233467] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.233470] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.233471] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.233473] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x2f=0A=
Jan 28 21:37:17 prueba kernel: [  116.233475] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.233476] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.233481] cx23885[0]: =
[ffff8800585d5c00/14] wakeup reg=3D47 buf=3D47=0A=
Jan 28 21:37:17 prueba kernel: [  116.233507] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d5c00=0A=
Jan 28 21:37:17 prueba kernel: [  116.233513] cx23885[0]: =
[ffff8800585d5c00/14] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.243112] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.243116] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.243118] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.243120] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.243122] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x30=0A=
Jan 28 21:37:17 prueba kernel: [  116.243123] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.243125] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.243130] cx23885[0]: =
[ffff8800585d1000/15] wakeup reg=3D48 buf=3D48=0A=
Jan 28 21:37:17 prueba kernel: [  116.243156] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d1000=0A=
Jan 28 21:37:17 prueba kernel: [  116.243162] cx23885[0]: =
[ffff8800585d1000/15] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.252819] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.252823] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.252825] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.252827] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.252829] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x31=0A=
Jan 28 21:37:17 prueba kernel: [  116.252830] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.252832] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.252837] cx23885[0]: =
[ffff8800585d5000/16] wakeup reg=3D49 buf=3D49=0A=
Jan 28 21:37:17 prueba kernel: [  116.252863] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d5000=0A=
Jan 28 21:37:17 prueba kernel: [  116.252869] cx23885[0]: =
[ffff8800585d5000/16] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.262497] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.262501] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.262503] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.262505] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.262507] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x32=0A=
Jan 28 21:37:17 prueba kernel: [  116.262508] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.262510] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.262515] cx23885[0]: =
[ffff8800585d2c00/17] wakeup reg=3D50 buf=3D50=0A=
Jan 28 21:37:17 prueba kernel: [  116.262541] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d2c00=0A=
Jan 28 21:37:17 prueba kernel: [  116.262547] cx23885[0]: =
[ffff8800585d2c00/17] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.272171] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.272176] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.272178] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.272180] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.272181] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x33=0A=
Jan 28 21:37:17 prueba kernel: [  116.272183] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.272185] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.272189] cx23885[0]: =
[ffff8800585d0400/18] wakeup reg=3D51 buf=3D51=0A=
Jan 28 21:37:17 prueba kernel: [  116.272215] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d0400=0A=
Jan 28 21:37:17 prueba kernel: [  116.272221] cx23885[0]: =
[ffff8800585d0400/18] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.281835] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.281839] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.281841] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.281843] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.281845] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x34=0A=
Jan 28 21:37:17 prueba kernel: [  116.281846] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.281848] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.281853] cx23885[0]: =
[ffff8800585d0c00/19] wakeup reg=3D52 buf=3D52=0A=
Jan 28 21:37:17 prueba kernel: [  116.281880] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d0c00=0A=
Jan 28 21:37:17 prueba kernel: [  116.281886] cx23885[0]: =
[ffff8800585d0c00/19] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.291529] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.291533] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.291536] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.291537] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.291539] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x35=0A=
Jan 28 21:37:17 prueba kernel: [  116.291541] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.291542] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.291547] cx23885[0]: =
[ffff8800585d1c00/20] wakeup reg=3D53 buf=3D53=0A=
Jan 28 21:37:17 prueba kernel: [  116.291573] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d1c00=0A=
Jan 28 21:37:17 prueba kernel: [  116.291579] cx23885[0]: =
[ffff8800585d1c00/20] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.301206] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.301211] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.301213] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.301215] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.301216] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x36=0A=
Jan 28 21:37:17 prueba kernel: [  116.301218] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.301220] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.301224] cx23885[0]: =
[ffff8800585d2000/21] wakeup reg=3D54 buf=3D54=0A=
Jan 28 21:37:17 prueba kernel: [  116.301251] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d2000=0A=
Jan 28 21:37:17 prueba kernel: [  116.301257] cx23885[0]: =
[ffff8800585d2000/21] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.310884] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.310889] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.310891] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.310893] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.310895] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x37=0A=
Jan 28 21:37:17 prueba kernel: [  116.310896] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.310898] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.310903] cx23885[0]: =
[ffff8800585d7800/22] wakeup reg=3D55 buf=3D55=0A=
Jan 28 21:37:17 prueba kernel: [  116.310928] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d7800=0A=
Jan 28 21:37:17 prueba kernel: [  116.310934] cx23885[0]: =
[ffff8800585d7800/22] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.320563] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.320567] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.320570] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.320571] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.320573] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x38=0A=
Jan 28 21:37:17 prueba kernel: [  116.320575] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.320576] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.320581] cx23885[0]: =
[ffff8800585d5400/23] wakeup reg=3D56 buf=3D56=0A=
Jan 28 21:37:17 prueba kernel: [  116.320607] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d5400=0A=
Jan 28 21:37:17 prueba kernel: [  116.320612] cx23885[0]: =
[ffff8800585d5400/23] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.330229] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.330233] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.330235] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.330237] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.330239] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x39=0A=
Jan 28 21:37:17 prueba kernel: [  116.330241] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.330242] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.330247] cx23885[0]: =
[ffff8800585d0000/24] wakeup reg=3D57 buf=3D57=0A=
Jan 28 21:37:17 prueba kernel: [  116.330273] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d0000=0A=
Jan 28 21:37:17 prueba kernel: [  116.330279] cx23885[0]: =
[ffff8800585d0000/24] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.339917] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.339921] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.339923] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.339925] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.339927] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x3a=0A=
Jan 28 21:37:17 prueba kernel: [  116.339928] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.339930] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.339935] cx23885[0]: =
[ffff8800585d6000/25] wakeup reg=3D58 buf=3D58=0A=
Jan 28 21:37:17 prueba kernel: [  116.339960] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d6000=0A=
Jan 28 21:37:17 prueba kernel: [  116.339966] cx23885[0]: =
[ffff8800585d6000/25] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.349596] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.349600] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.349602] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.349604] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.349606] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x3b=0A=
Jan 28 21:37:17 prueba kernel: [  116.349607] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.349609] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.349614] cx23885[0]: =
[ffff8800585d6800/26] wakeup reg=3D59 buf=3D59=0A=
Jan 28 21:37:17 prueba kernel: [  116.349640] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d6800=0A=
Jan 28 21:37:17 prueba kernel: [  116.349646] cx23885[0]: =
[ffff8800585d6800/26] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.359270] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.359274] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.359276] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.359278] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.359280] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x3c=0A=
Jan 28 21:37:17 prueba kernel: [  116.359281] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.359283] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.359288] cx23885[0]: =
[ffff8800585d3800/27] wakeup reg=3D60 buf=3D60=0A=
Jan 28 21:37:17 prueba kernel: [  116.359314] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d3800=0A=
Jan 28 21:37:17 prueba kernel: [  116.359320] cx23885[0]: =
[ffff8800585d3800/27] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.368947] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.368952] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.368954] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.368956] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.368958] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x3d=0A=
Jan 28 21:37:17 prueba kernel: [  116.368959] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.368961] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.368966] cx23885[0]: =
[ffff8800585d6c00/28] wakeup reg=3D61 buf=3D61=0A=
Jan 28 21:37:17 prueba kernel: [  116.368992] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d6c00=0A=
Jan 28 21:37:17 prueba kernel: [  116.368997] cx23885[0]: =
[ffff8800585d6c00/28] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.378625] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.378630] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.378632] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.378634] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.378636] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x3e=0A=
Jan 28 21:37:17 prueba kernel: [  116.378637] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.378639] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.378644] cx23885[0]: =
[ffff8800585d3c00/29] wakeup reg=3D62 buf=3D62=0A=
Jan 28 21:37:17 prueba kernel: [  116.378670] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d3c00=0A=
Jan 28 21:37:17 prueba kernel: [  116.378675] cx23885[0]: =
[ffff8800585d3c00/29] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.388303] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.388307] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.388309] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.388311] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.388313] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x3f=0A=
Jan 28 21:37:17 prueba kernel: [  116.388314] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.388316] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.388321] cx23885[0]: =
[ffff8800585d3000/30] wakeup reg=3D63 buf=3D63=0A=
Jan 28 21:37:17 prueba kernel: [  116.388346] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d3000=0A=
Jan 28 21:37:17 prueba kernel: [  116.388352] cx23885[0]: =
[ffff8800585d3000/30] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.397983] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.397987] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.397989] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.397991] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.397993] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x40=0A=
Jan 28 21:37:17 prueba kernel: [  116.397995] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.397996] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.398001] cx23885[0]: =
[ffff8800585d4c00/31] wakeup reg=3D64 buf=3D64=0A=
Jan 28 21:37:17 prueba kernel: [  116.398027] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d4c00=0A=
Jan 28 21:37:17 prueba kernel: [  116.398033] cx23885[0]: =
[ffff8800585d4c00/31] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.407658] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.407662] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.407664] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.407666] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.407668] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x41=0A=
Jan 28 21:37:17 prueba kernel: [  116.407669] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.407671] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.407676] cx23885[0]: =
[ffff88005975b400/0] wakeup reg=3D65 buf=3D65=0A=
Jan 28 21:37:17 prueba kernel: [  116.407701] cx23885[0]: =
cx23885_buf_prepare: ffff88005975b400=0A=
Jan 28 21:37:17 prueba kernel: [  116.407707] cx23885[0]: =
[ffff88005975b400/0] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.417338] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.417342] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.417344] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.417346] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.417348] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x42=0A=
Jan 28 21:37:17 prueba kernel: [  116.417350] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.417351] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.417356] cx23885[0]: =
[ffff88005975cc00/1] wakeup reg=3D66 buf=3D66=0A=
Jan 28 21:37:17 prueba kernel: [  116.417381] cx23885[0]: =
cx23885_buf_prepare: ffff88005975cc00=0A=
Jan 28 21:37:17 prueba kernel: [  116.417387] cx23885[0]: =
[ffff88005975cc00/1] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.427016] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.427020] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.427022] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.427024] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.427026] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x43=0A=
Jan 28 21:37:17 prueba kernel: [  116.427027] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.427029] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.427034] cx23885[0]: =
[ffff88005975ec00/2] wakeup reg=3D67 buf=3D67=0A=
Jan 28 21:37:17 prueba kernel: [  116.427058] cx23885[0]: =
cx23885_buf_prepare: ffff88005975ec00=0A=
Jan 28 21:37:17 prueba kernel: [  116.427064] cx23885[0]: =
[ffff88005975ec00/2] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.436694] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.436698] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.436700] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.436702] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.436704] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x44=0A=
Jan 28 21:37:17 prueba kernel: [  116.436705] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.436707] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.436712] cx23885[0]: =
[ffff8800565d0800/3] wakeup reg=3D68 buf=3D68=0A=
Jan 28 21:37:17 prueba kernel: [  116.436738] cx23885[0]: =
cx23885_buf_prepare: ffff8800565d0800=0A=
Jan 28 21:37:17 prueba kernel: [  116.436744] cx23885[0]: =
[ffff8800565d0800/3] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.446370] cx23885[0]: pci_status: =
0x00008004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.446374] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.446377] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.446378] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.446380] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x45=0A=
Jan 28 21:37:17 prueba kernel: [  116.446382] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.446383] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.446388] cx23885[0]: =
[ffff8800565d0000/4] wakeup reg=3D69 buf=3D69=0A=
Jan 28 21:37:17 prueba kernel: [  116.446413] cx23885[0]: =
cx23885_buf_prepare: ffff8800565d0000=0A=
Jan 28 21:37:17 prueba kernel: [  116.446419] cx23885[0]: =
[ffff8800565d0000/4] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.455987] cx23885[0]: pci_status: =
0x00038004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.455989] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.455991] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.455992] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.455993] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x46=0A=
Jan 28 21:37:17 prueba kernel: [  116.455995] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.455996] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.456000] cx23885[0]: =
[ffff8800565d0400/5] wakeup reg=3D70 buf=3D70=0A=
Jan 28 21:37:17 prueba kernel: [  116.456041] cx23885[0]: =
cx23885_buf_prepare: ffff8800565d0400=0A=
Jan 28 21:37:17 prueba kernel: [  116.456048] cx23885[0]: =
[ffff8800565d0400/5] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.465663] cx23885[0]: pci_status: =
0x00038004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.465664] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.465665] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.465666] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.465667] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x47=0A=
Jan 28 21:37:17 prueba kernel: [  116.465668] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.465669] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.465672] cx23885[0]: =
[ffff8800565d1000/6] wakeup reg=3D71 buf=3D71=0A=
Jan 28 21:37:17 prueba kernel: [  116.465705] cx23885[0]: =
cx23885_buf_prepare: ffff8800565d1000=0A=
Jan 28 21:37:17 prueba kernel: [  116.465710] cx23885[0]: =
[ffff8800565d1000/6] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.475341] cx23885[0]: pci_status: =
0x00038004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.475342] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.475343] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.475344] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.475345] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x48=0A=
Jan 28 21:37:17 prueba kernel: [  116.475346] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.475347] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.475350] cx23885[0]: =
[ffff8800585d6400/7] wakeup reg=3D72 buf=3D72=0A=
Jan 28 21:37:17 prueba kernel: [  116.475382] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d6400=0A=
Jan 28 21:37:17 prueba kernel: [  116.475388] cx23885[0]: =
[ffff8800585d6400/7] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.485019] cx23885[0]: pci_status: =
0x00038004  pci_mask: 0x00001f04=0A=
Jan 28 21:37:17 prueba kernel: [  116.485020] cx23885[0]: vida_status: =
0x00000000 vida_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.485021] cx23885[0]: audint_status: =
0x00000000 audint_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.485022] cx23885[0]: ts1_status: =
0x00000000  ts1_mask: 0x00000000 count: 0x0=0A=
Jan 28 21:37:17 prueba kernel: [  116.485023] cx23885[0]: ts2_status: =
0x00000001  ts2_mask: 0x00001111 count: 0x49=0A=
Jan 28 21:37:17 prueba kernel: [  116.485024] cx23885[0]:  =
(PCI_MSK_VID_C     0x00000004)=0A=
Jan 28 21:37:17 prueba kernel: [  116.485025] cx23885[0]:  (RISCI1       =
     0x00000001)=0A=
Jan 28 21:37:17 prueba kernel: [  116.485028] cx23885[0]: =
[ffff8800585d7000/8] wakeup reg=3D73 buf=3D73=0A=
Jan 28 21:37:17 prueba kernel: [  116.485061] cx23885[0]: =
cx23885_buf_prepare: ffff8800585d7000=0A=
Jan 28 21:37:17 prueba kernel: [  116.485066] cx23885[0]: =
[ffff8800585d7000/8] cx23885_buf_queue - append to active=0A=
Jan 28 21:37:17 prueba kernel: [  116.494490] cx23885[0]: =
cx23885_cancel_buffers()=0A=
Jan 28 21:37:17 prueba kernel: [  116.494491] cx23885[0]: =
cx23885_stop_dma()=0A=
Jan 28 21:37:17 prueba kernel: [  116.494498] cx23885[0]: =
[ffff8800585d4800/9] cancel - dma=3D0x561cd000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494499] cx23885[0]: =
[ffff8800585d7400/10] cancel - dma=3D0x3693a000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494501] cx23885[0]: =
[ffff8800585d1800/11] cancel - dma=3D0x5611a000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494502] cx23885[0]: =
[ffff8800585d7c00/12] cancel - dma=3D0x55d64000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494503] cx23885[0]: =
[ffff8800585d5800/13] cancel - dma=3D0x561ec000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494505] cx23885[0]: =
[ffff8800585d5c00/14] cancel - dma=3D0x0017b000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494506] cx23885[0]: =
[ffff8800585d1000/15] cancel - dma=3D0x00122000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494507] cx23885[0]: =
[ffff8800585d5000/16] cancel - dma=3D0x00161000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494508] cx23885[0]: =
[ffff8800585d2c00/17] cancel - dma=3D0x0005f000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494510] cx23885[0]: =
[ffff8800585d0400/18] cancel - dma=3D0x00172000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494511] cx23885[0]: =
[ffff8800585d0c00/19] cancel - dma=3D0x00189000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494512] cx23885[0]: =
[ffff8800585d1c00/20] cancel - dma=3D0x00066000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494513] cx23885[0]: =
[ffff8800585d2000/21] cancel - dma=3D0x00192000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494515] cx23885[0]: =
[ffff8800585d7800/22] cancel - dma=3D0x0016c000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494516] cx23885[0]: =
[ffff8800585d5400/23] cancel - dma=3D0x0016d000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494517] cx23885[0]: =
[ffff8800585d0000/24] cancel - dma=3D0x0016a000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494518] cx23885[0]: =
[ffff8800585d6000/25] cancel - dma=3D0x0016b000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494520] cx23885[0]: =
[ffff8800585d6800/26] cancel - dma=3D0x0018a000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494521] cx23885[0]: =
[ffff8800585d3800/27] cancel - dma=3D0x0018b000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494522] cx23885[0]: =
[ffff8800585d6c00/28] cancel - dma=3D0x00170000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494523] cx23885[0]: =
[ffff8800585d3c00/29] cancel - dma=3D0x00171000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494525] cx23885[0]: =
[ffff8800585d3000/30] cancel - dma=3D0x00190000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494526] cx23885[0]: =
[ffff8800585d4c00/31] cancel - dma=3D0x00191000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494527] cx23885[0]: =
[ffff88005975b400/0] cancel - dma=3D0x00064000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494528] cx23885[0]: =
[ffff88005975cc00/1] cancel - dma=3D0x00065000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494530] cx23885[0]: =
[ffff88005975ec00/2] cancel - dma=3D0x00178000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494531] cx23885[0]: =
[ffff8800565d0800/3] cancel - dma=3D0x00179000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494532] cx23885[0]: =
[ffff8800565d0000/4] cancel - dma=3D0x0018c000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494533] cx23885[0]: =
[ffff8800565d0400/5] cancel - dma=3D0x0018d000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494535] cx23885[0]: =
[ffff8800565d1000/6] cancel - dma=3D0x0018e000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494536] cx23885[0]: =
[ffff8800585d6400/7] cancel - dma=3D0x0018f000=0A=
Jan 28 21:37:17 prueba kernel: [  116.494537] cx23885[0]: =
[ffff8800585d7000/8] cancel - dma=3D0x00174000=0A=

------=_NextPart_000_006F_01D03FEF.AEB84570
Content-Type: application/octet-stream;
	name="test1.2-adap1-ko.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="test1.2-adap1-ko.log"

Jan 28 21:34:23 prueba kernel: [ 2169.691968] mt2063: detected a mt2063 =
B3=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731392] cx23885[0]: =
cx23885_buf_prepare: ffff880055c79c00=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731397] cx23885[0]: =
cx23885_buf_prepare: ffff880055c78000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731399] cx23885[0]: =
cx23885_buf_prepare: ffff880055c79800=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731401] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7ec00=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731402] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7d400=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731404] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7f000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731405] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7e400=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731407] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7c400=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731408] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7c000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731410] cx23885[0]: =
cx23885_buf_prepare: ffff880055c79000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731411] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7b400=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731413] cx23885[0]: =
cx23885_buf_prepare: ffff880055c79400=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731415] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7a400=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731416] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7b800=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731418] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7f400=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731420] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7f800=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731421] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7d000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731423] cx23885[0]: =
cx23885_buf_prepare: ffff880055c78c00=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731425] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7a800=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731426] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7a000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731428] cx23885[0]: =
cx23885_buf_prepare: ffff880055c7e800=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731429] cx23885[0]: =
cx23885_buf_prepare: ffff880055c72800=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731431] cx23885[0]: =
cx23885_buf_prepare: ffff880055c75800=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731433] cx23885[0]: =
cx23885_buf_prepare: ffff880055c72000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731434] cx23885[0]: =
cx23885_buf_prepare: ffff880055c71c00=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731436] cx23885[0]: =
cx23885_buf_prepare: ffff880036875800=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731437] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8e400=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731439] cx23885[0]: =
cx23885_buf_prepare: ffff880056f88400=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731441] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8ac00=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731442] cx23885[0]: =
cx23885_buf_prepare: ffff880056f8a800=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731444] cx23885[0]: =
cx23885_buf_prepare: ffff880056f89000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731445] cx23885[0]: =
cx23885_buf_prepare: ffff880056f89400=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731448] cx23885[0]: =
[ffff880055c79c00/0] cx23885_buf_queue - first active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731450] cx23885[0]: =
[ffff880055c78000/1] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731451] cx23885[0]: =
[ffff880055c79800/2] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731452] cx23885[0]: =
[ffff880055c7ec00/3] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731460] cx23885[0]: =
[ffff880055c7d400/4] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731462] cx23885[0]: =
[ffff880055c7f000/5] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731463] cx23885[0]: =
[ffff880055c7e400/6] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731464] cx23885[0]: =
[ffff880055c7c400/7] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731465] cx23885[0]: =
[ffff880055c7c000/8] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731466] cx23885[0]: =
[ffff880055c79000/9] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731468] cx23885[0]: =
[ffff880055c7b400/10] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731469] cx23885[0]: =
[ffff880055c79400/11] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731470] cx23885[0]: =
[ffff880055c7a400/12] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731472] cx23885[0]: =
[ffff880055c7b800/13] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731473] cx23885[0]: =
[ffff880055c7f400/14] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731474] cx23885[0]: =
[ffff880055c7f800/15] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731475] cx23885[0]: =
[ffff880055c7d000/16] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731476] cx23885[0]: =
[ffff880055c78c00/17] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731478] cx23885[0]: =
[ffff880055c7a800/18] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731479] cx23885[0]: =
[ffff880055c7a000/19] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731480] cx23885[0]: =
[ffff880055c7e800/20] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731481] cx23885[0]: =
[ffff880055c72800/21] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731482] cx23885[0]: =
[ffff880055c75800/22] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731484] cx23885[0]: =
[ffff880055c72000/23] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731485] cx23885[0]: =
[ffff880055c71c00/24] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731486] cx23885[0]: =
[ffff880036875800/25] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731487] cx23885[0]: =
[ffff880056f8e400/26] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731488] cx23885[0]: =
[ffff880056f88400/27] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731490] cx23885[0]: =
[ffff880056f8ac00/28] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731491] cx23885[0]: =
[ffff880056f8a800/29] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731492] cx23885[0]: =
[ffff880056f89000/30] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731493] cx23885[0]: =
[ffff880056f89400/31] cx23885_buf_queue - append to active=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731495] cx23885[0]: =
cx23885_start_dma() w: 0, h: 0, f: 0=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731498] cx23885[0]: =
cx23885_sram_channel_setup() Configuring channel [TS2 C]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731500] cx23885[0]: =
cx23885_sram_channel_setup() 0x000105e0 <- 0x00006000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731502] cx23885[0]: =
cx23885_sram_channel_setup() 0x000105f0 <- 0x000062f0=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731503] cx23885[0]: =
cx23885_sram_channel_setup() 0x00010600 <- 0x000065e0=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731504] cx23885[0]: =
cx23885_sram_channel_setup() 0x00010610 <- 0x000068d0=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731518] cx23885[0]: =
cx23885_sram_channel_setup() 0x00010620 <- 0x00006bc0=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731523] cx23885[0]: [bridge 885] =
sram setup TS2 C: bpl=3D752 lines=3D5=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731524] cx23885[0]: TS2 C - dma =
channel status dump=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731531] cx23885[0]:   cmds: init =
risc lo   : 0x5624a000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731534] cx23885[0]:   cmds: init =
risc hi   : 0x00000000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731537] cx23885[0]:   cmds: cdt =
base       : 0x000105e0=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731540] cx23885[0]:   cmds: cdt =
size       : 0x0000000a=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731543] cx23885[0]:   cmds: iq =
base        : 0x00010440=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731546] cx23885[0]:   cmds: iq =
size        : 0x00000010=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731549] cx23885[0]:   cmds: risc =
pc lo     : 0x00000000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731552] cx23885[0]:   cmds: risc =
pc hi     : 0x00000000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731555] cx23885[0]:   cmds: iq wr =
ptr      : 0x00000000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731559] cx23885[0]:   cmds: iq rd =
ptr      : 0x00000000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731562] cx23885[0]:   cmds: cdt =
current    : 0x00000000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731565] cx23885[0]:   cmds: pci =
target lo  : 0x00000000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731568] cx23885[0]:   cmds: pci =
target hi  : 0x00000000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731571] cx23885[0]:   cmds: line / =
byte    : 0x00000000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731574] cx23885[0]:   risc0: =
0x00000000 [ INVALID count=3D0 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731578] cx23885[0]:   risc1: =
0x00000000 [ INVALID count=3D0 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731582] cx23885[0]:   risc2: =
0x00000000 [ INVALID count=3D0 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731585] cx23885[0]:   risc3: =
0x00000000 [ INVALID count=3D0 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731589] cx23885[0]:   (0x00010440) =
iq 0: 0x1c0002f0 [ write sol eol count=3D752 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731593] cx23885[0]:   iq 1: =
0x569600a0 [ arg #1 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731596] cx23885[0]:   iq 2: =
0x00000000 [ arg #2 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731599] cx23885[0]:   (0x0001044c) =
iq 3: 0x00000000 [ INVALID count=3D0 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731603] cx23885[0]:   (0x00010450) =
iq 4: 0x1c0002f0 [ write sol eol count=3D752 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731607] cx23885[0]:   iq 5: =
0x36a177d0 [ arg #1 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731610] cx23885[0]:   iq 6: =
0x00000000 [ arg #2 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731613] cx23885[0]:   (0x0001045c) =
iq 7: 0x1c0002f0 [ write sol eol count=3D752 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731617] cx23885[0]:   iq 8: =
0x36a17ac0 [ arg #1 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731620] cx23885[0]:   iq 9: =
0x00000000 [ arg #2 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731623] cx23885[0]:   (0x00010468) =
iq a: 0x18000250 [ write sol count=3D592 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731627] cx23885[0]:   iq b: =
0x36a17db0 [ arg #1 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731630] cx23885[0]:   iq c: =
0x00000000 [ arg #2 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731633] cx23885[0]:   (0x00010474) =
iq d: 0x140000a0 [ write eol count=3D160 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731637] cx23885[0]:   iq e: =
0x56960000 [ arg #1 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731640] cx23885[0]:   iq f: =
0x00000000 [ arg #2 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731641] cx23885[0]: fifo: =
0x00006000 -> 0x7000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731642] cx23885[0]: ctrl: =
0x00010440 -> 0x104a0=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731645] cx23885[0]:   ptr1_reg: =
0x00006000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731648] cx23885[0]:   ptr2_reg: =
0x000105e8=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731650] cx23885[0]:   cnt1_reg: =
0x00000000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731653] cx23885[0]:   cnt2_reg: =
0x00000009=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731654] cx23885[0]: risc disasm: =
ffff88005624a000 [dma=3D0x5624a000]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731655] cx23885[0]:   0000: =
0x70000000 [ jump count=3D0 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731657] cx23885[0]:   0001: =
0x5624a00c [ arg #1 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731658] cx23885[0]:   0002: =
0x00000000 [ arg #2 ]=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731862] cx23885[0]: =
cx23885_start_dma() enabling TS int's and DMA=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731875] cx23885[0]: =
cx23885_tsport_reg_dump() Register Dump=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731878] cx23885[0]: =
cx23885_tsport_reg_dump() DEV_CNTRL2               0x00000020=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731881] cx23885[0]: =
cx23885_tsport_reg_dump() PCI_INT_MSK              0x00001F06=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731884] cx23885[0]: =
cx23885_tsport_reg_dump() AUD_INT_INT_MSK          0x00000000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731887] cx23885[0]: =
cx23885_tsport_reg_dump() AUD_INT_DMA_CTL          0x00000000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731890] cx23885[0]: =
cx23885_tsport_reg_dump() AUD_EXT_INT_MSK          0x00000000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731893] cx23885[0]: =
cx23885_tsport_reg_dump() AUD_EXT_DMA_CTL          0x00000000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731896] cx23885[0]: =
cx23885_tsport_reg_dump() PAD_CTRL                 0x00500300=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731899] cx23885[0]: =
cx23885_tsport_reg_dump() ALT_PIN_OUT_SEL          0x00000000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731902] cx23885[0]: =
cx23885_tsport_reg_dump() GPIO2                    0xC7CADA5F=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731906] cx23885[0]: =
cx23885_tsport_reg_dump() gpcnt(0x00130220)          0x00000000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731910] cx23885[0]: =
cx23885_tsport_reg_dump() gpcnt_ctl(0x00130230)      0x00000000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731913] cx23885[0]: =
cx23885_tsport_reg_dump() dma_ctl(0x00130240)        0x00000011=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731916] cx23885[0]: =
cx23885_tsport_reg_dump() lngth(0x00130250)          0x000002f0=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731919] cx23885[0]: =
cx23885_tsport_reg_dump() hw_sop_ctrl(0x00130254)    0x00470bc0=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731922] cx23885[0]: =
cx23885_tsport_reg_dump() gen_ctrl(0x00130258)       0x0000000c=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731925] cx23885[0]: =
cx23885_tsport_reg_dump() bd_pkt_status(0x0013025C)  0x00000000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731928] cx23885[0]: =
cx23885_tsport_reg_dump() sop_status(0x00130260)     0x00000000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731932] cx23885[0]: =
cx23885_tsport_reg_dump() fifo_ovfl_stat(0x00130264) 0x00000000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731935] cx23885[0]: =
cx23885_tsport_reg_dump() vld_misc(0x00130268)       0x00000000=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731938] cx23885[0]: =
cx23885_tsport_reg_dump() ts_clk_en(0x0013026C)      0x00000001=0A=
Jan 28 21:34:23 prueba kernel: [ 2169.731942] cx23885[0]: =
cx23885_tsport_reg_dump() ts_int_msk(0x00040040)     0x00001111=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290709] cx23885[0]: =
cx23885_cancel_buffers()=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290711] cx23885[0]: =
cx23885_stop_dma()=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290720] cx23885[0]: =
[ffff880055c79c00/0] cancel - dma=3D0x5624a000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290722] cx23885[0]: =
[ffff880055c78000/1] cancel - dma=3D0x56845000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290723] cx23885[0]: =
[ffff880055c79800/2] cancel - dma=3D0x57ee5000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290725] cx23885[0]: =
[ffff880055c7ec00/3] cancel - dma=3D0x563eb000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290726] cx23885[0]: =
[ffff880055c7d400/4] cancel - dma=3D0x571e7000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290728] cx23885[0]: =
[ffff880055c7f000/5] cancel - dma=3D0x36902000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290729] cx23885[0]: =
[ffff880055c7e400/6] cancel - dma=3D0x51946000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290731] cx23885[0]: =
[ffff880055c7c400/7] cancel - dma=3D0x57173000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290732] cx23885[0]: =
[ffff880055c7c000/8] cancel - dma=3D0x597de000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290734] cx23885[0]: =
[ffff880055c79000/9] cancel - dma=3D0x57dd9000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290735] cx23885[0]: =
[ffff880055c7b400/10] cancel - dma=3D0x57187000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290736] cx23885[0]: =
[ffff880055c79400/11] cancel - dma=3D0x56317000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290738] cx23885[0]: =
[ffff880055c7a400/12] cancel - dma=3D0x56261000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290739] cx23885[0]: =
[ffff880055c7b800/13] cancel - dma=3D0x51877000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290741] cx23885[0]: =
[ffff880055c7f400/14] cancel - dma=3D0x57296000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290742] cx23885[0]: =
[ffff880055c7f800/15] cancel - dma=3D0x57195000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290743] cx23885[0]: =
[ffff880055c7d000/16] cancel - dma=3D0x55c14000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290745] cx23885[0]: =
[ffff880055c78c00/17] cancel - dma=3D0x56fba000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290746] cx23885[0]: =
[ffff880055c7a800/18] cancel - dma=3D0x518b7000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290748] cx23885[0]: =
[ffff880055c7a000/19] cancel - dma=3D0x5976f000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290749] cx23885[0]: =
[ffff880055c7e800/20] cancel - dma=3D0x56224000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290750] cx23885[0]: =
[ffff880055c72800/21] cancel - dma=3D0x56743000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290752] cx23885[0]: =
[ffff880055c75800/22] cancel - dma=3D0x36baf000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290753] cx23885[0]: =
[ffff880055c72000/23] cancel - dma=3D0x518d3000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290754] cx23885[0]: =
[ffff880055c71c00/24] cancel - dma=3D0x56370000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290756] cx23885[0]: =
[ffff880036875800/25] cancel - dma=3D0x36551000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290757] cx23885[0]: =
[ffff880056f8e400/26] cancel - dma=3D0x51867000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290758] cx23885[0]: =
[ffff880056f88400/27] cancel - dma=3D0x369ae000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290760] cx23885[0]: =
[ffff880056f8ac00/28] cancel - dma=3D0x56f02000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290761] cx23885[0]: =
[ffff880056f8a800/29] cancel - dma=3D0x51836000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290762] cx23885[0]: =
[ffff880056f89000/30] cancel - dma=3D0x5187c000=0A=
Jan 28 21:34:28 prueba kernel: [ 2174.290764] cx23885[0]: =
[ffff880056f89400/31] cancel - dma=3D0x55c39000=0A=

------=_NextPart_000_006F_01D03FEF.AEB84570--

