Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:46034 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932358AbdJWOlf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Oct 2017 10:41:35 -0400
Received: by mail-oi0-f52.google.com with SMTP id f66so31110270oib.2
        for <linux-media@vger.kernel.org>; Mon, 23 Oct 2017 07:41:35 -0700 (PDT)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Mon, 23 Oct 2017 16:41:33 +0200
Message-ID: <CAAeHK+yfNVEqmExt7Pes2XG5BYu35OKF6U93XRa1U-twB5LG_w@mail.gmail.com>
Subject: usb/media/mxl111sf: trying to register non-static key in mxl111sf_ctrl_msg
To: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I've got the following report while fuzzing the kernel with syzkaller.

On commit 3e0cc09a3a2c40ec1ffb6b4e12da86e98feccb11 (4.14-rc5+).

usb 1-1: New USB device found, idVendor=2040, idProduct=c602
usb 1-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 1-1: Product: a
usb 1-1: dvb_usb_v2: found a 'HCW 126xxx' in warm state
usb 1-1: dvb_usb_v2: will pass the complete MPEG2 transport stream to
the software demuxer
dvbdev: DVB: registering new adapter (HCW 126xxx)
usb 1-1: media controller created
dvbdev: dvb_create_media_entity: media entity 'dvb-demux' registered.
usb 1-1: selecting invalid altsetting 1
set interface failed
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 0 PID: 24 Comm: kworker/0:1 Not tainted 4.14.0-rc5-43687-g06ab8a23e0e6 #545
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
 __dump_stack lib/dump_stack.c:16
 dump_stack+0x292/0x395 lib/dump_stack.c:52
 register_lock_class+0x6c4/0x1a00 kernel/locking/lockdep.c:769
 __lock_acquire+0x244/0x3610 kernel/locking/lockdep.c:3377
 lock_acquire+0x259/0x620 kernel/locking/lockdep.c:3994
 __mutex_lock_common kernel/locking/mutex.c:756
 __mutex_lock+0x18e/0x1a60 kernel/locking/mutex.c:893
 mutex_lock_nested+0x1b/0x20 kernel/locking/mutex.c:908
 mxl111sf_ctrl_msg+0x93/0x1f0 drivers/media/usb/dvb-usb-v2/mxl111sf.c:69
 mxl111sf_write_reg+0xc9/0x170 drivers/media/usb/dvb-usb-v2/mxl111sf.c:126
 mxl1x1sf_soft_reset+0x69/0x1a0 drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c:56
 mxl111sf_lg2160_frontend_attach+0x27b/0x9e0
drivers/media/usb/dvb-usb-v2/mxl111sf.c:521
 mxl111sf_frontend_attach_mh+0x1c/0x20
drivers/media/usb/dvb-usb-v2/mxl111sf.c:977
 dvb_usbv2_adapter_frontend_init drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:655
 dvb_usbv2_adapter_init drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:818
 dvb_usbv2_init drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:881
 dvb_usbv2_probe+0x143d/0x32f0 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:992
 usb_probe_interface+0x35d/0x8e0 drivers/usb/core/driver.c:361
 really_probe drivers/base/dd.c:413
 driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
 __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
 bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
 __device_attach+0x26b/0x3c0 drivers/base/dd.c:710
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
 bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
 device_add+0xd0b/0x1660 drivers/base/core.c:1835
 usb_set_configuration+0x104e/0x1870 drivers/usb/core/message.c:1932
 generic_probe+0x73/0xe0 drivers/usb/core/generic.c:174
 usb_probe_device+0xaf/0xe0 drivers/usb/core/driver.c:266
 really_probe drivers/base/dd.c:413
 driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
 __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
 bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
 __device_attach+0x26b/0x3c0 drivers/base/dd.c:710
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
 bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
 device_add+0xd0b/0x1660 drivers/base/core.c:1835
 usb_new_device+0x7b8/0x1020 drivers/usb/core/hub.c:2457
 hub_port_connect drivers/usb/core/hub.c:4903
 hub_port_connect_change drivers/usb/core/hub.c:5009
 port_event drivers/usb/core/hub.c:5115
 hub_event+0x194d/0x3740 drivers/usb/core/hub.c:5195
 process_one_work+0xc73/0x1d90 kernel/workqueue.c:2119
 worker_thread+0x221/0x1850 kernel/workqueue.c:2253
 kthread+0x363/0x440 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431
usb 1-1: dvb_usb_v2: usb_bulk_msg() failed=-22
error writing reg: 0xff, val: 0x00
dvb_usb_mxl111sf: probe of 1-1:1.0 failed with error -22
