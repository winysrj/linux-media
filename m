Return-path: <mchehab@pedra>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:42745 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab1CCQBn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 11:01:43 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by stevekerrison.com (Postfix) with ESMTP id 4B25B16405
	for <linux-media@vger.kernel.org>; Thu,  3 Mar 2011 16:01:42 +0000 (GMT)
Received: from stevekerrison.com ([127.0.0.1])
	by localhost (stevekez.vm.bytemark.co.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cfz4Gcjooglf for <linux-media@vger.kernel.org>;
	Thu,  3 Mar 2011 16:01:35 +0000 (GMT)
Received: from [192.168.1.19] (94-193-106-123.zone7.bethere.co.uk [94.193.106.123])
	(Authenticated sender: steve@stevekerrison.com)
	by stevekerrison.com (Postfix) with ESMTPSA id 6FF3D163E5
	for <linux-media@vger.kernel.org>; Thu,  3 Mar 2011 16:01:35 +0000 (GMT)
Subject: em28xx: dvb lock bug on re-plug of device?
From: Steve Kerrison <steve@stevekerrison.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 16:01:33 +0000
Message-ID: <1299168093.2864.14.camel@ares>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

I wonder if Devin/Mauro could help me with something as I've run into a
problem developing a driver for the PCTV 290e?

First plug of the device works fine, em28xx and em28xx_dvb are loaded.
However, if I disconnect and then re-plug the device, the em28xx_dvb
module will hang in dvb_init() where it performs mutex_lock(&dev->lock);

It looks like the code to handle udev locking runs into a problem
if the em28xx_dvb is already loaded. I'm referring to this:
https://patchwork.kernel.org/patch/91160/

I don't have any other em28xx DVB devices to test against at the moment.
I have modified dvb_init to give up if it doesn't get a lock straight
away. This is not a valid fix, but it means I can run rmmod instead of
rebooting.

Below is a copy of khubd's complaint about the hangup. I pulled from
media_tree.git. Perhaps this is already fixed in another branch? Thanks.

[31498.792677] INFO: task khubd:28 blocked for more than 120 seconds.
[31498.792682] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[31498.792685] khubd           D ffff880232d59a58     0    28      2
0x00000000
[31498.792689]  ffff880232d4d6b0 0000000000000046 ffff880232d4d600
ffffffff81036bb9
[31498.792692]  0000000000013a80 ffff880232d596c0 ffff880232d59a58
ffff880232d4dfd8
[31498.792695]  ffff880232d59a60 0000000000013a80 ffff880232d4c010
0000000000013a80
[31498.792699] Call Trace:
[31498.792708]  [<ffffffff81036bb9>] ? default_spin_lock_flags+0x9/0x10
[31498.792714]  [<ffffffff81598817>] __mutex_lock_slowpath+0xf7/0x180
[31498.792717]  [<ffffffff815986fb>] mutex_lock+0x2b/0x50
[31498.792722]  [<ffffffffa07f43c9>] dvb_init+0x69/0xc20 [em28xx_dvb]
[31498.792730]  [<ffffffffa07a84c2>] em28xx_init_extension+0x42/0x70
[em28xx]
[31498.792735]  [<ffffffffa07a7e89>] em28xx_usb_probe+0x6a9/0xb10
[em28xx]
[31498.792741]  [<ffffffff814173c3>] usb_probe_interface+0xf3/0x210
[31498.792746]  [<ffffffff813979f6>] driver_probe_device+0x96/0x1c0
[31498.792749]  [<ffffffff81397bc0>] ? __device_attach+0x0/0x60
[31498.792751]  [<ffffffff81397c13>] __device_attach+0x53/0x60
[31498.792755]  [<ffffffff81396a88>] bus_for_each_drv+0x68/0x90
[31498.792757]  [<ffffffff81397cdf>] device_attach+0x8f/0xb0
[31498.792760]  [<ffffffff8139685d>] bus_probe_device+0x2d/0x50
[31498.792764]  [<ffffffff813951c9>] device_add+0x639/0x710
[31498.792767]  [<ffffffff81393a01>] ? dev_set_name+0x41/0x50
[31498.792770]  [<ffffffff81415a26>] usb_set_configuration+0x606/0x6d0
[31498.792774]  [<ffffffff8141f064>] generic_probe+0x44/0xa0
[31498.792777]  [<ffffffff81416c10>] usb_probe_device+0x30/0x60
[31498.792779]  [<ffffffff813979f6>] driver_probe_device+0x96/0x1c0
[31498.792782]  [<ffffffff81397bc0>] ? __device_attach+0x0/0x60
[31498.792784]  [<ffffffff81397c13>] __device_attach+0x53/0x60
[31498.792787]  [<ffffffff81396a88>] bus_for_each_drv+0x68/0x90
[31498.792789]  [<ffffffff81397cdf>] device_attach+0x8f/0xb0
[31498.792792]  [<ffffffff8139685d>] bus_probe_device+0x2d/0x50
[31498.792795]  [<ffffffff813951c9>] device_add+0x639/0x710
[31498.792797]  [<ffffffff81415279>] ? usb_cache_string+0x99/0xb0
[31498.792800]  [<ffffffff8140e3cb>] usb_new_device+0x9b/0x140
[31498.792803]  [<ffffffff8140f428>] hub_thread+0xc18/0x11a0
[31498.792806]  [<ffffffff8105afee>] ? dequeue_task_fair+0x29e/0x2b0
[31498.792811]  [<ffffffff81083000>] ? autoremove_wake_function+0x0/0x40
[31498.792813]  [<ffffffff8140e810>] ? hub_thread+0x0/0x11a0
[31498.792816]  [<ffffffff81082ab6>] kthread+0x96/0xa0
[31498.792820]  [<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
[31498.792823]  [<ffffffff81082a20>] ? kthread+0x0/0xa0
[31498.792825]  [<ffffffff8100cde0>] ? kernel_thread_helper+0x0/0x10
[31498.792868] INFO: task usb_id:19221 blocked for more than 120
seconds.
[31498.792870] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[31498.792872] usb_id          D ffff8802016b8398     0 19221      1
0x00000000
[31498.792875]  ffff88018ac9fda8 0000000000000082 0000000003a65c58
0000000000000000
[31498.792878]  0000000000013a80 ffff8802016b8000 ffff8802016b8398
ffff88018ac9ffd8
[31498.792882]  ffff8802016b83a0 0000000000013a80 ffff88018ac9e010
0000000000013a80
[31498.792885] Call Trace:
[31498.792888]  [<ffffffff81598817>] __mutex_lock_slowpath+0xf7/0x180
[31498.792891]  [<ffffffff815986fb>] mutex_lock+0x2b/0x50
[31498.792895]  [<ffffffff8141a51f>] show_manufacturer+0x2f/0x70
[31498.792898]  [<ffffffff81393a37>] dev_attr_show+0x27/0x50
[31498.792904]  [<ffffffff8110abae>] ? __get_free_pages+0xe/0x50
[31498.792910]  [<ffffffff811c6e9e>] sysfs_read_file+0xce/0x1c0
[31498.792914]  [<ffffffff81159995>] vfs_read+0xc5/0x190
[31498.792916]  [<ffffffff81159b61>] sys_read+0x51/0x90
[31498.792922]  [<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
-- 
Steve Kerrison MEng Hons.
http://www.stevekerrison.com/ 


