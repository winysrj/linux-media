Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47483 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbaJBQJx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Oct 2014 12:09:53 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [RFC PATCH] media: uvc: *HACK* workaround uvc unregister device *HACK*
Date: Thu,  2 Oct 2014 18:09:47 +0200
Message-Id: <1412266187-28969-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the uvc_driver is not cleaning up its child devices if a
device is still in use. It leads to orphaned devices which are not
sitting on any interface. They get cleaned up on uvc_delete which will
be called on uvc_remove after the userspace application is closing the
stream. When PM_RUNTIME is used in the kernel, this leads to the
following backtrace for missing sysfs entries in the orphaned kobjects.

This patch is moving the device cleanup code for the child devices from
uvc_delete to uvc_unregister_video. It is an *HACK* workaround which
is ment to initiate the discussion for a proper solution.

This behaviour can simply be reproduced by the following command:

$ gst-launch v4l2src device=/dev/video0 ! fakesink

-> Now disconnect the UVC Camera while the stream is still open and used

$ <Ctrl-C> # to close the running gstreamer pipeline

[  258.012048] ------------[ cut here ]------------
[  258.021206] WARNING: CPU: 0 PID: 280 at fs/sysfs/group.c:220 sysfs_remove_group+0xb4/0xb8()
[  258.031728] sysfs group 80c79200 not found for kobject 'event0'
[  258.039383] Modules linked in: lock(O) usb_f_ecm g_ether usb_f_rndis u_ether libcomposite coda ath6kl_sdio ath6kl_core
[  258.051098] CPU: 0 PID: 280 Comm: v4l2filter0:src Tainted: G           O   3.17.0-rc6-20140925-1+ #10
[  258.063318] Backtrace:
[  258.066403] [<80012ca4>] (dump_backtrace) from [<80012f94>] (show_stack+0x18/0x1c)
[  258.077579]  r6:000000dc r5:00000009 r4:d81f7ba8 r3:00000000
[  258.084549] [<80012f7c>] (show_stack) from [<807872e4>] (dump_stack+0x24/0x28)
[  258.091791] [<807872c0>] (dump_stack) from [<80025140>] (warn_slowpath_common+0x78/0x90)
[  258.100770] [<800250c8>] (warn_slowpath_common) from [<80025190>] (warn_slowpath_fmt+0x38/0x40)
[  258.109818]  r8:00000000 r7:da00a218 r6:da0520f0 r5:00000000 r4:80c79200
[  258.116675] [<8002515c>] (warn_slowpath_fmt) from [<8015bb4c>] (sysfs_remove_group+0xb4/0xb8)
[  258.125824]  r3:80c79200 r2:8098e22c
[  258.129463] [<8015ba98>] (sysfs_remove_group) from [<803ec5a4>] (dpm_sysfs_remove+0x54/0x58)
[  258.138500]  r6:da0520e8 r5:da0520f0 r4:80c79200
[  258.143195] [<803ec550>] (dpm_sysfs_remove) from [<803e3664>] (device_del+0x4c/0x1b0)
[  258.151790]  r6:da052004 r5:da0520e8 r4:da052000 r3:da306200
[  258.157813] [<803e3618>] (device_del) from [<804eb7a8>] (evdev_disconnect+0x20/0x48)
[  258.166190]  r7:da00a1b4 r6:da052004 r5:da0520e8 r4:da052000
[  258.172637] [<804eb788>] (evdev_disconnect) from [<804e694c>] (__input_unregister_device+0xb0/0x150)
[  258.182282]  r6:da00a000 r5:da00a448 r4:da00a434 r3:804eb788
[  258.188064] [<804e689c>] (__input_unregister_device) from [<804e7b50>] (input_unregister_device+0x50/0x78)
[  258.198271]  r7:da051c00 r6:da009000 r5:81506254 r4:da00a000
[  258.204013] [<804e7b00>] (input_unregister_device) from [<8052eba8>] (uvc_status_cleanup+0x38/0x3c)
[  258.213557]  r4:da009000 r3:00000000
[  258.217221] [<8052eb70>] (uvc_status_cleanup) from [<80524e64>] (uvc_delete+0x28/0x140)
[  258.225704]  r4:da051c58 r3:00000000
[  258.229322] [<80524e3c>] (uvc_delete) from [<80525098>] (uvc_release+0x40/0x44)
[  258.237136]  r8:00000000 r7:da051c00 r6:da009428 r5:81506254 r4:da051c58 r3:da00951c
[  258.245495] [<80525058>] (uvc_release) from [<80500a0c>] (v4l2_device_release+0xd0/0xf4)
[  258.253608] [<8050093c>] (v4l2_device_release) from [<803e30f4>] (device_release+0x34/0x98)
[  258.262529]  r8:da054070 r7:da026a40 r6:da021c00 r5:da051c58 r4:da051c60 r3:8050093c
[  258.270519] [<803e30c0>] (device_release) from [<80323fd4>] (kobject_cleanup+0x98/0x1b8)
[  258.279105]  r6:80c78848 r5:da051c60 r4:80cb61e8 r3:803e30c0
[  258.284887] [<80323f3c>] (kobject_cleanup) from [<80323e6c>] (kobject_put+0x50/0x7c)
[  258.292634]  r7:da054070 r6:da562258 r5:00000000 r4:da051c60
[  258.298839] [<80323e1c>] (kobject_put) from [<803e350c>] (put_device+0x1c/0x20)
[  258.306654]  r4:da051c00
[  258.309221] [<803e34f0>] (put_device) from [<804ff73c>] (v4l2_release+0x58/0x7c)
[  258.317133] [<804ff6e4>] (v4l2_release) from [<800f1444>] (__fput+0x9c/0x220)
[  258.324554]  r5:da15e190 r4:da3c8dc0
[  258.328171] [<800f13a8>] (__fput) from [<800f1624>] (____fput+0x10/0x14)
[  258.335344]  r10:da306200 r9:da30c620 r8:00418004 r7:da306200 r6:80cc2180 r5:da3ee280
[  258.343252]  r4:da306564
[  258.346086] [<800f1614>] (____fput) from [<8003d198>] (task_work_run+0xa0/0xe4)
[  258.353407] [<8003d0f8>] (task_work_run) from [<80025cb8>] (do_exit+0x280/0x8d0)
[  258.361489]  r7:da30c624 r6:da3c229c r5:da306574 r4:da3c2240
[  258.367266] [<80025a38>] (do_exit) from [<8002722c>] (do_group_exit+0x44/0xb8)
[  258.375011]  r7:da30c624
[  258.377584] [<800271e8>] (do_group_exit) from [<80031510>] (get_signal+0x254/0x6c8)
[  258.385736]  r7:da30c624 r6:d81f7ed4 r5:00000009 r4:d81f6000
[  258.391476] [<800312bc>] (get_signal) from [<80012190>] (do_signal+0x6c/0x3f4)
[  258.399230]  r10:00000000 r9:d81f6000 r8:fffffe00 r7:d81f7ec0 r6:76ca6de6 r5:76ca6de4
[  258.407190]  r4:d81f7fb0
[  258.409751] [<80012124>] (do_signal) from [<800126c4>] (do_work_pending+0xa8/0xe8)
[  258.418003]  r10:00000000 r9:d81f6000 r8:8000f3a4 r7:d81f7fb0 r6:8000f3a4 r5:d81f6000
[  258.425959]  r4:d81f6008
[  258.428519] [<8001261c>] (do_work_pending) from [<8000f238>] (work_pending+0xc/0x20)
[  258.436967]  r7:00000036 r6:756065a8 r5:0193d3f8 r4:76b77b24
[  258.442692] ---[ end trace cd2cc911d2f600ac ]---
[  258.481579] ------------[ cut here ]------------
[  258.487313] WARNING: CPU: 0 PID: 280 at fs/sysfs/group.c:220 sysfs_remove_group+0xb4/0xb8()
[  258.496077] sysfs group 80c79200 not found for kobject 'input0'
[  258.502005] Modules linked in: lock(O) usb_f_ecm g_ether usb_f_rndis u_ether libcomposite coda ath6kl_sdio ath6kl_core
[  258.513158] CPU: 0 PID: 280 Comm: v4l2filter0:src Tainted: G        W  O   3.17.0-rc6-20140925-1+ #10
[  258.523587] Backtrace:
[  258.526208] [<80012ca4>] (dump_backtrace) from [<80012f94>] (show_stack+0x18/0x1c)
[  258.533914]  r6:000000dc r5:00000009 r4:d81f7bc8 r3:00000000
[  258.540589] [<80012f7c>] (show_stack) from [<807872e4>] (dump_stack+0x24/0x28)
[  258.548471] [<807872c0>] (dump_stack) from [<80025140>] (warn_slowpath_common+0x78/0x90)
[  258.557029] [<800250c8>] (warn_slowpath_common) from [<80025190>] (warn_slowpath_fmt+0x38/0x40)
[  258.566077]  r8:00000000 r7:da051020 r6:da00a220 r5:00000000 r4:80c79200
[  258.572879] [<8002515c>] (warn_slowpath_fmt) from [<8015bb4c>] (sysfs_remove_group+0xb4/0xb8)
[  258.581992]  r3:80c79200 r2:8098e22c
[  258.585681] [<8015ba98>] (sysfs_remove_group) from [<803ec5a4>] (dpm_sysfs_remove+0x54/0x58)
[  258.594810]  r6:da00a218 r5:da00a220 r4:80c79200
[  258.599506] [<803ec550>] (dpm_sysfs_remove) from [<803e3664>] (device_del+0x4c/0x1b0)
[  258.607982]  r6:da00a000 r5:da00a218 r4:00000008 r3:da306200
[  258.613738] [<803e3618>] (device_del) from [<804e69d0>] (__input_unregister_device+0x134/0x150)
[  258.623046]  r7:da00a1b4 r6:da00a000 r5:00000007 r4:00000008
[  258.629199] [<804e689c>] (__input_unregister_device) from [<804e7b50>] (input_unregister_device+0x50/0x78)
[  258.639498]  r7:da051c00 r6:da009000 r5:81506254 r4:da00a000
[  258.646041] [<804e7b00>] (input_unregister_device) from [<8052eba8>] (uvc_status_cleanup+0x38/0x3c)
[  258.655588]  r4:da009000 r3:00000000
[  258.659207] [<8052eb70>] (uvc_status_cleanup) from [<80524e64>] (uvc_delete+0x28/0x140)
[  258.667690]  r4:da051c58 r3:00000000
[  258.671308] [<80524e3c>] (uvc_delete) from [<80525098>] (uvc_release+0x40/0x44)
[  258.679116]  r8:00000000 r7:da051c00 r6:da009428 r5:81506254 r4:da051c58 r3:da00951c
[  258.687002] [<80525058>] (uvc_release) from [<80500a0c>] (v4l2_device_release+0xd0/0xf4)
[  258.695592] [<8050093c>] (v4l2_device_release) from [<803e30f4>] (device_release+0x34/0x98)
[  258.703953]  r8:da054070 r7:da026a40 r6:da021c00 r5:da051c58 r4:da051c60 r3:8050093c
[  258.712128] [<803e30c0>] (device_release) from [<80323fd4>] (kobject_cleanup+0x98/0x1b8)
[  258.720734]  r6:80c78848 r5:da051c60 r4:80cb61e8 r3:803e30c0
[  258.726516] [<80323f3c>] (kobject_cleanup) from [<80323e6c>] (kobject_put+0x50/0x7c)
[  258.734731]  r7:da054070 r6:da562258 r5:00000000 r4:da051c60
[  258.740463] [<80323e1c>] (kobject_put) from [<803e350c>] (put_device+0x1c/0x20)
[  258.748243]  r4:da051c00
[  258.750807] [<803e34f0>] (put_device) from [<804ff73c>] (v4l2_release+0x58/0x7c)
[  258.758684] [<804ff6e4>] (v4l2_release) from [<800f1444>] (__fput+0x9c/0x220)
[  258.766125]  r5:da15e190 r4:da3c8dc0
[  258.769743] [<800f13a8>] (__fput) from [<800f1624>] (____fput+0x10/0x14)
[  258.776915]  r10:da306200 r9:da30c620 r8:00418004 r7:da306200 r6:80cc2180 r5:da3ee280
[  258.785114]  r4:da306564
[  258.787687] [<800f1614>] (____fput) from [<8003d198>] (task_work_run+0xa0/0xe4)
[  258.795532] [<8003d0f8>] (task_work_run) from [<80025cb8>] (do_exit+0x280/0x8d0)
[  258.802936]  r7:da30c624 r6:da3c229c r5:da306574 r4:da3c2240
[  258.808947] [<80025a38>] (do_exit) from [<8002722c>] (do_group_exit+0x44/0xb8)
[  258.816648]  r7:da30c624
[  258.819219] [<800271e8>] (do_group_exit) from [<80031510>] (get_signal+0x254/0x6c8)
[  258.827360]  r7:da30c624 r6:d81f7ed4 r5:00000009 r4:d81f6000
[  258.833098] [<800312bc>] (get_signal) from [<80012190>] (do_signal+0x6c/0x3f4)
[  258.840828]  r10:00000000 r9:d81f6000 r8:fffffe00 r7:d81f7ec0 r6:76ca6de6 r5:76ca6de4
[  258.848786]  r4:d81f7fb0
[  258.851346] [<80012124>] (do_signal) from [<800126c4>] (do_work_pending+0xa8/0xe8)
[  258.859609]  r10:00000000 r9:d81f6000 r8:8000f3a4 r7:d81f7fb0 r6:8000f3a4 r5:d81f6000
[  258.867567]  r4:d81f6008
[  258.870126] [<8001261c>] (do_work_pending) from [<8000f238>] (work_pending+0xc/0x20)
[  258.878543]  r7:00000036 r6:756065a8 r5:0193d3f8 r4:76b77b24
[  258.884530] ---[ end trace cd2cc911d2f600ad ]---
[  258.892863] ------------[ cut here ]------------
[  258.898189] WARNING: CPU: 0 PID: 280 at fs/sysfs/group.c:220 sysfs_remove_group+0xb4/0xb8()
[  258.906811] sysfs group 80c8a764 not found for kobject 'input0'
[  258.912736] Modules linked in: lock(O) usb_f_ecm g_ether usb_f_rndis u_ether libcomposite coda ath6kl_sdio ath6kl_core
[  258.923850] CPU: 0 PID: 280 Comm: v4l2filter0:src Tainted: G        W  O   3.17.0-rc6-20140925-1+ #10
[  258.933569] Backtrace:
[  258.936097] [<80012ca4>] (dump_backtrace) from [<80012f94>] (show_stack+0x18/0x1c)
[  258.943671]  r6:000000dc r5:00000009 r4:d81f7bb0 r3:00000000
[  258.949877] [<80012f7c>] (show_stack) from [<807872e4>] (dump_stack+0x24/0x28)
[  258.957588] [<807872c0>] (dump_stack) from [<80025140>] (warn_slowpath_common+0x78/0x90)
[  258.965957] [<800250c8>] (warn_slowpath_common) from [<80025190>] (warn_slowpath_fmt+0x38/0x40)
[  258.974918]  r8:00000000 r7:80c8a578 r6:da00a220 r5:00000000 r4:80c8a764
[  258.981703] [<8002515c>] (warn_slowpath_fmt) from [<8015bb4c>] (sysfs_remove_group+0xb4/0xb8)
[  258.990724]  r3:80c8a764 r2:8098e22c
[  258.994444] [<8015ba98>] (sysfs_remove_group) from [<8015bc04>] (sysfs_remove_groups+0x2c/0x3c)
[  259.003147]  r6:80c8a590 r5:da00a220 r4:80c8a624
[  259.008319] [<8015bbd8>] (sysfs_remove_groups) from [<803e303c>] (device_remove_attrs+0x58/0x74)
[  259.017585]  r5:da00a220 r4:da00a218
[  259.021207] [<803e2fe4>] (device_remove_attrs) from [<803e372c>] (device_del+0x114/0x1b0)
[  259.029860]  r7:da051020 r6:da00a220 r5:da00a218 r4:dad9be5c
[  259.035642] [<803e3618>] (device_del) from [<804e69d0>] (__input_unregister_device+0x134/0x150)
[  259.044806]  r7:da00a1b4 r6:da00a000 r5:00000007 r4:00000008
[  259.050541] [<804e689c>] (__input_unregister_device) from [<804e7b50>] (input_unregister_device+0x50/0x78)
[  259.060693]  r7:da051c00 r6:da009000 r5:81506254 r4:da00a000
[  259.066505] [<804e7b00>] (input_unregister_device) from [<8052eba8>] (uvc_status_cleanup+0x38/0x3c)
[  259.076023]  r4:da009000 r3:00000000
[  259.079642] [<8052eb70>] (uvc_status_cleanup) from [<80524e64>] (uvc_delete+0x28/0x140)
[  259.088106]  r4:da051c58 r3:00000000
[  259.091722] [<80524e3c>] (uvc_delete) from [<80525098>] (uvc_release+0x40/0x44)
[  259.099491]  r8:00000000 r7:da051c00 r6:da009428 r5:81506254 r4:da051c58 r3:da00951c
[  259.107368] [<80525058>] (uvc_release) from [<80500a0c>] (v4l2_device_release+0xd0/0xf4)
[  259.115928] [<8050093c>] (v4l2_device_release) from [<803e30f4>] (device_release+0x34/0x98)
[  259.124546]  r8:da054070 r7:da026a40 r6:da021c00 r5:da051c58 r4:da051c60 r3:8050093c
[  259.132381] [<803e30c0>] (device_release) from [<80323fd4>] (kobject_cleanup+0x98/0x1b8)
[  259.140968]  r6:80c78848 r5:da051c60 r4:80cb61e8 r3:803e30c0
[  259.146747] [<80323f3c>] (kobject_cleanup) from [<80323e6c>] (kobject_put+0x50/0x7c)
[  259.154978]  r7:da054070 r6:da562258 r5:00000000 r4:da051c60
[  259.160711] [<80323e1c>] (kobject_put) from [<803e350c>] (put_device+0x1c/0x20)
[  259.168496]  r4:da051c00
[  259.171060] [<803e34f0>] (put_device) from [<804ff73c>] (v4l2_release+0x58/0x7c)
[  259.178935] [<804ff6e4>] (v4l2_release) from [<800f1444>] (__fput+0x9c/0x220)
[  259.186343]  r5:da15e190 r4:da3c8dc0
[  259.189959] [<800f13a8>] (__fput) from [<800f1624>] (____fput+0x10/0x14)
[  259.197161]  r10:da306200 r9:da30c620 r8:00418004 r7:da306200 r6:80cc2180 r5:da3ee280
[  259.205361]  r4:da306564
[  259.207932] [<800f1614>] (____fput) from [<8003d198>] (task_work_run+0xa0/0xe4)
[  259.215734] [<8003d0f8>] (task_work_run) from [<80025cb8>] (do_exit+0x280/0x8d0)
[  259.223137]  r7:da30c624 r6:da3c229c r5:da306574 r4:da3c2240
[  259.229130] [<80025a38>] (do_exit) from [<8002722c>] (do_group_exit+0x44/0xb8)
[  259.236844]  r7:da30c624
[  259.239410] [<800271e8>] (do_group_exit) from [<80031510>] (get_signal+0x254/0x6c8)
[  259.247760]  r7:da30c624 r6:d81f7ed4 r5:00000009 r4:d81f6000
[  259.253505] [<800312bc>] (get_signal) from [<80012190>] (do_signal+0x6c/0x3f4)
[  259.261226]  r10:00000000 r9:d81f6000 r8:fffffe00 r7:d81f7ec0 r6:76ca6de6 r5:76ca6de4
[  259.269215]  r4:d81f7fb0
[  259.271773] [<80012124>] (do_signal) from [<800126c4>] (do_work_pending+0xa8/0xe8)
[  259.280054]  r10:00000000 r9:d81f6000 r8:8000f3a4 r7:d81f7fb0 r6:8000f3a4 r5:d81f6000
[  259.288010]  r4:d81f6008
[  259.290568] [<8001261c>] (do_work_pending) from [<8000f238>] (work_pending+0xc/0x20)
[  259.298977]  r7:00000036 r6:756065a8 r5:0193d3f8 r4:76b77b24
[  259.304748] ---[ end trace cd2cc911d2f600ae ]---
[  259.313908] ------------[ cut here ]------------
[  259.319437] WARNING: CPU: 0 PID: 280 at fs/sysfs/group.c:220 sysfs_remove_group+0xb4/0xb8()
[  259.328075] sysfs group 80c8a630 not found for kobject 'input0'
[  259.334001] Modules linked in: lock(O) usb_f_ecm g_ether usb_f_rndis u_ether libcomposite coda ath6kl_sdio ath6kl_core
[  259.345180] CPU: 0 PID: 280 Comm: v4l2filter0:src Tainted: G        W  O   3.17.0-rc6-20140925-1+ #10
[  259.354876] Backtrace:
[  259.357359] [<80012ca4>] (dump_backtrace) from [<80012f94>] (show_stack+0x18/0x1c)
[  259.365406]  r6:000000dc r5:00000009 r4:d81f7bb0 r3:00000000
[  259.371147] [<80012f7c>] (show_stack) from [<807872e4>] (dump_stack+0x24/0x28)
[  259.378856] [<807872c0>] (dump_stack) from [<80025140>] (warn_slowpath_common+0x78/0x90)
[  259.387252] [<800250c8>] (warn_slowpath_common) from [<80025190>] (warn_slowpath_fmt+0x38/0x40)
[  259.396262]  r8:00000000 r7:80c8a578 r6:da00a220 r5:00000000 r4:80c8a630
[  259.403049] [<8002515c>] (warn_slowpath_fmt) from [<8015bb4c>] (sysfs_remove_group+0xb4/0xb8)
[  259.412058]  r3:80c8a630 r2:8098e22c
[  259.415748] [<8015ba98>] (sysfs_remove_group) from [<8015bc04>] (sysfs_remove_groups+0x2c/0x3c)
[  259.424924]  r6:80c8a590 r5:da00a220 r4:80c8a628
[  259.429604] [<8015bbd8>] (sysfs_remove_groups) from [<803e303c>] (device_remove_attrs+0x58/0x74)
[  259.438873]  r5:da00a220 r4:da00a218
[  259.442494] [<803e2fe4>] (device_remove_attrs) from [<803e372c>] (device_del+0x114/0x1b0)
[  259.451143]  r7:da051020 r6:da00a220 r5:da00a218 r4:dad9be5c
[  259.459353] [<803e3618>] (device_del) from [<804e69d0>] (__input_unregister_device+0x134/0x150)
[  259.468788]  r7:da00a1b4 r6:da00a000 r5:00000007 r4:00000008
[  259.474673] [<804e689c>] (__input_unregister_device) from [<804e7b50>] (input_unregister_device+0x50/0x78)
[  259.484912]  r7:da051c00 r6:da009000 r5:81506254 r4:da00a000
[  259.490656] [<804e7b00>] (input_unregister_device) from [<8052eba8>] (uvc_status_cleanup+0x38/0x3c)
[  259.500189]  r4:da009000 r3:00000000
[  259.503808] [<8052eb70>] (uvc_status_cleanup) from [<80524e64>] (uvc_delete+0x28/0x140)
[  259.512287]  r4:da051c58 r3:00000000
[  259.515948] [<80524e3c>] (uvc_delete) from [<80525098>] (uvc_release+0x40/0x44)
[  259.523260]  r8:00000000 r7:da051c00 r6:da009428 r5:81506254 r4:da051c58 r3:da00951c
[  259.531558] [<80525058>] (uvc_release) from [<80500a0c>] (v4l2_device_release+0xd0/0xf4)
[  259.540130] [<8050093c>] (v4l2_device_release) from [<803e30f4>] (device_release+0x34/0x98)
[  259.548753]  r8:da054070 r7:da026a40 r6:da021c00 r5:da051c58 r4:da051c60 r3:8050093c
[  259.556668] [<803e30c0>] (device_release) from [<80323fd4>] (kobject_cleanup+0x98/0x1b8)
[  259.565261]  r6:80c78848 r5:da051c60 r4:80cb61e8 r3:803e30c0
[  259.570995] [<80323f3c>] (kobject_cleanup) from [<80323e6c>] (kobject_put+0x50/0x7c)
[  259.579214]  r7:da054070 r6:da562258 r5:00000000 r4:da051c60
[  259.584993] [<80323e1c>] (kobject_put) from [<803e350c>] (put_device+0x1c/0x20)
[  259.592305]  r4:da051c00
[  259.595383] [<803e34f0>] (put_device) from [<804ff73c>] (v4l2_release+0x58/0x7c)
[  259.602793] [<804ff6e4>] (v4l2_release) from [<800f1444>] (__fput+0x9c/0x220)
[  259.610614]  r5:da15e190 r4:da3c8dc0
[  259.614503] [<800f13a8>] (__fput) from [<800f1624>] (____fput+0x10/0x14)
[  259.621212]  r10:da306200 r9:da30c620 r8:00418004 r7:da306200 r6:80cc2180 r5:da3ee280
[  259.629413]  r4:da306564
[  259.631980] [<800f1614>] (____fput) from [<8003d198>] (task_work_run+0xa0/0xe4)
[  259.639994] [<8003d0f8>] (task_work_run) from [<80025cb8>] (do_exit+0x280/0x8d0)
[  259.647692]  r7:da30c624 r6:da3c229c r5:da306574 r4:da3c2240
[  259.653422] [<80025a38>] (do_exit) from [<8002722c>] (do_group_exit+0x44/0xb8)
[  259.661117]  r7:da30c624
[  259.663688] [<800271e8>] (do_group_exit) from [<80031510>] (get_signal+0x254/0x6c8)
[  259.671819]  r7:da30c624 r6:d81f7ed4 r5:00000009 r4:d81f6000
[  259.677600] [<800312bc>] (get_signal) from [<80012190>] (do_signal+0x6c/0x3f4)
[  259.685289]  r10:00000000 r9:d81f6000 r8:fffffe00 r7:d81f7ec0 r6:76ca6de6 r5:76ca6de4
[  259.693197]  r4:d81f7fb0
[  259.696049] [<80012124>] (do_signal) from [<800126c4>] (do_work_pending+0xa8/0xe8)
[  259.703623]  r10:00000000 r9:d81f6000 r8:8000f3a4 r7:d81f7fb0 r6:8000f3a4 r5:d81f6000
[  259.712000]  r4:d81f6008
[  259.714816] [<8001261c>] (do_work_pending) from [<8000f238>] (work_pending+0xc/0x20)
[  259.722563]  r7:00000036 r6:756065a8 r5:0193d3f8 r4:76b77b24
[  259.728745] ---[ end trace cd2cc911d2f600af ]---
[  259.735876] deleting dev: da0090a8
[  259.739317] in sysfs_remove_group: power
[  259.743245] ------------[ cut here ]------------
[  259.748707] WARNING: CPU: 0 PID: 280 at fs/sysfs/group.c:220 sysfs_remove_group+0xb4/0xb8()
[  259.757392] sysfs group 80c79200 not found for kobject 'media1'
[  259.763319] Modules linked in: lock(O) usb_f_ecm g_ether usb_f_rndis u_ether libcomposite coda ath6kl_sdio ath6kl_core
[  259.774565] CPU: 0 PID: 280 Comm: v4l2filter0:src Tainted: G        W  O   3.17.0-rc6-20140925-1+ #10
[  259.783788] Backtrace:
[  259.786771] [<80012ca4>] (dump_backtrace) from [<80012f94>] (show_stack+0x18/0x1c)
[  259.794880]  r6:000000dc r5:00000009 r4:d81f7bc8 r3:00000000
[  259.800622] [<80012f7c>] (show_stack) from [<807872e4>] (dump_stack+0x24/0x28)
[  259.808395] [<807872c0>] (dump_stack) from [<80025140>] (warn_slowpath_common+0x78/0x90)
[  259.816778] [<800250c8>] (warn_slowpath_common) from [<80025190>] (warn_slowpath_fmt+0x38/0x40)
[  259.825750]  r8:00000000 r7:da051020 r6:da0090b0 r5:00000000 r4:80c79200
[  259.832537] [<8002515c>] (warn_slowpath_fmt) from [<8015bb4c>] (sysfs_remove_group+0xb4/0xb8)
[  259.841570]  r3:80c79200 r2:8098e22c
[  259.845245] [<8015ba98>] (sysfs_remove_group) from [<803ec5a4>] (dpm_sysfs_remove+0x54/0x58)
[  259.853687]  r6:da0090a8 r5:da0090b0 r4:80c79200
[  259.858846] [<803ec550>] (dpm_sysfs_remove) from [<803e3664>] (device_del+0x4c/0x1b0)
[  259.867159]  r6:da009098 r5:da0090a8 r4:da0090a8 r3:da306200
[  259.872893] [<803e3618>] (device_del) from [<803e37f4>] (device_unregister+0x2c/0x6c)
[  259.881206]  r7:da051c00 r6:da009098 r5:da00939c r4:da0090a8
[  259.886987] [<803e37c8>] (device_unregister) from [<804fe768>] (media_devnode_unregister+0x58/0x5c)
[  259.896543]  r4:da0090a0 r3:600f0013
[  259.900164] [<804fe710>] (media_devnode_unregister) from [<804fe330>] (media_device_unregister+0x50/0x54)
[  259.910260]  r4:da00939c r3:00000001
[  259.913881] [<804fe2e0>] (media_device_unregister) from [<80524f74>] (uvc_delete+0x138/0x140)
[  259.922900]  r6:da009000 r5:81506254 r4:da051c58 r3:00000001
[  259.928674] [<80524e3c>] (uvc_delete) from [<80525098>] (uvc_release+0x40/0x44)
[  259.936451]  r8:00000000 r7:da051c00 r6:da009428 r5:81506254 r4:da051c58 r3:da00951c
[  259.944539] [<80525058>] (uvc_release) from [<80500a0c>] (v4l2_device_release+0xd0/0xf4)
[  259.952645] [<8050093c>] (v4l2_device_release) from [<803e30f4>] (device_release+0x34/0x98)
[  259.961478]  r8:da054070 r7:da026a40 r6:da021c00 r5:da051c58 r4:da051c60 r3:8050093c
[  259.969371] [<803e30c0>] (device_release) from [<80323fd4>] (kobject_cleanup+0x98/0x1b8)
[  259.977967]  r6:80c78848 r5:da051c60 r4:80cb61e8 r3:803e30c0
[  259.983702] [<80323f3c>] (kobject_cleanup) from [<80323e6c>] (kobject_put+0x50/0x7c)
[  259.991921]  r7:da054070 r6:da562258 r5:00000000 r4:da051c60
[  259.997738] [<80323e1c>] (kobject_put) from [<803e350c>] (put_device+0x1c/0x20)
[  260.005531]  r4:da051c00
[  260.008096] [<803e34f0>] (put_device) from [<804ff73c>] (v4l2_release+0x58/0x7c)
[  260.015976] [<804ff6e4>] (v4l2_release) from [<800f1444>] (__fput+0x9c/0x220)
[  260.023119]  r5:da15e190 r4:da3c8dc0
[  260.027004] [<800f13a8>] (__fput) from [<800f1624>] (____fput+0x10/0x14)
[  260.033709]  r10:da306200 r9:da30c620 r8:00418004 r7:da306200 r6:80cc2180 r5:da3ee280
[  260.042078]  r4:da306564
[  260.044936] [<800f1614>] (____fput) from [<8003d198>] (task_work_run+0xa0/0xe4)
[  260.052257] [<8003d0f8>] (task_work_run) from [<80025cb8>] (do_exit+0x280/0x8d0)
[  260.060365]  r7:da30c624 r6:da3c229c r5:da306574 r4:da3c2240
[  260.066144] [<80025a38>] (do_exit) from [<8002722c>] (do_group_exit+0x44/0xb8)
[  260.073369]  r7:da30c624
[  260.076398] [<800271e8>] (do_group_exit) from [<80031510>] (get_signal+0x254/0x6c8)
[  260.084059]  r7:da30c624 r6:d81f7ed4 r5:00000009 r4:d81f6000
[  260.090262] [<800312bc>] (get_signal) from [<80012190>] (do_signal+0x6c/0x3f4)
[  260.097955]  r10:00000000 r9:d81f6000 r8:fffffe00 r7:d81f7ec0 r6:76ca6de6 r5:76ca6de4
[  260.105910]  r4:d81f7fb0
[  260.108469] [<80012124>] (do_signal) from [<800126c4>] (do_work_pending+0xa8/0xe8)
[  260.116728]  r10:00000000 r9:d81f6000 r8:8000f3a4 r7:d81f7fb0 r6:8000f3a4 r5:d81f6000
[  260.124899]  r4:d81f6008
[  260.127463] [<8001261c>] (do_work_pending) from [<8000f238>] (work_pending+0xc/0x20)
[  260.135694]  r7:00000036 r6:756065a8 r5:0193d3f8 r4:76b77b24
[  260.141419] ---[ end trace cd2cc911d2f600b0 ]---
---
 drivers/media/usb/uvc/uvc_driver.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index f8135f4..b58e46a 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1626,15 +1626,10 @@ static void uvc_delete(struct uvc_device *dev)
 	usb_put_intf(dev->intf);
 	usb_put_dev(dev->udev);
 
-	uvc_status_cleanup(dev);
 	uvc_ctrl_cleanup_device(dev);
 
 	if (dev->vdev.dev)
 		v4l2_device_unregister(&dev->vdev);
-#ifdef CONFIG_MEDIA_CONTROLLER
-	if (media_devnode_is_registered(&dev->mdev.devnode))
-		media_device_unregister(&dev->mdev);
-#endif
 
 	list_for_each_safe(p, n, &dev->chains) {
 		struct uvc_video_chain *chain;
@@ -1705,6 +1700,11 @@ static void uvc_unregister_video(struct uvc_device *dev)
 		uvc_debugfs_cleanup_stream(stream);
 	}
 
+	uvc_status_cleanup(dev);
+#ifdef CONFIG_MEDIA_CONTROLLER
+	if (media_devnode_is_registered(&dev->mdev.devnode))
+		media_device_unregister(&dev->mdev);
+#endif
 	/* Decrement the stream count and call uvc_delete explicitly if there
 	 * are no stream left.
 	 */
-- 
2.1.0

