Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1KPScC-00044Y-T4
	for linux-dvb@linuxtv.org; Sun, 03 Aug 2008 03:42:36 +0200
From: Andy Walls <awalls@radix.net>
To: mpapet@yahoo.com
In-Reply-To: <454501.55957.qm@web62012.mail.re1.yahoo.com>
References: <454501.55957.qm@web62012.mail.re1.yahoo.com>
Date: Sat, 02 Aug 2008 21:42:22 -0400
Message-Id: <1217727742.5348.55.camel@morgan.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx18 hvr-1600 update
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

On Tue, 2008-07-29 at 09:26 -0700, Michael Papet wrote:
> Andy,
> 
> Thanks again for your help on this.  
> 
> 1. I tried your test procedure and got an mpeg file full of snow.
> Maybe this is not related to the problem, but an NTSC channel scan in
> mythtv picks up all of the NTSC channels just fine.  It's the fact
> that watching is all snow.  I've verified the cable/antenna connection
> to the card is good by connecting it to the TV and watching TV/tuning
> channels.

So what you are saying is that no matter what channel you try to tune
to, mythtv and mplayer always show snow, right?

After you change channels in MythTV, what does "v4l2-ctl --log-status"
show for "Frequency" and for "Video Signal"? 

> 
> 2. In an attempt to eliminate auto config problems, I'm forcing cx18
> options.  options cx18 debug=3 radio=0 tuner=57 cardtype=1 ntsc=M
> Changing the tuner model didn't do anything different.  

You may want to set the "debug" option for the "tuner" module
in /etc/modprobe.conf, and you may also want to set the I2C debugging
flag for the cx18 module as well.  If the messages to the tuner never
make it over the I2C bus, then the tuner will never change freqs.



> 3. I sent the wrong lspci -v.  I'm sorry to waste your time on dumb
> mistakes.  Here's the correct one
> 
> 00:00.0 Host bridge: Intel Corporation 82845G/GL[Brookdale-G]/GE/PE DRAM Controller/Host-Hub Interface (rev 01)                                                                                     
>         Flags: bus master, fast devsel, latency 0                                                 
>         Memory at e8000000 (32-bit, prefetchable) [size=128M]                                     
>         Capabilities: [e4] Vendor Specific Information                                            
> 
> 00:02.0 VGA compatible controller: Intel Corporation 82845G/GL[Brookdale-G]/GE Chipset Integrated Graphics Device (rev 01) (prog-if 00 [VGA])                                                       
>         Subsystem: Compaq Computer Corporation Evo D510 SFF                                       
>         Flags: bus master, fast devsel, latency 0, IRQ 16                                         
>         Memory at f0000000 (32-bit, prefetchable) [size=128M]                                     
>         Memory at f8400000 (32-bit, non-prefetchable) [size=512K]                                 
>         Capabilities: [d0] Power Management version 1                                             
> 
> 00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 01) (prog-if 00 [UHCI])                                                                  
>         Subsystem: Compaq Computer Corporation Unknown device 00b9                                
>         Flags: bus master, medium devsel, latency 0, IRQ 16                                       
>         I/O ports at 2440 [size=32]                                                               
> 
> 00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 01) (prog-if 00 [UHCI])                                                                  
>         Subsystem: Compaq Computer Corporation Unknown device 00b9                                
>         Flags: bus master, medium devsel, latency 0, IRQ 19                                       
>         I/O ports at 2460 [size=32]                                                               
> 
> 00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 01) (prog-if 20 [EHCI])                                                                               
>         Subsystem: Compaq Computer Corporation Unknown device 00b9                                
>         Flags: bus master, medium devsel, latency 0, IRQ 23                                       
>         Memory at f8480000 (32-bit, non-prefetchable) [size=1K]                                   
>         Capabilities: [50] Power Management version 2                                             
>         Capabilities: [58] Debug port                                                             
> 
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 81) (prog-if 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0                                           
>         Bus: primary=00, secondary=05, subordinate=05, sec-latency=64                       
>         I/O behind bridge: 00001000-00001fff                                                
>         Memory behind bridge: e3d00000-e7ffffff                                             
> 
> 00:1f.0 ISA bridge: Intel Corporation 82801DB/DBL (ICH4/ICH4-L) LPC Interface Bridge (rev 01)
>         Flags: bus master, medium devsel, latency 0                                          
> 
> 00:1f.1 IDE interface: Intel Corporation 82801DB (ICH4) IDE Controller (rev 01) (prog-if 8a [Master SecP PriP])                                                                                     
>         Subsystem: Compaq Computer Corporation Unknown device 00b9                                
>         Flags: bus master, medium devsel, latency 0, IRQ 18                                       
>         I/O ports at 01f0 [size=8]                                                                
>         I/O ports at 03f4 [size=1]                                                                
>         I/O ports at 0170 [size=8]                                                                
>         I/O ports at 0374 [size=1]                                                                
>         I/O ports at 24a0 [size=16]
>         Memory at 20000000 (32-bit, non-prefetchable) [size=1K]
> 
> 05:04.0 Multimedia audio controller: C-Media Electronics Inc CM8738 (rev 10)
>         Subsystem: C-Media Electronics Inc CMI8738/C3DX PCI Audio Device
>         Flags: bus master, medium devsel, latency 66, IRQ 16
>         I/O ports at 1000 [size=256]
>         Capabilities: [c0] Power Management version 2
> 
> 05:08.0 Ethernet controller: Intel Corporation 82801DB PRO/100 VM (LOM) Ethernet Controller (rev 81)
>         Subsystem: Compaq Computer Corporation Unknown device 0012
>         Flags: bus master, medium devsel, latency 66, IRQ 20
>         Memory at e3d00000 (32-bit, non-prefetchable) [size=4K]
>         I/O ports at 1400 [size=64]
>         Capabilities: [dc] Power Management version 2
> 
> 05:09.0 Multimedia video controller: Conexant Unknown device 5b7a
>         Subsystem: Hauppauge computer works Inc. Unknown device 7444
>         Flags: bus master, medium devsel, latency 66, IRQ 18
>         Memory at e4000000 (32-bit, non-prefetchable) [size=64M]
>         Capabilities: [44] Vital Product Data
>         Capabilities: [4c] Power Management version 2


You have a PCI v2.2 chipset - the Intel 82801DB ICH4.  I suspect the
HVR-1600/CX23418 (a PCI v2.3 device) may have a problem with PCI v2.2
and earlier chipsets under linux.

I don't know what to do about that problem at the moment (or if it's a
real problem).  To verify if you have the problem that Gerhard Wittreich
and Matt Loomis have with hardware registers providing back bogus values
over the PCI bus, use the cx18 driver from this repo:

http://linuxtv.org/hg/~awalls/cx18-i2c/

Specifically this change from that repo:

http://linuxtv.org/hg/~awalls/cx18-i2c/rev/a8a56fe6f67d

with high volume I2C debugging turned on in the cx18 driver.  This will
show you if the values being written to the I2C control registers of the
CX23418 are the same values being read back immediately.  If the high
bytes of the values don't match, then you have the problem.  



As a stab in the dark, you can try normalizing the latency timers one
the devices where they are set to 66 to numbers that are a multiple of 8
(64 or 72) with setpci.  I doubt this will have any effect.

I'd also suggest trying the board under linux in a machine that has a
PCI v2.3 or newer chipset if you can.

You may also want to try the card under Windows XP to rule out a bad
card.

Regards,
Andy


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
