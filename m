Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.academica.fi ([109.75.228.249]:44375 "EHLO
	smtp41.academica.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933025AbbFVJkN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2015 05:40:13 -0400
Received: from localhost (localhost [IPv6:::1])
	by smtp41.academica.fi (Postfix) with ESMTP id C0336601DA
	for <linux-media@vger.kernel.org>; Mon, 22 Jun 2015 12:40:10 +0300 (EEST)
Received: from smtp41.academica.fi ([127.0.0.1])
	by localhost (smtp41.academica.fi [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SVPHPTUfSl8k for <linux-media@vger.kernel.org>;
	Mon, 22 Jun 2015 12:40:09 +0300 (EEST)
Received: from [192.168.2.157] (host-109-75-226-21.igua.fi [109.75.226.21])
	by smtp41.academica.fi (Postfix) with ESMTP id D721760090
	for <linux-media@vger.kernel.org>; Mon, 22 Jun 2015 12:40:09 +0300 (EEST)
Message-ID: <5587D7F9.5@iki.fi>
Date: Mon, 22 Jun 2015 12:40:09 +0300
From: Jouni Karvo <Jouni.Karvo@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: cx23885 mpeg risc op code error with DVBSky T980C
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


T980C with up to date firmware from openelec repository.

Linux xpc 4.1.0-rc8 #2 SMP Sun Jun 21 11:16:21 EEST 2015 x86_64 x86_64 
x86_64 GNU/Linux

[   18.180769] cx23885[1]: cx23885 based dvb card
[   18.181426] i2c i2c-13: Added multiplexed i2c bus 15
[   18.181428] si2168 13-0064: Silicon Labs Si2168 successfully attached
[   18.183134] si2157 15-0060: Silicon Labs Si2147/2148/2157/2158 
successfully attached
[   18.183138] DVB: registering new adapter (cx23885[1])
[   18.183140] cx23885 0000:02:00.0: DVB: registering adapter 2 frontend 
0 (Silicon Labs Si2168)...
[   18.190429] sp2 13-0040: CIMaX SP2 successfully attached
[   18.216762] DVBSky T980C MAC address: 00:17:42:54:09:89
[   18.216765] cx23885_dev_checkrevision() Hardware revision = 0xa5
[   18.216768] cx23885[1]/0: found at 0000:02:00.0, rev: 4, irq: 17, 
latency: 0, mmio: 0xdf600000


Jun 21 22:47:43 xpc kernel: [31579.827615] cx23885[1]: mpeg risc op code 
error
Jun 21 22:47:43 xpc kernel: [31579.827620] cx23885[1]: TS1 B - dma 
channel status dump
Jun 21 22:47:43 xpc kernel: [31579.827622] cx23885[1]:   cmds: init risc 
lo   : 0x4650c000
Jun 21 22:47:43 xpc kernel: [31579.827624] cx23885[1]:   cmds: init risc 
hi   : 0x00000000
Jun 21 22:47:43 xpc kernel: [31579.827626] cx23885[1]:   cmds: cdt 
base       : 0x00010580
Jun 21 22:47:43 xpc kernel: [31579.827628] cx23885[1]:   cmds: cdt 
size       : 0x0000000a
Jun 21 22:47:43 xpc kernel: [31579.827629] cx23885[1]:   cmds: iq 
base        : 0x00010400
Jun 21 22:47:43 xpc kernel: [31579.827631] cx23885[1]:   cmds: iq 
size        : 0x00000010
Jun 21 22:47:43 xpc kernel: [31579.827633] cx23885[1]:   cmds: risc pc 
lo     : 0x4650c00c
Jun 21 22:47:43 xpc kernel: [31579.827635] cx23885[1]:   cmds: risc pc 
hi     : 0x00000000
Jun 21 22:47:43 xpc kernel: [31579.827636] cx23885[1]:   cmds: iq wr 
ptr      : 0x00004103
Jun 21 22:47:43 xpc kernel: [31579.827638] cx23885[1]:   cmds: iq rd 
ptr      : 0x00004100
Jun 21 22:47:43 xpc kernel: [31579.827640] cx23885[1]:   cmds: cdt 
current    : 0x00010588
Jun 21 22:47:43 xpc kernel: [31579.827643] cx23885[1]:   cmds: pci 
target lo  : 0x4b8d82f0
Jun 21 22:47:43 xpc kernel: [31579.827644] cx23885[1]:   cmds: pci 
target hi  : 0x00000000
Jun 21 22:47:43 xpc kernel: [31579.827646] cx23885[1]:   cmds: line / 
byte    : 0x01c10000
Jun 21 22:47:43 xpc kernel: [31579.827648] cx23885[1]:   risc0: 
0x1c0002f0 [ write sol eol count=752 ]
Jun 21 22:47:43 xpc kernel: [31579.827651] cx23885[1]:   risc1: 
0x4b8d82f0 [ INVALID sol irq2 irq1 23 19 18 cnt0 resync count=752 ]
Jun 21 22:47:43 xpc kernel: [31579.827655] cx23885[1]:   risc2: 
0x00000000 [ INVALID count=0 ]
Jun 21 22:47:43 xpc kernel: [31579.827657] cx23885[1]:   risc3: 
0x1c0002f0 [ write sol eol count=752 ]
Jun 21 22:47:43 xpc kernel: [31579.827659] cx23885[1]: (0x00010400) iq 
0: 0x80200080 [ sync 21 count=128 ]
Jun 21 22:47:43 xpc kernel: [31579.827662] cx23885[1]: (0x00010404) iq 
1: 0xf4b82563 [ INVALID eol 23 21 20 19 13 count=1379 ]
Jun 21 22:47:43 xpc kernel: [31579.827665] cx23885[1]: (0x00010408) iq 
2: 0x01000000 [ INVALID irq1 count=0 ]
Jun 21 22:47:43 xpc kernel: [31579.827677] cx23885[1]: (0x0001040c) iq 
3: 0x1c0002f0 [ write sol eol count=752 ]
Jun 21 22:47:43 xpc kernel: [31579.827683] cx23885[1]:   iq 4: 
0x4b8d8bc0 [ arg #1 ]
Jun 21 22:47:43 xpc kernel: [31579.827685] cx23885[1]:   iq 5: 
0x00000000 [ arg #2 ]
Jun 21 22:47:43 xpc kernel: [31579.827688] cx23885[1]: (0x00010418) iq 
6: 0x71000000 [ jump irq1 count=0 ]
Jun 21 22:47:43 xpc kernel: [31579.827704] cx23885[1]:   iq 7: 
0x1c0002f0 [ arg #1 ]
Jun 21 22:47:43 xpc kernel: [31579.827706] cx23885[1]:   iq 8: 
0x4b8d8000 [ arg #2 ]
Jun 21 22:47:43 xpc kernel: [31579.827707] cx23885[1]: (0x00010424) iq 
9: 0x00000000 [ INVALID count=0 ]
Jun 21 22:47:43 xpc kernel: [31579.827709] cx23885[1]: (0x00010428) iq 
a: 0x1c0002f0 [ write sol eol count=752 ]
Jun 21 22:47:43 xpc kernel: [31579.827722] cx23885[1]:   iq b: 
0x4b8d82f0 [ arg #1 ]
Jun 21 22:47:43 xpc kernel: [31579.827723] cx23885[1]:   iq c: 
0x00000000 [ arg #2 ]
Jun 21 22:47:43 xpc kernel: [31579.827725] cx23885[1]: (0x00010434) iq 
d: 0x1c0002f0 [ write sol eol count=752 ]
Jun 21 22:47:43 xpc kernel: [31579.827727] cx23885[1]:   iq e: 
0x4b8d85e0 [ arg #1 ]
Jun 21 22:47:43 xpc kernel: [31579.827729] cx23885[1]:   iq f: 
0x00000000 [ arg #2 ]
Jun 21 22:47:43 xpc kernel: [31579.827730] cx23885[1]: fifo: 0x00005000 
-> 0x6000
Jun 21 22:47:43 xpc kernel: [31579.827730] cx23885[1]: ctrl: 0x00010400 
-> 0x10460
Jun 21 22:47:43 xpc kernel: [31579.827732] cx23885[1]:   ptr1_reg: 
0x00005030
Jun 21 22:47:43 xpc kernel: [31579.827734] cx23885[1]:   ptr2_reg: 
0x00010588
Jun 21 22:47:43 xpc kernel: [31579.827735] cx23885[1]:   cnt1_reg: 
0x00000003
Jun 21 22:47:43 xpc kernel: [31579.827738] cx23885[1]:   cnt2_reg: 
0x00000009

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
