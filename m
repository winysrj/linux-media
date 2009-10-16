Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout.eastlink.ca ([24.222.0.30]:52092 "EHLO
	smtpout.eastlink.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759080AbZJPMr2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 08:47:28 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Received: from ip04.eastlink.ca ([unknown] [24.222.39.52])
 by mta05.eastlink.ca (Sun Java(tm) System Messaging Server 7u2-7.02 64bit
 (built Apr 16 2009)) with ESMTP id <0KRL006G5Y63U8B1@mta05.eastlink.ca> for
 linux-media@vger.kernel.org; Fri, 16 Oct 2009 09:46:51 -0300 (ADT)
Message-id: <4AD86B3A.8010704@apple2pl.us>
Date: Fri, 16 Oct 2009 09:46:50 -0300
From: Donald Bailey <donnie@apple2pl.us>
To: linux-media@vger.kernel.org
Subject: Status of CX25821 PCI-E capture driver
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I recently picked up a 16 port DVR card from China which uses two 
CX25821 chips.  I compiled the staging driver for it and was able to 
load it successfully with kernel 2.6.32-rc2.  But I can't find any /dev 
devices to get at the inputs.  I created a character device with a 
major/minor of 81/0 but am unable to open it.

What device major/minor should I be using or is the driver that far 
yet?  Do I need to add a card definition to get this going?

Again, I'm using kernel 2.6.32-rc2 with the CX25821 staging module.

[root@mary dev]# uname -a
Linux mary 2.6.32-rc2 #1 SMP Tue Sep 29 16:03:18 ADT 2009 x86_64 x86_64 
x86_64 GNU/Linux

dmesg output when module loaded:

Linux video capture interface: v2.00
cx25821: module is from the staging directory, the quality is unknown, 
you have been warned.
cx25821 driver version 0.0.106 loaded

lspci -nnvvv output:

07:00.0 Multimedia video controller [0400]: Conexant Systems, Inc. 
Device [14f1:8210]
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 10
    Region 0: Memory at dfc00000 (64-bit, non-prefetchable) [size=2M]
    Capabilities: [40] Express (v1) Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, 
L1 <1us
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <2us, L1 <4us
            ClockPM- Suprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- 
DLActive- BWMgmt- ABWMgmt-
    Capabilities: [80] Power Management version 3
        Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [90] Vital Product Data <?>
    Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ 
Count=1/1 Enable-
        Address: 0000000000000000  Data: 0000
    Capabilities: [100] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
        UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSVoil-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
    Capabilities: [200] Virtual Channel <?>

08:00.0 Multimedia video controller [0400]: Conexant Systems, Inc. 
Device [14f1:8210]
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 10
    Region 0: Memory at dfe00000 (64-bit, non-prefetchable) [size=2M]
    Capabilities: [40] Express (v1) Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, 
L1 <1us
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <2us, L1 <4us
            ClockPM- Suprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- 
DLActive- BWMgmt- ABWMgmt-
    Capabilities: [80] Power Management version 3
        Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [90] Vital Product Data <?>
    Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ 
Count=1/1 Enable-
        Address: 0000000000000000  Data: 0000
    Capabilities: [100] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
        UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSVoil-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
        CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
        AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
    Capabilities: [200] Virtual Channel <?>



[root@mary dev]# lsmod
Module                  Size  Used by
berry_charge            3293  0
cx25821               111230  0
fuse                   54209  2
nvidia              10302077  26
sit                     8840  0
tunnel4                 2475  1 sit
v4l2_common            14983  1 cx25821
videodev               33367  2 cx25821,v4l2_common
v4l1_compat            11804  1 videodev
v4l2_compat_ioctl32     9328  1 videodev
videobuf_dma_sg        10088  1 cx25821
videobuf_core          15015  2 cx25821,videobuf_dma_sg
btcx_risc               3586  1 cx25821
tveeprom               12611  1 cx25821
ipt_MASQUERADE          1735  1
iptable_nat             3692  1
nf_nat                 15263  2 ipt_MASQUERADE,iptable_nat
sco                     8020  2
bridge                 43131  0
stp                     1871  1 bridge
bnep                   10212  2
l2cap                  25937  3 bnep
crc16                   1519  1 l2cap
bluetooth              48464  5 sco,bnep,l2cap
rfkill                 15696  1 bluetooth
sunrpc                184847  1
ipv6                  262918  77 sit
dm_multipath           14064  0
raid1                  18477  1
uinput                  6789  0
snd_intel8x0           27964  3
snd_ac97_codec        112068  1 snd_intel8x0
ac97_bus                1258  1 snd_ac97_codec
snd_seq_dummy           1622  0
snd_seq_oss            28403  0
snd_seq_midi_event      5828  1 snd_seq_oss
snd_seq                49546  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
snd_pcm_oss            39558  0
snd_mpu401              6596  0
firewire_ohci          20222  0
firewire_core          41233  1 firewire_ohci
snd_mixer_oss          13386  1 snd_pcm_oss
snd_mpu401_uart         5880  1 snd_mpu401
snd_pcm                75376  3 snd_intel8x0,snd_ac97_codec,snd_pcm_oss
snd_rawmidi            19255  1 snd_mpu401_uart
snd_seq_device          5769  4 
snd_seq_dummy,snd_seq_oss,snd_seq,snd_rawmidi
snd_timer              18466  2 snd_seq,snd_pcm
i2c_nforce2             5677  0
k8temp                  3579  0
ppdev                   5322  0
snd                    57873  19 
snd_intel8x0,snd_ac97_codec,snd_seq_dummy,snd_seq_oss,snd_seq,snd_pcm_oss,snd_mpu401,snd_mixer_oss,snd_mpu401_uart,snd_pcm,snd_rawmidi,snd_seq_device,snd_timer
parport_pc             20715  0
hwmon                   1758  1 k8temp
forcedeth              47910  0
floppy                 52095  0
parport                32662  2 ppdev,parport_pc
soundcore               6047  1 snd
crc_itu_t               1539  1 firewire_core
pcspkr                  1854  0
sky2                   40941  0
sata_sil24             11675  0
snd_page_alloc          7109  2 snd_intel8x0,snd_pcm
ns558                   2378  0
i2c_core               18993  6 
cx25821,nvidia,v4l2_common,videodev,tveeprom,i2c_nforce2
gameport                8936  2 ns558
pata_amd               10803  0
ata_generic             3419  0
pata_acpi               3267  0
sata_nv                20228  8
raid456                44977  1
async_raid6_recov       5098  1 raid456
async_pq                4115  2 raid456,async_raid6_recov
async_xor               3122  3 raid456,async_raid6_recov,async_pq
xor                     4608  1 async_xor
async_memcpy            1298  2 raid456,async_raid6_recov
async_tx                2097  5 
raid456,async_raid6_recov,async_pq,async_xor,async_memcpy
raid6_pq               78519  3 raid456,async_raid6_recov,async_pq

