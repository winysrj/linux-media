Return-path: <linux-media-owner@vger.kernel.org>
Received: from viefep28-int.chello.at ([62.179.121.48]:37048 "EHLO
	viefep28-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab0AESHe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2010 13:07:34 -0500
Received: from edge03.upc.biz ([192.168.13.238]) by viefep12-int.chello.at
          (InterMail vM.7.09.01.00 201-2219-108-20080618) with ESMTP
          id <20100105175057.TKAR13918.viefep12-int.chello.at@edge03.upc.biz>
          for <linux-media@vger.kernel.org>; Tue, 5 Jan 2010 18:50:57 +0100
Message-ID: <4B437BFE.7040003@chello.at>
Date: Tue, 05 Jan 2010 18:50:54 +0100
From: =?ISO-8859-1?Q?Franz_F=FCrba=DF?= <franz.fuerbass@chello.at>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: PROBLEM: DVB-T scan not working after ioctl
Content-Type: multipart/mixed;
 boundary="------------020700050906080100020702"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020700050906080100020702
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hello,

[1] . Can't scan for DVB-T channels with Hauppauge HVR 4000 HD.

[2] Got a scan problem with the Hauppauge HVR 4000 HD card.
If I try to scan for channels with the DVB-T frontend 
(/dev/dvb/adapter0/frontend1)
 no lock is generated after this sequence:

-open()
-ioctl( fd, FE_GET_INFO, &fe_info )
-close()
-open()
-ioctl( fd, FE_GET_INFO, &fe_info )
...

I think this is also the reason why DVB-T scanning does not work in 
MythTV and w_scan, as both programs show
the same behaviour and have many ioctl calls in the code.

[3] DVB, cx88_dvb, HVR 4000 HD, scan

[4] Linux version 2.6.32.2 (root@debian) (gcc version 4.4.2 (Debian 
4.4.2-8) ) #7 SMP Mon Jan 4 09:47:59 CET 2010

[6] The program testdvb.c demonstrates this. Please comment line 58 to 
get it work.

[7]
[7.1]
My config:
Linux debian 2.6.32.2 #7 SMP Mon Jan 4 09:47:59 CET 2010 x86_64 GNU/Linux

Gnu C                  4.4.2
Gnu make               3.81
binutils               2.20
util-linux             2.16.2
mount                  support
module-init-tools      3.11
e2fsprogs              1.41.9
Linux C Library        2.10.2
Dynamic linker (ldd)   2.10.2
Procps                 3.2.8
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               8.0
Modules Loaded         nvidia sco fuse e1000 ntfs bnep rfcomm l2cap 
bluetooth coretemp cx22702 isl6421 cx24116 cx88_dvb cx88_vp3054_i2c 
videobuf_dvb dvb_core wm8775 tuner_simple tuner_types tda9887 tda8290 
tuner snd_hda_codec_idt cx88_alsa snd_hda_intel cx8802 cx8800 
snd_hda_codec cx88xx snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm 
v4l2_common snd_seq_oss ir_common videodev i2c_algo_bit 
snd_seq_midi_event v4l2_compat_ioctl32 tveeprom snd_seq i2c_core 
snd_timer snd_seq_device snd videobuf_dma_sg btcx_risc videobuf_core 
snd_page_alloc e1000e

[7.2.] 
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     E6550  @ 2.33GHz
stepping        : 11
cpu MHz         : 2331.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow vnmi flexpriority
bogomips        : 4666.65
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     E6550  @ 2.33GHz
stepping        : 11
cpu MHz         : 2331.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow vnmi flexpriority
bogomips        : 4666.43
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:


[7.3.]

nvidia 9612708 38 - Live 0xffffffffa02c9000 (P)
sco 7571 2 - Live 0xffffffffa02c1000
fuse 52755 1 - Live 0xffffffffa02ab000
e1000 89804 0 - Live 0xffffffffa028b000
ntfs 169855 0 - Live 0xffffffffa0258000
bnep 9815 2 - Live 0xffffffffa024f000
rfcomm 30104 0 - Live 0xffffffffa0240000
l2cap 27432 6 bnep,rfcomm, Live 0xffffffffa0233000
bluetooth 47924 6 sco,bnep,rfcomm,l2cap, Live 0xffffffffa021e000
coretemp 4670 0 - Live 0xffffffffa0217000
cx22702 4963 1 - Live 0xffffffffa0210000
isl6421 1364 1 - Live 0xffffffffa020a000
cx24116 14086 1 - Live 0xffffffffa0201000
cx88_dvb 19996 0 - Live 0xffffffffa01f6000
cx88_vp3054_i2c 1711 1 cx88_dvb, Live 0xffffffffa01f0000
videobuf_dvb 4930 1 cx88_dvb, Live 0xffffffffa01e9000
dvb_core 84176 2 cx88_dvb,videobuf_dvb, Live 0xffffffffa01ca000
wm8775 3213 1 - Live 0xffffffffa01c4000
tuner_simple 11654 2 - Live 0xffffffffa01bc000
tuner_types 18054 1 tuner_simple, Live 0xffffffffa01b1000
tda9887 9257 1 - Live 0xffffffffa01a9000
tda8290 12832 0 - Live 0xffffffffa01a0000
tuner 18500 2 - Live 0xffffffffa0195000
snd_hda_codec_idt 50261 1 - Live 0xffffffffa017f000
cx88_alsa 8210 1 - Live 0xffffffffa0176000
snd_hda_intel 19022 2 - Live 0xffffffffa016a000
cx8802 12272 1 cx88_dvb, Live 0xffffffffa0161000
cx8800 26668 0 - Live 0xffffffffa0153000
snd_hda_codec 61068 2 snd_hda_codec_idt,snd_hda_intel, Live 
0xffffffffa013a000
cx88xx 70653 4 cx88_dvb,cx88_alsa,cx8802,cx8800, Live 0xffffffffa0120000
snd_hwdep 5482 1 snd_hda_codec, Live 0xffffffffa0119000
snd_pcm_oss 31609 0 - Live 0xffffffffa010a000
snd_mixer_oss 12459 1 snd_pcm_oss, Live 0xffffffffa0100000
snd_pcm 66872 4 cx88_alsa,snd_hda_intel,snd_hda_codec,snd_pcm_oss, Live 
0xffffffffa00e5000
v4l2_common 14842 4 wm8775,tuner,cx8800,cx88xx, Live 0xffffffffa00db000
snd_seq_oss 23541 0 - Live 0xffffffffa00ce000
ir_common 37736 1 cx88xx, Live 0xffffffffa00bc000
videodev 32233 5 wm8775,tuner,cx8800,cx88xx,v4l2_common, Live 
0xffffffffa00ae000
i2c_algo_bit 4675 2 cx88_vp3054_i2c,cx88xx, Live 0xffffffffa00a7000
snd_seq_midi_event 5572 1 snd_seq_oss, Live 0xffffffffa00a0000
v4l2_compat_ioctl32 6070 1 videodev, Live 0xffffffffa0099000
tveeprom 12806 1 cx88xx, Live 0xffffffffa0090000
snd_seq 43382 4 snd_seq_oss,snd_seq_midi_event, Live 0xffffffffa007c000
i2c_core 18913 16 
nvidia,cx22702,isl6421,cx24116,cx88_vp3054_i2c,wm8775,tuner_simple,tda9887,tda8290,tuner,cx8800,cx88xx,v4l2_common,videodev,i2c_algo_bit,tveeprom, 
Live 0xffffffffa0070000
snd_timer 17216 2 snd_pcm,snd_seq, Live 0xffffffffa0065000
snd_seq_device 5369 2 snd_seq_oss,snd_seq, Live 0xffffffffa005e000
snd 50234 18 
snd_hda_codec_idt,cx88_alsa,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_seq,snd_timer,snd_seq_device, 
Live 0xffffffffa0047000
videobuf_dma_sg 9800 5 cx88_dvb,cx88_alsa,cx8802,cx8800,cx88xx, Live 
0xffffffffa003e000
btcx_risc 3474 4 cx88_alsa,cx8802,cx8800,cx88xx, Live 0xffffffffa0038000
videobuf_core 14235 5 videobuf_dvb,cx8802,cx8800,cx88xx,videobuf_dma_sg, 
Live 0xffffffffa002e000
snd_page_alloc 6757 2 snd_hda_intel,snd_pcm, Live 0xffffffffa0027000
e1000e 111221 0 - Live 0xffffffffa0000000


[7.4.]
0000-001f : 
dma1                                                                                                                                                                    

0020-0021 : 
pic1                                                                                                                                                                    

0040-0043 : 
timer0                                                                                                                                                                  

0050-0053 : 
timer1                                                                                                                                                                  

0060-0060 : 
keyboard                                                                                                                                                                

0064-0064 : 
keyboard                                                                                                                                                                

0070-0077 : 
rtc                                                                                                                                                                     

0080-008f : dma page 
reg                                                                                                                                                            

00a0-00a1 : 
pic2                                                                                                                                                                    

00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : ide_generic
01f0-01f7 : ide_generic
02f8-02ff : serial
0376-0376 : ide_generic
03c0-03df : vga+
03f6-03f6 : ide_generic
0400-047f : 0000:00:1f.0
  0400-047f : pnp 00:06
    0400-0403 : ACPI PM1a_EVT_BLK
    0404-0405 : ACPI PM1a_CNT_BLK
    0408-040b : ACPI PM_TMR
    0410-0415 : ACPI CPU throttle
    0420-042f : ACPI GPE0_BLK
    0450-0450 : ACPI PM2_CNT_BLK
0500-053f : 0000:00:1f.0
  0500-053f : pnp 00:06
0680-06ff : pnp 00:06
0cf8-0cff : PCI conf1
1000-1fff : PCI Bus 0000:03
  1000-100f : 0000:03:00.0
    1000-100f : pata_marvell
  1010-1017 : 0000:03:00.0
  1018-101f : 0000:03:00.0
    1018-101f : pata_marvell
  1020-1023 : 0000:03:00.0
  1024-1027 : 0000:03:00.0
    1024-1027 : pata_marvell
2000-2fff : PCI Bus 0000:01
  2000-207f : 0000:01:00.0
3000-301f : 0000:00:1f.3
3020-303f : 0000:00:1f.2
  3020-303f : ahci
3040-305f : 0000:00:1d.2
  3040-305f : uhci_hcd
3060-307f : 0000:00:1d.1
  3060-307f : uhci_hcd
3080-309f : 0000:00:1d.0
  3080-309f : uhci_hcd
30a0-30bf : 0000:00:1a.2
  30a0-30bf : uhci_hcd
30c0-30df : 0000:00:1a.1
  30c0-30df : uhci_hcd
30e0-30ff : 0000:00:1a.0
  30e0-30ff : uhci_hcd
3400-341f : 0000:00:19.0
3420-3427 : 0000:00:1f.2
  3420-3427 : ahci
3428-342f : 0000:00:1f.2
  3428-342f : ahci
3430-3433 : 0000:00:1f.2
  3430-3433 : ahci
3434-3437 : 0000:00:1f.2
  3434-3437 : ahci
4000-4fff : PCI Bus 0000:02
5000-5fff : PCI Bus 0000:04
6000-6fff : PCI Bus 0000:05
7000-7fff : PCI Bus 0000:06



/proc/iomem
00000000-0009fbff : System 
RAM                                                                                                                                                      

0009fc00-0009ffff : 
reserved                                                                                                                                                        

000c0000-000dffff : pnp 
00:01                                                                                                                                                       

000e0000-000fffff : 
reserved                                                                                                                                                        

00100000-7ed14fff : System 
RAM                                                                                                                                                      

  01000000-013b235b : Kernel 
code                                                                                                                                                   

  013b235c-016178df : Kernel 
data                                                                                                                                                   

  016b5000-017575c3 : Kernel 
bss                                                                                                                                                    

7ed15000-7ed16fff : 
reserved                                                                                                                                                        

7ed17000-7ee34fff : System 
RAM                                                                                                                                                      

7ee35000-7eee9fff : ACPI Non-volatile 
Storage                                                                                                                                       

7eeea000-7eef2fff : ACPI Tables
7eef3000-7eef3fff : System RAM
7eef4000-7eefefff : ACPI Tables
7eeff000-7eefffff : System RAM
7ef00000-7effffff : reserved
7f000000-7fffffff : RAM buffer
80000000-8fffffff : PCI Bus 0000:01
  80000000-8fffffff : 0000:01:00.0
90000000-92ffffff : PCI Bus 0000:01
  90000000-91ffffff : 0000:01:00.0
  92000000-92ffffff : 0000:01:00.0
    92000000-92ffffff : nvidia
93000000-96ffffff : PCI Bus 0000:07
  93000000-93ffffff : 0000:07:01.4
  94000000-94ffffff : 0000:07:01.2
    94000000-94ffffff : cx88[0]
  95000000-95ffffff : 0000:07:01.1
    95000000-95ffffff : cx88[0]
  96000000-96ffffff : 0000:07:01.0
    96000000-96ffffff : cx88[0]
97000000-970fffff : PCI Bus 0000:03
  97000000-970001ff : 0000:03:00.0
97100000-9711ffff : 0000:00:19.0
  97100000-9711ffff : e1000e
97120000-97123fff : 0000:00:1b.0
  97120000-97123fff : ICH HD audio
97124000-97124fff : 0000:00:19.0
  97124000-97124fff : e1000e
97125000-971257ff : 0000:00:1f.2
  97125000-971257ff : ahci
97125800-97125bff : 0000:00:1d.7
  97125800-97125bff : ehci_hcd
97125c00-97125fff : 0000:00:1a.7
  97125c00-97125fff : ehci_hcd
97126000-971260ff : 0000:00:1f.3
97126100-9712610f : 0000:00:03.0
97200000-972fffff : PCI Bus 0000:02
97300000-973fffff : PCI Bus 0000:04
97400000-974fffff : PCI Bus 0000:05
97500000-975fffff : PCI Bus 0000:06
97600000-977fffff : PCI Bus 0000:02
97800000-979fffff : PCI Bus 0000:03
97a00000-97bfffff : PCI Bus 0000:04
97c00000-97dfffff : PCI Bus 0000:05
97e00000-97ffffff : PCI Bus 0000:06
f0000000-f7ffffff : PCI MMCONFIG 0 [00-7f]
  f0000000-f7ffffff : reserved
    f0000000-f7ffffff : pnp 00:01
feb00000-feb03fff : pnp 00:01
fec00000-fec00fff : IOAPIC 0
fed13000-fed13fff : pnp 00:01
fed14000-fed17fff : pnp 00:01
fed18000-fed18fff : pnp 00:01
fed19000-fed19fff : pnp 00:01
fed1c000-fed1ffff : pnp 00:01
fed20000-fed3ffff : pnp 00:01
fed45000-fed99fff : pnp 00:01
fee00000-fee00fff : Local APIC
fff00000-ffffffff : reserved





[7.5.]

00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM 
Controller (rev 02)
        Subsystem: Intel Corporation Device 
5044                                        
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 
0                                                                                           

        Capabilities: [e0] Vendor Specific Information 
<?>                                                  

00:01.0 PCI bridge: Intel Corporation 82G33/G31/P35/P31 Express PCI 
Express Root Port (rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+             
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-              
        Latency: 0, Cache Line Size: 64 
bytes                                                                              

        Bus: primary=00, secondary=01, subordinate=01, 
sec-latency=0                                                      
        I/O behind bridge: 
00002000-00002fff                                                                               

        Memory behind bridge: 
90000000-92ffffff                                                                            

        Prefetchable memory behind bridge: 
0000000080000000-000000008fffffff                                               

        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-                    
        BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- 
FastB2B-                                                     
                PriDiscTmr- SecDiscTmr- DiscTmrStat- 
DiscTmrSERREn-                                                       
        Capabilities: [88] Subsystem: Intel Corporation Device 
5044                                                       
        Capabilities: [80] Power Management version 
3                                                                     
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)                                
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 
PME-                                                    
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 
64bit-                                                        
                Address: fee0300c  Data: 
4171                                                                              

        Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 
00                                                         
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us                                     
                        ExtTag- RBE+ 
FLReset-                                                                              

                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-                                        
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- 
NoSnoop-                                                      
                        MaxPayload 128 bytes, MaxReadReq 128 
bytes                                                        
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-                                       
                LnkCap: Port #2, Speed 2.5GT/s, Width x16, ASPM L0s, 
Latency L0 <256ns, L1 <4us                           
                        ClockPM- Surprise- LLActRep- 
BwNot-                                                               
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+                                           
                        ExtSynch- ClockPM- AutWidDis- BWInt- 
AutBWInt-                                                    
                LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-                       
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- 
Surpise-                                         
                        Slot #  0, PowerLimit 75.000000; Interlock- 
NoCompl+                                              
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-                                   
                        Control: AttnInd Off, PwrInd On, Power- 
Interlock-                                                
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-                                      
                        Changed: MRL- PresDet+ 
LinkState-                                                                 
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-                                   
                RootCap: 
CRSVisible-                                                                                       

                RootSta: PME ReqID 0000, PMEStatus- 
PMEPending-                                                           
        Capabilities: [100] Virtual Channel 
<?>                                                                            

        Capabilities: [140] Root Complex Link 
<?>                                                                          

        Kernel driver in use: 
pcieport                                                                                     


00:03.0 Communication controller: Intel Corporation 82G33/G31/P35/P31 
Express MEI Controller (rev 02)
        Subsystem: Intel Corporation Device 
5044                                                    
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 
0                                                                                           

        Interrupt: pin A routed to IRQ 
11                                                                   
        Region 0: Memory at 97126100 (64-bit, non-prefetchable) 
[size=16]                                   
        Capabilities: [50] Power Management version 
3                                                       
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)                  
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 
PME-                                      
        Capabilities: [8c] MSI: Enable- Count=1/1 Maskable- 
