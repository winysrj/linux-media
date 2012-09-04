Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51327 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828Ab2IDW3p (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Sep 2012 18:29:45 -0400
Received: by wgbdr13 with SMTP id dr13so6213472wgb.1
        for <linux-media@vger.kernel.org>; Tue, 04 Sep 2012 15:29:43 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 5 Sep 2012 00:29:43 +0200
Message-ID: <CALPoULWGaWykaSw4BsJBmCqiFFNU3btZwNs8JMfmCURT_eCN4Q@mail.gmail.com>
Subject: SAA7231 chipset support
From: Wombachi <wombachi@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Google tries to convince me that the Philips / NXP / Trident /
SigmaDesigns  SAA7231  chip is not (and will probably not be)
supported on Linux (mostly because of bad will from the hardware
companies).

Could you please confirm that this chip is not (and will probably not
be) supported [1]  ?

Thanks for your time


[1] as opposed to other SAA71x chips, as seen in 3.2 kernel headers
and on http://linuxtv.org/wiki/index.php/DVB-T_PCI_Cards


You'll find details below (chip details / history, partial output of
lspci -v / vv, hardware, uname -a)


1. Chip history:
- announced by NXP (2008-03):
   http://www.nxp.com/news/press-releases/2008/03/nxp-launches-world-s-smallest-single-chip-triple-mode-pctv-solution.html
- some guy at a German company began devlopments but this seems discontinued
  http://osdir.com/ml/video4linux-list/2010-07/msg00016.html
  and the src code url is dead / 404:  http://www.jusst.de/hg/saa7231/
- Trident was the next owner. See TV > PC TV > SAAA link from the CX2450X page
  http://www.tridentmicro.com/producttree/stb/satellite-stb/cx2450x/
  but they refused to give any help to linux develpers -- then finally
filed for bankrupcy
  http://forums.opensuse.org/english/get-technical-help-here/hardware/450034-saa7231-module-2.html
  https://www.linux.com/community/forums/multimedia/installing-and-using-a-saa7231-tv-card/limit/20/offset/0
- the current owner seems to be Sigma Design for the SAA71x (and
perhaps the SAA72) chips
  http://www.sigmadesigns.com/uploads/library/press_releases/120402.pdf

2. Output of lspci -v

02:00.0 Multimedia controller: Philips Semiconductors SAA7231 (rev ca)
        Subsystem: Yuan Yuan Enterprise Co., Ltd. Device 0762
        Flags: bus master, fast devsel, latency 0, IRQ 11
        Memory at dcc00000 (64-bit, non-prefetchable) [size=4M]
        Memory at dc800000 (64-bit, non-prefetchable) [size=4M]
        Capabilities: [40] MSI: Enable- Count=1/16 Maskable- 64bit+
        Capabilities: [50] Express Endpoint, MSI 00
        Capabilities: [74] Power Management version 3
        Capabilities: [7c] Vendor Specific Information: Len=84 <?>
        Capabilities: [100] Vendor Specific Information: ID=0000 Rev=0
Len=094 <?>

and lspci -vv

02:00.0 Multimedia controller: Philips Semiconductors SAA7231 (rev ca)
        Subsystem: Yuan Yuan Enterprise Co., Ltd. Device 0762
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at dcc00000 (64-bit, non-prefetchable) [size=4M]
        Region 2: Memory at dc800000 (64-bit, non-prefetchable) [size=4M]
        Capabilities: [40] MSI: Enable- Count=1/16 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [50] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<256ns, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <4us, L1 <64us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk- DLActive- BWMgmt- ABWMgmt-
        Capabilities: [74] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=55mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [7c] Vendor Specific Information: Len=84 <?>
        Capabilities: [100 v1] Vendor Specific Information: ID=0000
Rev=0 Len=094 <?>

3. Other details:

Hardware: the laptop with this chipset is an Asus N73S.
Software: Linux Kubuntu. uname -a:
   Linux Newton 3.2.0-29-generic #46-Ubuntu SMP Fri Jul 27 17:03:23
UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
