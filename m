Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4OFfsEx028469
	for <video4linux-list@redhat.com>; Sat, 24 May 2008 11:41:54 -0400
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.225])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4OFffaR006157
	for <video4linux-list@redhat.com>; Sat, 24 May 2008 11:41:42 -0400
Received: by wx-out-0506.google.com with SMTP id i27so951070wxd.6
	for <video4linux-list@redhat.com>; Sat, 24 May 2008 08:41:41 -0700 (PDT)
Message-ID: <4fd977fd0805240841g113e27c1kead1d086ebb348f4@mail.gmail.com>
Date: Sat, 24 May 2008 17:41:40 +0200
From: "Vladimir Komendantsky" <komendantsky@gmail.com>
To: linux-dvb@linuxtv.org, video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: 
Subject: noisy sound on cx23880/xc2028 -- please help!!!
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

Can anyone help me please to resolve a problem on a card with cx88
chipset and tuner xc2028? The picture is perfect but the sound signal
is completely distorted (still there is a weak hint of the original
sound). I loaded the firmware xc3028-v27.fw as explained in a few
places including v4l-dvb docs and wiki. Then I tried Conexant based
xc3028 firmwares and Powerangel firmwares from
http://mcentral.de/firmware/, and both produced the same noisy sound.

The dmesg output is below. The card is recognised as PowerColor Real
Angel, although I've got mine rebranded under the name Techgear
Classic TV Pro.

tuner' 1-0061: chip found @ 0xc2 (cx88[0])
xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
cx88[0]: Asking xc2028/3028 to load firmware xc3028-v25.fw
input: cx88 IR (PowerColor Real Angel  as /class/input/input3
cx88[0]/0: found at 0000:00:10.0, rev: 5, irq: 10, latency: 66, mmio: 0x43000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
cx88 IR (PowerColor Real Angel : unknown key: key=0x3f raw=0x3f down=1
cx88 IR (PowerColor Real Angel : unknown key: key=0x3f raw=0x3f down=0
xc2028 1-0061: Loading 80 firmware images from xc3028-v25.fw, type:
xc2028 firmware, ver 2.7
cx88[0]: Calling XC2028/3028 callback
xc2028 1-0061: Loading firmware for type=BASE (1), id 0000000000000000.
cx88[0]: Calling XC2028/3028 callback
xc2028 1-0061: Loading firmware for type=(0), id 000000000000b700.
SCODE (20000000), id 000000000000b700:
xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320
(60008000), id 0000000000008000.
cx88[0]: Calling XC2028/3028 callback
...
cx88[0]: Calling XC2028/3028 callback
xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
cx88[0]: Calling XC2028/3028 callback
xc2028 1-0061: Loading firmware for type=(0), id 0000001000400000.
SCODE (20000000), id 0000001000400000:
xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_6000
(60008000), id 0000000c04c000f0.
cx88[0]: Calling XC2028/3028 callback
...
cx88[0]: video y / packed - dma channel status dump
cx88[0]:   cmds: initial risc: 0x07f5c000
cx88[0]:   cmds: cdt base    : 0x00180440
cx88[0]:   cmds: cdt size    : 0x0000000c
cx88[0]:   cmds: iq base     : 0x00180400
cx88[0]:   cmds: iq size     : 0x00000010
cx88[0]:   cmds: risc pc     : 0x07f5c998
cx88[0]:   cmds: iq wr ptr   : 0x00000106
cx88[0]:   cmds: iq rd ptr   : 0x0000010a
cx88[0]:   cmds: cdt current : 0x00000488
cx88[0]:   cmds: pci target  : 0x07f56b00
cx88[0]:   cmds: line / byte : 0x00f00000
cx88[0]:   risc0: 0x80008200 [ sync resync count=512 ]
cx88[0]:   risc1: 0x1c000500 [ write sol eol count=1280 ]
cx88[0]:   risc2: 0x07e89500 [ arg #1 ]
cx88[0]:   risc3: 0x18000100 [ write sol count=256 ]
cx88[0]:   iq 0: 0x1c000500 [ write sol eol count=1280 ]
cx88[0]:   iq 1: 0x07e8a900 [ arg #1 ]
cx88[0]:   iq 2: 0x1c000500 [ write sol eol count=1280 ]
cx88[0]:   iq 3: 0x07e8b300 [ arg #1 ]
...
cx88[0]:   iq 4: 0x18000300 [ write sol count=768 ]
cx88[0]:   iq 5: 0x07e8bd00 [ arg #1 ]
cx88[0]:   iq 6: 0x07f56000 [ INVALID eol irq2 irq1 23 22 21 20 18
cnt0 14 13 count=0 ]
cx88[0]:   iq 7: 0x1c000500 [ write sol eol count=1280 ]
cx88[0]:   iq 8: 0x07f56600 [ arg #1 ]
cx88[0]:   iq 9: 0x80008200 [ sync resync count=512 ]
cx88[0]:   iq a: 0x1c000500 [ write sol eol count=1280 ]
cx88[0]:   iq b: 0x07e89500 [ arg #1 ]
cx88[0]:   iq c: 0x18000100 [ write sol count=256 ]
cx88[0]:   iq d: 0x07e89f00 [ arg #1 ]
cx88[0]:   iq e: 0x14000400 [ write eol count=1024 ]
cx88[0]:   iq f: 0x07e8a000 [ arg #1 ]
cx88[0]: fifo: 0x00180c00 -> 0x183400
cx88[0]: ctrl: 0x00180400 -> 0x180460
cx88[0]:   ptr1_reg: 0x00181ce0
cx88[0]:   ptr2_reg: 0x00180478
cx88[0]:   cnt1_reg: 0x0000006b
cx88[0]:   cnt2_reg: 0x00000000
cx88[0]/0: [ce75c5c0/0] timeout - dma=0x07f5c000
cx88[0]/0: [ce75cbc0/1] timeout - dma=0x07ff4000
cx88[0]: Calling XC2028/3028 callback
...

--
Vladimir

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
