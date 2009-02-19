Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1JLBjZK004099
	for <video4linux-list@redhat.com>; Thu, 19 Feb 2009 16:11:45 -0500
Received: from publicis.hu (mail.publicis.hu [195.228.55.162])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1JLBVj9005061
	for <video4linux-list@redhat.com>; Thu, 19 Feb 2009 16:11:32 -0500
Mime-Version: 1.0 (Apple Message framework v753.1)
To: V4L <video4linux-list@redhat.com>
Message-Id: <DEB306E3-97D0-461B-A69B-C56FC86F562B@madmac.hu>
From: =?ISO-8859-1?Q?Riba_Zolt=E1n?= <libus@madmac.hu>
Date: Thu, 19 Feb 2009 22:11:28 +0100
Content-Type: text/plain;
	charset=ISO-8859-1;
	delsp=yes;
	format=flowed
Content-Transfer-Encoding: quoted-printable
Subject: Newbie question about cheap 4ch security card
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

Hi,

I want to get working this card under my Debian :(2.6.24-etchnhalf.=20
1-686 on i686)

http://www.zoneminder.com/wiki/index.php/Image:4ch_DVR_card.jpg

But it doesn't want...:
dmesg:

bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Host bridge needs ETBF enabled.
bttv: Bt8xx card found (0).
PCI: Found IRQ 15 for device 0000:00:12.0
PCI: Sharing IRQ 15 with 0000:00:07.2
PCI: Sharing IRQ 15 with 0000:00:0b.0
FPCI: Sharing IRQ 15 with 0000:00:12.1F
bttv0: Bt878 (rev 17) at 0000:00:12.0, irq: 15, latency: 32, mmio: =20
0xd7001000
bttv0: using: GrandTec Multi Capture Card (Bt878) [card=3D77,insmod =20
option]
bttv0: enabling ETBF (430FX/VP3 compatibilty)
bttv0: gpio: en=3D00000000, out=3D00000000 in=3D00f360ff [init]
bt878 #0 [sw]: bus seems to be busy
bttv0: tuner absent
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: PLL: 28636363 =3D> 35468950 .. ok
bt878: AUDIO driver version 0.0.0 loaded
bt878: Bt878 AUDIO function found (0).
PCI: Found IRQ 15 for device 0000:00:12.1
PCI: Sharing IRQ 15 with 0000:00:07.2
PCI: Sharing IRQ 15 with 0000:00:0b.0
PCI: Sharing IRQ 15 with 0000:00:12.0
bt878_probe: card id=3D[0x0], Unknown card.Exiting..
bt878: probe of 0000:00:12.1 failed with error -22

lspci -vn

00:12.0 0400: 109e:036e (rev 11)
         Flags: bus master, medium devsel, latency 32, IRQ 15
         Memory at d7001000 (32-bit, prefetchable) [size=3D4K]
         Capabilities: [44] Vital Product Data <?>
         Capabilities: [4c] Power Management version 2
         Kernel driver in use: bttv
         Kernel modules: bttv

00:12.1 0480: 109e:0878 (rev 11)
         Flags: medium devsel, IRQ 15
         Memory at d7002000 (32-bit, prefetchable) [size=3D4K]
         Capabilities: [44] Vital Product Data <?>
         Capabilities: [4c] Power Management version 2
         Kernel modules: bt878

lspci -v

00:12.0 Multimedia video controller: Brooktree Corporation Bt878 =20
Video Capture (rev 11)
         Flags: bus master, medium devsel, latency 32, IRQ 15
         Memory at d7001000 (32-bit, prefetchable) [size=3D4K]
         Capabilities: [44] Vital Product Data <?>
         Capabilities: [4c] Power Management version 2
         Kernel driver in use: bttv
         Kernel modules: bttv

00:12.1 Multimedia controller: Brooktree Corporation Bt878 Audio =20
Capture (rev 11)
         Flags: medium devsel, IRQ 15
         Memory at d7002000 (32-bit, prefetchable) [size=3D4K]
         Capabilities: [44] Vital Product Data <?>
         Capabilities: [4c] Power Management version 2
         Kernel modules: bt878


There are any suggestion to get working this card?

Thanks : Zolt=E1n Riba


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
