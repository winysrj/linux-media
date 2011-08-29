Return-path: <linux-media-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:49160 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab1H2VZd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 17:25:33 -0400
Date: Mon, 29 Aug 2011 21:48:46 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: BUG: unable to handle kernel paging request at 6b6b6bcb
 (v4l2_device_disconnect+0x11/0x30)
Message-ID: <20110829204846.GA14699@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I managed to produce an oops in 3.1.0-rc3-00270-g7a54f5e by unplugging a
USB webcam. See below:

eeepc kernel: [ 1263.874756] cheese[3402]: segfault at 58 ip 080630b6 sp afc2c840 error 4 in cheese[8048000+24000]
eeepc kernel: [ 1393.419370] uvcvideo: Non-zero status (-84) in status completion handler.
eeepc kernel: [ 1393.500719] usb 3-2: USB disconnect, device number 4
eeepc kernel: [ 1393.504351] uvcvideo: Failed to resubmit video URB (-19).
eeepc kernel: [ 1495.428853] BUG: unable to handle kernel paging request at 6b6b6bcb
eeepc kernel: [ 1495.429017] IP: [<b0358d37>] dev_get_drvdata+0x17/0x20
eeepc kernel: [ 1495.429017] *pde = 00000000 
eeepc kernel: [ 1495.429017] Oops: 0000 [#1] DEBUG_PAGEALLOC
eeepc kernel: [ 1495.429017] 
eeepc kernel: [ 1495.429017] Pid: 3476, comm: cheese Not tainted 3.1.0-rc3-00270-g7a54f5e-dirty #485 ASUSTeK Computer INC. 900/900
eeepc kernel: [ 1495.429017] EIP: 0060:[<b0358d37>] EFLAGS: 00010202 CPU: 0
eeepc kernel: [ 1495.429017] EIP is at dev_get_drvdata+0x17/0x20
eeepc kernel: [ 1495.429017] EAX: 6b6b6b6b EBX: eb08d870 ECX: 00000000 EDX: eb08d930
eeepc kernel: [ 1495.429017] ESI: eb08d870 EDI: eb08d870 EBP: d3249cac ESP: d3249cac
eeepc kernel: [ 1495.429017]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
eeepc kernel: [ 1495.429017] Process cheese (pid: 3476, ti=d3248000 task=df46d870 task.ti=d3248000)
eeepc kernel: [ 1495.429017] Stack:
eeepc kernel: [ 1495.429017]  d3249cb8 b03e77a1 d307b840 d3249ccc b03e77d1 d307b840 eb08d870 eb08d830
eeepc kernel: [ 1495.429017]  d3249ce4 b03ed3b7 00000246 d307b840 eb08d870 d3021b80 d3249cec b03ed565
eeepc kernel: [ 1495.429017]  d3249cfc b03e044d e8323d10 b06e013c d3249d18 b0355fb9 fffffffe d3249d1c
eeepc kernel: [ 1495.429017] Call Trace:
eeepc kernel: [ 1495.429017]  [<b03e77a1>] v4l2_device_disconnect+0x11/0x30
eeepc kernel: [ 1495.429017]  [<b03e77d1>] v4l2_device_unregister+0x11/0x50
eeepc kernel: [ 1495.429017]  [<b03ed3b7>] uvc_delete+0x37/0x110
eeepc kernel: [ 1495.429017]  [<b03ed565>] uvc_release+0x25/0x30
eeepc kernel: [ 1495.429017]  [<b03e044d>] v4l2_device_release+0x9d/0xc0
eeepc kernel: [ 1495.429017]  [<b0355fb9>] device_release+0x19/0x90
eeepc kernel: [ 1495.429017]  [<b03adfdc>] ? usb_hcd_unlink_urb+0x7c/0x90
eeepc kernel: [ 1495.429017]  [<b026b99c>] kobject_release+0x3c/0x90
eeepc kernel: [ 1495.429017]  [<b026b960>] ? kobject_del+0x30/0x30
eeepc kernel: [ 1495.429017]  [<b026ca4c>] kref_put+0x2c/0x60
eeepc kernel: [ 1495.429017]  [<b026b88d>] kobject_put+0x1d/0x50
eeepc kernel: [ 1495.429017]  [<b03b2385>] ? usb_autopm_put_interface+0x25/0x30
eeepc kernel: [ 1495.429017]  [<b03f0e5d>] ? uvc_v4l2_release+0x5d/0xd0
eeepc kernel: [ 1495.429017]  [<b0355d2f>] put_device+0xf/0x20
eeepc kernel: [ 1495.429017]  [<b03dfa96>] v4l2_release+0x56/0x60
eeepc kernel: [ 1495.429017]  [<b019c8dc>] fput+0xcc/0x220
eeepc kernel: [ 1495.429017]  [<b01990f4>] filp_close+0x44/0x70
eeepc kernel: [ 1495.429017]  [<b012b238>] put_files_struct+0x158/0x180
eeepc kernel: [ 1495.429017]  [<b012b100>] ? put_files_struct+0x20/0x180
eeepc kernel: [ 1495.429017]  [<b012b2a0>] exit_files+0x40/0x50
eeepc kernel: [ 1495.429017]  [<b012b9e7>] do_exit+0x5a7/0x660
eeepc kernel: [ 1495.429017]  [<b0135f72>] ? __dequeue_signal+0x12/0x120
eeepc kernel: [ 1495.429017]  [<b055edf2>] ? _raw_spin_unlock_irq+0x22/0x30
eeepc kernel: [ 1495.429017]  [<b012badc>] do_group_exit+0x3c/0xb0
eeepc kernel: [ 1495.429017]  [<b015792b>] ? trace_hardirqs_on+0xb/0x10
eeepc kernel: [ 1495.429017]  [<b013755f>] get_signal_to_deliver+0x18f/0x570
eeepc kernel: [ 1495.429017]  [<b01020f7>] do_signal+0x47/0x9e0
eeepc kernel: [ 1495.429017]  [<b055edf2>] ? _raw_spin_unlock_irq+0x22/0x30
eeepc kernel: [ 1495.429017]  [<b015792b>] ? trace_hardirqs_on+0xb/0x10
eeepc kernel: [ 1495.429017]  [<b0123300>] ? T.1034+0x30/0xc0
eeepc kernel: [ 1495.429017]  [<b055c45f>] ? schedule+0x29f/0x640
eeepc kernel: [ 1495.429017]  [<b0102ac8>] do_notify_resume+0x38/0x40
eeepc kernel: [ 1495.429017]  [<b055f154>] work_notifysig+0x9/0x11
eeepc kernel: [ 1495.429017] Code: e5 5d 83 f8 01 19 c0 f7 d0 83 e0 f0 c3 8d b4 26 00 00 00 00 55 85 c0 89 e5 75 09 31 c0 5d c3 90 8d 74 26 00 8b 40 04 85 c0 74 f0 <8b> 40 60 5d c3 8d 74 26 00 55 89 e5 53 89 c3 83 ec 04 8b 40 04 
eeepc kernel: [ 1495.429017] EIP: [<b0358d37>] dev_get_drvdata+0x17/0x20 SS:ESP 0068:d3249cac
eeepc kernel: [ 1495.429017] CR2: 000000006b6b6bcb
eeepc kernel: [ 1495.466975] uvcvideo: Failed to resubmit video URB (-27).
eeepc kernel: [ 1495.467860] uvcvideo: Failed to resubmit video URB (-27).
eeepc kernel: last message repeated 3 times
eeepc kernel: [ 1495.512610] ---[ end trace 73ec16848794e5a5 ]---
eeepc kernel: [ 1495.512620] Fixing recursive fault but reboot is needed!

-- 
Sitsofe | http://sucs.org/~sits/
