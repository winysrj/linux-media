Return-path: <linux-media-owner@vger.kernel.org>
Received: from relaycp03.dominioabsoluto.net ([217.116.26.84]:54726 "EHLO
	relaycp03.dominioabsoluto.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753881AbbBCVjH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2015 16:39:07 -0500
From: "dCrypt" <dcrypt@telefonica.net>
To: "'Steven Toth'" <stoth@kernellabs.com>
Cc: "'Linux-Media'" <linux-media@vger.kernel.org>
References: <54472CB702988260@smtp.movistar.es>	<02ee01d031ec$283a80f0$78af82d0$@net>	<006301d03b58$0181a9a0$0484fce0$@net>	<006e01d03fe7$4cf3dd70$e6db9850$@net> <CALzAhNVjZh7nm5_3hGpSh4ZMsstja+M_2GLh2-15F0yp8QDOVw@mail.gmail.com>
In-Reply-To: <CALzAhNVjZh7nm5_3hGpSh4ZMsstja+M_2GLh2-15F0yp8QDOVw@mail.gmail.com>
Subject: RE: [possible BUG, cx23885] Dual tuner TV card, works using one tuner only, doesn't work if both tuners are used
Date: Tue, 3 Feb 2015 22:39:06 +0100
Message-ID: <009201d03ff9$d66da1a0$8348e4e0$@net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Language: es
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Steve. 

If sending it really helps you in your development, I will gladly pay for the postage forth and back if you live in Europe. 

When my recently purchased HVR-2200 is stable in my PVR (I could still use the Terratec disabling one tuner), I will consider donating the Terratec.

BR


> -----Mensaje original-----
> De: Steven Toth [mailto:stoth@kernellabs.com]
> Enviado el: martes, 03 de febrero de 2015 20:32
> Para: dCrypt
> CC: Linux-Media
> Asunto: Re: [possible BUG, cx23885] Dual tuner TV card, works using one
> tuner only, doesn't work if both tuners are used
> 
> While I am the maintainer of the cx23885 driver, its currently
> undergoing a significant amount of churn related to Han's recent VB2
> and other changes. I consider the current driver broken until the
> feedback on the mailing list dies down. I'm reluctant to work on the
> driver while its considered unstable.
> 
> If you want to send me a Terratec card then I'll try to fund an hour to
> investigate in the coming weeks.
> 
> Best,
> 
> - Steve
> 
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com
> 
> 
> On Tue, Feb 3, 2015 at 2:26 PM, dCrypt <dcrypt@telefonica.net> wrote:
> > Steve,
> >
> > Maybe you can help me tracking down my other card's problem, as I saw
> you were owner of the (c) in the cx23885 source code.
> >
> > BR
> >
> >> -----Mensaje original-----
> >> De: linux-media-owner@vger.kernel.org [mailto:linux-media-
> >> owner@vger.kernel.org] En nombre de dCrypt
> >> Enviado el: jueves, 29 de enero de 2015 1:11
> >> Para: linux-media@vger.kernel.org
> >> CC: stoth@linuxtv.org
> >> Asunto: RE: [possible BUG, cx23885] Dual tuner TV card, works using
> one
> >> tuner only, doesn't work if both tuners are used
> >>
> >> Hi,
> >>
> >> I have attached four excerpts from /var/log/kern.log with debug=9
> >> option for module cx23885. The test flow is the following:
> >>
> >> 0) Ubuntu 14.04/kernel 3.13 just installed, latest V4L source code
> >> compiled and installed Test 1.1)
> >>       - Reboot
> >>       - sudo tzap -a 0 -x -H -c channelsv3.conf "La 1 HD.", using
> first
> >> tuner, it locks and works
> >>       - log excerpt extracted -> test1.1-adap0-ok.log
> >>
> >> Test 1.2)
> >>       - sudo tzap -a 1 -x -H -c channelsv3.conf "La 1 HD.", using
> >> second tuner after first tuner lock, it doesn't lock and doesn't
> work
> >>       - log excerpt extracted -> test1.2-adap1-ko.log
> >>
> >> Test 2.1)
> >>       - Reboot
> >>       - sudo tzap -a 1 -x -H -c channelsv3.conf "La 1 HD.", using
> >> second tuner, it locks and works
> >>       - log excerpt extracted -> test2.1-adap1-ok.log
> >>
> >> Test 2.2)
> >>       - sudo tzap -a 0 -x -H -c channelsv3.conf "La 1 HD.", using
> first
> >> tuner after second tuner lock, it doesn't lock and doesn't work
> >>       - log excerpt extracted -> test2.2-adap0-ko.log
> >>
> >> From the logs, I interpret that, after one tuner is used and locked
> the
> >> signal, trying to use the other tuner no IRQs are fired after
> >> cx23885_start_dma(), so the driver immediately cancels buffers and
> >> stops dma. However, I am not an expert and I can't follow the full
> >> workflow, so I could be wrong.
> >>
> >> I would like to help as much as I can, but I'm afraid I need some
> >> guidance.
> >>
> >> BR
> >>
> >> -----Mensaje original-----
> >> De: linux-media-owner@vger.kernel.org [mailto:linux-media-
> >> owner@vger.kernel.org] En nombre de dCrypt Enviado el: sábado, 17 de
> >> enero de 2015 1:26
> >> Para: james@ejbdigital.com.au
> >> CC: linux-media@vger.kernel.org; hverkuil@xs4all.nl
> >> Asunto: RE: [possible BUG, cx23885] Dual tuner TV card, works using
> one
> >> tuner only, doesn't work if both tuners are used
> >>
> >> Hi, James.
> >>
> >> After searching for somebody posting some issues similar to mine, I
> >> think this one you posted to the mailing list can be related:
> >>
> >> https://www.mail-archive.com/linux-
> >> media%40vger.kernel.org/msg80078.html
> >>
> >> I'm having problems using both tuners in a dual tuner card (Terratec
> >> Cinergy T PCIe Dual), also based on cx23885, but it uses different
> >> frontends/tuners than yours.
> >>
> >> In summary, my problem is that I started getting signal/locking
> errors
> >> in VDR if I tuned one frontend, and VDR scanned EIT/EPG using the
> >> second tuner in the background; by disabling the second tuner it
> works.
> >> I managed to reproduce the problem by simply using dvbzap/dvbv5-zap
> in
> >> command line. And it suddenly started failing on the 1st of Dec 2014
> >> (after a frequency change in DVB-T in Spain). I tested different
> Ubuntu
> >> distros wich previously worked, but I can't manage to make it work
> now
> >> using the default kernel included in the Ubuntu ISO image that I had
> >> installed.
> >>
> >> I am testing now with Ubuntu 15.04 nightly, kernel 3.18, in a
> separate
> >> hw platform. I also tested with MythTV and TVHedaend, but as I
> managed
> >> to reproduce it with the dvb command line tools, I don't test any
> GUI
> >> anymore. I've also tested it in Windows 7, and it works tuning both
> >> tuners simultaneously, so I discarded a hardware problem. I've also
> >> tested with the latest git from the v4l repo by following this guide
> >> ("basic" approach):
> >>
> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-
> >> DVB_Device_Drivers with the same result.
> >>
> >> My guess is that something in the cx23885 driver does not like the
> >> current DVB-T signal in Spain. Is it possible that something similar
> >> happened where you live?
> >>
> >> The problem is that I don't know how to proceed to debug the issue,
> so
> >> any advice is welcome.
> >>
> >> BR
> >>
> >> -----Mensaje original-----
> >> De: linux-media-owner@vger.kernel.org [mailto:linux-media-
> >> owner@vger.kernel.org] En nombre de dCrypt Enviado el: viernes, 09
> de
> >> enero de 2015 8:16
> >> Para: blind Pete
> >> CC: linux-media@vger.kernel.org
> >> Asunto: RE: [BUG] Dual tuner TV card, works using one tuner only,
> >> doesn't work if both tuners are used
> >>
> >> Hi, blind Pete.
> >>
> >> Thank you for taking your time to answer.
> >>
> >> Yes, I tried different kernels focusing con Ubuntu distro. I don't
> >> remember the exact kernel version, but at least those included by
> >> default in the Ubuntu 12.04 lts and 14.04 lts ISO image, which
> worked
> >> for me. The latest Ubuntu version I tested was the nightly 15.04
> from
> >> the 7th of January.
> >>
> >> BREl 9/1/2015 4:46, blind Pete <0123peter@gmail.com> escribió:
> >> >
> >> > Hi dCrypt,
> >> >
> >> > I'm not a developer at all.  I'm not even sure why I read this
> list,
> >> > but can you determine if the problem is associated with a
> particular
> >> > kernel version?  i.e. if it works on x.y.z but fails on x.y.(z+1)
> you
> >> > have a starting point.  If you use the word "regression" and a
> kernel
> >> > version number you might get more attention - but I'm only
> guessing.
> >> >
> >> > Good luck,
> >> > blind Pete
> >> >
> >> > dCrypt wrote:
> >> >
> >> > > Hi again,
> >> > >
> >> > > I'm sorry if I sound quite rude, but I'm not sure if I am doing
> it
> >> > > right or not. I subscribed to this mailing list in order to ask
> for
> >> > > help, or to help with a bug that I've found (as instructed in
> the
> >> > > wiki http://linuxtv.org/wiki/index.php/Bug_Report), but it seems
> to
> >> > > me that the mailing list is filled up with developing messages.
> I
> >> > > don't want to participate in the development, I am a developer
> but
> >> I
> >> > > don't have the skills nor the knowledge.
> >> > >
> >> > > If this is not the right place to direct my questions, I would
> >> > > appreciate some advice.
> >> > >
> >> > > Thank you very much, and best regards.
> >> > >
> >> > > -----Mensaje original-----
> >> > > De: linux-media-owner@vger.kernel.org
> >> > > [mailto:linux-media-owner@vger.kernel.org] En nombre de dCrypt
> >> > > Enviado el: jueves, 01 de enero de 2015 22:04
> >> > > Para: linux-media@vger.kernel.org
> >> > > Asunto: [BUG] Dual tuner TV card, works using one tuner only,
> >> > > doesn't work if both tuners are used
> >> > >
> >> > > Hi,
> >> > >
> >> > > I just subscribed to the mailing list to submit information on
> the
> >> > > bug which is driving me crazy since one month ago.
> >> > >
> >> > > I have a VDR based PVR at home, installed over an Ubuntu 14.04
> LTS.
> >> > > Everything was working perfectly, until beginning of December.
> It
> >> > > seems to me that something changed that broke my PVR pretty bad.
> >> > >
> >> > > The problem is the following: tuning (zap) both tuners (it's not
> >> > > needed that both are tuned simultaneously, only one after the
> >> other,
> >> > > in no particular order) makes the tuners to enter an state where
> >> > > they can't lock the signal anymore.
> >> > >
> >> > > Facts:
> >> > >
> >> > > - My TV card is a Cinergy T PCIe Dual from Terratec
> >> > >
> >>
> (http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_T_PCIe_dual).
> >> > > - The problem arose in the form of "frontend x/0 timed out while
> >> > > tuning to channel ..." in /var/log/syslog. It happened when both
> >> > > tuners are active, during EPG scan. The problem does not happen
> if
> >> > > VDR is run with -D parameter to limit the number of frontends
> >> > > enabled. Disabling the EPG scan with both frontends enabled
> >> > > minimizes the problem, but doesn't solve it because tuning both
> >> > > frontends without any EPG scan makes the error happen again. - I
> >> > > initially thought about a problem in the DVB-T signal, because
> it
> >> > > all started the 1st of December, during the transition to a new
> set
> >> of frequencies in Spain.
> >> > > - Everything was working perfectly before the 1st, and the
> problems
> >> > > started suddenly.
> >> > > - I setup testing board for debugging, different board and
> >> > > processor, less memory, lots of Linux distros tested, Windows
> >> tested as well.
> >> > > - Both tuners works in windows without problems. Confirmed.
> >> > > - I have completely discarded problems/errors in hardware
> (because
> >> > > in Windows I can enable both tuners without problems) and VDR
> >> > > (because I can reproduce the problems at OS level, without even
> >> having VDR installed).
> >> > > - I have almost narrowed the problem at the cx23885 driver,
> because
> >> > > when it happens, I can restart the TV card to working conditions
> by
> >> > > executing "rmmod cx23885" and "modprobe cx23885"; however, as
> with
> >> > > "rmmod" several dependencies are unloaded as well, I am stuck
> and I
> >> > > am unable to go on with debugging to find out where the problem
> >> really is.
> >> > > - Tools used to test and confirm the problem are: VDR, MythTV,
> >> > > TVHeadend, dvbscan, dvbv5-scan, dvbv5-zap and others
> >> > > - Linux distros tested: Ubuntu, Fedora, Suse, yaVDR (not sure if
> >> the
> >> > > card worked at all), MythBuntu ("dvb-fe-tool -a 1 -c DVBT" was
> >> > > required to force DVB-T mode for the second tuner), and probably
> >> > > others
> >> > > - I have a Sony PlayTV also with dual tuners, which works
> without
> >> > > any problem.
> >> > >
> http://www.linuxtv.org/wiki/index.php/Sony_PlayTV_dual_tuner_DVB-T
> >> > >
> >> > > So, that's why I ask for your help. How can I further debug the
> >> problem?
> >> > > Is there something I can do?
> >> > >
> >> > > BR, and happy new year!
> >> > >
> >> > >
> >> > > INFO & TEST:
> >> > >
> >> > > ----------------------------------------------------------------
> ---
> >> ->
> >> > >
> >> > > pvr@prueba:~$ sudo lspci -vvv -s 03:00.0 03:00.0 Multimedia
> video
> >> > > controller: Conexant Systems, Inc. CX23885 PCI Video and Audio
> >> > >Decoder  (rev 04)
> >> > >         Subsystem: TERRATEC Electronic GmbH Cinergy T PCIe Dual
> >> > >         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV-
> VGASnoop-
> >> > >         ParErr-
> >> > > Stepping- SERR- FastB2B- DisINTx-
> >> > >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >> > >>TAbort-
> >> > > <TAbort- <MAbort- >SERR- <PERR- INTx-
> >> > >         Latency: 0, Cache Line Size: 4 bytes
> >> > >         Interrupt: pin A routed to IRQ 16
> >> > >         Region 0: Memory at fba00000 (64-bit, non-prefetchable)
> >> > >[size=2M]
> >> > >         Capabilities: [40] Express (v1) Endpoint, MSI 00
> >> > >                 DevCap: MaxPayload 128 bytes, PhantFunc 0,
> Latency
> >> > >L0s  <64ns, L1 <1us
> >> > >                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE-
> >> > >FLReset-
> >> > >                 DevCtl: Report errors: Correctable- Non-Fatal-
> >> > >Fatal-
> >> > > Unsupported-
> >> > >                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr-
> >> NoSnoop+
> >> > >                         MaxPayload 128 bytes, MaxReadReq 512
> bytes
> >> > >                 DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+
> >> > >AuxPwr-
> >> > > TransPend-
> >> > >                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM
> L0s
> >> > >L1,
> >> > >                 Exit
> >> > > Latency L0s <2us, L1 <4us
> >> > >                         ClockPM- Surprise- LLActRep- BwNot-
> >> > >                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled-
> >> > >CommClk+
> >> > >                         ExtSynch- ClockPM- AutWidDis- BWInt-
> >> > >AutBWInt-
> >> > >                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
> >> > >SlotClk+
> >> > > DLActive- BWMgmt- ABWMgmt-
> >> > >         Capabilities: [80] Power Management version 2
> >> > >                 Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
> >> > > PME(D0+,D1+,D2+,D3hot+,D3cold-)
> >> > >                 Status: D0 NoSoftRst- PME-Enable- DSel=0
> DScale=0
> >> > >PME-
> >> > >         Capabilities: [90] Vital Product Data
> >> > >                 Product Name: "
> >> > >                 End
> >> > >         Capabilities: [a0] MSI: Enable- Count=1/1 Maskable-
> 64bit+
> >> > >                 Address: 0000000000000000  Data: 0000
> >> > >         Capabilities: [100 v1] Advanced Error Reporting
> >> > >                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> >> > >UnxCmplt-
> >> > > RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
> >> > >                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> >> > >UnxCmplt-
> >> > > RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> >> > >                 UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
> >> > >UnxCmplt-
> >> > > RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
> >> > >                 CESta:  RxErr- BadTLP- BadDLLP- Rollover-
> Timeout-
> >> > > NonFatalErr-
> >> > >                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover-
> Timeout-
> >> > > NonFatalErr-
> >> > >                 AERCap: First Error Pointer: 14, GenCap- CGenEn-
> >> > >ChkCap-
> >> > > ChkEn-
> >> > >         Capabilities: [200 v1] Virtual Channel
> >> > >                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
> >> > >                 Arb:    Fixed+ WRR32+ WRR64+ WRR128-
> >> > >                 Ctrl:   ArbSelect=WRR64
> >> > >                 Status: InProgress-
> >> > >                 Port Arbitration Table [240] <?>
> >> > >                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1
> >> > >RejSnoopTrans-
> >> > >                         Arb:    Fixed- WRR32- WRR64- WRR128-
> >> > >TWRR128-
> >> > > WRR256-
> >> > >                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed
> >> > >TC/VC=ff
> >> > >                         Status: NegoPending- InProgress-
> >> > >         Kernel driver in use: cx23885
> >> > >
> >> > > ----------------------------------------------------------------
> ---
> >> ->
> >> > >
> >> > > pvr@prueba:~$ dmesg | grep cx
> >> > > [   12.812789] cx23885 driver version 0.0.3 loaded [
> 12.812997]
> >> > > CORE cx23885[0]: subsystem: 153b:117e, board: TerraTec Cinergy T
> >> > > PCIe Dual [card=34,autodetected] [   12.949340] cx25840 11-0044:
> >> > > cx23885 A/V decoder found @ 0x88
> >> > > (cx23885[0])
> >> > > [   13.723953] cx25840 11-0044: loaded v4l-cx23885-avcore-01.fw
> >> > > firmware
> >> > > (16382 bytes)
> >> > > [   13.739701] cx23885_dvb_register() allocating 1 frontend(s) [
> >> > > 13.739704] cx23885[0]: cx23885 based dvb card [   13.852565]
> DVB:
> >> > > registering new adapter (cx23885[0]) [   13.852569] cx23885
> >> > > 0000:03:00.0: DVB: registering adapter 0 frontend 0 (DRXK DVB-
> T)...
> >> > > [   13.852749] cx23885_dvb_register() allocating 1 frontend(s) [
> >> > > 13.852750] cx23885[0]: cx23885 based dvb card [   13.958613]
> DVB:
> >> > > registering new adapter (cx23885[0]) [   13.958618] cx23885
> >> > > 0000:03:00.0: DVB: registering adapter 1 frontend 0 (DRXK DVB-C
> >> > > DVB-T)...
> >> > > [   13.958934] cx23885_dev_checkrevision() Hardware revision =
> 0xa5
> >> > > [   13.958939] cx23885[0]/0: found at 0000:03:00.0, rev: 4, irq:
> >> 16,
> >> > > latency: 0, mmio: 0xfba00000
> >> > >
> >> > > ----------------------------------------------------------------
> ---
> >> ->
> >> > >
> >> > > pvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c channelsv5.conf -a 0
> -x
> >> > >using  demux '/dev/dvb/adapter0/demux0'
> >> > > reading channels from file 'channelsv5.conf'
> >> > > service has pid type 05:  115
> >> > > tuning to 770000000 Hz
> >> > >        (0x00) Quality= Good Signal= 100,00% C/N= 11,30dB UCB= 2
> >> > >postBER= 0  preBER= 57,9x10^-6 PER= 48,8x10^-6  Lock   (0x1f)
> >> > >Quality= Good Signal= 100,00% C/N= 11,80dB UCB= 3 postBER= 0
> >> preBER=
> >> > >55,1x10^-6 PER= 0  pvr@prueba:~$  pvr@prueba:~$ sudo dvbv5-zap
> "La 1
> >> > >HD." -c channelsv5.conf -a 0 -x using  demux
> >> > >'/dev/dvb/adapter0/demux0'
> >> > > reading channels from file 'channelsv5.conf'
> >> > > service has pid type 05:  115
> >> > > tuning to 770000000 Hz
> >> > >        (0x00) Quality= Good Signal= 100,00% C/N= 11,80dB UCB= 3
> >> > >postBER= 0  preBER= 63,6x10^-6 PER= 56,3x10^-6  Lock   (0x1f)
> >> > >Quality= Good Signal= 100,00% C/N= 12,20dB UCB= 4 postBER=
> >> > > 5,39x10^-6 preBER= 0 PER= 0
> >> > > pvr@prueba:~$
> >> > > pvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c channelsv5.conf -a 0
> -x
> >> > >using  demux '/dev/dvb/adapter0/demux0'
> >> > > reading channels from file 'channelsv5.conf'
> >> > > service has pid type 05:  115
> >> > > tuning to 770000000 Hz
> >> > >        (0x00) Quality= Good Signal= 100,00% C/N= 12,20dB UCB= 4
> >> > >postBER=
> >> > > 1,01x10^-6 preBER= 58,6x10^-6 PER= 61,0x10^-6  Lock   (0x1f)
> >> > >Quality= Good Signal= 100,00% C/N= 12,10dB UCB= 4 postBER= 0
> >> preBER=
> >> > >55,1x10^-6 PER= 0  pvr@prueba:~$  pvr@prueba:~$ sudo dvbv5-zap
> "La 1
> >> > >HD." -c channelsv5.conf -a 1 -x using  demux
> >> > >'/dev/dvb/adapter1/demux0'
> >> > > reading channels from file 'channelsv5.conf'
> >> > > service has pid type 05:  115
> >> > > tuning to 770000000 Hz
> >> > >        (0x00) Signal= 0,00%
> >> > > Viterbi(0x07) Signal= 100,00% C/N= 10,00dB
> >> > > Viterbi(0x07) Signal= 100,00% C/N= 0,00dB
> >> > > Viterbi(0x07) Signal= 100,00% C/N= 0,00dB
> >> > > Viterbi(0x07) Signal= 100,00% C/N= 0,00dB
> >> > > Viterbi(0x07) Signal= 100,00% C/N= 0,00dB
> >> > > Viterbi(0x07) Signal= 100,00% C/N= 0,00dB
> >> > >
> >> > > ^Cpvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c channelsv5.conf -a
> 0 -
> >> x
> >> > >using  demux '/dev/dvb/adapter0/demux0'
> >> > > reading channels from file 'channelsv5.conf'
> >> > > service has pid type 05:  115
> >> > > tuning to 770000000 Hz
> >> > >        (0x00) Quality= Good Signal= 100,00% C/N= 12,10dB UCB= 4
> >> > >postBER=
> >> > > 850x10^-9 preBER= 58,0x10^-6 PER= 51,4x10^-6
> >> > > Viterbi(0x07) Signal= 100,00% C/N= 0,00dB
> >> > > Viterbi(0x07) Signal= 100,00% C/N= 0,00dB
> >> > > Viterbi(0x07) Signal= 100,00% C/N= 0,00dB
> >> > > Viterbi(0x07) Signal= 100,00% C/N= 8,80dB
> >> > > Viterbi(0x07) Signal= 100,00% C/N= 10,00dB
> >> > >
> >> > > ^Cpvr@prueba:~$ sudo rmmod cx23885
> >> > > pvr@prueba:~$ sudo modprobe cx23885  pvr@prueba:~$
> pvr@prueba:~$
> >> > >pvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c channelsv5.conf -a 1 -
> x
> >> > >using  demux '/dev/dvb/adapter1/demux0'
> >> > > reading channels from file 'channelsv5.conf'
> >> > > service has pid type 05:  115
> >> > > tuning to 770000000 Hz
> >> > >        (0x00) Signal= 0,00%
> >> > > Lock   (0x1f) Quality= Good Signal= 100,00% C/N= 10,40dB UCB= 0
> >> > >postBER= 0  preBER= 55,1x10^-6 PER= 0  pvr@prueba:~$ sudo dvbv5-
> zap
> >> > >"La 1 HD." -c channelsv5.conf -a 1 -x using  demux
> >> > >'/dev/dvb/adapter1/demux0'
> >> > > reading channels from file 'channelsv5.conf'
> >> > > service has pid type 05:  115
> >> > > tuning to 770000000 Hz
> >> > >        (0x00) Quality= Good Signal= 100,00% C/N= 10,40dB UCB= 0
> >> > >postBER= 0  preBER= 36,7x10^-6 PER= 0  Lock   (0x1f) Quality=
> Good
> >> > >Signal= 100,00% C/N= 11,90dB UCB= 1 postBER= 0  preBER= 331x10^-6
> >> > >PER= 0  pvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c
> channelsv5.conf -
> >> a
> >> > >1 -x using  demux '/dev/dvb/adapter1/demux0'
> >> > > reading channels from file 'channelsv5.conf'
> >> > > service has pid type 05:  115
> >> > > tuning to 770000000 Hz
> >> > >        (0x00) Quality= Good Signal= 100,00% C/N= 11,90dB UCB= 1
> >> > >postBER= 0  preBER= 175x10^-6 PER= 40,7x10^-6  Lock   (0x1f)
> >> Quality=
> >> > >Good Signal= 100,00% C/N= 12,30dB UCB= 2 postBER= 0  preBER=
> >> > >55,1x10^-6 PER= 0  pvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c
> >> > >channelsv5.conf -a 0 -x using  demux '/dev/dvb/adapter0/demux0'
> >> > > reading channels from file 'channelsv5.conf'
> >> > > service has pid type 05:  115
> >> > > tuning to 770000000 Hz
> >> > >        (0x00) Signal= 0,00%
> >> > > Viterbi(0x07) Signal= 100,00% C/N= 11,60dB
> >> > > Viterbi(0x07) Signal= 100,00% C/N= 0,00dB
> >> > > Viterbi(0x07) Signal= 100,00% C/N= 0,00dB
> >> > > Viterbi(0x07) Signal= 100,00% C/N= 0,00dB
> >> > >
> >> > > ^Cpvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c channelsv5.conf -a
> 1 -
> >> x
> >> > >using  demux '/dev/dvb/adapter1/demux0'
> >> > > reading channels from file 'channelsv5.conf'
> >> > > service has pid type 05:  115
> >> > > tuning to 770000000 Hz
> >> > >        (0x00) Quality= Good Signal= 100,00% C/N= 12,30dB UCB= 2
> >> > >postBER= 0  preBER= 138x10^-6 PER= 54,3x10^-6
> >> > > Viterbi(0x07) Signal= 100,00% C/N= 10,20dB
> >> > > Viterbi(0x07) Signal= 100,00% C/N= 11,70dB
> >> > > Viterbi(0x07) Signal= 100,00% C/N= 0,00dB
> >> > > Viterbi(0x07) Signal= 100,00% C/N= 10,40dB
> >> > >
> >> > > ^Cpvr@prueba:~$
> >> > >
> >> > >
> >> > > --
> >> > > To unsubscribe from this list: send the line "unsubscribe
> >> > > linux-media" in the body of a message to
> majordomo@vger.kernel.org
> >> > > More majordomo info at http://vger.kernel.org/majordomo-
> info.html
> >> > --
> >> > blind Pete
> >> > Sig goes here...
> >> >
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe linux-
> >> media"
> >> > in the body of a message to majordomo@vger.kernel.org More
> majordomo
> >> > info at  http://vger.kernel.org/majordomo-info.html
> >> N     r  y   b X  ǧv ^ )޺{.n +    {   bj)   w*jg         ݢj/   z ޖ
> 2 ޙ
> >> & )ߡ a       G   h   j:+v   w ٥
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-
> media"
> >> in the body of a message to majordomo@vger.kernel.org More majordomo
> >> info at  http://vger.kernel.org/majordomo-info.html

