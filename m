Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.academica.fi ([109.75.228.249]:49077 "EHLO
	smtp41.academica.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbbFUSYH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jun 2015 14:24:07 -0400
Received: from localhost (localhost [IPv6:::1])
	by smtp41.academica.fi (Postfix) with ESMTP id DE1D36025A
	for <linux-media@vger.kernel.org>; Sun, 21 Jun 2015 21:19:01 +0300 (EEST)
Received: from smtp41.academica.fi ([127.0.0.1])
	by localhost (smtp41.academica.fi [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IWIkimP-Dz4u for <linux-media@vger.kernel.org>;
	Sun, 21 Jun 2015 21:19:01 +0300 (EEST)
Received: from [192.168.2.157] (host-109-75-226-21.igua.fi [109.75.226.21])
	by smtp41.academica.fi (Postfix) with ESMTP id 1BBB56024E
	for <linux-media@vger.kernel.org>; Sun, 21 Jun 2015 21:19:00 +0300 (EEST)
Message-ID: <55870014.90902@iki.fi>
Date: Sun, 21 Jun 2015 21:19:00 +0300
From: Jouni Karvo <Jouni.Karvo@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: cx23885 risc op code error with DvbSKY T982
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have dvbsky T982.  The firmware is up to date from openelec site.  Nothing on the CI slot

Linux xpc 4.1.0-rc8 #2 SMP Sun Jun 21 11:16:21 EEST 2015 x86_64 x86_64 x86_64 GNU/Linux
I run the kernel in ubuntu

dmesg from the startup

[   16.427634] CORE cx23885[0]: subsystem: 4254:0982, board: DVBSky T982 [card=51,autodetected]
[   17.275820] cx23885_dvb_register() allocating 1 frontend(s)
[   17.275822] cx23885[0]: cx23885 based dvb card
[   17.281850] DVB: registering new adapter (cx23885[0])
[   17.281853] cx23885 0000:01:00.0: DVB: registering adapter 0 frontend 0 (Silicon Labs Si2168)...
[   17.308303] DVBSky T982 port 1 MAC address: 00:17:42:54:09:87
[   17.308304] cx23885_dvb_register() allocating 1 frontend(s)
[   17.308305] cx23885[0]: cx23885 based dvb card
[   17.310640] DVB: registering new adapter (cx23885[0])

And /var/log/kern.log from the event.

Jun 21 16:44:03 xpc kernel: [ 9793.748543] cx23885[0]: mpeg risc op code error
Jun 21 16:44:03 xpc kernel: [ 9793.748548] cx23885[0]: TS2 C - dma channel status dump
Jun 21 16:44:03 xpc kernel: [ 9793.748550] cx23885[0]:   cmds: init risc lo   : 0x78b76000
Jun 21 16:44:03 xpc kernel: [ 9793.748552] cx23885[0]:   cmds: init risc hi   : 0x00000000
Jun 21 16:44:03 xpc kernel: [ 9793.748554] cx23885[0]:   cmds: cdt base       : 0x000105e0
Jun 21 16:44:03 xpc kernel: [ 9793.748556] cx23885[0]:   cmds: cdt size       : 0x0000000a
Jun 21 16:44:03 xpc kernel: [ 9793.748558] cx23885[0]:   cmds: iq base        : 0x00010440
Jun 21 16:44:03 xpc kernel: [ 9793.748560] cx23885[0]:   cmds: iq size        : 0x00000010
Jun 21 16:44:03 xpc kernel: [ 9793.748562] cx23885[0]:   cmds: risc pc lo     : 0x78b76004
Jun 21 16:44:03 xpc kernel: [ 9793.748564] cx23885[0]:   cmds: risc pc hi     : 0x00000000
Jun 21 16:44:03 xpc kernel: [ 9793.748566] cx23885[0]:   cmds: iq wr ptr      : 0x00004111
Jun 21 16:44:03 xpc kernel: [ 9793.748568] cx23885[0]:   cmds: iq rd ptr      : 0x00004110
Jun 21 16:44:03 xpc kernel: [ 9793.748570] cx23885[0]:   cmds: cdt current    : 0x00010628
Jun 21 16:44:03 xpc kernel: [ 9793.748572] cx23885[0]:   cmds: pci target lo  : 0x4b9a42f0
Jun 21 16:44:03 xpc kernel: [ 9793.748574] cx23885[0]:   cmds: pci target hi  : 0x00000000
Jun 21 16:44:03 xpc kernel: [ 9793.748576] cx23885[0]:   cmds: line / byte    : 0x02610000
Jun 21 16:44:03 xpc kernel: [ 9793.748578] cx23885[0]:   risc0: 0x1c0002f0 [ write sol eol count=752 ]
Jun 21 16:44:03 xpc kernel: [ 9793.748582] cx23885[0]:   risc1: 0x4b9a42f0 [ INVALID sol irq2 irq1 23 20 19 cnt1 14 count=752 ]
Jun 21 16:44:03 xpc kernel: [ 9793.748587] cx23885[0]:   risc2: 0x00000000 [ INVALID count=0 ]
Jun 21 16:44:03 xpc kernel: [ 9793.748589] cx23885[0]:   risc3: 0x1c0002f0 [ write sol eol count=752 ]
Jun 21 16:44:03 xpc kernel: [ 9793.748592] cx23885[0]:   (0x00010440) iq 0: 0x003fb002 [ INVALID 21 20 19 18 cnt1 cnt0 resync 13 12 count=2 ]
Jun 21 16:44:03 xpc kernel: [ 9793.748597] cx23885[0]:   (0x00010444) iq 1: 0x4b9a4000 [ INVALID sol irq2 irq1 23 20 19 cnt1 14 count=0 ]
Jun 21 16:44:03 xpc kernel: [ 9793.748601] cx23885[0]:   (0x00010448) iq 2: 0x00000000 [ INVALID count=0 ]
Jun 21 16:44:03 xpc kernel: [ 9793.748603] cx23885[0]:   (0x0001044c) iq 3: 0x1c0002f0 [ write sol eol count=752 ]
Jun 21 16:44:03 xpc kernel: [ 9793.748606] cx23885[0]:   iq 4: 0x4b9a42f0 [ arg #1 ]
Jun 21 16:44:03 xpc kernel: [ 9793.748608] cx23885[0]:   iq 5: 0x00000000 [ arg #2 ]
Jun 21 16:44:03 xpc kernel: [ 9793.748610] cx23885[0]:   (0x00010458) iq 6: 0x1c0002f0 [ write sol eol count=752 ]
Jun 21 16:44:03 xpc kernel: [ 9793.748613] cx23885[0]:   iq 7: 0x4b9a45e0 [ arg #1 ]
Jun 21 16:44:03 xpc kernel: [ 9793.748615] cx23885[0]:   iq 8: 0x00000000 [ arg #2 ]
Jun 21 16:44:03 xpc kernel: [ 9793.748617] cx23885[0]:   (0x00010464) iq 9: 0x1c0002f0 [ write sol eol count=752 ]
Jun 21 16:44:03 xpc kernel: [ 9793.748620] cx23885[0]:   iq a: 0x4b9a48d0 [ arg #1 ]
Jun 21 16:44:03 xpc kernel: [ 9793.748623] cx23885[0]:   iq b: 0x00000000 [ arg #2 ]
Jun 21 16:44:03 xpc kernel: [ 9793.748625] cx23885[0]:   (0x00010470) iq c: 0x1c0002f0 [ write sol eol count=752 ]
Jun 21 16:44:03 xpc kernel: [ 9793.748628] cx23885[0]:   iq d: 0x4b9a4bc0 [ arg #1 ]
Jun 21 16:44:03 xpc kernel: [ 9793.748629] cx23885[0]:   iq e: 0x00000000 [ arg #2 ]
Jun 21 16:44:03 xpc kernel: [ 9793.748631] cx23885[0]:   (0x0001047c) iq f: 0x71000000 [ jump irq1 count=0 ]
Jun 21 16:44:03 xpc kernel: [ 9793.748634] cx23885[0]:   iq 10: 0x0af829b7 [ arg #1 ]
Jun 21 16:44:03 xpc kernel: [ 9793.748636] cx23885[0]:   iq 11: 0x7bf7a9f0 [ arg #2 ]
Jun 21 16:44:03 xpc kernel: [ 9793.748637] cx23885[0]: fifo: 0x00006000 -> 0x7000
Jun 21 16:44:03 xpc kernel: [ 9793.748638] cx23885[0]: ctrl: 0x00010440 -> 0x104a0
Jun 21 16:44:03 xpc kernel: [ 9793.748640] cx23885[0]:   ptr1_reg: 0x00006be0
Jun 21 16:44:03 xpc kernel: [ 9793.748642] cx23885[0]:   ptr2_reg: 0x00010628
Jun 21 16:44:03 xpc kernel: [ 9793.748643] cx23885[0]:   cnt1_reg: 0x00000002
Jun 21 16:44:03 xpc kernel: [ 9793.748645] cx23885[0]:   cnt2_reg: 0x00000001

yours,
		Jouni

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
