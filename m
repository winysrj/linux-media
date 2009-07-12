Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6CEJo75024901
	for <video4linux-list@redhat.com>; Sun, 12 Jul 2009 10:19:50 -0400
Received: from pasmtpB.tele.dk (pasmtpb.tele.dk [80.160.77.98])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n6CEJZ1h005187
	for <video4linux-list@redhat.com>; Sun, 12 Jul 2009 10:19:36 -0400
Received: from [10.0.0.19]
	(0x5da6fe5a.cpe.ge-0-2-0-1104.arcnqu1.customer.tele.dk
	[93.166.254.90])
	by pasmtpB.tele.dk (Postfix) with ESMTP id C90F8E3031A
	for <video4linux-list@redhat.com>;
	Sun, 12 Jul 2009 16:19:34 +0200 (CEST)
Message-ID: <4A59F0F5.5020009@softwarehuset.dk>
Date: Sun, 12 Jul 2009 16:19:33 +0200
From: Morten Stigaard Laursen <morten@softwarehuset.dk>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Subject: System crashes when trying to tune a channel using tzap with a
 LITE-ON USB2.0 DVB-T Tuner
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

Hi, I'm trying to get my USB DVB-T tuner up and running it is a rebrand 
of the LITE-ON USB2.0 DVB-T Tuner and the kernel identifies it as such, 
using the DiBcom 3000MC/P driver. And the led comes on when driver is 
loaded as it's supposed to so everything looks right, however when I try 
to tune a channel using Tzap the system crashes and prints the errors 
attached below, I have tried the stick on another system (ubuntu 9.04) 
and on that system it works perfectly.
Any suggestions to how I might narrow down or solve this problem is 
greatly appreciated.

Thank you in advance for any help
Morten S. Laursen

The system I'm trying to run this on is and OMAP3 DevKit8000 Board using 
a Texas Instruments OMAP3530 Arm processor (the same as the Beagle 
boards), I'm running kernel 2.6.28-rc9-omap1.

Channels.conf:

Tegnsprogstolkning:658000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:103
DR1:658000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:111:121:101
DR2:658000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:211:221:102
TV 2 (Østjylland):658000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:2111:2121:213

Console log from crash:

devkit8000:~# tzap dr1
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/root/.tzap/channels.conf'
tuning to 658000000 HzUnable to handle kernel NULL pointer dereference 
at virtual address 00000000
 
