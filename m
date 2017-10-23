Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:42480 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751662AbdJWS56 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Oct 2017 14:57:58 -0400
Subject: Re: usb/media/dtt200u: use-after-free in __dvb_frontend_free
To: Andrey Konovalov <andreyknvl@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
References: <CAAeHK+zRfmghESqdKBqFw1CQnrkEkCxCLNgDQKzPqzZS=onEpg@mail.gmail.com>
From: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <c4ad7f4e-c838-aa44-5f0d-f8072ed41904@gentoo.org>
Date: Mon, 23 Oct 2017 20:58:09 +0200
MIME-Version: 1.0
In-Reply-To: <CAAeHK+zRfmghESqdKBqFw1CQnrkEkCxCLNgDQKzPqzZS=onEpg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 23.10.2017 um 16:41 schrieb Andrey Konovalov:
> Hi!
> 
> I've got the following report while fuzzing the kernel with syzkaller.
> 
> On commit 3e0cc09a3a2c40ec1ffb6b4e12da86e98feccb11 (4.14-rc5+).
> 
> dvb-usb: found a 'WideView WT-220U PenType Receiver (based on ZL353)'
> in warm state.
> dvb-usb: bulk message failed: -22 (2/1102416563)
> dvb-usb: will use the device's hardware PID filter (table count: 15).
> dvbdev: DVB: registering new adapter (WideView WT-220U PenType
> Receiver (based on ZL353))
> usb 1-1: media controller created
> dvbdev: dvb_create_media_entity: media entity 'dvb-demux' registered.
> usb 1-1: DVB: registering adapter 0 frontend 0 (WideView USB DVB-T)...
> dvbdev: dvb_create_media_entity: media entity 'WideView USB DVB-T' registered.
> Registered IR keymap rc-dtt200u
> rc rc1: IR-receiver inside an USB DVB receiver as
> /devices/platform/dummy_hcd.0/usb1/1-1/rc/rc1
> input: IR-receiver inside an USB DVB receiver as
> /devices/platform/dummy_hcd.0/usb1/1-1/rc/rc1/input9
> dvb-usb: schedule remote query interval to 300 msecs.
> dvb-usb: WideView WT-220U PenType Receiver (based on ZL353)
> successfully initialized and connected.
> dvb-usb: bulk message failed: -22 (1/1807119384)
> dvb-usb: error -22 while querying for an remote control event.
> dvb-usb: bulk message failed: -22 (1/1807119384)
> dvb-usb: error -22 while querying for an remote control event.
> dvb-usb: bulk message failed: -22 (1/1807119384)
> dvb-usb: error -22 while querying for an remote control event.
> dvb-usb: bulk message failed: -22 (1/1807119384)
> dvb-usb: error -22 while querying for an remote control event.
> dvb-usb: bulk message failed: -22 (1/1807119384)
> dvb-usb: error -22 while querying for an remote control event.
> dvb-usb: bulk message failed: -22 (1/1807119384)
> dvb-usb: error -22 while querying for an remote control event.
> usb 1-1: USB disconnect, device number 2
> ==================================================================
> BUG: KASAN: use-after-free in __dvb_frontend_free+0x113/0x120
> Write of size 8 at addr ffff880067d45a00 by task kworker/0:1/24
> 
> CPU: 0 PID: 24 Comm: kworker/0:1 Not tainted 4.14.0-rc5-43687-g06ab8a23e0e6 #545
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> Workqueue: usb_hub_wq hub_event
> Call Trace:
>  __dump_stack lib/dump_stack.c:16
>  dump_stack+0x292/0x395 lib/dump_stack.c:52
>  print_address_description+0x78/0x280 mm/kasan/report.c:252
>  kasan_report_error mm/kasan/report.c:351
>  kasan_report+0x23d/0x350 mm/kasan/report.c:409
>  __asan_report_store8_noabort+0x1c/0x20 mm/kasan/report.c:435
>  __dvb_frontend_free+0x113/0x120 drivers/media/dvb-core/dvb_frontend.c:156
>  dvb_frontend_put+0x59/0x70 drivers/media/dvb-core/dvb_frontend.c:176
>  dvb_frontend_detach+0x120/0x150 drivers/media/dvb-core/dvb_frontend.c:2803
>  dvb_usb_adapter_frontend_exit+0xd6/0x160
> drivers/media/usb/dvb-usb/dvb-usb-dvb.c:340
>  dvb_usb_adapter_exit drivers/media/usb/dvb-usb/dvb-usb-init.c:116
>  dvb_usb_exit+0x9b/0x200 drivers/media/usb/dvb-usb/dvb-usb-init.c:132
>  dvb_usb_device_exit+0xa5/0xf0 drivers/media/usb/dvb-usb/dvb-usb-init.c:295
>  usb_unbind_interface+0x21c/0xa90 drivers/usb/core/driver.c:423
>  __device_release_driver drivers/base/dd.c:861
>  device_release_driver_internal+0x4f1/0x5c0 drivers/base/dd.c:893
>  device_release_driver+0x1e/0x30 drivers/base/dd.c:918
>  bus_remove_device+0x2f4/0x4b0 drivers/base/bus.c:565
>  device_del+0x5c4/0xab0 drivers/base/core.c:1985
>  usb_disable_device+0x1e9/0x680 drivers/usb/core/message.c:1170
>  usb_disconnect+0x260/0x7a0 drivers/usb/core/hub.c:2124
>  hub_port_connect drivers/usb/core/hub.c:4754
>  hub_port_connect_change drivers/usb/core/hub.c:5009
>  port_event drivers/usb/core/hub.c:5115
>  hub_event+0x1318/0x3740 drivers/usb/core/hub.c:5195
>  process_one_work+0xc73/0x1d90 kernel/workqueue.c:2119
>  worker_thread+0x221/0x1850 kernel/workqueue.c:2253
>  kthread+0x363/0x440 kernel/kthread.c:231
>  ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431
> 
It looks like this is caused by commit
ead666000a5fe34bdc82d61838e4df2d416ea15e ("media: dvb_frontend: only use
kref after initialized").

The writing to "fe->frontend_priv" in dvb_frontend.c:156 is a
use-after-free in case the object dvb_frontend *fe is already freed by
the release callback called in line 153.
Only if the demod driver is based on new style i2c_client the memory is
still accessible.

There are two possible solutions:
1. Clear fe->frontend_priv earlier (before line 153).
2. Do not clear fe->frontend_priv

Can you try if the following patch (solution 1) fixes the issue?

Regards
Matthias

diff --git a/drivers/media/dvb-core/dvb_frontend.c
b/drivers/media/dvb-core/dvb_frontend.c
index daaf969719e4..f552acdb7d8c 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -150,10 +150,11 @@ static void __dvb_frontend_free(struct
dvb_frontend *fe)

        dvb_free_device(fepriv->dvbdev);

+       fe->frontend_priv = NULL;
+
        dvb_frontend_invoke_release(fe, fe->ops.release);

        kfree(fepriv);
-       fe->frontend_priv = NULL;
 }

 static void dvb_frontend_free(struct kref *ref)
