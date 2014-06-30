Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:48253 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaF3Waz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jun 2014 18:30:55 -0400
Received: by mail-ob0-f172.google.com with SMTP id uy5so9693301obc.31
        for <linux-media@vger.kernel.org>; Mon, 30 Jun 2014 15:30:55 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 1 Jul 2014 01:30:55 +0300
Message-ID: <CANtDUYzhibHAis3Qg=nj=nbYf+NeUqS8GJ7kMm4nYZHOSBOBxA@mail.gmail.com>
Subject: 
From: =?UTF-8?B?VmzEg2R1xaMgRnLEg8WjaW1hbg==?=
	<fratiman.vladut@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have an capture card with two bt878A fusion chip and 16 imputs.
Linux don't recognize and cannot get to work. How can do to resolve that?
This is message from lspci (i put only for one decive)
12:0c.0 Multimedia video controller [0400]: Brooktree Corporation
Bt878 Video Capture [109e:036e] (rev 11)
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 132 (4000ns min, 10000ns max)
Interrupt: pin A routed to IRQ 22
Region 0: Memory at d0000000 (32-bit, prefetchable) [size=4K]
Capabilities: [44] Vital Product Data
pcilib: sysfs_read_vpd: read failed: Connection timed out
Not readable
Capabilities: [4c] Power Management version 2
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: bttv

With regspy on indows i have this:
BT878 Card [0]:

Vendor ID:           0x109e
Device ID:           0x036e
Subsystem ID:        0x00000000

=================================================================================

BT878 Card - Register Dump:
BT848_IFORM:                     49         (01001001)
BT848_FCNTR:                     54         (01010100)
BT848_PLL_F_LO:                  00         (00000000)
BT848_PLL_F_HI:                  00         (00000000)
BT848_PLL_XCI:                   00         (00000000)
BT848_TGCTRL:                    00         (00000000)
BT848_TDEC:                      00         (00000000)
BT848_E_CROP:                    12         (00010010)
BT848_O_CROP:                    12         (00010010)
BT848_E_VDELAY_LO:               1a         (00011010)
BT848_O_VDELAY_LO:               1a         (00011010)
BT848_E_VACTIVE_LO:              e0         (11100000)
BT848_O_VACTIVE_LO:              e0         (11100000)
BT848_E_HDELAY_LO:               82         (10000010)
BT848_O_HDELAY_LO:               82         (10000010)
BT848_E_HACTIVE_LO:              d0         (11010000)
BT848_O_HACTIVE_LO:              d0         (11010000)
BT848_E_HSCALE_HI:               00         (00000000)
BT848_O_HSCALE_HI:               00         (00000000)
BT848_E_HSCALE_LO:               c1         (11000001)
BT848_O_HSCALE_LO:               c1         (11000001)
BT848_BRIGHT:                    14         (00010100)
BT848_E_CONTROL:                 00         (00000000)
BT848_O_CONTROL:                 00         (00000000)
BT848_CONTRAST_LO:               cf         (11001111)
BT848_SAT_U_LO:                  fe         (11111110)
BT848_SAT_V_LO:                  db         (11011011)
BT848_HUE:                       00         (00000000)
BT848_E_SCLOOP:                  40         (01000000)
BT848_O_SCLOOP:                  40         (01000000)
BT848_WC_UP:                     cf         (11001111)
BT848_WC_DOWN:                   7f         (01111111)
BT848_VTOTAL_LO:                 00         (00000000)
BT848_VTOTAL_HI:                 00         (00000000)
BT848_DVSIF:                     00         (00000000)
BT848_OFORM:                     06         (00000110)
BT848_E_VSCALE_HI:               60         (01100000)
BT848_O_VSCALE_HI:               60         (01100000)
BT848_E_VSCALE_LO:               00         (00000000)
BT848_O_VSCALE_LO:               00         (00000000)
BT848_ADC:                       41         (01000001)
BT848_E_VTC:                     00         (00000000)
BT848_O_VTC:                     00         (00000000)
BT848_COLOR_FMT:                 44         (01000100)
BT848_COLOR_CTL:                 00         (00000000)
BT848_CAP_CTL:                   00         (00000000)
BT848_VBI_PACK_SIZE:             90         (10010000)
BT848_VBI_PACK_DEL:              01         (00000001)
BT848_INT_MASK:                  00000000   (00000000 00000000
00000000 00000000)
BT848_GPIO_OUT_EN:               0000b8ff   (00000000 00000000
10111000 11111111)
BT848_GPIO_OUT_EN_HIBYTE:        00000000   (00000000 00000000
00000000 00000000)
BT848_GPIO_DATA:                 00ffcd00   (00000000 11111111
11001101 00000000)
BT848_RISC_STRT_ADD:             00000000   (00000000 00000000
00000000 00000000)
BT848_GPIO_DMA_CTL:              00fc       (00000000 11111100)

end of dump

and with btspy:
### BtSpy Report ###

General information:
 Name:Broktree
 Chip: Bt878 , Rev: 0x00
 Subsystem: 0x00000000
 Vendor: Gammagraphx, Inc.
 Values to MUTE audio:
  Mute_GPOE  : 0x00b8ff
  Mute_GPDATA: 0x008803
 Has TV Tuner: No
 Number of Composite Ins: 2
  Composite in #1
   Composite1_Mux   : 2
   Composite1_GPOE  : 0x00b8ff
   Composite1_GPDATA: 0x008803
  Composite in #2
   Composite2_Mux   : 2
   Composite2_GPOE  : 0x00b8ff
   Composite2_GPDATA: 0x008803
 Has SVideo: Yes
  SVideo_Mux   : 2
  SVideo_GPOE  : 0x00b8ff
  SVideo_GPDATA: 0x008803
 Has Radio: No

I try't all card numbers when load bttv module but in the best case
only one camera i can see per device on channel 0 (using zoneminder).
Because is a tunerless card, probably my problem is to make tuner on
chip to work.
Any advice?
