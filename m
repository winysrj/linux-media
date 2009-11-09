Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx01.extmail.prod.ext.phx2.redhat.com
	[10.5.110.5])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nA9KAZXo007841
	for <video4linux-list@redhat.com>; Mon, 9 Nov 2009 15:10:35 -0500
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nA9KAY0P021092
	for <video4linux-list@redhat.com>; Mon, 9 Nov 2009 15:10:34 -0500
Received: from tervel.nabble.com ([192.168.236.150])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <bounces@n2.nabble.com>) id 1N7aZO-0008Ru-57
	for video4linux-list@redhat.com; Mon, 09 Nov 2009 12:10:34 -0800
Date: Mon, 9 Nov 2009 12:10:34 -0800 (PST)
From: guillaumeB <yog4trash@gmail.com>
To: video4linux-list@redhat.com
Message-ID: <1257797434152-3975418.post@n2.nabble.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: bttv card=10 tuner=38 and kernel > 2.6.28 issue
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


hi,

Since kernel 2.6.29, i've got some trouble to make my tv card working
(Hauppauge WinTV Express). I have try with differents distributions and
kernel, and this is always the same:
if kernel > 2.6.28 then no way to have a signal.

He have suspect a IRQ issue with my nvidia AGP card but i have try to change
PCI slot of my tv Card or disable PnP OS option in my BIOS but without any
progress.

With an older TV card which have tuner=3 (a Hauppauge winTV-GO) , there is
any trouble!
 
here are some log of my config:

With kernel < 2.6.29:
Bt87x 0000:02:0a.1: PCI INT A -> Link[LNKA] -> GSI 18 (level, low) -> IRQ 18
bt87x0: Using board 1, analog, digital (rate 32000 Hz)                      
bttv: driver version 0.9.17 loaded                                          
bttv: using 8 buffers with 2080k (520 pages) each for capture               
bttv: Bt8xx card found (0).                                                 
bttv 0000:02:0a.0: PCI INT A -> Link[LNKA] -> GSI 18 (level, low) -> IRQ 18 
bttv0: Bt878 (rev 17) at 0000:02:0a.0, irq: 18, latency: 64, mmio:
0xda8fe000
bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb    
bttv0: using: Hauppauge (bt878) [card=10,autodetected]                       
bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]                    
bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]                         
bttv0: Hauppauge eeprom indicates model#44809                                
bttv0: tuner type=38                                                         
bttv0: i2c: checking for MSP34xx @ 0x80... not found                         
bttv0: i2c: checking for TDA9875 @ 0xb0... not found                         
bttv0: i2c: checking for TDA7432 @ 0x8a... not found                         
tuner' 2-0043: chip found @ 0x86 (bt878 #0 [sw])                             
tuner' 2-0061: chip found @ 0xc2 (bt878 #0 [sw])                             
bttv0: registered device video0                                              
bttv0: registered device vbi0                                                
bttv0: registered device radio0                                              
bttv0: PLL: 28636363 => 35468950 .. ok                                       
tveeprom 2-0050: The eeprom says no radio is present, but the tuner type     
tveeprom 2-0050: indicates otherwise. I will assume that radio is present.   
tveeprom 2-0050: Hauppauge model 44809, rev E1A5, serial# 10431244           
tveeprom 2-0050: tuner model is TCL MPE05-2 (idx 105, type 38)               
tveeprom 2-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K)
(eeprom 0x74)
tveeprom 2-0050: audio processor is None (idx 0)                                   
tveeprom 2-0050: decoder processor is BT878 (idx 14)                               
tveeprom 2-0050: has radio

With kernel >= 2.6.29:
<root@/># dmesg | grep [bB]t && dmesg | grep tveeprom
Bt87x 0000:02:0a.1: PCI INT A -> Link[LNKA] -> GSI 19 (level, low) -> IRQ 19
bt87x0: Using board 1, analog, digital (rate 32000 Hz)
bttv: driver version 0.9.18 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv 0000:02:0a.0: PCI INT A -> Link[LNKA] -> GSI 19 (level, low) -> IRQ 19
bttv0: Bt878 (rev 17) at 0000:02:0a.0, irq: 19, latency: 64, mmio:
0xda8fe000
bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
bttv0: using: Hauppauge (bt878) [card=10,autodetected]
IRQ 19/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
bttv0: Hauppauge eeprom indicates model#44809
bttv0: tuner type=38
bttv0: audio absent, no audio device found!
tuner 1-0043: chip found @ 0x86 (bt878 #0 [sw])
tuner 1-0061: chip found @ 0xc2 (bt878 #0 [sw])
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: registered device radio0
bttv0: PLL: 28636363 => 35468950 .. ok
tveeprom 1-0050: The eeprom says no radio is present, but the tuner type
tveeprom 1-0050: indicates otherwise. I will assume that radio is present.
tveeprom 1-0050: Hauppauge model 44809, rev E1A5, serial# 10431244
tveeprom 1-0050: tuner model is TCL MPE05-2 (idx 105, type 38)
tveeprom 1-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K)
(eeprom 0x74)
tveeprom 1-0050: audio processor is None (idx 0)
tveeprom 1-0050: decoder processor is BT878 (idx 14)
tveeprom 1-0050: has radio


<root@/># lspci -vv -s 02:0a.0                                                                                 
02:0a.0 Multimedia video controller: Brooktree Corporation Bt878 Video
Capture (rev 11)                        
        Subsystem: Hauppauge computer works Inc. WinTV Series                                                  
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-  
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx- 
        Latency: 64 (4000ns min, 10000ns max)                                                                  
        Interrupt: pin A routed to IRQ 18                                                                      
        Region 0: Memory at da8fe000 (32-bit, prefetchable) [size=4K]                                          
        Capabilities: [44] Vital Product Data                                                                  
        pcilib: sysfs_read_vpd: read failed: Connection timed out                                                      
                Not readable                                                                                   
        Capabilities: [4c] Power Management version 2                                                          
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)                     
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-                                         
        Kernel driver in use: bttv                                                                             
        Kernel modules: bttv

He hope some one could help me!


-- 
View this message in context: http://n2.nabble.com/bttv-card-10-tuner-38-and-kernel-2-6-28-issue-tp3975418p3975418.html
Sent from the video4linux-list mailing list archive at Nabble.com.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
