Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tkrantz@stahurabrenner.com>) id 1Ki7E0-0007IR-6p
	for linux-dvb@linuxtv.org; Tue, 23 Sep 2008 14:42:41 +0200
From: "Timothy E. Krantz" <tkrantz@stahurabrenner.com>
To: "'Darren Salt'" <linux@youmustbejoking.demon.co.uk>,
	<linux-dvb@linuxtv.org>
References: <!&!AAAAAAAAAAAYAAAAAAAAACQaAAE2cqNLuI5vSe3nryTCgAAAEAAAAEH2unQOalpGjvGmwr9GMIQBAAAAAA==@stahurabrenner.com>
	<4FE87384AC%linux@youmustbejoking.demon.co.uk>
Date: Tue, 23 Sep 2008 08:42:01 -0400
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAACQaAAE2cqNLuI5vSe3nryTCgAAAEAAAAA5pLLanb2xLgYhuuwWOuDoBAAAAAA==@stahurabrenner.com>
MIME-Version: 1.0
In-Reply-To: <4FE87384AC%linux@youmustbejoking.demon.co.uk>
Subject: Re: [linux-dvb] CX88 IRQ Loop
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

 

> -----Original Message-----
> From: linux-dvb-bounces@linuxtv.org 
> [mailto:linux-dvb-bounces@linuxtv.org] On Behalf Of Darren Salt
> Sent: Monday, September 22, 2008 6:39 PM
> To: linux-dvb@linuxtv.org
> Subject: Re: [linux-dvb] CX88 IRQ Loop
> 
> I demand that Timothy E. Krantz may or may not have written...
> 
> > I am getting the following problems as reported in dmesg.
> > Any help would be appreciated.
> 
> > Linux video capture interface: v2.00
> > cx2388x alsa driver version 0.0.6 loaded
> > ACPI: PCI Interrupt 0000:00:09.1[A] -> GSI 17 (level, low) -> IRQ 20
> > cx88[0]: subsystem: 11bd:0051, board: Pinnacle PCTV HD 800i
> [snip]
> > xc5000: firmware upload
> [snip]
> > NVRM: loading NVIDIA UNIX x86 Kernel Module  169.12  Thu Feb 14 
> > 17:53:07 PST 2008
> [snip]
> > ndiswrapper version 1.51 loaded (smp=yes, preempt=no) usb 
> 1-5: reset 
> > high speed USB device using ehci_hcd and address 2
> > ndiswrapper: driver netmw245 (Marvell,11/27/2006,1.0.4.9) loaded
> [snip]
> > cx88[0]/2-mpeg: general errors: 0x00140000
> > cx88[0]/2-mpeg: clearing mask
> > cx88[0]/0: irq loop -- clearing mask
> [snip]
> > cx88[0]: irq mpeg  [0xa0000] par_err* pci_abort*
> > cx88[0]/2-mpeg: general errors: 0x000a0000 irq 20: nobody 
> cared (try 
> > booting with the "irqpoll" option)
> > Pid: 0, comm: swapper Tainted: P        2.6.24.4-64.fc8 #1
> >  [<c04612be>] __report_bad_irq+0x36/0x75  [<f15a3a16>] 
> > nv_kern_isr+0xa5/0xb2 [nvidia]
> 
> Oh dear. I do believe that that's within nVidia's proprietary driver.
> 
> And you're using ndiswrapper, and it's loaded a driver 
> module. That's another source of kernel taint. This raises 
> the possibility of some interaction between the two, which 
> basically You Don't Want To See. Ever.
> 
> Which isn't good because one or other, or some interaction 
> between them, is a possible source of the problem. So you 
> need to be able to produce this without one or both taint 
> sources: without one, it's likely caused by the other piece 
> of taintware; without both, you know that the problem isn't 
> caused by taintware (it's either a cx88 driver bug or a 
> hardware fault). If, however, it only ever happens with both 
> lots of taint applied, you have a problem somewhere between 
> nVidia and either ndiswrapper or netwm245 - good luck ;-)
> 
> (Taint removal: prevent the taintware from being loaded, then reboot.)
> 
> -- 
> | Darren Salt    | linux or ds at              | nr. Ashington, | Toon
> | RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
> | + At least 4000 million too many people. POPULATION LEVEL 
> IS UNSUSTAINABLE.
> 
> Hire the morally handicapped.

Thanks,
Tried withough the nvidia driver last night and still had the IRQ loop issue
below.

