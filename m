Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com (ext-mx10.extmail.prod.ext.phx2.redhat.com
	[10.5.110.14])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id oBM5FQMY013249
	for <video4linux-list@redhat.com>; Wed, 22 Dec 2010 00:15:26 -0500
Received: from mail-qw0-f46.google.com (mail-qw0-f46.google.com
	[209.85.216.46])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBM5FF1o000717
	for <video4linux-list@redhat.com>; Wed, 22 Dec 2010 00:15:16 -0500
Received: by qwa26 with SMTP id 26so4585548qwa.33
	for <video4linux-list@redhat.com>; Tue, 21 Dec 2010 21:15:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinwrr=vphwVq+dSi2ceL2+qBG_-GMGZHHYujYW4@mail.gmail.com>
References: <AANLkTinwrr=vphwVq+dSi2ceL2+qBG_-GMGZHHYujYW4@mail.gmail.com>
Date: Wed, 22 Dec 2010 10:45:14 +0530
Message-ID: <AANLkTikjOG14Db=S3Dk6AC53zTpv=fyY4X+HtC16sa_+@mail.gmail.com>
Subject: Quickcam express: Not able to capture video
From: Sudhindra Nayak <sudhindra.nayak@gmail.com>
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: Mauro Carvalho Chehab <mchehab@gaivota>
List-ID: <video4linux-list@redhat.com>

Hi all,

I'm using a 'Logitech Quickcam Express' (046d:0840) camera to capture video.
I'm using the STV06xx driver for this camera. I'm using a v4l2 example code
as my application along with the above mentioned driver. The example code
can be found at the below link:

http://v4l2spec.bytesex.org/spec/capture-example.html


When I run the application, the kernel crashes. I'm running the application
on the AT91 linux4sam kernel running on an AT91SAM9G45-EKES board. I've
included the error messages below:

gspca: [a.out] open
gspca: frame alloc frsz: 106560
gspca: reqbufs st:0 c:4

gspca: mmap start:4013e000 size:110592
gspca: mmap start:40159000 size:110592
gspca: mmap start:40174000 size:110592
gspca: mmap start:4018f000 size:110592
gspca: qbuf 0
gspca: qbuf 1
gspca: qbuf 2
gspca: qbuf 3
gspca: use alt 1 ep 0x81
gspca: init transfer alt 1
gspca: isoc 32 pkts size 1023 = bsize:32736
STV06xx: Starting stream
STV06xx: I2C: Command buffer contains 1 entries
STV06xx: I2C: Writing 0x00 to reg 0x30
STV06xx: I2C: Command buffer contains 1 entries
STV06xx: I2C: Writing 0x04 to reg 0x30
STV06xx: Written 0x1 to address 0x1440, status: 1
gspca: poll
gspca: poll
gspca: isoc irq
gspca: fill_frame st=0 no=32

