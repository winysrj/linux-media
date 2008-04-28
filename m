Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3S2lOv8016180
	for <video4linux-list@redhat.com>; Sun, 27 Apr 2008 22:47:24 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3S2l8am001514
	for <video4linux-list@redhat.com>; Sun, 27 Apr 2008 22:47:08 -0400
From: Andy Walls <awalls@radix.net>
To: Xefur Ragnarok <x3fur@yahoo.com>
In-Reply-To: <173975.40126.qm@web63109.mail.re1.yahoo.com>
References: <173975.40126.qm@web63109.mail.re1.yahoo.com>
Content-Type: text/plain
Date: Sun, 27 Apr 2008 22:47:02 -0400
Message-Id: <1209350822.3208.37.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: WinTV PVR PCI
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

On Sun, 2008-04-27 at 09:04 -0700, Xefur Ragnarok wrote:
> Hello, 
> 
> I have recently acquired a WinTV PVR PCI card. What is interesting about this card is that none of the drivers worked in either windows or linux. I believe the reason to be the following:
> 
> excerpt from lspci:
> 01:02.0 Multimedia video controller: Unknown device 009e:036e (rev 11)
> 01:02.1 Multimedia controller: Unknown device 009e:0878 (rev 11)

Are you sure those aren't 109e:036e & 109e:0878 ?

http://pci-ids.ucw.cz/iii/?i=109e036e
http://pci-ids.ucw.cz/iii/?i=109e0878

What are the subsystem id's (available via lspci -nv)?

Once you know the subsystem id's, you can look at the lines in
drivers/media/video/bt8xx/bttv-cards.c that look like this:

{ 0x13eb0070, BTTV_BOARD_HAUPPAUGE878,  "Hauppauge WinTV" },
{ 0x39000070, BTTV_BOARD_HAUPPAUGE878,  "Hauppauge WinTV-D" },
{ 0x45000070, BTTV_BOARD_HAUPPAUGEPVR,  "Hauppauge WinTV/PVR" },
...
/* ---- card 0x50 ---------------------------------- */
   [BTTV_BOARD_HAUPPAUGEPVR] = {
        .name           = "Hauppauge WinTV PVR",
...


and the card numbers listed in Documentation/video4linux/CARDLIST.bttv,
and try to modprobe the bttv module specifying the card type:

# modprobe -r bttv
# modprobe bttv card=2 (or 10, or 80 = 0x50, or something else)



> I'm positive that this is the card. However its' PCI Subsystem ID is unrecognised.

What are the subsystem id's? (lspci -nv)

> It has the BT878 Chipset, I'm not sure about the tuner but I know it is NTSC. I've tried manually following the directions on the bttv howto to no avail. All of those instructions assume that you have a pci subsystem id of a card that should have been already detected.
> 
> Other Info:
> 
> mediacenter:/home/tim/Desktop/bttv-0.9.15 # lspci
> 00:00.0 Host bridge: Intel Corporation 82865G/PE/P DRAM Controller/Host-Hub Interface (rev 02)
> 00:01.0 PCI bridge: Intel Corporation 82865G/PE/P PCI to AGP Controller (rev 02)
> 00:03.0 PCI bridge: Intel Corporation 82865G/PE/P PCI to CSA Bridge (rev 02)
> 00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #1 (rev 02)
> 00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #2 (rev 02)
> 00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #3 (rev 02)
> 00:1d.3 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #4 (rev 02)
> 00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2 EHCI Controller (rev 02)
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2)
> 00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC Interface Bridge (rev 02)
> 00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE Controller (rev 02)
> 00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller (rev 02)
> 00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus Controller (rev 02)
> 00:1f.5 Multimedia audio controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) AC'97 Audio Controller (rev 02)
> 01:01.0 Multimedia audio controller: C-Media Electronics Inc CM8738 (rev 10)
> 01:02.0 Multimedia video controller: Unknown device 009e:036e (rev 11)
> 01:02.1 Multimedia controller: Unknown device 009e:0878 (rev 11)
> 02:01.0 Ethernet controller: Intel Corporation 82547EI Gigabit Ethernet Controller
> 03:00.0 VGA compatible controller: ATI Technologies Inc RV350 AR [Radeon 9600]
> 03:00.1 Display controller: ATI Technologies Inc RV350 AR [Radeon 9600] (Secondary)
> 
> 
> mediacenter:/home/tim/Desktop/bttv-0.9.15 # lsmod |grep bt
> bttv                  168980  0
> i2c_algo_bit            9988  1 bttv
> tveeprom               18960  1 bttv
> i2c_core               27520  3 bttv,i2c_algo_bit,tveeprom
> video_buf              27652  1 bttv
> ir_common              38148  1 bttv
> compat_ioctl32          5376  1 bttv
> btcx_risc               8840  1 bttv
> videodev               30464  1 bttv
> v4l2_common            20608  2 bttv,videodev
> v4l1_compat            16388  2 bttv,videodev
> firmware_class         13568  2 bttv,microcode

Did you modprobe these yourself, or did it happen automatically?  What
was logged in dmesg when the module was probed?  What was logged
in /var/log/messages?

Earlier you stated the linux driver wasn't working.  What are the
symptoms - what is not working?

> 
> Any help would be appreciated
> Timothy

-Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