I will run without both the nvidia driver and the ndiswrapper today.

Linux video capture interface: v2.00
input: PC Speaker as /class/input/input6
cx2388x alsa driver version 0.0.6 loaded
ACPI: PCI Interrupt 0000:00:09.1[A] -> GSI 17 (level, low) -> IRQ 20
cx88[0]: subsystem: 11bd:0051, board: Pinnacle PCTV HD 800i
[card=58,autodetecte
d]
cx88[0]: TV tuner type 76, Radio tuner type -1
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
tuner' 1-0064: chip found @ 0xc8 (cx88[0])
xc5000: Successfully identified at address 0x64
xc5000: Firmware has not been loaded previously
xc5000: waiting for firmware upload (dvb-fe-xc5000-1.1.fw)...
xc5000: firmware read 12332 bytes.
xc5000: firmware upload
cx88[0]: Calling XC5000 callback
input: cx88 IR (Pinnacle PCTV HD 800i) as /class/input/input7
cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
cx88[0]/2: cx2388x 8802 Driver Manager
ACPI: PCI Interrupt 0000:00:09.2[A] -> GSI 17 (level, low) -> IRQ 20
cx88[0]/2: found at 0000:00:09.2, rev: 5, irq: 20, latency: 64, mmio:
0xde000000
cx88[1]: subsystem: 11bd:0051, board: Pinnacle PCTV HD 800i
[card=58,autodetecte
d]
cx88[1]: TV tuner type 76, Radio tuner type -1
tuner' 2-0064: chip found @ 0xc8 (cx88[1])
xc5000: Successfully identified at address 0x64
xc5000: Firmware has not been loaded previously
xc5000: waiting for firmware upload (dvb-fe-xc5000-1.1.fw)...
xc5000: firmware read 12332 bytes.
xc5000: firmware upload
cx88[1]: Calling XC5000 callback
input: cx88 IR (Pinnacle PCTV HD 800i) as /class/input/input8
cx88[1]/2: cx2388x 8802 Driver Manager
ACPI: PCI Interrupt 0000:00:0a.2[A] -> GSI 18 (level, low) -> IRQ 21
cx88[1]/2: found at 0000:00:0a.2, rev: 5, irq: 21, latency: 64, mmio:
0xdb000000
ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 17 (level, low) -> IRQ 20
cx88[0]/0: found at 0000:00:09.0, rev: 5, irq: 20, latency: 64, mmio:
0xdc000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 11bd:0051, board: Pinnacle PCTV HD 800i [card=58]
cx88[0]/2: cx2388x based DVB/ATSC card
xc5000: Successfully identified at address 0x64
xc5000: Firmware has been loaded previously
DVB: registering new adapter (cx88[0])
DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
cx88[1]/2: subsystem: 11bd:0051, board: Pinnacle PCTV HD 800i [card=58]
cx88[1]/2: cx2388x based DVB/ATSC card
ACPI: PCI Interrupt 0000:00:02.7[C] -> GSI 18 (level, low) -> IRQ 21
xc5000: Successfully identified at address 0x64
xc5000: Firmware has been loaded previously
DVB: registering new adapter (cx88[1])
DVB: registering frontend 1 (Samsung S5H1409 QAM/8VSB Frontend)...
intel8x0_measure_ac97_clock: measured 50804 usecs
intel8x0: clocking to 48000
ACPI: PCI Interrupt 0000:00:0a.1[A] -> GSI 18 (level, low) -> IRQ 21
cx88[1]/1: CX88x/1: ALSA support for cx2388x boards
ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 18 (level, low) -> IRQ 21
cx88[1]/0: found at 0000:00:0a.0, rev: 5, irq: 21, latency: 64, mmio:
0xd9000000
cx88[1]/0: registered device video1 [v4l2]
cx88[1]/0: registered device vbi1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 19
loop: module loaded
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1572856k swap on /dev/mapper/VolGroup01-LogVol02.  Priority:-1
extents:1
across:1572856k
warning: process `kudzu' used the deprecated sysctl system call with 1.23.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
ndiswrapper version 1.51 loaded (smp=yes, preempt=no)
usb 1-5: reset high speed USB device using ehci_hcd and address 2
ndiswrapper: driver netmw245 (Marvell,11/27/2006,1.0.4.9) loaded
wlan0: ethernet device 00:14:d1:39:73:20 using NDIS driver: netmw245,
version: 0
x1000308, NDIS version: 0x501, vendor: 'NDIS Network Adapter',
1286:2006.F.conf
wlan0: encryption modes supported: WEP; TKIP with WPA, WPA2, WPA2PSK;
AES/CCMP w
ith WPA, WPA2, WPA2PSK
usbcore: registered new interface driver ndiswrapper
ADDRCONF(NETDEV_UP): wlan0: link is not ready
 CIFS VFS: Error connecting to IPv4 socket. Aborting operation
 CIFS VFS: cifs_mount failed w/return code = -113
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
 CIFS VFS: Error connecting to IPv4 socket. Aborting operation
 CIFS VFS: cifs_mount failed w/return code = -113
wlan0: no IPv6 routers present
 CIFS VFS: Error connecting to IPv4 socket. Aborting operation
 CIFS VFS: cifs_mount failed w/return code = -113
cx88[0]: video y / packed - dma channel status dump
cx88[0]:   cmds: initial risc: 0x229fc000
cx88[0]:   cmds: cdt base    : 0x00180440
cx88[0]:   cmds: cdt size    : 0x0000000c
cx88[0]:   cmds: iq base     : 0x00180400
cx88[0]:   cmds: iq size     : 0x00000010
cx88[0]:   cmds: risc pc     : 0x22a5a958
cx88[0]:   cmds: iq wr ptr   : 0x0000010b
cx88[0]:   cmds: iq rd ptr   : 0x0000010f
cx88[0]:   cmds: cdt current : 0x00000458
cx88[0]:   cmds: pci target  : 0x22a58440
cx88[0]:   cmds: line / byte : 0x00f00000
cx88[0]:   risc0: 0x80008200 [ sync resync count=512 ]
cx88[0]:   risc1: 0x1c0003c0 [ write sol eol count=960 ]
cx88[0]:   risc2: 0x229e63c0 [ arg #1 ]
cx88[0]:   risc3: 0x1c0003c0 [ write sol eol count=960 ]
cx88[0]:   iq 0: 0x229e63c0 [ skip irq2 23 20 19 18 cnt1 14 13 count=960 ]
cx88[0]:   iq 1: 0x1c0003c0 [ write sol eol count=960 ]
cx88[0]:   iq 2: 0x229e6b40 [ arg #1 ]
cx88[0]:   iq 3: 0x1c0003c0 [ write sol eol count=960 ]
cx88[0]:   iq 4: 0x229e72c0 [ arg #1 ]
cx88[0]:   iq 5: 0x1c0003c0 [ write sol eol count=960 ]
cx88[0]:   iq 6: 0x229e7a40 [ arg #1 ]
cx88[0]:   iq 7: 0x1c0003c0 [ write sol eol count=960 ]
cx88[0]:   iq 8: 0x229e81c0 [ arg #1 ]
cx88[0]:   iq 9: 0x1c0003c0 [ write sol eol count=960 ]
cx88[0]:   iq a: 0x229e8940 [ arg #1 ]
cx88[0]:   iq b: 0x22a57900 [ skip irq2 23 21 18 cnt0 14 13 12 count=2304 ]
cx88[0]:   iq c: 0x1c0003c0 [ write sol eol count=960 ]
cx88[0]:   iq d: 0x22a58080 [ arg #1 ]
cx88[0]:   iq e: 0x80008200 [ sync resync count=512 ]
cx88[0]:   iq f: 0x1c0003c0 [ write sol eol count=960 ]
cx88[0]:   iq 10: 0x00180c00 [ arg #1 ]
cx88[0]: fifo: 0x00180c00 -> 0x183400
cx88[0]: ctrl: 0x00180400 -> 0x180460
cx88[0]:   ptr1_reg: 0x00181830
cx88[0]:   ptr2_reg: 0x00180478
cx88[0]:   cnt1_reg: 0x0000002c
cx88[0]:   cnt2_reg: 0x00000000
cx88[0]/0: [e2959300/1] timeout - dma=0x22a5a000
cx88[0]/0: [e2959540/2] timeout - dma=0x22ad8000
cx88[0]/0: [e2959240/3] timeout - dma=0x22b56000
cx88[0]/0: [e2959840/4] timeout - dma=0x22bb8000
cx88[0]/0: [e2959780/0] timeout - dma=0x229fc000
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1101] dn_risci1* dnf_of dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1000] dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*
cx88[1]/1: IRQ loop detected, disabling interrupts
cx88[1]: irq aud [0x1001] dn_risci1* dn_sync*



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
