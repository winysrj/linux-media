Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp22.acens.net ([86.109.99.146]:33663 "EHLO smtp.movistar.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751085AbbAFXqk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Jan 2015 18:46:40 -0500
Received: from ElGrande (83.56.11.105) by smtp.movistar.es (8.6.122.03) (authenticated as dcrypt$telefonica.net)
        id 545397C002282146 for linux-media@vger.kernel.org; Tue, 6 Jan 2015 23:46:36 +0000
From: "dCrypt" <dcrypt@telefonica.net>
To: <linux-media@vger.kernel.org>
References: <007d01d02606$87552d70$95ff8850$@net>
In-Reply-To: <007d01d02606$87552d70$95ff8850$@net>
Subject: RE: [BUG] Dual tuner TV card, works using one tuner only, doesn't work if both tuners are used
Date: Wed, 7 Jan 2015 00:46:36 +0100
Message-ID: <01ad01d02a0b$02263690$0672a3b0$@net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: es
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi again,

I'm sorry if I sound quite rude, but I'm not sure if I am doing it right or
not. I subscribed to this mailing list in order to ask for help, or to help
with a bug that I've found (as instructed in the wiki
http://linuxtv.org/wiki/index.php/Bug_Report), but it seems to me that the
mailing list is filled up with developing messages. I don't want to
participate in the development, I am a developer but I don't have the skills
nor the knowledge. 

If this is not the right place to direct my questions, I would appreciate
some advice.

Thank you very much, and best regards.

-----Mensaje original-----
De: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] En nombre de dCrypt
Enviado el: jueves, 01 de enero de 2015 22:04
Para: linux-media@vger.kernel.org
Asunto: [BUG] Dual tuner TV card, works using one tuner only, doesn't work
if both tuners are used

Hi,

I just subscribed to the mailing list to submit information on the bug which
is driving me crazy since one month ago.

I have a VDR based PVR at home, installed over an Ubuntu 14.04 LTS.
Everything was working perfectly, until beginning of December. It seems to
me that something changed that broke my PVR pretty bad. 

The problem is the following: tuning (zap) both tuners (it's not needed that
both are tuned simultaneously, only one after the other, in no particular
order) makes the tuners to enter an state where they can't lock the signal
anymore. 

Facts:

- My TV card is a Cinergy T PCIe Dual from Terratec
(http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_T_PCIe_dual).
- The problem arose in the form of "frontend x/0 timed out while tuning to
channel ..." in /var/log/syslog. It happened when both tuners are active,
during EPG scan. The problem does not happen if VDR is run with -D parameter
to limit the number of frontends enabled. Disabling the EPG scan with both
frontends enabled minimizes the problem, but doesn't solve it because tuning
both frontends without any EPG scan makes the error happen again.
- I initially thought about a problem in the DVB-T signal, because it all
started the 1st of December, during the transition to a new set of
frequencies in Spain.
- Everything was working perfectly before the 1st, and the problems started
suddenly.
- I setup testing board for debugging, different board and processor, less
memory, lots of Linux distros tested, Windows tested as well.
- Both tuners works in windows without problems. Confirmed.
- I have completely discarded problems/errors in hardware (because in
Windows I can enable both tuners without problems) and VDR (because I can
reproduce the problems at OS level, without even having VDR installed).
- I have almost narrowed the problem at the cx23885 driver, because when it
happens, I can restart the TV card to working conditions by executing "rmmod
cx23885" and "modprobe cx23885"; however, as with "rmmod" several
dependencies are unloaded as well, I am stuck and I am unable to go on with
debugging to find out where the problem really is.
- Tools used to test and confirm the problem are: VDR, MythTV, TVHeadend,
dvbscan, dvbv5-scan, dvbv5-zap and others
- Linux distros tested: Ubuntu, Fedora, Suse, yaVDR (not sure if the card
worked at all), MythBuntu ("dvb-fe-tool -a 1 -c DVBT" was required to force
DVB-T mode for the second tuner), and probably others
- I have a Sony PlayTV also with dual tuners, which works without any
problem. http://www.linuxtv.org/wiki/index.php/Sony_PlayTV_dual_tuner_DVB-T

So, that's why I ask for your help. How can I further debug the problem? Is
there something I can do?

BR, and happy new year!


INFO & TEST:

-------------------------------------------------------------------->

