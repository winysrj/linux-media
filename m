Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roman.jarosz@gmail.com>) id 1LJ9Zz-00009A-2m
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 17:42:28 +0100
Received: by bwz11 with SMTP id 11so14641025bwz.17
	for <linux-dvb@linuxtv.org>; Sat, 03 Jan 2009 08:41:53 -0800 (PST)
Date: Sat, 03 Jan 2009 17:42:38 +0100
To: linux-dvb@linuxtv.org
From: "Roman Jarosz" <roman.jarosz@gmail.com>
MIME-Version: 1.0
Message-ID: <op.um6wpcvirj95b0@localhost>
Subject: [linux-dvb] DVB-S Channel searching problem
Reply-To: kedgedev@centrum.cz
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

Hi,

I have a problem with DVB-S channel searching, the scan command doesn't find all channels in Linux on Astra 19.2E.
It works in Windows.

For instance the scan doesn't find RTL2, but if I add to channels.conf
RTL2:12187:h:0:27500:166:128:12020
then szap -r works correctly.

I have TeVii S460 DVB-S/S2.
Linux kernel 2.6.28.

Can anybody help me to find out why the scan doesn't work correctly.
I've compiled kernel from source so I can apply patches or change its settings.

Regards,
Roman

lspci:

00:09.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
        Subsystem: Unknown device d460:9022
        Flags: bus master, medium devsel, latency 32, IRQ 10
        Memory at e8000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2

00:09.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] (rev 05)
        Subsystem: Unknown device d460:9022
        Flags: bus master, medium devsel, latency 32, IRQ 10
        Memory at e9000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2

This is part of dmesg:
cx8800 0000:00:09.0: PCI INT A -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10                                                               
cx88[0]: quirk: PCIPCI_NATOMA -- set TBFX                                                                                                   
cx88[0]: subsystem: d460:9022, board: TeVii S460 DVB-S/S2 [card=70,autodetected], frontend(s): 1                                            
cx88[0]: TV tuner type -1, Radio tuner type -1                                                                                              
cx88[0]/0: found at 0000:00:09.0, rev: 5, irq: 10, latency: 32, mmio: 0xe8000000                                                            
cx88[0]/0: registered device video0 [v4l2]                                                                                                  
cx88[0]/0: registered device vbi0                                                                                                           
Linux agpgart interface v0.103                                                                                                              
agpgart-intel 0000:00:00.0: Intel 440BX Chipset                                                                                             
agpgart-intel 0000:00:00.0: AGP aperture is 32M @ 0xe4000000                                                                                
EXT3 FS on sda1, internal journal                                                                                                           
Adding 1020088k swap on /dev/sda5.  Priority:-1 extents:1 across:1020088k                                                                   
kjournald starting.  Commit interval 5 seconds                                                                                              
EXT3 FS on sda6, internal journal                                                                                                           
EXT3-fs: mounted filesystem with ordered data mode.                                                                                         
loop: module loaded                                                                                                                         
eth2: link up, 100Mbps, full-duplex, lpa 0xC5E1                                                                                             
warning: `proftpd' uses 32-bit capabilities (legacy support in use)                                                                         
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory                                                                   
NFSD: starting 90-second grace period                                                                                                       
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded                                                                                 
cx88[0]/2: cx2388x 8802 Driver Manager                                                                                                      
cx88-mpeg driver manager 0000:00:09.2: PCI INT A -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10                                             
cx88[0]/2: found at 0000:00:09.2, rev: 5, irq: 10, latency: 32, mmio: 0xe9000000                                                            
cx8802_probe() allocating 1 frontend(s)                                                                                                     
cx88/2: cx2388x dvb driver version 0.0.6 loaded                                                                                             
cx88/2: registering cx8802 driver, type: dvb access: shared                                                                                 
cx88[0]/2: subsystem: d460:9022, board: TeVii S460 DVB-S/S2 [card=70]                                                                       
cx88[0]/2: cx2388x based DVB/ATSC card                                                                                                      
DVB: registering new adapter (cx88[0])                                                                                                      
DVB: registering adapter 0 frontend 0 (Conexant CX24116/CX24118)...                                                                         
cx24116_firmware_ondemand: Waiting for firmware upload (dvb-fe-cx24116.fw)...                                                               
i2c-adapter i2c-0: firmware: requesting dvb-fe-cx24116.fw                                                                                   
cx24116_firmware_ondemand: Waiting for firmware upload(2)...                                                                                
cx24116_load_firmware: FW version 1.23.86.1                                                                                                 
cx24116_firmware_ondemand: Firmware upload complete


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
