Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web62012.mail.re1.yahoo.com ([69.147.74.235])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <mpapet@yahoo.com>) id 1KNs3h-0004yy-Kl
	for linux-dvb@linuxtv.org; Tue, 29 Jul 2008 18:28:24 +0200
Date: Tue, 29 Jul 2008 09:26:16 -0700 (PDT)
From: Michael Papet <mpapet@yahoo.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <mailman.2.1217300160.25488.linux-dvb@linuxtv.org>
MIME-Version: 1.0
Message-ID: <454501.55957.qm@web62012.mail.re1.yahoo.com>
Subject: [linux-dvb] cx18 hvr-1600 update
Reply-To: mpapet@yahoo.com
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Andy,

Thanks again for your help on this.  

1. I tried your test procedure and got an mpeg file full of snow.  Maybe this is not related to the problem, but an NTSC channel scan in mythtv picks up all of the NTSC channels just fine.  It's the fact that watching is all snow.  I've verified the cable/antenna connection to the card is good by connecting it to the TV and watching TV/tuning channels.

2. In an attempt to eliminate auto config problems, I'm forcing cx18 options.  options cx18 debug=3 radio=0 tuner=57 cardtype=1 ntsc=M  Changing the tuner model didn't do anything different.  

3. I sent the wrong lspci -v.  I'm sorry to waste your time on dumb mistakes.  Here's the correct one

00:00.0 Host bridge: Intel Corporation 82845G/GL[Brookdale-G]/GE/PE DRAM Controller/Host-Hub Interface (rev 01)                                                                                     
        Flags: bus master, fast devsel, latency 0                                                 
        Memory at e8000000 (32-bit, prefetchable) [size=128M]                                     
        Capabilities: [e4] Vendor Specific Information                                            

00:02.0 VGA compatible controller: Intel Corporation 82845G/GL[Brookdale-G]/GE Chipset Integrated Graphics Device (rev 01) (prog-if 00 [VGA])                                                       
        Subsystem: Compaq Computer Corporation Evo D510 SFF                                       
        Flags: bus master, fast devsel, latency 0, IRQ 16                                         
        Memory at f0000000 (32-bit, prefetchable) [size=128M]                                     
        Memory at f8400000 (32-bit, non-prefetchable) [size=512K]                                 
        Capabilities: [d0] Power Management version 1                                             

00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 01) (prog-if 00 [UHCI])                                                                  
        Subsystem: Compaq Computer Corporation Unknown device 00b9                                
        Flags: bus master, medium devsel, latency 0, IRQ 16                                       
        I/O ports at 2440 [size=32]                                                               

00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 01) (prog-if 00 [UHCI])                                                                  
        Subsystem: Compaq Computer Corporation Unknown device 00b9                                
        Flags: bus master, medium devsel, latency 0, IRQ 19                                       
        I/O ports at 2460 [size=32]                                                               

00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 01) (prog-if 20 [EHCI])                                                                               
        Subsystem: Compaq Computer Corporation Unknown device 00b9                                
        Flags: bus master, medium devsel, latency 0, IRQ 23                                       
        Memory at f8480000 (32-bit, non-prefetchable) [size=1K]                                   
        Capabilities: [50] Power Management version 2                                             
        Capabilities: [58] Debug port                                                             

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 81) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0                                           
        Bus: primary=00, secondary=05, subordinate=05, sec-latency=64                       
        I/O behind bridge: 00001000-00001fff                                                
        Memory behind bridge: e3d00000-e7ffffff                                             

00:1f.0 ISA bridge: Intel Corporation 82801DB/DBL (ICH4/ICH4-L) LPC Interface Bridge (rev 01)
        Flags: bus master, medium devsel, latency 0                                          

00:1f.1 IDE interface: Intel Corporation 82801DB (ICH4) IDE Controller (rev 01) (prog-if 8a [Master SecP PriP])                                                                                     
        Subsystem: Compaq Computer Corporation Unknown device 00b9                                
        Flags: bus master, medium devsel, latency 0, IRQ 18                                       
        I/O ports at 01f0 [size=8]                                                                
        I/O ports at 03f4 [size=1]                                                                
        I/O ports at 0170 [size=8]                                                                
        I/O ports at 0374 [size=1]                                                                
        I/O ports at 24a0 [size=16]
        Memory at 20000000 (32-bit, non-prefetchable) [size=1K]

05:04.0 Multimedia audio controller: C-Media Electronics Inc CM8738 (rev 10)
        Subsystem: C-Media Electronics Inc CMI8738/C3DX PCI Audio Device
        Flags: bus master, medium devsel, latency 66, IRQ 16
        I/O ports at 1000 [size=256]
        Capabilities: [c0] Power Management version 2

05:08.0 Ethernet controller: Intel Corporation 82801DB PRO/100 VM (LOM) Ethernet Controller (rev 81)
        Subsystem: Compaq Computer Corporation Unknown device 0012
        Flags: bus master, medium devsel, latency 66, IRQ 20
        Memory at e3d00000 (32-bit, non-prefetchable) [size=4K]
        I/O ports at 1400 [size=64]
        Capabilities: [dc] Power Management version 2

05:09.0 Multimedia video controller: Conexant Unknown device 5b7a
        Subsystem: Hauppauge computer works Inc. Unknown device 7444
        Flags: bus master, medium devsel, latency 66, IRQ 18
        Memory at e4000000 (32-bit, non-prefetchable) [size=64M]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2



      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