gspca: packet [0] o:0 l:847
STV06xx: Packet of length 0 arrived
gspca: packet [1] o:1023 l:63
STV06xx: Packet of length 1023 arrived
Unable to handle kernel NULL pointer dereference at virtual address 00000040
pgd = c0004000
[00000040] *pgd=00000000
Internal error: Oops: 17 [#1]
Modules linked in:
CPU: 0    Not tainted  (2.6.30 #17)
PC is at stv06xx_pkt_scan+0x3c/0x1e0
LR is at stv06xx_pkt_scan+0x20/0x1e0
pc : [<c01c5d80>]    lr : [<c01c5d64>]    psr: 20000093
sp : c03b5e68  ip : c014c9e8  fp : 0000c001
r10: 0000c005  r9 : 0000c002  r8 : c7bfe000
r7 : c7bfe000  r6 : 000003ff  r5 : 0000003f  r4 : 0000003f
r3 : 20000093  r2 : 00000001  r1 : 00002f08  r0 : 0000002a
Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 0005317f  Table: 77b58000  DAC: 00000017
Process swapper (pid: 0, stack limit = 0xc03b4268)
Stack: (0xc03b5e68 to 0xc03b6000)
5e60:                   00000000 0000003f c7bb0800 c7bb0810 c7bfe000
00000001
5e80: 00000001 c01c5d44 00000000 c01c4034 c004d768 c7bb0800 00000000
c7bb0800
5ea0: 00000000 00000002 ffa6d800 70020b8c 00000000 c01774f8 c7bede40
c7845000
5ec0: c78450c0 c01883d8 c0035cf0 c7bede40 ffa6c040 c7bb0800 c78450c0
c018845c
5ee0: c03e4808 00000000 c7845000 c78450c0 c8c00000 c0189aac c03babc4
c03b5f00
5f00: c03b5f00 c7845000 a0000013 00000001 00000000 00000000 41069265
70020b8c
5f20: 00000000 c0177890 c03e3ea0 c78dbea0 00000016 c005c2cc c03bcd80
00000016
5f40: 00000016 c00272b0 c03df148 c005e0a8 c003fa90 00000016 00000000
c0025050
5f60: c782201c ffffffff fefff000 c00259b4 00000000 0005317f 0005217f
60000013
5f80: c00272b0 c03b4000 c03b7e44 c00272b0 c03df148 41069265 70020b8c
00000000
5fa0: 600000d3 c03b5fb8 c00272f0 c00272fc 60000013 ffffffff c00271b0
c0027194
5fc0: c03e69bc c03df11c c0022ee4 c03b7c90 70020bc0 c00089ac c000834c
00000000
5fe0: 00000000 c0022ee4 00053175 c03df178 c00232e8 70008034 00000000
00000000
[<c01c5d80>] (stv06xx_pkt_scan+0x3c/0x1e0) from [<c01c4034>]
(isoc_irq+0xec/0x14
8)
[<c01c4034>] (isoc_irq+0xec/0x148) from [<c01774f8>]
(usb_hcd_giveback_urb+0x7c/
0xcc)
[<c01774f8>] (usb_hcd_giveback_urb+0x7c/0xcc) from [<c01883d8>]
(finish_urb+0x78
/0xa8)
[<c01883d8>] (finish_urb+0x78/0xa8) from [<c018845c>]
(takeback_td+0x54/0xdc)
[<c018845c>] (takeback_td+0x54/0xdc) from [<c0189aac>]
(ohci_irq+0x210/0x2b0)
[<c0189aac>] (ohci_irq+0x210/0x2b0) from [<c0177890>]
(usb_hcd_irq+0x8c/0x98)
[<c0177890>] (usb_hcd_irq+0x8c/0x98) from [<c005c2cc>]
(handle_IRQ_event+0x40/0x
10c)
[<c005c2cc>] (handle_IRQ_event+0x40/0x10c) from [<c005e0a8>]
(handle_level_irq+0
xd0/0xf0)
[<c005e0a8>] (handle_level_irq+0xd0/0xf0) from [<c0025050>]
(_text+0x50/0x78)
[<c0025050>] (_text+0x50/0x78) from [<c00259b4>] (__irq_svc+0x34/0x60)
Exception stack(0xc03b5f70 to 0xc03b5fb8)
5f60:                                     00000000 0005317f 0005217f
60000013
5f80: c00272b0 c03b4000 c03b7e44 c00272b0 c03df148 41069265 70020b8c
00000000
5fa0: 600000d3 c03b5fb8 c00272f0 c00272fc 60000013 ffffffff
[<c00259b4>] (__irq_svc+0x34/0x60) from [<c00272f0>]
(default_idle+0x40/0x58)
[<c00272f0>] (default_idle+0x40/0x58) from [<c0027194>] (cpu_idle+0x44/0x70)
[<c0027194>] (cpu_idle+0x44/0x70) from [<c00089ac>]
(start_kernel+0x25c/0x2c0)
[<c00089ac>] (start_kernel+0x25c/0x2c0) from [<70008034>] (0x70008034)
Code: ea000057 e3560003 d59f0174 da00000d (e5d50001)
Kernel panic - not syncing: Fatal exception in interrupt
[<c002b588>] (unwind_backtrace+0x0/0xe0) from [<c003af20>]
(panic+0x44/0x11c)
[<c003af20>] (panic+0x44/0x11c) from [<c0029b44>] (die+0x12c/0x158)
[<c0029b44>] (die+0x12c/0x158) from [<c002c4b4>]
(__do_kernel_fault+0x68/0x80)
[<c002c4b4>] (__do_kernel_fault+0x68/0x80) from [<c002c6d4>]
(do_page_fault+0x20
8/0x228)
[<c002c6d4>] (do_page_fault+0x208/0x228) from [<c0025224>]
(do_DataAbort+0x34/0x
98)
[<c0025224>] (do_DataAbort+0x34/0x98) from [<c002596c>]
(__dabt_svc+0x4c/0x60)
Exception stack(0xc03b5e20 to 0xc03b5e68)
5e20: 0000002a 00002f08 00000001 20000093 0000003f 0000003f 000003ff
c7bfe000
5e40: c7bfe000 0000c002 0000c005 0000c001 c014c9e8 c03b5e68 c01c5d64
c01c5d80
5e60: 20000093 ffffffff
[<c002596c>] (__dabt_svc+0x4c/0x60) from [<c01c5d64>]
(stv06xx_pkt_scan+0x20/0x1
e0)
[<c01c5d64>] (stv06xx_pkt_scan+0x20/0x1e0) from [<c01c4034>]
(isoc_irq+0xec/0x14
8)
[<c01c4034>] (isoc_irq+0xec/0x148) from [<c01774f8>]
(usb_hcd_giveback_urb+0x7c/
0xcc)
[<c01774f8>] (usb_hcd_giveback_urb+0x7c/0xcc) from [<c01883d8>]
(finish_urb+0x78
/0xa8)
[<c01883d8>] (finish_urb+0x78/0xa8) from [<c018845c>]
(takeback_td+0x54/0xdc)
[<c018845c>] (takeback_td+0x54/0xdc) from [<c0189aac>]
(ohci_irq+0x210/0x2b0)
[<c0189aac>] (ohci_irq+0x210/0x2b0) from [<c0177890>]
(usb_hcd_irq+0x8c/0x98)
[<c0177890>] (usb_hcd_irq+0x8c/0x98) from [<c005c2cc>]
(handle_IRQ_event+0x40/0x
10c)
[<c005c2cc>] (handle_IRQ_event+0x40/0x10c) from [<c005e0a8>]
(handle_level_irq+0
xd0/0xf0)
[<c005e0a8>] (handle_level_irq+0xd0/0xf0) from [<c0025050>]
(_text+0x50/0x78)
[<c0025050>] (_text+0x50/0x78) from [<c00259b4>] (__irq_svc+0x34/0x60)
Exception stack(0xc03b5f70 to 0xc03b5fb8)
5f60:                                     00000000 0005317f 0005217f
60000013
5f80: c00272b0 c03b4000 c03b7e44 c00272b0 c03df148 41069265 70020b8c
00000000
5fa0: 600000d3 c03b5fb8 c00272f0 c00272fc 60000013 ffffffff
[<c00259b4>] (__irq_svc+0x34/0x60) from [<c00272f0>]
(default_idle+0x40/0x58)
[<c00272f0>] (default_idle+0x40/0x58) from [<c0027194>] (cpu_idle+0x44/0x70)
[<c0027194>] (cpu_idle+0x44/0x70) from [<c00089ac>]
(start_kernel+0x25c/0x2c0)
[<c00089ac>] (start_kernel+0x25c/0x2c0) from [<70008034>] (0x70008034)


Any suggestions??

-- 
Regards,

Sudhindra Nayak
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
