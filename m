Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52196 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab3LUW1X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Dec 2013 17:27:23 -0500
Message-ID: <52B615C9.8040806@iki.fi>
Date: Sun, 22 Dec 2013 00:27:21 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Subject: em28xx list_add corruption reported by list debug
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I ran also this kind of bug. Device was PCTV 290e, which has that video 
unused. I have no any analog em28xx webcam to test if that happens here too.

Fortunately I found one video device which does not crash nor dump debug 
bug warnings. It is some old gspca webcam. Have to look example how 
those videobuf callbacks are implemented there..

regards
Antti


[crope@localhost linux]$ cat /dev/video0
cat: /dev/video0: Invalid argument
[crope@localhost linux]$ cat /dev/video0
cat: /dev/video0: Device or resource busy
[crope@localhost linux]$


joulu 22 00:08:24 localhost.localdomain kernel: em28174 #0: no endpoint 
for analog mode and transfer type 0
joulu 22 00:08:31 localhost.localdomain kernel: ------------[ cut here 
]------------
joulu 22 00:08:31 localhost.localdomain kernel: WARNING: CPU: 3 PID: 
6892 at lib/list_debug.c:33 __list_add+0xac/0xc0()
joulu 22 00:08:31 localhost.localdomain kernel: list_add corruption. 
prev->next should be next (ffff88030b686498), but was           (null). 
(prev=ffff88030c6c1748).
joulu 22 00:08:31 localhost.localdomain kernel: Modules linked in: 
rc_pinnacle_pctv_hd(O) em28xx_rc(O) tda18271(O) cxd2820r(O) 
em28xx_dvb(O) r820t(O) mn88472(O) rtl2832_sd...b_usb_af901
joulu 22 00:08:31 localhost.localdomain kernel: CPU: 3 PID: 6892 Comm: 
cat Tainted: G         C O 3.13.0-rc1+ #77
joulu 22 00:08:31 localhost.localdomain kernel: Hardware name: System 
manufacturer System Product Name/M5A78L-M/USB3, BIOS 1503    11/14/2012
joulu 22 00:08:31 localhost.localdomain kernel:  0000000000000009 
ffff8803052afcb8 ffffffff816b8da9 ffff8803052afd00
joulu 22 00:08:31 localhost.localdomain kernel:  ffff8803052afcf0 
ffffffff8106bcfd ffff88030c6c5348 ffff88030b686498
joulu 22 00:08:31 localhost.localdomain kernel:  ffff88030c6c1748 
0000000000000292 0000000000000001 ffff8803052afd50
joulu 22 00:08:31 localhost.localdomain kernel: Call Trace:
joulu 22 00:08:31 localhost.localdomain kernel:  [<ffffffff816b8da9>] 
dump_stack+0x4d/0x66
joulu 22 00:08:31 localhost.localdomain kernel:  [<ffffffff8106bcfd>] 
warn_slowpath_common+0x7d/0xa0
joulu 22 00:08:31 localhost.localdomain kernel:  [<ffffffff8106bd6c>] 
warn_slowpath_fmt+0x4c/0x50
joulu 22 00:08:31 localhost.localdomain kernel:  [<ffffffff8134c2dc>] 
__list_add+0xac/0xc0
joulu 22 00:08:31 localhost.localdomain kernel:  [<ffffffffa0273a7b>] 
buffer_queue+0x7b/0xb0 [em28xx]
joulu 22 00:08:31 localhost.localdomain kernel:  [<ffffffffa025a2d4>] 
__enqueue_in_driver+0x74/0x80 [videobuf2_core]
joulu 22 00:08:31 localhost.localdomain kernel:  [<ffffffffa025c568>] 
vb2_streamon+0xa8/0x190 [videobuf2_core]
joulu 22 00:08:31 localhost.localdomain kernel:  [<ffffffffa025dd12>] 
__vb2_init_fileio+0x332/0x3a0 [videobuf2_core]
joulu 22 00:08:31 localhost.localdomain kernel:  [<ffffffffa025e733>] 
__vb2_perform_fileio+0x483/0x620 [videobuf2_core]
joulu 22 00:08:31 localhost.localdomain kernel:  [<ffffffffa025eae4>] 
vb2_fop_read+0xc4/0x5e0 [videobuf2_core]
joulu 22 00:08:31 localhost.localdomain kernel:  [<ffffffffa022da55>] 
v4l2_read+0x65/0xb0 [videodev]
joulu 22 00:08:31 localhost.localdomain kernel:  [<ffffffff811cc498>] 
vfs_read+0x98/0x170
joulu 22 00:08:31 localhost.localdomain kernel:  [<ffffffff811ccfdc>] 
SyS_read+0x4c/0xa0
joulu 22 00:08:31 localhost.localdomain kernel:  [<ffffffff8110affc>] ? 
__audit_syscall_entry+0x9c/0xf0
joulu 22 00:08:31 localhost.localdomain kernel:  [<ffffffff816ca729>] 
system_call_fastpath+0x16/0x1b
joulu 22 00:08:31 localhost.localdomain kernel: ---[ end trace 
dcb247cebbcc2a82 ]---



-- 
http://palosaari.fi/