64bit+                                          
                Address: 0000000000000000  Data: 
0000                                                       

00:19.0 Ethernet controller: Intel Corporation 82566DC-2 Gigabit Network 
Connection (rev 02)
        Subsystem: Intel Corporation Device 
0001                                           
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 
0                                                                                           

        Interrupt: pin A routed to IRQ 
31                                                                   
        Region 0: Memory at 97100000 (32-bit, non-prefetchable) 
[size=128K]                                 
        Region 1: Memory at 97124000 (32-bit, non-prefetchable) 
[size=4K]                                   
        Region 2: I/O ports at 3400 
[size=32]                                                               
        Capabilities: [c8] Power Management version 
2                                                       
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)                  
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 
PME-                                      
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 
64bit+                                          
                Address: 00000000fee0300c  Data: 
41d1                                                       
        Capabilities: [e0] Vendor Specific Information 
<?>                                                  
        Kernel driver in use: 
e1000e                                                                         


00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #4 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Device 
5044                                                                 
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-    
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-   
        Latency: 
0                                                                                                

        Interrupt: pin A routed to IRQ 
18                                                                        
        Region 4: I/O ports at 30e0 
[size=32]                                                                     

        Capabilities: [50] Vendor Specific Information 
<?>                                                       
        Kernel driver in use: 
