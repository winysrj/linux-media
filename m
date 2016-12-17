Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo27.poczta.onet.pl ([213.180.142.158]:35365 "EHLO
        smtpo27.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751962AbcLQRXB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Dec 2016 12:23:01 -0500
From: Piotr Chmura <chmooreck@poczta.onet.pl>
Subject: PROBLEM: siano "transfer buffer not dma capable" when trying to
 capture video in 4.9.0
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        LMML <linux-media@vger.kernel.org>
Message-ID: <518f6abd-5f95-ae99-de4c-028faa70c72c@poczta.onet.pl>
Date: Sat, 17 Dec 2016 18:13:08 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

siano "transfer buffer not dma capable" when trying to capture video

On kernel 4.9.0 when trying to watch TV (in Kaffeine 1.0.5, libVLC) i 
get Oops instead of audio/video stream.
Kernel 4.8.X series works fine (currently using 4.8.13).

[   60.268359] ------------[ cut here ]------------
[   60.268366] WARNING: CPU: 1 PID: 3558 at drivers/usb/core/hcd.c:1584 
usb_hcd_map_urb_for_dma+0x249/0x2f9
[   60.268366] transfer buffer not dma capable
[   60.268367] Modules linked in: nfsv3 nfs_acl auth_rpcgss oid_registry 
nfsv4 dns_resolver nfs lockd grace fscache sunrpc snd_usb_audio 
snd_usbmidi_lib snd_rawmidi gspca_zc3xx gspca_main v4l2_common videodev 
cdc_acm joydev btusb btrtl btbcm btintel bluetooth smsdvb dvb_core 
smsusb smsmdtv media usb_storage nvidia_modeset(PO) nvidia(PO) 
x86_pkg_temp_thermal drm xhci_pci xhci_hcd ehci_pci ehci_hcd 8250 
8250_base serial_core
[   60.268389] CPU: 1 PID: 3558 Comm: kdvb-ad-1-fe-0 Tainted: 
P           O    4.9.0 #1
[   60.268390] Hardware name: Gigabyte Technology Co., Ltd. To be filled 
by O.E.M./Z77N-WIFI, BIOS F4a 07/29/2013
[   60.268391]  0000000000000000 ffffffff811e7617 ffffc90008a83830 
0000000000000000
[   60.268393]  ffffffff8103a5a7 ffff8803dca48780 ffffc90008a83888 
0000000000000001
[   60.268395]  0000000000000000 ffff88040bed4780 ffffc90008a83a58 
ffffffff8103a606
[   60.268397] Call Trace:
[   60.268401]  [<ffffffff811e7617>] ? dump_stack+0x46/0x59
[   60.268404]  [<ffffffff8103a5a7>] ? __warn+0xc8/0xe1
[   60.268406]  [<ffffffff8103a606>] ? warn_slowpath_fmt+0x46/0x4e
[   60.268408]  [<ffffffff812e80d1>] ? usb_hcd_map_urb_for_dma+0x249/0x2f9
[   60.268409]  [<ffffffff812e8fbe>] ? usb_hcd_submit_urb+0x627/0x6f0
[   60.268412]  [<ffffffff812ea994>] ? usb_start_wait_urb+0x54/0xc5
[   60.268415]  [<ffffffffa001129a>] ? smsusb_sendrequest+0x4c/0x58 [smsusb]
[   60.268417]  [<ffffffffa005b136>] ? 
smsdvb_sendrequest_and_wait.isra.4+0x9/0x29 [smsdvb]
[   60.268419]  [<ffffffffa005b624>] ? smsdvb_set_frontend+0x2b9/0x2c9 
[smsdvb]
[   60.268422]  [<ffffffffa0c1745a>] ? 
dvb_frontend_swzigzag_autotune+0x160/0x1b2 [dvb_core]
[   60.268426]  [<ffffffffa0c1846d>] ? dvb_frontend_swzigzag+0x1ef/0x25a 
[dvb_core]
[   60.268428]  [<ffffffff81059934>] ? update_load_avg+0x25a/0x293
[   60.268429]  [<ffffffff81059934>] ? update_load_avg+0x25a/0x293
[   60.268431]  [<ffffffff81058e21>] ? 
get_sd_balance_interval.isra.55+0x13/0x2e
[   60.268433]  [<ffffffff81058e51>] ? update_next_balance+0x15/0x26
[   60.268435]  [<ffffffff8105844f>] ? vtime_account_idle+0x5/0xd
[   60.268437]  [<ffffffff810584ad>] ? vtime_common_task_switch+0x12/0x1f
[   60.268438]  [<ffffffff81052829>] ? finish_task_switch+0x130/0x19e
[   60.268440]  [<ffffffff81072df5>] ? lock_timer_base+0x33/0x57
[   60.268442]  [<ffffffff81072ea2>] ? try_to_del_timer_sync+0x3f/0x49
[   60.268443]  [<ffffffff81072f8c>] ? del_timer_sync+0x20/0x3d
[   60.268446]  [<ffffffff81452f17>] ? schedule_timeout+0xad/0xd0
[   60.268447]  [<ffffffff81072fa9>] ? del_timer_sync+0x3d/0x3d
[   60.268449]  [<ffffffffa0c18bfa>] ? dvb_frontend_thread+0x3fd/0x4bd 
[dvb_core]
[   60.268452]  [<ffffffff81061041>] ? wake_up_atomic_t+0x21/0x21
[   60.268454]  [<ffffffffa0c187fd>] ? dtv_set_frontend+0x325/0x325 
[dvb_core]
[   60.268456]  [<ffffffff8104eee7>] ? kthread+0x96/0x9e
[   60.268457]  [<ffffffff8104ee51>] ? init_completion+0x1d/0x1d
[   60.268460]  [<ffffffff81453cd2>] ? ret_from_fork+0x22/0x30
[   60.268472] ---[ end trace f08e58646fa0507a ]---


System info:
$ ./ver_linux
Linux darkstar 4.9.0 #1 SMP PREEMPT Sat Dec 17 17:45:05 CET 2016 x86_64 
Intel(R) Core(TM) i5-2500K CPU @ 3.30GHz GenuineIntel GNU/Linux

GNU C                   5.4.0
GNU Make                4.1
Binutils                2.27
Util-linux              2.29
Mount                   2.29
Linux C Library         2.23
Dynamic linker (ldd)    2.23
Procps                  3.3.12
Net-tools               1.60
Kbd                     2.0.3
Console-tools           2.0.3
Sh-utils                8.25
Udev                    232
Modules Loaded          8250 8250_base auth_rpcgss bluetooth btbcm 
btintel btrtl btusb cdc_acm dns_resolver drm dvb_core ehci_hcd ehci_pci 
fscache grace gspca_main gspca_zc3xx joydev lockd media nfs nfs_acl 
nfsv3 nfsv4 nvidia nvidia_modeset oid_registry serial_core smsdvb 
smsmdtv smsusb snd_rawmidi snd_usb_audio snd_usbmidi_lib sunrpc 
usb_storage v4l2_common videodev x86_pkg_temp_thermal xhci_hcd xhci_pci


