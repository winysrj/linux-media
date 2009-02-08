Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n180QMgi012285
	for <video4linux-list@redhat.com>; Sat, 7 Feb 2009 19:26:22 -0500
Received: from s5.cableone.net (s5.cableone.net [24.116.0.231])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n180Q49U014817
	for <video4linux-list@redhat.com>; Sat, 7 Feb 2009 19:26:05 -0500
Received: from Desktop (unverified [24.119.216.113])
	by s5.cableone.net (CableOne SMTP Service s5) with ESMTP id
	13788833-1872270
	for <video4linux-list@redhat.com>; Sat, 07 Feb 2009 17:26:01 -0700
From: "Chris S. Wilson" <info@coolcatpc.com>
To: <video4linux-list@redhat.com>
Date: Sat, 7 Feb 2009 18:25:58 -0600
Message-ID: <000301c98983$d0d1c7e0$727557a0$@com>
MIME-Version: 1.0
Content-Language: en-us
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Subject: New Card - BT878
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

Hello Everyone, I got a new BT878 card instead of my ATI, I cant seem to get
it to work:

 

LSPCI shows me:

 

00:00.0 RAM memory: nVidia Corporation MCP61 Memory Controller (rev a1)

00:01.0 ISA bridge: nVidia Corporation MCP61 LPC Bridge (rev a2)

00:01.1 SMBus: nVidia Corporation MCP61 SMBus (rev a2)

00:01.2 RAM memory: nVidia Corporation MCP61 Memory Controller (rev a2)

00:02.0 USB Controller: nVidia Corporation MCP61 USB Controller (rev a3)

00:02.1 USB Controller: nVidia Corporation MCP61 USB Controller (rev a3)

00:04.0 PCI bridge: nVidia Corporation MCP61 PCI bridge (rev a1)

00:05.0 Audio device: nVidia Corporation MCP61 High Definition Audio (rev
a2)

00:06.0 IDE interface: nVidia Corporation MCP61 IDE (rev a2)

00:08.0 IDE interface: nVidia Corporation MCP61 SATA Controller (rev a2)

00:08.1 IDE interface: nVidia Corporation MCP61 SATA Controller (rev a2)

00:09.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev a2)

00:0b.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev a2)

00:0c.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev a2)

00:0d.0 VGA compatible controller: nVidia Corporation GeForce 6150SE nForce
430 (rev a2)

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
HyperTransport Technology Configuration

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Address Map

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM
Controller

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Miscellaneous Control

01:05.0 Multimedia video controller: Brooktree Corporation Bt879(??) Video
Capture (rev 11)

01:05.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture
(rev 11)

01:09.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 IEEE-1394a-2000
Controller (PHY/Link)

03:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8039 PCI-E
Fast Ethernet Controller (rev 14)

 

Then I modprobe bttv, and lsmod:

 

[root@server-1 ~]# lsmod |grep bttv

bttv                  150868  1 bt878

videodev               32000  3 bttv,ivtv,cx88xx

ir_common              38532  2 bttv,cx88xx

compat_ioctl32          5120  2 bttv,ivtv

i2c_algo_bit            8836  3 bttv,ivtv,cx88xx

v4l2_common            12800  3 bttv,ivtv,cx2341x

videobuf_dma_sg        13828  2 bttv,cx88xx

videobuf_core          18052  3 bttv,cx88xx,videobuf_dma_sg

btcx_risc               7560  2 bttv,cx88xx

tveeprom               14596  3 bttv,ivtv,cx88xx

i2c_core               21396  8
bttv,ivtv,cx88xx,i2c_algo_bit,v4l2_common,tveeprom,nvidia,i2c_nforce2

[root@server-1 ~]#

 

 

I get no /dev/video0 like I did with this card on my centos 5.1 box, I am
running Fedora Core 10 on this machine with kernel 2.6.27, any ideas anyone?
I tried a ./MAKEDEV video0 however this did not fix the issue.

 

I've browsed around the wiki, read the docs, but cant seem to find any
answers. Any help would be greatly appreciated.

 

Thanks in advance!

 

Chris W

 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