uhci_hcd                                                                            


00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #5 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Device 
5044                                                                 
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-    
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-   
        Latency: 
0                                                                                                

        Interrupt: pin B routed to IRQ 
21                                                                        
        Region 4: I/O ports at 30c0 
[size=32]                                                                     

        Capabilities: [50] Vendor Specific Information 
<?>                                                       
        Kernel driver in use: 
uhci_hcd                                                                            


00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #6 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Device 
5044                                                                 
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-    
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-   
        Latency: 
0                                                                                                

        Interrupt: pin C routed to IRQ 
17                                                                        
        Region 4: I/O ports at 30a0 
[size=32]                                                                     

        Capabilities: [50] Vendor Specific Information 
<?>                                                       
        Kernel driver in use: 
uhci_hcd                                                                            


00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
Controller #2 (rev 02) (prog-if 20 [EHCI])
        Subsystem: Intel Corporation Device 
5044                                                                  
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-     
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-    
        Latency: 
0                                                                                                 

        Interrupt: pin C routed to IRQ 
17                                                                         
        Region 0: Memory at 97125c00 (32-bit, non-prefetchable) 
[size=1K]                                         
        Capabilities: [50] Power Management version 
2                                                             
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)                      
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 
PME-                                            
        Capabilities: [58] Debug port: BAR=1 
