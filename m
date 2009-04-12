Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:46768 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZDLRhq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Apr 2009 13:37:46 -0400
Received: by ewy9 with SMTP id 9so1834898ewy.37
        for <linux-media@vger.kernel.org>; Sun, 12 Apr 2009 10:37:44 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 12 Apr 2009 19:37:44 +0200
Message-ID: <27463cd40904121037p1c1922fardfc52037d946a98f@mail.gmail.com>
Subject: LifeView FlyTV Express X1 MST-T2A2 - TV card with SAA7162 chip
From: Pavel Valach <valach.pavel@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,
first sorry for that "help" topic I sended, I was little confused, I
never used mailing lists before.

Now to my card:
I'm using Ubuntu 9.04 and I'm trying to get LifeView FlyTV Express X1
MST-T2A2 - TV card with Philips SAA7162 chip - to work. The card is
plugged into PCIe X1 slot. Because there is some driver for SAA716x
chips, I have been trying it. But without larger success. I managed to
install and load all modules I compiled from source archive... and I
supposed that's all. Well, now I know it isn't the end.

*lspci -vvnnnxxx*
03:00.0 Multimedia controller [0480]: Philips Semiconductors Pinnacle
PCTV 3010iX Dual Analog + DVB-T (VT8251 Ultra VLINK Controller)
[1131:7162]
	Subsystem: Animation Technologies Inc. Device [5168:0820]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 16 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at dbf00000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: [40] Message Signalled Interrupts: Mask- 64bit+ Queue=0/5 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [50] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <256ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<4us, L1 <64us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [74] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Vendor Specific Information <?>
00: 31 11 62 71 07 00 10 00 00 00 80 04 04 00 00 00
10: 04 00 f0 db 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 68 51 20 08
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 00 00
40: 05 50 8a 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 10 74 01 00 80 00 28 00 10 00 0a 00 11 6c 03 01
60: 08 00 11 00 00 0a 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 01 80 02 3e 00 00 00 00 00 00 00 00
80: 09 00 50 00 03 0c 00 00 02 02 00 00 00 00 00 00
90: 00 03 00 00 00 00 00 08 00 00 10 00 00 00 00 00
a0: 01 00 00 04 03 16 00 00 00 00 01 03 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 20 01 2a 00 00
c0: 01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


*lsmod*
Module                  Size  Used by
saa716x_ff             25864  0
saa716x_budget         16904  0
saa716x_hybrid         19336  0
saa716x_core           73012  3 saa716x_ff,saa716x_budget,saa716x_hybrid
lgdt330x               17924  0
dvb_core              112684  4 saa716x_ff,saa716x_hybrid,saa716x_core,lgdt330x
stv090x                56988  1 saa716x_ff
tda1004x               26116  1 saa716x_hybrid
mt352                  15876  0
mb86a16                30464  1 saa716x_budget
isl6423                11264  0
zl10353                16776  0
binfmt_misc            18572  1
bridge                 63904  0
stp                    11140  1 bridge
bnep                   22912  2
input_polldev          12688  0
video                  29204  0
output                 11648  1 video
lp                     19588  0
joydev                 20864  0
snd_hda_intel         557364  7
snd_pcm_oss            52352  0
snd_mixer_oss          24960  1 snd_pcm_oss
snd_pcm                99336  3 snd_hda_intel,snd_pcm_oss
snd_seq_dummy          11524  0
snd_seq_oss            41984  0
snd_seq_midi           15744  0
snd_rawmidi            33920  1 snd_seq_midi
snd_seq_midi_event     16512  2 snd_seq_oss,snd_seq_midi
snd_seq                66272  6
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
snd_timer              34064  2 snd_pcm,snd_seq
snd_seq_device         16276  5
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
iTCO_wdt               21712  0
iTCO_vendor_support    12420  1 iTCO_wdt
snd                    78792  22
snd_hda_intel,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
gspca_zc3xx            59392  0
soundcore              16800  1 snd
gspca_main             34560  1 gspca_zc3xx
ppdev                  16904  0
nvidia               8123768  50
snd_page_alloc         18704  2 snd_hda_intel,snd_pcm
compat_ioctl32         18304  1 gspca_main
intel_agp              39408  0
atl2                   38680  0
pcspkr                 11136  0
parport_pc             45096  1
parport                49584  3 lp,ppdev,parport_pc
videodev               45184  2 gspca_main,compat_ioctl32
v4l1_compat            23940  1 videodev
hid_logitech           18560  0
ff_memless             14472  1 hid_logitech
hid_a4tech             11392  0
usbhid                 47040  1 hid_logitech
floppy                 75816  0
fbcon                  49792  0
tileblit               11264  1 fbcon
font                   17024  1 fbcon
bitblit                14464  1 fbcon
softcursor             10368  1 bitblit

//I've got one webcam there as zc3xx.//
Are there any news about SAA716x driver development? Is my card in the
supported or "coming soon" list? Or how can I help with the
development of the driver if this card isn't supported?

------------
Thank you
Pavel Valach
