Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54143 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab0FEBsX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jun 2010 21:48:23 -0400
Received: by fxm8 with SMTP id 8so1158446fxm.19
        for <linux-media@vger.kernel.org>; Fri, 04 Jun 2010 18:48:21 -0700 (PDT)
Message-ID: <4C09ACE4.6080003@gmail.com>
Date: Sat, 05 Jun 2010 03:48:20 +0200
From: Xavier Gnata <xavier.gnata@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: dvb-usb/af9015 disconnection crashes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I get crashes when I disconnect a dvb-usb-af9015:


[54017.407738] usb 2-1.1: USB disconnect, address 9
[54018.685543] usb 2-1.5: USB disconnect, address 8
[54018.685895] af9015: bulk message failed:-22 (8/0)
[54018.685901] af9013: I2C read failed reg:d417
[54018.685907] af9015: bulk message failed:-22 (8/0)
[54018.685911] af9013: I2C read failed reg:d417
[54018.685915] af9015: bulk message failed:-22 (9/0)
[54018.685919] mt2060 I2C write failed
[54018.685923] af9015: bulk message failed:-22 (8/-30719)
[54018.685927] af9013: I2C read failed reg:d417
[54018.685931] af9015: bulk message failed:-22 (8/-30720)
[54018.685934] af9013: I2C read failed reg:d417
[54018.685940] af9015: bulk message failed:-22 (8/-1)
[54018.685944] af9013: I2C read failed reg:d730
[54024.625315] sky2 0000:04:00.0: eth0: Link is down
[54148.121532] INFO: task khubd:42 blocked for more than 120 seconds.
[54148.121537] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[54148.121542] khubd         D 00000000ffffffff     0    42      2
0x00000000
[54148.121549]  ffff8801270fdb00 0000000000000046 dead000000200200
0000000000015740
[54148.121555]  ffff8801270fdfd8 0000000000015740 ffff8801270fdfd8
ffff8801270f5c00
[54148.121561]  0000000000015740 0000000000015740 ffff8801270fdfd8
0000000000015740
[54148.121566] Call Trace:
[54148.121578]  [<ffffffff8107b7f0>] ? prepare_to_wait+0x60/0x90
[54148.121594]  [<ffffffffa123f885>] dvb_unregister_frontend+0xc5/0x110
[dvb_core]
[54148.121600]  [<ffffffff8107b540>] ? autoremove_wake_function+0x0/0x40
[54148.121607]  [<ffffffff8129b6c7>] ? idr_remove+0x187/0x1f0
[54148.121614]  [<ffffffffa10be072>]
dvb_usb_adapter_frontend_exit+0x22/0x40 [dvb_usb]
[54148.121620]  [<ffffffffa10bd4b3>] dvb_usb_exit+0x53/0xd0 [dvb_usb]
[54148.121627]  [<ffffffffa10bd579>] dvb_usb_device_exit+0x49/0x60 [dvb_usb]
[54148.121633]  [<ffffffffa1253051>] af9015_usb_device_exit+0x41/0x60
[dvb_usb_af9015]
[54148.121643]  [<ffffffff813c8721>] usb_unbind_interface+0x61/0x190
[54148.121651]  [<ffffffff8135512f>] __device_release_driver+0x6f/0xe0
[54148.121656]  [<ffffffff8135529d>] device_release_driver+0x2d/0x40
[54148.121662]  [<ffffffff813542ba>] bus_remove_device+0x9a/0xc0
[54148.121667]  [<ffffffff813523c7>] device_del+0x127/0x1d0
[54148.121672]  [<ffffffff813c4d18>] usb_disable_device+0xa8/0x130
[54148.121678]  [<ffffffff813be893>] usb_disconnect+0xd3/0x170
[54148.121683]  [<ffffffff813bf8ee>] hub_thread+0x50e/0x1260
[54148.121689]  [<ffffffff8107b540>] ? autoremove_wake_function+0x0/0x40
[54148.121694]  [<ffffffff813bf3e0>] ? hub_thread+0x0/0x1260
[54148.121698]  [<ffffffff8107b006>] kthread+0x96/0xa0
[54148.121705]  [<ffffffff8100ae64>] kernel_thread_helper+0x4/0x10
[54148.121710]  [<ffffffff8107af70>] ? kthread+0x0/0xa0
[54148.121714]  [<ffffffff8100ae60>] ? kernel_thread_helper+0x0/0x10
[54267.913317] INFO: task khubd:42 blocked for more than 120 seconds.
[54267.913322] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[54267.913327] khubd         D 00000000ffffffff     0    42      2
0x00000000
[54267.913333]  ffff8801270fdb00 0000000000000046 dead000000200200
0000000000015740
[54267.913340]  ffff8801270fdfd8 0000000000015740 ffff8801270fdfd8
ffff8801270f5c00
[54267.913346]  0000000000015740 0000000000015740 ffff8801270fdfd8
0000000000015740
[54267.913351] Call Trace:
[54267.913363]  [<ffffffff8107b7f0>] ? prepare_to_wait+0x60/0x90
[54267.913378]  [<ffffffffa123f885>] dvb_unregister_frontend+0xc5/0x110
[dvb_core]
[54267.913384]  [<ffffffff8107b540>] ? autoremove_wake_function+0x0/0x40
[54267.913392]  [<ffffffff8129b6c7>] ? idr_remove+0x187/0x1f0
[54267.913398]  [<ffffffffa10be072>]
dvb_usb_adapter_frontend_exit+0x22/0x40 [dvb_usb]
[54267.913405]  [<ffffffffa10bd4b3>] dvb_usb_exit+0x53/0xd0 [dvb_usb]
[54267.913411]  [<ffffffffa10bd579>] dvb_usb_device_exit+0x49/0x60 [dvb_usb]
[54267.913418]  [<ffffffffa1253051>] af9015_usb_device_exit+0x41/0x60
[dvb_usb_af9015]
[54267.913427]  [<ffffffff813c8721>] usb_unbind_interface+0x61/0x190
[54267.913435]  [<ffffffff8135512f>] __device_release_driver+0x6f/0xe0
[54267.913441]  [<ffffffff8135529d>] device_release_driver+0x2d/0x40
[54267.913446]  [<ffffffff813542ba>] bus_remove_device+0x9a/0xc0
[54267.913451]  [<ffffffff813523c7>] device_del+0x127/0x1d0
[54267.913457]  [<ffffffff813c4d18>] usb_disable_device+0xa8/0x130
[54267.913462]  [<ffffffff813be893>] usb_disconnect+0xd3/0x170
[54267.913467]  [<ffffffff813bf8ee>] hub_thread+0x50e/0x1260
[54267.913473]  [<ffffffff8107b540>] ? autoremove_wake_function+0x0/0x40
[54267.913478]  [<ffffffff813bf3e0>] ? hub_thread+0x0/0x1260
[54267.913483]  [<ffffffff8107b006>] kthread+0x96/0xa0
[54267.913490]  [<ffffffff8100ae64>] kernel_thread_helper+0x4/0x10
[54267.913494]  [<ffffffff8107af70>] ? kthread+0x0/0xa0
[54267.913499]  [<ffffffff8100ae60>] ? kernel_thread_helper+0x0/0x10
[54387.706298] INFO: task khubd:42 blocked for more than 120 seconds.
[54387.706304] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[54387.706308] khubd         D 00000000ffffffff     0    42      2
0x00000000
[54387.706315]  ffff8801270fdb00 0000000000000046 dead000000200200
0000000000015740
[54387.706321]  ffff8801270fdfd8 0000000000015740 ffff8801270fdfd8
ffff8801270f5c00
[54387.706327]  0000000000015740 0000000000015740 ffff8801270fdfd8
0000000000015740
[54387.706333] Call Trace:
[54387.706344]  [<ffffffff8107b7f0>] ? prepare_to_wait+0x60/0x90
[54387.706360]  [<ffffffffa123f885>] dvb_unregister_frontend+0xc5/0x110
[dvb_core]
[54387.706366]  [<ffffffff8107b540>] ? autoremove_wake_function+0x0/0x40
[54387.706373]  [<ffffffff8129b6c7>] ? idr_remove+0x187/0x1f0
[54387.706380]  [<ffffffffa10be072>]
dvb_usb_adapter_frontend_exit+0x22/0x40 [dvb_usb]
[54387.706386]  [<ffffffffa10bd4b3>] dvb_usb_exit+0x53/0xd0 [dvb_usb]
[54387.706393]  [<ffffffffa10bd579>] dvb_usb_device_exit+0x49/0x60 [dvb_usb]
[54387.706399]  [<ffffffffa1253051>] af9015_usb_device_exit+0x41/0x60
[dvb_usb_af9015]
[54387.706408]  [<ffffffff813c8721>] usb_unbind_interface+0x61/0x190
[54387.706417]  [<ffffffff8135512f>] __device_release_driver+0x6f/0xe0
[54387.706422]  [<ffffffff8135529d>] device_release_driver+0x2d/0x40
[54387.706428]  [<ffffffff813542ba>] bus_remove_device+0x9a/0xc0
[54387.706433]  [<ffffffff813523c7>] device_del+0x127/0x1d0
[54387.706438]  [<ffffffff813c4d18>] usb_disable_device+0xa8/0x130
[54387.706443]  [<ffffffff813be893>] usb_disconnect+0xd3/0x170
[54387.706448]  [<ffffffff813bf8ee>] hub_thread+0x50e/0x1260
[54387.706454]  [<ffffffff8107b540>] ? autoremove_wake_function+0x0/0x40
[54387.706459]  [<ffffffff813bf3e0>] ? hub_thread+0x0/0x1260
[54387.706464]  [<ffffffff8107b006>] kthread+0x96/0xa0
[54387.706470]  [<ffffffff8100ae64>] kernel_thread_helper+0x4/0x10
[54387.706475]  [<ffffffff8107af70>] ? kthread+0x0/0xa0
[54387.706480]  [<ffffffff8100ae60>] ? kernel_thread_helper+0x0/0x10
[54507.498084] INFO: task khubd:42 blocked for more than 120 seconds.
[54507.498089] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[54507.498094] khubd         D 00000000ffffffff     0    42      2
0x00000000
[54507.498100]  ffff8801270fdb00 0000000000000046 dead000000200200
0000000000015740
[54507.498107]  ffff8801270fdfd8 0000000000015740 ffff8801270fdfd8
ffff8801270f5c00
[54507.498113]  0000000000015740 0000000000015740 ffff8801270fdfd8
0000000000015740
and so on.
The same trace is repeated sevral time in the dmesg.

I'm using a 2.6.34 unpatched on a SPM x86_64 box.
It looks like I cannot reproduce the bug if I close VLC before I unplug
the device.
However, the bug is annoying because the usb is fully screwed up.
The only way to get usb back on business is to reboot.


Xavier