offset=00a0                                                          
        Capabilities: [98] Vendor Specific Information 
<?>                                                        
        Kernel driver in use: 
ehci_hcd                                                                             


00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio 
Controller (rev 02)
        Subsystem: Intel Corporation Device 
3001                                        
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 
bytes                                                               
        Interrupt: pin A routed to IRQ 
22                                                                   
        Region 0: Memory at 97120000 (64-bit, non-prefetchable) 
[size=16K]                                  
        Capabilities: [50] Power Management version 
2                                                       
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)                 
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 
PME-                                      
        Capabilities: [60] MSI: Enable- Count=1/1 Maskable- 
64bit+                                          
                Address: 0000000000000000  Data: 
0000                                                       
        Capabilities: [70] Express (v1) Root Complex Integrated 
Endpoint, MSI 00                            
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us                       
                        ExtTag- RBE- 
FLReset+                                                               
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-                          
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- 
NoSnoop+                                        
                        MaxPayload 128 bytes, MaxReadReq 128 
bytes                                          
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-                         
                LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, 
Latency L0 <64ns, L1 <1us           
                        ClockPM- Surprise- LLActRep- 
BwNot-                                                 
                LnkCtl: ASPM Disabled; Disabled- Retrain- 
CommClk-                                          
                        ExtSynch- ClockPM- AutWidDis- BWInt- 
AutBWInt-                                      
                LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- 
DLActive- BWMgmt- ABWMgmt-          
        Capabilities: [100] Virtual Channel 
<?>                                                             
        Capabilities: [130] Root Complex Link 
<?>                                                           
        Kernel driver in use: HDA 
