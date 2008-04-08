Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m38CDPS6006181
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 08:13:25 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m38CCsnX011464
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 08:12:54 -0400
From: Michael Bergmann <mbergmann-sh@gmx.de>
To: video4linux-list@redhat.com
Date: Tue, 8 Apr 2008 14:12:48 +0200
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200804081412.48030.mbergmann-sh@gmx.de>
Subject: Need help installing FastWin tv2000 XP without radio tuner
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

Hi list!

Hope this is the right place to put my question?
I placed a LeadTec Winfast TV2000 XP rev. 11 into my dual boot system (AMD 
Athlon64 X 2 running WinXP and Debian/GNU Linux SID with Kernel 
2.6.24-2.6.24.4). While TV is working perfectly for DVB-C under XP (...radio 
doesn't work - no radio tuner can be found), it refuses to do so under Linux: 
no signal!

What I did already:
1) googeling a lot...
2) hg'ing the v4l sources, compiling and installing them
3) The tv card and remote are detected automatically with their correct names. 
Nevertheless, I wrote a file /etc/modprobe.d/tvcard, containing the 
parameters mentioned in the wiki:
# Leadtec WinFAST 2000 analog TV
options bttv card=34 tuner=5 radio=0 lumafilter=1 combfilter=1 chroma_agc=1

Anyhow, if I start tvtime-scanner --norm=PAL, I receive a message: No Signal!
dmesg says:
___________________________________
Linux video capture interface: v2.00
ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:07.0[B] -> Link [LAZA] -> GSI 20 (level, low) -> 
IRQ 20
PCI: Setting latency timer of device 0000:00:07.0 to 64
hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 18
ACPI: PCI Interrupt 0000:01:0a.0[A] -> Link [LNKC] -> GSI 18 (level, low) -> 
IRQ 18
bttv0: Bt878 (rev 17) at 0000:01:0a.0, irq: 18, latency: 64, mmio: 0xcffff000
bttv0: detected: Leadtek TV 2000 XP [card=34], PCI subsystem ID is 107d:6609
bttv0: using: Leadtek WinFast 2000/ WinFast 2000 XP [card=34,insmod option]
bttv0: gpio: en=00000000, out=00000000 in=003ff500 [init]
bttv0: tuner type=5
bttv0: i2c: checking for MSP34xx @ 0x80... not found
bttv0: i2c: checking for TDA9875 @ 0xb0... not found
bttv0: i2c: checking for TDA7432 @ 0x8a... not found
tuner' 2-0043: chip found @ 0x86 (bt878 #0 [sw])
tda9887 2-0043: creating new instance
tda9887 2-0043: tda988[5/6/7] found
tuner' 2-0061: chip found @ 0xc2 (bt878 #0 [sw])
tuner-simple 2-0061: creating new instance
tuner-simple 2-0061: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
tuner' 2-0063: chip found @ 0xc6 (bt878 #0 [sw])
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: registered device radio0
bttv0: PLL: 28636363 => 35468950 .. ok
input: bttv IR (card=34) 
as /devices/pci0000:00/0000:00:08.0/0000:01:0a.0/input/input5
___________________________________________________________
root@Asgaard:/home/bergmann# lspci | grep Multimedia
01:0a.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture 
(rev 11)
01:0a.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 
11)
____________
lspci -v:

01:0a.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture 
(rev 11)
        Subsystem: LeadTek Research Inc. Unknown device 6609
        Flags: bus master, medium devsel, latency 64, IRQ 18
        Memory at cffff000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data <?>
        Capabilities: [4c] Power Management version 2
        Kernel driver in use: bttv
        Kernel modules: bttv

01:0a.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 
11)
        Subsystem: LeadTek Research Inc. Unknown device 6609
        Flags: bus master, medium devsel, latency 64, IRQ 10
        Memory at cfffe000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data <?>
        Capabilities: [4c] Power Management version 2
_______________________________________________________________________

I've tried to change the identifier for the tuner device to everything listed 
in the wiki, but the result stays the same - no signal. tvtime refuses to 
connect to the tuner, nor does vdr. I'm stuck.

I've heard rumours about an alternative driver under v4l/experimental that 
might work, but don't have the faintest idea on how to configure it.

Could someone please help me out?

Thanks a lot for any idea, tip or hint!

regards,

Michael
__________________________
http://www.mbergmann.de

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