pvr@prueba:~$ sudo lspci -vvv -s 03:00.0 03:00.0 Multimedia video
controller: Conexant Systems, Inc. CX23885 PCI Video and Audio Decoder (rev
04)
        Subsystem: TERRATEC Electronic GmbH Cinergy T PCIe Dual
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 4 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fba00000 (64-bit, non-prefetchable) [size=2M]
        Capabilities: [40] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr-
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s <2us, L1 <4us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] Vital Product Data
                Product Name: "
                End
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr-
                AERCap: First Error Pointer: 14, GenCap- CGenEn- ChkCap-
ChkEn-
        Capabilities: [200 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed+ WRR32+ WRR64+ WRR128-
                Ctrl:   ArbSelect=WRR64
                Status: InProgress-
                Port Arbitration Table [240] <?>
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Kernel driver in use: cx23885

-------------------------------------------------------------------->

pvr@prueba:~$ dmesg | grep cx
[   12.812789] cx23885 driver version 0.0.3 loaded
[   12.812997] CORE cx23885[0]: subsystem: 153b:117e, board: TerraTec
Cinergy T PCIe Dual [card=34,autodetected]
[   12.949340] cx25840 11-0044: cx23885 A/V decoder found @ 0x88
(cx23885[0])
[   13.723953] cx25840 11-0044: loaded v4l-cx23885-avcore-01.fw firmware
(16382 bytes)
[   13.739701] cx23885_dvb_register() allocating 1 frontend(s)
[   13.739704] cx23885[0]: cx23885 based dvb card
[   13.852565] DVB: registering new adapter (cx23885[0])
[   13.852569] cx23885 0000:03:00.0: DVB: registering adapter 0 frontend 0
(DRXK DVB-T)...
[   13.852749] cx23885_dvb_register() allocating 1 frontend(s)
[   13.852750] cx23885[0]: cx23885 based dvb card
[   13.958613] DVB: registering new adapter (cx23885[0])
[   13.958618] cx23885 0000:03:00.0: DVB: registering adapter 1 frontend 0
(DRXK DVB-C DVB-T)...
[   13.958934] cx23885_dev_checkrevision() Hardware revision = 0xa5
[   13.958939] cx23885[0]/0: found at 0000:03:00.0, rev: 4, irq: 16,
latency: 0, mmio: 0xfba00000

-------------------------------------------------------------------->

pvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c channelsv5.conf -a 0 -x using
demux '/dev/dvb/adapter0/demux0'
reading channels from file 'channelsv5.conf'
service has pid type 05:  115
tuning to 770000000 Hz
       (0x00) Quality= Good Signal= 100,00% C/N= 11,30dB UCB= 2 postBER= 0
preBER= 57,9x10^-6 PER= 48,8x10^-6
Lock   (0x1f) Quality= Good Signal= 100,00% C/N= 11,80dB UCB= 3 postBER= 0
preBER= 55,1x10^-6 PER= 0
pvr@prueba:~$
pvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c channelsv5.conf -a 0 -x using
demux '/dev/dvb/adapter0/demux0'
reading channels from file 'channelsv5.conf'
service has pid type 05:  115
tuning to 770000000 Hz
       (0x00) Quality= Good Signal= 100,00% C/N= 11,80dB UCB= 3 postBER= 0
preBER= 63,6x10^-6 PER= 56,3x10^-6
Lock   (0x1f) Quality= Good Signal= 100,00% C/N= 12,20dB UCB= 4 postBER=
5,39x10^-6 preBER= 0 PER= 0
pvr@prueba:~$
pvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c channelsv5.conf -a 0 -x using
demux '/dev/dvb/adapter0/demux0'
reading channels from file 'channelsv5.conf'
service has pid type 05:  115
tuning to 770000000 Hz
       (0x00) Quality= Good Signal= 100,00% C/N= 12,20dB UCB= 4 postBER=
1,01x10^-6 preBER= 58,6x10^-6 PER= 61,0x10^-6
Lock   (0x1f) Quality= Good Signal= 100,00% C/N= 12,10dB UCB= 4 postBER= 0
preBER= 55,1x10^-6 PER= 0
pvr@prueba:~$
pvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c channelsv5.conf -a 1 -x using
demux '/dev/dvb/adapter1/demux0'
reading channels from file 'channelsv5.conf'
service has pid type 05:  115
tuning to 770000000 Hz
       (0x00) Signal= 0,00%
Viterbi(0x07) Signal= 100,00% C/N= 10,00dB
Viterbi(0x07) Signal= 100,00% C/N= 0,00dB
Viterbi(0x07) Signal= 100,00% C/N= 0,00dB
Viterbi(0x07) Signal= 100,00% C/N= 0,00dB
Viterbi(0x07) Signal= 100,00% C/N= 0,00dB
Viterbi(0x07) Signal= 100,00% C/N= 0,00dB

^Cpvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c channelsv5.conf -a 0 -x using
demux '/dev/dvb/adapter0/demux0'
reading channels from file 'channelsv5.conf'
service has pid type 05:  115
tuning to 770000000 Hz
       (0x00) Quality= Good Signal= 100,00% C/N= 12,10dB UCB= 4 postBER=
850x10^-9 preBER= 58,0x10^-6 PER= 51,4x10^-6
Viterbi(0x07) Signal= 100,00% C/N= 0,00dB
Viterbi(0x07) Signal= 100,00% C/N= 0,00dB
Viterbi(0x07) Signal= 100,00% C/N= 0,00dB
Viterbi(0x07) Signal= 100,00% C/N= 8,80dB
Viterbi(0x07) Signal= 100,00% C/N= 10,00dB

^Cpvr@prueba:~$ sudo rmmod cx23885
pvr@prueba:~$ sudo modprobe cx23885
pvr@prueba:~$
pvr@prueba:~$
pvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c channelsv5.conf -a 1 -x using
demux '/dev/dvb/adapter1/demux0'
reading channels from file 'channelsv5.conf'
service has pid type 05:  115
tuning to 770000000 Hz
       (0x00) Signal= 0,00%
Lock   (0x1f) Quality= Good Signal= 100,00% C/N= 10,40dB UCB= 0 postBER= 0
preBER= 55,1x10^-6 PER= 0
pvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c channelsv5.conf -a 1 -x using
demux '/dev/dvb/adapter1/demux0'
reading channels from file 'channelsv5.conf'
service has pid type 05:  115
tuning to 770000000 Hz
       (0x00) Quality= Good Signal= 100,00% C/N= 10,40dB UCB= 0 postBER= 0
preBER= 36,7x10^-6 PER= 0
Lock   (0x1f) Quality= Good Signal= 100,00% C/N= 11,90dB UCB= 1 postBER= 0
preBER= 331x10^-6 PER= 0
pvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c channelsv5.conf -a 1 -x using
demux '/dev/dvb/adapter1/demux0'
reading channels from file 'channelsv5.conf'
service has pid type 05:  115
tuning to 770000000 Hz
       (0x00) Quality= Good Signal= 100,00% C/N= 11,90dB UCB= 1 postBER= 0
preBER= 175x10^-6 PER= 40,7x10^-6
Lock   (0x1f) Quality= Good Signal= 100,00% C/N= 12,30dB UCB= 2 postBER= 0
preBER= 55,1x10^-6 PER= 0
pvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c channelsv5.conf -a 0 -x using
demux '/dev/dvb/adapter0/demux0'
reading channels from file 'channelsv5.conf'
service has pid type 05:  115
tuning to 770000000 Hz
       (0x00) Signal= 0,00%
Viterbi(0x07) Signal= 100,00% C/N= 11,60dB
Viterbi(0x07) Signal= 100,00% C/N= 0,00dB
Viterbi(0x07) Signal= 100,00% C/N= 0,00dB
Viterbi(0x07) Signal= 100,00% C/N= 0,00dB

^Cpvr@prueba:~$ sudo dvbv5-zap "La 1 HD." -c channelsv5.conf -a 1 -x using
demux '/dev/dvb/adapter1/demux0'
reading channels from file 'channelsv5.conf'
service has pid type 05:  115
tuning to 770000000 Hz
       (0x00) Quality= Good Signal= 100,00% C/N= 12,30dB UCB= 2 postBER= 0
preBER= 138x10^-6 PER= 54,3x10^-6
Viterbi(0x07) Signal= 100,00% C/N= 10,20dB
Viterbi(0x07) Signal= 100,00% C/N= 11,70dB
Viterbi(0x07) Signal= 100,00% C/N= 0,00dB
Viterbi(0x07) Signal= 100,00% C/N= 10,40dB

^Cpvr@prueba:~$


--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