Intel                                                                     

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 1 (rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+     
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-      
        Latency: 0, Cache Line Size: 64 
bytes                                                                     
        Bus: primary=00, secondary=02, subordinate=02, 
sec-latency=0                                              
        I/O behind bridge: 
00004000-00004fff                                                                       

        Memory behind bridge: 
97200000-972fffff                                                                    

        Prefetchable memory behind bridge: 
0000000097600000-00000000977fffff                                      
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-            
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- 
FastB2B-                                             
                PriDiscTmr- SecDiscTmr- DiscTmrStat- 
DiscTmrSERREn-                                               
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 
00                                                 
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us                             
                        ExtTag- RBE+ 
FLReset-                                                                      

                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-                                
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- 
NoSnoop-                                              
                        MaxPayload 128 bytes, MaxReadReq 128 
bytes                                                
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-                               
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <1us, L1 <4us                   
                        ClockPM- Surprise- LLActRep+ 
BwNot-                                                       
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk-                                   
                        ExtSynch- ClockPM- AutWidDis- BWInt- 
AutBWInt-                                            
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-                
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surpise+                                 
                        Slot #  1, PowerLimit 10.000000; Interlock- 
NoCompl-                                      
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-                           
                        Control: AttnInd Unknown, PwrInd Unknown, Power- 
Interlock-                               
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet- Interlock-                              
                        Changed: MRL- PresDet- 
LinkState-                                                         
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-                           
                RootCap: 
CRSVisible-                                                                               

                RootSta: PME ReqID 0000, PMEStatus- 
PMEPending-                                                   
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 
64bit-                                                
                Address: fee0300c  Data: 
4179                                                                     
        Capabilities: [90] Subsystem: Intel Corporation Optiplex 
755                                              
        Capabilities: [a0] Power Management version 
2                                                             
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)                        
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 
PME-                                            
        Capabilities: [100] Virtual Channel 
<?>                                                                   
        Capabilities: [180] Root Complex Link 
<?>                                                                 
        Kernel driver in use: 
pcieport                                                                             


00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 2 (rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+     
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-      
        Latency: 0, Cache Line Size: 64 
bytes                                                                     
        Bus: primary=00, secondary=03, subordinate=03, 
sec-latency=0                                              
        I/O behind bridge: 
00001000-00001fff                                                                       

        Memory behind bridge: 
97000000-970fffff                                                                    

        Prefetchable memory behind bridge: 
0000000097800000-00000000979fffff                                      
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-            
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- 
FastB2B-                                             
                PriDiscTmr- SecDiscTmr- DiscTmrStat- 
DiscTmrSERREn-                                               
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 
00                                                 
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us                             
                        ExtTag- RBE+ 
FLReset-                                                                      

                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-                                
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- 
NoSnoop-                                              
                        MaxPayload 128 bytes, MaxReadReq 128 
bytes                                                
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-                               
                LnkCap: Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <256ns, L1 <4us                 
                        ClockPM- Surprise- LLActRep+ 
BwNot-                                                       
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+                                   
                        ExtSynch- ClockPM- AutWidDis- BWInt- 
AutBWInt-                                            
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-                
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surpise+                                 
                        Slot #  2, PowerLimit 10.000000; Interlock- 
NoCompl-                                      
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-                           
                        Control: AttnInd Unknown, PwrInd Unknown, Power- 
Interlock-                               
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-                              
                        Changed: MRL- PresDet+ 
LinkState+                                                         
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-                           
                RootCap: 
CRSVisible-                                                                               

                RootSta: PME ReqID 0000, PMEStatus- 
PMEPending-                                                   
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 
64bit-                                                
                Address: fee0300c  Data: 
4181                                                                     
        Capabilities: [90] Subsystem: Intel Corporation 82801I (ICH9 
Family) PCI Express Port 2                   
        Capabilities: [a0] Power Management version 
2                                                             
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)                        
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 
PME-                                            
        Capabilities: [100] Virtual Channel 
<?>                                                                   
        Capabilities: [180] Root Complex Link 
<?>                                                                 
        Kernel driver in use: 
pcieport                                                                             


00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 3 (rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+     
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-      
        Latency: 0, Cache Line Size: 64 
bytes                                                                     
        Bus: primary=00, secondary=04, subordinate=04, 
sec-latency=0                                              
        I/O behind bridge: 
00005000-00005fff                                                                       

        Memory behind bridge: 
97300000-973fffff                                                                    

        Prefetchable memory behind bridge: 
0000000097a00000-0000000097bfffff                                      
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-            
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- 
FastB2B-                                             
                PriDiscTmr- SecDiscTmr- DiscTmrStat- 
DiscTmrSERREn-                                               
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 
00                                                 
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us                             
                        ExtTag- RBE+ 
FLReset-                                                                      

                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-                                
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- 
NoSnoop-                                              
                        MaxPayload 128 bytes, MaxReadReq 128 
bytes                                                
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-                               
                LnkCap: Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <1us, L1 <4us                   
                        ClockPM- Surprise- LLActRep+ 
BwNot-                                                       
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk-                                   
                        ExtSynch- ClockPM- AutWidDis- BWInt- 
AutBWInt-                                            
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-                
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surpise+                                 
                        Slot #  3, PowerLimit 10.000000; Interlock- 
NoCompl-                                      
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-                           
                        Control: AttnInd Unknown, PwrInd Unknown, Power- 
Interlock-                               
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet- Interlock-                              
                        Changed: MRL- PresDet- 
LinkState-                                                         
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-                           
                RootCap: 
CRSVisible-                                                                               

                RootSta: PME ReqID 0000, PMEStatus- 
PMEPending-                                                   
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 
64bit-                                                
                Address: fee0300c  Data: 
4189                                                                     
        Capabilities: [90] Subsystem: Intel Corporation 82801I (ICH9 
Family) PCI Express Port 3                   
        Capabilities: [a0] Power Management version 
2                                                             
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)                        
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 
PME-                                            
        Capabilities: [100] Virtual Channel 
<?>                                                                   
        Capabilities: [180] Root Complex Link 
<?>                                                                 
        Kernel driver in use: 
