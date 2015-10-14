Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53270 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652AbbJNPvp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2015 11:51:45 -0400
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: MC Next Gen au0828_usb_disconnect() softlockups
Message-ID: <561E7A0A.2090100@osg.samsung.com>
Date: Wed, 14 Oct 2015 09:51:38 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am seeing softlockups from au0828_usb_disconnect().
I am looking into this problem. Reporting just in case
you saw this during your testing and problem is fixed.
I am doing USB device removal test when I ran into this.
Could this be an issue with the use of spin_lock() - should
spin_lock_irq() a better choice in media_device_unregister_entity()

Here is the dmesg snippet:

[ 1316.127004] R13: ffffffff810d0a2e R14: ffffffff818005a1 R15:
ffffffff810d0a2e
[ 1316.127008] FS:  00007f47d8fd9700(0000) GS:ffff88023ec80000(0000)
knlGS:0000000000000000
[ 1316.127012] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1316.127015] CR2: 00007fff1917afa8 CR3: 0000000222b4b000 CR4:
00000000000407e0
[ 1316.127017] Stack:
[ 1316.127020]  ffff88023407b958 ffffffff813bf83f ffff88023407b988
ffffffff810b4d4c
[ 1316.127027]  ffff880223329180 ffff880223329180 ffff880223385d58
ffff880223385d78
[ 1316.127034]  ffff88023407b9b8 ffffffff817fefa9 ffffffff8161199b
ffffffff81611b18
[ 1316.127040] Call Trace:
[ 1316.127049]  [<ffffffff813bf83f>] __delay+0xf/0x20
[ 1316.127056]  [<ffffffff810b4d4c>] do_raw_spin_lock+0x8c/0x120
[ 1316.127062]  [<ffffffff817fefa9>] _raw_spin_lock+0x39/0x40
[ 1316.127070]  [<ffffffff8161199b>] ?
media_device_unregister_entity+0x3b/0x130
[ 1316.127075]  [<ffffffff81611b18>] ? media_device_unregister+0x88/0x150
[ 1316.127081]  [<ffffffff8161199b>]
media_device_unregister_entity+0x3b/0x130
[ 1316.127087]  [<ffffffff81611b4e>] media_device_unregister+0xbe/0x150
[ 1316.127097]  [<ffffffffa061e325>]
au0828_unregister_media_device+0x45/0x60 [au0828]
[ 1316.127105]  [<ffffffffa061e75a>] au0828_usb_v4l2_release+0x6a/0x90
[au0828]
[ 1316.127111]  [<ffffffff8161a65e>] v4l2_device_release+0x1e/0x30
[ 1316.127116]  [<ffffffff8161ad85>] v4l2_device_put+0x25/0x30
[ 1316.127123]  [<ffffffffa061e3f1>] au0828_usb_disconnect+0xb1/0xd0
[au0828]
[ 1316.127129]  [<ffffffff8159a556>] usb_unbind_interface+0x86/0x280
[ 1316.127135]  [<ffffffff810ae2ed>] ? trace_hardirqs_on+0xd/0x10
[ 1316.127141]  [<ffffffff814dc736>] __device_release_driver+0x96/0x130
[ 1316.127146]  [<ffffffff814dc7f5>] device_release_driver+0x25/0x40
[ 1316.127150]  [<ffffffff814db56c>] bus_remove_device+0x11c/0x1a0
[ 1316.127157]  [<ffffffff814d7bc9>] device_del+0x139/0x250
[ 1316.127162]  [<ffffffff815973f1>] ? remove_intf_ep_devs+0x41/0x60
[ 1316.127168]  [<ffffffff81597d49>] usb_disable_device+0x89/0x280
[ 1316.127173]  [<ffffffff8158d726>] usb_disconnect+0x96/0x2b0
[ 1316.127178]  [<ffffffff8158fa06>] hub_event+0x696/0x15a0
[ 1316.127185]  [<ffffffff81077ed0>] process_one_work+0x1c0/0x4b0
[ 1316.127191]  [<ffffffff81077e64>] ? process_one_work+0x154/0x4b0
[ 1316.127196]  [<ffffffff810784eb>] worker_thread+0x4b/0x440
[ 1316.127202]  [<ffffffff810784a0>] ? rescuer_thread+0x2e0/0x2e0
[ 1316.127207]  [<ffffffff810784a0>] ? rescuer_thread+0x2e0/0x2e0
[ 1316.127212]  [<ffffffff8107e404>] kthread+0xe4/0x100
[ 1316.127219]  [<ffffffff8107e320>] ? kthread_create_on_node+0x220/0x220
[ 1316.127224]  [<ffffffff817ffe0f>] ret_from_fork+0x3f/0x70
[ 1316.127229]  [<ffffffff8107e320>] ? kthread_create_on_node+0x220/0x220
[ 1316.127232] Code: c3 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
44 00 00 55 48 89 e5 65 8b 35 80 a8 c4 7e 0f ae f0 0f 31 89 c1 0f ae f0
0f 31 <48> c1 e2 20 89 c0 48 09 c2 89 d0 29 ca 39 fa 73 1c f3 90 65 8b
[ 1323.553480] device: '0:40': device_add
[ 1323.553532] PM: Adding info for No Bus:0:40

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