video pid 0x006f, audio pid 0xpgd = c6d08000
0079
[00000000] *pgd=87baa031, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#1]
Modules linked in:
CPU: 0    Not tainted  (2.6.28-rc9-omap1 #4)
PC is at dma_cache_maint+0x40/0xa8
LR is at usb_hcd_submit_urb+0x178/0x888
pc : [<c003310c>]    lr : [<c01f9cf4>]    psr: 20000013
sp : c6d2dc50  ip : c6d2dc60  fp : c6d2dc5c
r10: c78c9c48  r9 : 00000020  r8 : 00000000
r7 : 00000000  r6 : c78dd800  r5 : c78c9c40  r4 : ffa42000
r3 : 00000000  r2 : 00000002  r1 : ffa43000  r0 : ffa42000
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 10c5387d  Table: 86d08018  DAC: 00000015
Process tzap (pid: 1612, stack limit = 0xc6d2c2e0)
Stack: (0xc6d2dc50 to 0xc6d2e000)
dc40:                                     c6d2dd14 c6d2dc60 c01f9cf4 
c00330d8 
dc60: c6d2dccc c6d2dc70 c007ef64 c007d628 00000044 c004fb34 c781e01c 
00000000 
dc80: c03d3b18 00000000 00000000 00000001 00000000 c6d2c000 c03d3564 
c03d3564 
dca0: c02cb75c c03d3b18 000000d2 c03d3b14 00000000 00000000 c7813e90 
c89a4000 
dcc0: c89a4000 c0007220 c6d2dd14 c0092308 00000000 00000000 c7bec960 
000002cf 
dce0: c89a4000 00000002 c04c9ee0 c78c1c00 00000002 00000020 00000000 
00001100 
dd00: 00000001 c78c87d4 c6d2dd34 c6d2dd18 c01fa890 c01f9b88 c78c8a84 
c78c8a84 
dd20: 00000001 00000000 c6d2dd54 c6d2dd38 c01ee33c c01fa668 c78c873c 
c8871000 
dd40: 00000001 00000001 c6d2dd74 c6d2dd58 c01ed974 c01ee324 c8871000 
c78c8828 
dd60: c78c8a00 00000000 c6d2dd84 c6d2dd78 c01eda1c c01ed8b0 c6d2ddac 
c6d2dd88 
dd80: c01e0bd4 c01eda14 00000000 c01e0c18 0000006f c8986000 00000004 
00000001 
dda0: c6d2ddf4 c6d2ddb0 c01dec00 c01e0b5c 00008000 00000000 00000000 
22222222 
ddc0: 00000000 00000000 c8986000 c8986018 c8986000 c6d2de30 c898606c 
00000000 
dde0: c6c5c340 c78c8810 c6d2de24 c6d2ddf8 c01deec0 c01de880 c6d2de30 
be9f3b94 
de00: c6d2de30 00004014 40146f2c 00000001 c6c5c340 00000000 c6d2dedc 
c6d2de28 
de20: c01dd614 c01dec78 00000fff c78b00e0 0000006f 00000000 00000000 
00000001 
de40: 00000004 c008260c 60000013 c7b04b60 c6d2de6c c6d2de60 c01c0408 
c01c40d4 
de60: c6d2de84 c6d2de70 a0000013 c7af3000 c6d2de8c c6d2de80 c01c0408 
c01c40d4 
de80: c6d2dea4 c6d2de90 c01c0424 c01c03c4 00000022 c7af3000 00000000 
60000093 
dea0: a0000013 00000023 c7af3000 c6d2c000 00000000 40146f2c be9f3b94 
40146f2c 
dec0: c78b00e0 be9f3b94 c6d2c000 00000000 c6d2def4 c6d2dee0 c01de294 
c01dd538 
dee0: c01dec6c c004b354 c6d2df0c c6d2def8 c00a960c c01de284 c78b00e0 
00000004 
df00: c6d2df7c c6d2df10 c00a9a8c c00a95b0 00000000 c7bb8ea8 00000200 
00000002 
df20: c74e0cd8 c7bb8da0 00000023 be9f14e8 c6d2c000 00000000 c6d2df6c 
c6d2df48 
df40: c009e314 c00c4650 00000000 00000000 00000000 00000004 be9f3b94 
40146f2c 
df60: c78b00e0 c002df28 c6d2c000 00000000 c6d2dfa4 c6d2df80 c00a9b0c 
c00a9654 
df80: ffffffff 00000000 0000006f 00000001 be9f3f07 00000036 00000000 
c6d2dfa8 
dfa0: c002dd80 c00a9ad8 0000006f 00000001 00000004 40146f2c be9f3b94 
00000004 
dfc0: 0000006f 00000001 be9f3f07 00000036 0000b0c0 00000000 00000004 
00000000 
dfe0: 00013ca0 be9f3b90 00008b0c 400f4fbc 60000010 00000004 00000000 
00000000 
Backtrace: 
[<c00330cc>] (dma_cache_maint+0x0/0xa8) from [<c01f9cf4>] 
(usb_hcd_submit_urb+0x178/0x888)
[<c01f9b7c>] (usb_hcd_submit_urb+0x0/0x888) from [<c01fa890>] 
(usb_submit_urb+0x234/0x250)
[<c01fa65c>] (usb_submit_urb+0x0/0x250) from [<c01ee33c>] 
(usb_urb_submit+0x24/0x78)
 r7:00000000 r6:00000001 r5:c78c8a84 r4:c78c8a84
[<c01ee318>] (usb_urb_submit+0x0/0x78) from [<c01ed974>] 
(dvb_usb_ctrl_feed+0xd0/0x14c)
 r7:00000001 r6:00000001 r5:c8871000 r4:c78c873c
[<c01ed8a4>] (dvb_usb_ctrl_feed+0x0/0x14c) from [<c01eda1c>] 
(dvb_usb_start_feed+0x14/0x18)
 r7:00000000 r6:c78c8a00 r5:c78c8828 r4:c8871000
[<c01eda08>] (dvb_usb_start_feed+0x0/0x18) from [<c01e0bd4>] 
(dmx_ts_feed_start_filtering+0x84/0xc8)
[<c01e0b50>] (dmx_ts_feed_start_filtering+0x0/0xc8) from [<c01dec00>] 
(dvb_dmxdev_filter_start+0x38c/0x3f8)
 r9:00000001 r8:00000004 r7:c8986000 r6:0000006f r5:c01e0c18
r4:00000000
[<c01de874>] (dvb_dmxdev_filter_start+0x0/0x3f8) from [<c01deec0>] 
(dvb_demux_do_ioctl+0x254/0x38c)
[<c01dec6c>] (dvb_demux_do_ioctl+0x0/0x38c) from [<c01dd614>] 
(dvb_usercopy+0xe8/0x170)
[<c01dd52c>] (dvb_usercopy+0x0/0x170) from [<c01de294>] 
(dvb_demux_ioctl+0x1c/0x28)
[<c01de278>] (dvb_demux_ioctl+0x0/0x28) from [<c00a960c>] 
(vfs_ioctl+0x68/0x78)
[<c00a95a4>] (vfs_ioctl+0x0/0x78) from [<c00a9a8c>] 
(do_vfs_ioctl+0x444/0x484)
 r5:00000004 r4:c78b00e0
[<c00a9648>] (do_vfs_ioctl+0x0/0x484) from [<c00a9b0c>] 
(sys_ioctl+0x40/0x64)
[<c00a9acc>] (sys_ioctl+0x0/0x64) from [<c002dd80>] 
(ret_fast_syscall+0x0/0x2c)
 r7:00000036 r6:be9f3f07 r5:00000001 r4:0000006f
Code: 9a000001 e15c0003 3a000011 e3a03000 (e5833000) 
---[ end trace 39daa7aac997a191 ]---


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