pcieport                                                                             


00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 4 (rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+     
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-      
        Latency: 0, Cache Line Size: 64 
bytes                                                                     
        Bus: primary=00, secondary=05, subordinate=05, 
sec-latency=0                                              
        I/O behind bridge: 
00006000-00006fff                                                                       

        Memory behind bridge: 
97400000-974fffff                                                                    

        Prefetchable memory behind bridge: 
0000000097c00000-0000000097dfffff                                      
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-            
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- 
FastB2B-                                             
                PriDiscTmr- SecDiscTmr- DiscTmrStat- 
DiscTmrSERREn-                                               
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 
00                                                 
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us                             
                        ExtTag- RBE+ 
FLReset-                                                                      

                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-                                
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- 
NoSnoop-                                              
                        MaxPayload 128 bytes, MaxReadReq 128 
bytes                                                
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-                               
                LnkCap: Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <1us, L1 <4us                   
                        ClockPM- Surprise- LLActRep+ 
BwNot-                                                       
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk-                                   
                        ExtSynch- ClockPM- AutWidDis- BWInt- 
AutBWInt-                                            
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-                
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surpise+                                 
                        Slot #  4, PowerLimit 10.000000; Interlock- 
NoCompl-                                      
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-                           
                        Control: AttnInd Unknown, PwrInd Unknown, Power- 
Interlock-                               
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet- Interlock-                              
                        Changed: MRL- PresDet- 
LinkState-                                                         
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-                           
                RootCap: 
CRSVisible-                                                                               

                RootSta: PME ReqID 0000, PMEStatus- 
PMEPending-                                                   
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 
64bit-                                                
                Address: fee0300c  Data: 
4191                                                                     
        Capabilities: [90] Subsystem: Intel Corporation 82801I (ICH9 
Family) PCI Express Port 4                   
        Capabilities: [a0] Power Management version 
2                                                             
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)                        
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 
PME-                                            
        Capabilities: [100] Virtual Channel 
<?>                                                                   
        Capabilities: [180] Root Complex Link 
<?>                                                                 
        Kernel driver in use: 
pcieport                                                                             


00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 5 (rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+     
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-      
        Latency: 0, Cache Line Size: 64 
bytes                                                                     
        Bus: primary=00, secondary=06, subordinate=06, 
sec-latency=0                                              
        I/O behind bridge: 
00007000-00007fff                                                                       

        Memory behind bridge: 
97500000-975fffff                                                                    

        Prefetchable memory behind bridge: 
0000000097e00000-0000000097ffffff                                      
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-            
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- 
FastB2B-                                             
                PriDiscTmr- SecDiscTmr- DiscTmrStat- 
DiscTmrSERREn-                                               
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 
00                                                 
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us                             
                        ExtTag- RBE+ 
FLReset-                                                                      

                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-                                
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- 
NoSnoop-                                              
                        MaxPayload 128 bytes, MaxReadReq 128 
bytes                                                
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-                               
                LnkCap: Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <1us, L1 <4us                   
                        ClockPM- Surprise- LLActRep+ 
BwNot-                                                       
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk-                                   
                        ExtSynch- ClockPM- AutWidDis- BWInt- 
AutBWInt-                                            
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-                
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surpise+                                 
                        Slot #  5, PowerLimit 10.000000; Interlock- 
NoCompl-                                      
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-                           
                        Control: AttnInd Unknown, PwrInd Unknown, Power- 
Interlock-                               
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet- Interlock-                              
                        Changed: MRL- PresDet- 
LinkState-                                                         
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-                           
                RootCap: 
CRSVisible-                                                                               

                RootSta: PME ReqID 0000, PMEStatus- 
PMEPending-                                                   
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 
64bit-                                                
                Address: fee0300c  Data: 
4199                                                                     
        Capabilities: [90] Subsystem: Intel Corporation 82801I (ICH9 
Family) PCI Express Port 5                   
        Capabilities: [a0] Power Management version 
2                                                             
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)                        
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 
PME-                                            
        Capabilities: [100] Virtual Channel 
<?>                                                                   
        Capabilities: [180] Root Complex Link 
<?>                                                                 
        Kernel driver in use: 
pcieport                                                                             


00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #1 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Device 
5044                                                                 
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-    
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-   
        Latency: 
0                                                                                                

        Interrupt: pin A routed to IRQ 
23                                                                        
        Region 4: I/O ports at 3080 
[size=32]                                                                     

        Capabilities: [50] Vendor Specific Information 
<?>                                                       
        Kernel driver in use: 
uhci_hcd                                                                            


00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #2 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Device 
5044                                                                 
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-    
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-   
        Latency: 
0                                                                                                

        Interrupt: pin B routed to IRQ 
19                                                                        
        Region 4: I/O ports at 3060 
[size=32]                                                                     

        Capabilities: [50] Vendor Specific Information 
<?>                                                       
        Kernel driver in use: 
uhci_hcd                                                                            


00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #3 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Device 
5044                                                                 
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-    
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-   
        Latency: 
0                                                                                                

        Interrupt: pin C routed to IRQ 
18                                                                        
        Region 4: I/O ports at 3040 
[size=32]                                                                     

        Capabilities: [50] Vendor Specific Information 
<?>                                                       
        Kernel driver in use: 
uhci_hcd                                                                            


00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
Controller #1 (rev 02) (prog-if 20 [EHCI])
        Subsystem: Intel Corporation Device 
5044                                                                  
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-     
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-    
        Latency: 
0                                                                                                 

        Interrupt: pin A routed to IRQ 
23                                                                         
        Region 0: Memory at 97125800 (32-bit, non-prefetchable) 
[size=1K]                                         
        Capabilities: [50] Power Management version 
2                                                             
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)                      
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 
PME-                                            
        Capabilities: [58] Debug port: BAR=1 
offset=00a0                                                          
        Capabilities: [98] Vendor Specific Information 
<?>                                                        
        Kernel driver in use: 
ehci_hcd                                                                             


00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92) (prog-if 
01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 
0                                                                                           

        Bus: primary=00, secondary=07, subordinate=07, 
sec-latency=32                                       
        I/O behind bridge: 
0000f000-00000fff                                                                 

        Memory behind bridge: 
93000000-96ffffff                                                              

        Prefetchable memory behind bridge: 
fffffffffff00000-00000000000fffff                                
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-    
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- 
FastB2B-                                       
                PriDiscTmr- SecDiscTmr- DiscTmrStat- 
DiscTmrSERREn-                                         
        Capabilities: [50] Subsystem: Intel Corporation Device 
5044                                         

00:1f.0 ISA bridge: Intel Corporation 82801IR (ICH9R) LPC Interface 
Controller (rev 02)
        Subsystem: Intel Corporation Device 
5044                                      
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 
0                                                                                            

        Capabilities: [e0] Vendor Specific Information 
<?>                                                   

00:1f.2 RAID bus controller: Intel Corporation 82801 SATA RAID 
Controller (rev 02)
        Subsystem: Intel Corporation Device 
5044                                 
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 
0                                                                                            

        Interrupt: pin A routed to IRQ 
30                                                                    
        Region 0: I/O ports at 3428 
[size=8]                                                                 
        Region 1: I/O ports at 3434 
[size=4]                                                                 
        Region 2: I/O ports at 3420 
[size=8]                                                                 
        Region 3: I/O ports at 3430 
[size=4]                                                                 
        Region 4: I/O ports at 3020 
[size=32]                                                                
        Region 5: Memory at 97125000 (32-bit, non-prefetchable) 
[size=2K]                                    
        Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 
64bit-                                          
                Address: fee0300c  Data: 
41a9                                                                
        Capabilities: [70] Power Management version 
3                                                        
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)                   
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 
PME-                                       
        Capabilities: [a8] SATA HBA 
<?>                                                                      
        Capabilities: [b0] Vendor Specific Information 
<?>                                                   
        Kernel driver in use: 
ahci                                                                            


00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller 
(rev 02)
        Subsystem: Intel Corporation Device 
5044                              
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin B routed to IRQ 
10                                                                    
        Region 0: Memory at 97126000 (64-bit, non-prefetchable) 
[size=256]                                   
        Region 4: I/O ports at 3000 
[size=32]                                                                

01:00.0 VGA compatible controller: nVidia Corporation G84 [GeForce 8600 
GT] (rev a1) (prog-if 00 [VGA controller])
        Subsystem: ASUSTeK Computer Inc. Device 
8253                                                             
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-    
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-     
        Latency: 
0                                                                                                

        Interrupt: pin A routed to IRQ 
16                                                                        
        Region 0: Memory at 92000000 (32-bit, non-prefetchable) 
[size=16M]                                       
        Region 1: Memory at 80000000 (64-bit, prefetchable) 
[size=256M]                                          
        Region 3: Memory at 90000000 (64-bit, non-prefetchable) 
[size=32M]                                       
        Region 5: I/O ports at 2000 
[size=128]                                                                    

        Expansion ROM at <unassigned> 
[disabled]                                                                 
        Capabilities: [60] Power Management version 
2                                                            
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)                       
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 
PME-                                           
        Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 
64bit+                                               
                Address: 0000000000000000  Data: 
0000                                                            
        Capabilities: [78] Express (v1) Endpoint, MSI 
00                                                         
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<512ns, L1 <4us                           
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ 
FLReset-                                          
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-                               
                        RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- 
NoSnoop+                                             
                        MaxPayload 128 bytes, MaxReadReq 512 
bytes                                               
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-                              
                LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, 
Latency L0 <512ns, L1 <4us               
                        ClockPM- Surprise- LLActRep- 
BwNot-                                                      
                LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- Retrain- 
CommClk+                                 
                        ExtSynch- ClockPM- AutWidDis- BWInt- 
AutBWInt-                                           
                LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-              
        Capabilities: [100] Virtual Channel 
<?>                                                                  
        Capabilities: [128] Power Budgeting 
<?>                                                                  
        Capabilities: [600] Vendor Specific Information 
<?>                                                      
        Kernel driver in use: 
nvidia                                                                              


03:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6101 
single-port PATA133 interface (rev b1) (prog-if 8f [Master SecP SecO 
PriP PriO])
        Subsystem: Marvell Technology Group Ltd. 88SE6101 single-port 
PATA133 interface                                                      
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-                                
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-                                 
        Latency: 0, Cache Line Size: 64 
bytes                                                                                                 

        Interrupt: pin A routed to IRQ 
17                                                                                                     

        Region 0: I/O ports at 1018 
[size=8]                                                                                                  

        Region 1: I/O ports at 1024 
[size=4]                                                                                                  

        Region 2: I/O ports at 1010 
[size=8]                                                                                                  

        Region 3: I/O ports at 1020 
[size=4]                                                                                                  

        Region 4: I/O ports at 1000 
[size=16]                                                                                                 

        Region 5: Memory at 97000000 (32-bit, non-prefetchable) 
[size=512]                                                                    

        Capabilities: [48] Power Management version 
2                                                                                         

                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA 
PME(D0+,D1+,D2-,D3hot+,D3cold-)                                                    

                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 
PME-                                                                       
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 
64bit-                                                                            

                Address: 00000000  Data: 
0000                                                                                                 

        Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 
00                                                                               

                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 unlimited                                               
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- 
FLReset-                                                                       

                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-                                                           
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr+ 
NoSnoop-                                                                          

                        MaxPayload 128 bytes, MaxReadReq 512 
bytes                                                                            

                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-                                                          
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, 
Latency L0 <256ns, L1 unlimited                                          
                        ClockPM- Surprise- LLActRep- 
BwNot-                                                                                   

                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+                                                              
                        ExtSynch- ClockPM- AutWidDis- BWInt- 
AutBWInt-                                                                        

                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr+ BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                AERCap: First Error Pointer: 1f, GenCap- CGenEn- ChkCap- 
ChkEn-
        Kernel driver in use: pata_marvell

07:01.0 Multimedia video controller: Conexant Systems, Inc. 
CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
        Subsystem: Hauppauge computer works Inc. WinTV HVR-4000-HD
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at 96000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [44] Vital Product Data
                Unknown large resource type 04, will not decode more.
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: cx8800

07:01.1 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI 
Video and Audio Decoder [Audio Port] (rev 05)
        Subsystem: Hauppauge computer works Inc. WinTV HVR-4000-HD
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (1000ns min, 63750ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at 95000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: cx88_audio

07:01.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI 
Video and Audio Decoder [MPEG Port] (rev 05)
        Subsystem: Hauppauge computer works Inc. WinTV HVR-4000-HD
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (1500ns min, 22000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at 94000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: cx88-mpeg driver manager

07:01.4 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI 
Video and Audio Decoder [IR Port] (rev 05)
        Subsystem: Hauppauge computer works Inc. WinTV HVR-4000-HD
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (1500ns min, 63750ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at 93000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-





kind regards,

Franz Fürbaß

 .''`.    EMail: franz.fuerbass@chello.at 
: :'  :   
`. `'`            
  `-       


--------------020700050906080100020702
Content-Type: text/x-csrc;
 name="testdvb.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="testdvb.c"

#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/poll.h>
#include <unistd.h>
#include <fcntl.h>
#include <signal.h>
#include <assert.h>
#include <stdint.h>

#include <stdio.h>
#include <errno.h>
#include <time.h>
#include <sys/types.h>
#include <stdint.h>

#include <linux/dvb/dmx.h>
#include <linux/dvb/version.h>
#include <linux/dvb/frontend.h>

int simplescan()
{
  struct dvb_frontend_info fe_info;
  struct dtv_property cmdargs[20];
  struct dtv_properties cmdseq;
  int freq;
  int fd;
  int i;
  int testflags;
  fe_status_t status;
  int adapter;
  int frontend;
  char frontend_name[80];

  //transponder freq
  freq = 498000000;

  adapter = 0;
  frontend = 1;
  
  memset(frontend_name, 0, sizeof(frontend_name));
  snprintf (frontend_name, sizeof(frontend_name), "/dev/dvb/adapter%i/frontend%i", adapter, frontend);


  fprintf(stderr, "<SIMPLE SCAN>\n");

  
  if ((fd = open (frontend_name, O_RDWR)) < 0)
  { 
    error("Open1 failed\n"); 
    return 0;	     
  }


  
  //
  // comment next line to get it work!
  ioctl( fd, FE_GET_INFO, &fe_info );

  //
  //

  

  close(fd);
  if ((fd = open (frontend_name, O_RDWR)) < 0) 
  {  
      error("Open2 failed\n");  
     return 0;	      
   }  
  ioctl( fd, FE_GET_INFO, &fe_info );  
  fprintf(stderr, "Using DVB device %s \"%s\"\n",frontend_name, fe_info.name);
  

  cmdargs[0].cmd = DTV_DELIVERY_SYSTEM; cmdargs[0].u.data = SYS_DVBT;
  cmdargs[1].cmd = DTV_FREQUENCY; cmdargs[1].u.data = freq;
  cmdargs[2].cmd = DTV_MODULATION; cmdargs[2].u.data = QAM_16;
  cmdargs[3].cmd = DTV_CODE_RATE_HP; cmdargs[3].u.data = FEC_3_4;
  cmdargs[4].cmd = DTV_CODE_RATE_LP; cmdargs[4].u.data = FEC_AUTO;
  cmdargs[5].cmd = DTV_GUARD_INTERVAL; cmdargs[5].u.data = GUARD_INTERVAL_AUTO;
  cmdargs[6].cmd = DTV_TRANSMISSION_MODE; cmdargs[6].u.data = TRANSMISSION_MODE_8K;
  cmdargs[7].cmd = DTV_HIERARCHY; cmdargs[7].u.data = HIERARCHY_NONE;
  cmdargs[8].cmd = DTV_BANDWIDTH_HZ; cmdargs[8].u.data = 8000000;
  cmdargs[9].cmd = DTV_INVERSION; cmdargs[9].u.data = INVERSION_AUTO;
  cmdargs[10].cmd = DTV_TUNE;
  cmdseq.num = 11;
  cmdseq.props = cmdargs;  

  
  testflags = fcntl(fd, F_GETFL); 
  
  if ( ioctl( fd, FE_SET_PROPERTY, &cmdseq )<0 ) {
    fprintf(stderr, "ERROR tuning\n");
    close(fd);
    return 0;
  }

  for (i=0; i< 10; i++)
  {
    usleep( 100000 );
    fprintf( stderr, "." );
    if ( ioctl( fd, FE_READ_STATUS, &status )==-1 ) {
      perror( "FE_READ_STATUS" );
      break;
    }
    if ( status & FE_HAS_LOCK ) {
      fprintf(stderr," LOCKED.");
      return 1;      
    }
  }

  fprintf(stderr, " </SIMPLE SCAN>\n");
  return 0;
}


int main (int argc, char **argv)
{
  simplescan();
}

--------------020700050906080100020702--
