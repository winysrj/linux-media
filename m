Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:45326 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965237AbdIZORP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 10:17:15 -0400
Received: by mail-oi0-f52.google.com with SMTP id z73so12088522oia.2
        for <linux-media@vger.kernel.org>; Tue, 26 Sep 2017 07:17:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5144922.ruhMihuH9L@avalon>
References: <CAAeHK+z+Si69jUR+N-SjN9q4O+o5KFiNManqEa-PjUta7EOb7A@mail.gmail.com>
 <2018643.XCel7AsVXx@avalon> <CAAeHK+yobPp9-sZGf9-2tCeA=xPVW1esJLJNEP3CAnkf5eEi2w@mail.gmail.com>
 <5144922.ruhMihuH9L@avalon>
From: Andrey Konovalov <andreyknvl@google.com>
Date: Tue, 26 Sep 2017 16:17:13 +0200
Message-ID: <CAAeHK+yyMx89XX4MHuwuN9XEqifNmcNe_fy=MzMLsuxwrQcH5w@mail.gmail.com>
Subject: Re: usb/media/uvc: warning in uvc_scan_chain_forward/__list_add
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: multipart/mixed; boundary="001a113cf410f8289a055a1854eb"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--001a113cf410f8289a055a1854eb
Content-Type: text/plain; charset="UTF-8"

On Tue, Sep 26, 2017 at 2:50 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Andrey,
>
> On Tuesday, 26 September 2017 15:41:45 EEST Andrey Konovalov wrote:
>> On Tue, Sep 26, 2017 at 10:43 AM, Laurent Pinchart wrote:
>> > On Monday, 25 September 2017 15:40:13 EEST Andrey Konovalov wrote:
>> >> Hi!
>> >>
>> >> I've got the following report while fuzzing the kernel with syzkaller.
>> >
>> > Thank you for the report.
>> >
>> >> On commit e19b205be43d11bff638cad4487008c48d21c103 (4.14-rc2).
>> >>
>> >> list_add double add: new=ffff880069084010, prev=ffff880069084010,
>> >> next=ffff880067d22298.
>> >> ------------[ cut here ]------------
>> >> WARNING: CPU: 1 PID: 1846 at lib/list_debug.c:31
>> >> __list_add_valid+0xbd/0xf0
>> >> Modules linked in:
>> >> CPU: 1 PID: 1846 Comm: kworker/1:2 Not tainted
>> >> 4.14.0-rc2-42613-g1488251d1a98 #238
>> >> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs
>> >> 01/01/2011 Workqueue: usb_hub_wq hub_event
>> >> task: ffff88006b01ca40 task.stack: ffff880064358000
>> >> RIP: 0010:__list_add_valid+0xbd/0xf0 lib/list_debug.c:29
>> >> RSP: 0018:ffff88006435ddd0 EFLAGS: 00010286
>> >> RAX: 0000000000000058 RBX: ffff880067d22298 RCX: 0000000000000000
>> >> RDX: 0000000000000058 RSI: ffffffff85a58800 RDI: ffffed000c86bbac
>> >> RBP: ffff88006435dde8 R08: 1ffff1000c86ba52 R09: 0000000000000000
>> >> R10: 0000000000000002 R11: 0000000000000000 R12: ffff880069084010
>> >> R13: ffff880067d22298 R14: ffff880069084010 R15: ffff880067d222a0
>> >> FS:  0000000000000000(0000) GS:ffff88006c900000(0000)
>> >> knlGS:0000000000000000 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> >> CR2: 0000000020004ff2 CR3: 000000006b447000 CR4: 00000000000006e0
>> >>
>> >> Call Trace:
>> >>  __list_add ./include/linux/list.h:59
>> >>  list_add_tail+0x8c/0x1b0 ./include/linux/list.h:92
>> >>  uvc_scan_chain_forward.isra.8+0x373/0x416
>> >>
>> >> drivers/media/usb/uvc/uvc_driver.c:1471
>> >>
>> >>  uvc_scan_chain drivers/media/usb/uvc/uvc_driver.c:1585
>> >>  uvc_scan_device drivers/media/usb/uvc/uvc_driver.c:1769
>> >>  uvc_probe+0x77f2/0x8f00 drivers/media/usb/uvc/uvc_driver.c:2104
>> >
>> > So the issue happens at probe time, before the driver registers the V4L2
>> > device nodes that allow userspace access to the device. I wonder how
>> > fuzzing caused this. Do you have a more detailed log ?
>> >
>> > Could you also tell me what webcam you're using to test this out ? The
>> > output of lsusb -v would be useful.
>>
>> Hi Laurent,
>>
>> I fuzz the USB stack externally by emulating random USB devices via
>> dummy_hcd and gadgetfs.
>
> Ah that makes more sense indeed.
>
>> lsusb -v doesn't show anything, since the USB device doesn't finish
>> initialization.
>>
>> Since I'm able to reproduce this, I can collect debug traces for you.
>
> Could you send me the descriptors that your gadget driver returns to the host
> ? If that's difficult, as an alternative, could you enable tracing in the
> uvcvideo driver (uvcvideo.trace=0xffff on the kernel commmand line for
> instance) and send me the kernel log ?

The log with uvcvideo.trace=0xffff is below.

Also attaching usbmon trace.

gadgetfs: bound to dummy_udc driver
usb 1-1: new full-speed USB device number 2 using dummy_hcd
gadgetfs: connected
gadgetfs: disconnected
gadgetfs: connected
usb 1-1: config 3 has an invalid interface number: 3 but max is 0
usb 1-1: config 3 contains an unexpected descriptor of type 0x1, skipping
usb 1-1: config 3 has an invalid descriptor of length 208, skipping
remainder of the config
usb 1-1: config 3 has no interface number 0
usb 1-1: New USB device found, idVendor=07f5, idProduct=03ff
usb 1-1: New USB device strings: Mfr=83, Product=255, SerialNumber=5
usb 1-1: Product: a
usb 1-1: Manufacturer: a
usb 1-1: SerialNumber: a
gadgetfs: configuration #3
uvcvideo: Probing generic UVC device 1
uvcvideo: Found UVC 0.00 device a (07f5:03ff)
uvcvideo: Scanning UVC chain: OT 0
list_add double add: new=ffff880061ca3a90, prev=ffff880061ca3a90,
next=ffff88006b3f48d8.
------------[ cut here ]------------
...
---[ end trace e2bce247826f5cdb ]---
 (-> OT 0)
uvcvideo: Found a valid video chain ( -> 0).
uvcvideo 1-1:3.3: Entity type for entity a was not initialized!
uvcvideo: UVC device initialized.
gadgetfs: disconnected
usb 1-1: USB disconnect, device number 2

>
>> Here's a part of the log around the warning report:
>>
>> gadgetfs: bound to dummy_udc driver
>> usb 1-1: new full-speed USB device number 2 using dummy_hcd
>> gadgetfs: connected
>> gadgetfs: disconnected
>> gadgetfs: connected
>> usb 1-1: config 3 has an invalid interface number: 3 but max is 0
>> usb 1-1: config 3 contains an unexpected descriptor of type 0x1, skipping
>> usb 1-1: config 3 has an invalid descriptor of length 208, skipping
>> remainder of the config
>> usb 1-1: config 3 has no interface number 0
>> usb 1-1: New USB device found, idVendor=07f5, idProduct=03ff
>> usb 1-1: New USB device strings: Mfr=83, Product=255, SerialNumber=5
>> usb 1-1: Product: a
>> usb 1-1: Manufacturer: a
>> usb 1-1: SerialNumber: a
>> gadgetfs: configuration #3
>> uvcvideo: Found UVC 0.00 device a (07f5:03ff)
>> list_add double add: new=ffff880069a64910, prev=ffff880069a64910,
>> next=ffff8800698468d8.
>> ------------[ cut here ]------------
>> WARNING: CPU: 1 PID: 1846 at lib/list_debug.c:31 __list_add_valid+0xbd/0xf0
>> ...
>> ---[ end trace ea45186b02846d5a ]---
>> uvcvideo 1-1:3.3: Entity type for entity a was not initialized!
>> gadgetfs: disconnected
>> usb 1-1: USB disconnect, device number 2
>>
>> Thanks!
>>
>> >>  usb_probe_interface+0x35d/0x8e0 drivers/usb/core/driver.c:361
>> >>  really_probe drivers/base/dd.c:413
>> >>  driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
>> >>  __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
>> >>  bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
>> >>  __device_attach+0x26e/0x3d0 drivers/base/dd.c:710
>> >>  device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
>> >>  bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
>> >>  device_add+0xd0b/0x1660 drivers/base/core.c:1835
>> >>  usb_set_configuration+0x104e/0x1870 drivers/usb/core/message.c:1932
>> >>  generic_probe+0x73/0xe0 drivers/usb/core/generic.c:174
>> >>  usb_probe_device+0xaf/0xe0 drivers/usb/core/driver.c:266
>> >>  really_probe drivers/base/dd.c:413
>> >>  driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
>> >>  __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
>> >>  bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
>> >>  __device_attach+0x26e/0x3d0 drivers/base/dd.c:710
>> >>  device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
>> >>  bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
>> >>  device_add+0xd0b/0x1660 drivers/base/core.c:1835
>> >>  usb_new_device+0x7b8/0x1020 drivers/usb/core/hub.c:2457
>> >>  hub_port_connect drivers/usb/core/hub.c:4903
>> >>  hub_port_connect_change drivers/usb/core/hub.c:5009
>> >>  port_event drivers/usb/core/hub.c:5115
>> >>  hub_event+0x194d/0x3740 drivers/usb/core/hub.c:5195
>> >>  process_one_work+0xc7f/0x1db0 kernel/workqueue.c:2119
>> >>  worker_thread+0x221/0x1850 kernel/workqueue.c:2253
>> >>  kthread+0x3a1/0x470 kernel/kthread.c:231
>> >>  ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431
>> >>
>> >> Code: f1 48 c7 c7 c0 89 a5 85 48 89 de e8 38 34 e1 fe 0f ff 31 c0 eb
>> >> c3 48 89 f2 48 89 d9 4c 89 e6 48 c7 c7 40 8a a5 85 e8 1d 34 e1 fe <0f>
>> >> ff 31 c0 eb a8 48 89 75 e8 e8 e4 b3 2a ff 48 8b 75 e8 e9 5b
>> >> ---[ end trace 23181469b7a6915e ]---
>
> --
> Regards,
>
> Laurent Pinchart
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/d/optout.

--001a113cf410f8289a055a1854eb
Content-Type: application/octet-stream; name=uvc_scan_chain-warn-usbmon
Content-Disposition: attachment; filename=uvc_scan_chain-warn-usbmon
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j81or5c30

ZmZmZjg4MDA2OWQ3YjEwMCAzMDEwMTgxMSBTIENpOjE6MDAxOjAgcyBhMyAwMCAwMDAwIDAwMDEg
MDAwNCA0IDwKZmZmZjg4MDA2OWQ3YjEwMCAzMDEwMjYxNCBDIENpOjE6MDAxOjAgMCA0ID0gMDEw
MTAxMDAKZmZmZjg4MDA2OWQ3YjMwMCAzMDEwMjgwMSBTIENvOjE6MDAxOjAgcyAyMyAwMSAwMDEw
IDAwMDEgMDAwMCAwCmZmZmY4ODAwNjlkN2IzMDAgMzAxMDQwNDUgQyBDbzoxOjAwMTowIDAgMApm
ZmZmODgwMDZiM2Q2MTAwIDMwMjIwMjk3IFMgSWk6MTowMDE6MSAtMTE1OjIwNDggNCA8CmZmZmY4
ODAwNjlkN2I1MDAgMzAyMjA2NTYgUyBDaToxOjAwMTowIHMgYTMgMDAgMDAwMCAwMDAxIDAwMDQg
NCA8CmZmZmY4ODAwNjlkN2I1MDAgMzAyMjA5NjcgQyBDaToxOjAwMTowIDAgNCA9IDAxMDEwMDAw
CmZmZmY4ODAwNjlkN2IwMDAgMzAyMjIyNTQgUyBDbzoxOjAwMTowIHMgMjMgMDMgMDAwNCAwMDAx
IDAwMDAgMApmZmZmODgwMDY5ZDdiMDAwIDMwMjIzODQyIEMgQ286MTowMDE6MCAwIDAKZmZmZjg4
MDA2OWQ3YjkwMCAzMDMwMDMxOSBTIENpOjE6MDAxOjAgcyBhMyAwMCAwMDAwIDAwMDEgMDAwNCA0
IDwKZmZmZjg4MDA2YjNkNjEwMCAzMDMwMTU4NSBDIElpOjE6MDAxOjEgMDoyMDQ4IDEgPSAwMgpm
ZmZmODgwMDZiM2Q2MTAwIDMwMzAxNjM0IFMgSWk6MTowMDE6MSAtMTE1OjIwNDggNCA8CmZmZmY4
ODAwNjlkN2I5MDAgMzAzMDI4OTggQyBDaToxOjAwMTowIDAgNCA9IDAzMDExMDAwCmZmZmY4ODAw
NjlkN2IyMDAgMzAzMDMyMjUgUyBDbzoxOjAwMTowIHMgMjMgMDEgMDAxNCAwMDAxIDAwMDAgMApm
ZmZmODgwMDY5ZDdiMjAwIDMwMzAzNTM2IEMgQ286MTowMDE6MCAwIDAKZmZmZjg4MDA2OWQ3YjQw
MCAzMDM3MjQwMiBTIENpOjE6MDAwOjAgcyA4MCAwNiAwMTAwIDAwMDAgMDA0MCA2NCA8CmZmZmY4
ODAwNjlkN2I0MDAgMzAzOTEzNzQgQyBDaToxOjAwMDowIDAgMTggPSAxMjAxMDAwMiAwMTAwMDA0
MCBmNTA3ZmYwMyAwNDAwNTNmZiAwNTAxCmZmZmY4ODAwNjlkN2I2MDAgMzAzOTI2NjIgUyBDbzox
OjAwMTowIHMgMjMgMDMgMDAwNCAwMDAxIDAwMDAgMApmZmZmODgwMDY5ZDdiNjAwIDMwMzk0OTMw
IEMgQ286MTowMDE6MCAwIDAKZmZmZjg4MDA2OWM2MzAwMCAzMDQ3MDI2NSBTIENpOjE6MDAxOjAg
cyBhMyAwMCAwMDAwIDAwMDEgMDAwNCA0IDwKZmZmZjg4MDA2YjNkNjEwMCAzMDQ3MDQwMiBDIElp
OjE6MDAxOjEgMDoyMDQ4IDEgPSAwMgpmZmZmODgwMDZiM2Q2MTAwIDMwNDcwNDMzIFMgSWk6MTow
MDE6MSAtMTE1OjIwNDggNCA8CmZmZmY4ODAwNjljNjMwMDAgMzA0NzA3NzIgQyBDaToxOjAwMTow
IDAgNCA9IDAzMDExMDAwCmZmZmY4ODAwNjljNjMyMDAgMzA0NzA4ODcgUyBDbzoxOjAwMTowIHMg
MjMgMDEgMDAxNCAwMDAxIDAwMDAgMApmZmZmODgwMDY5YzYzMjAwIDMwNDcxMDcyIEMgQ286MTow
MDE6MCAwIDAKZmZmZjg4MDA2OWM2MzMwMCAzMDU0MDI2NyBTIENvOjE6MDAwOjAgcyAwMCAwNSAw
MDAyIDAwMDAgMDAwMCAwCmZmZmY4ODAwNjljNjMzMDAgMzA1NjAxNDIgQyBDbzoxOjAwMDowIDAg
MApmZmZmODgwMDY5YzYzNDAwIDMwNTkwMjc2IFMgQ2k6MTowMDI6MCBzIDgwIDA2IDAxMDAgMDAw
MCAwMDEyIDE4IDwKZmZmZjg4MDA2OWM2MzQwMCAzMDYxMTIxNSBDIENpOjE6MDAyOjAgMCAxOCA9
IDEyMDEwMDAyIDAxMDAwMDQwIGY1MDdmZjAzIDA0MDA1M2ZmIDA1MDEKZmZmZjg4MDA2OWM2MzYw
MCAzMDYxMTY2MSBTIENpOjE6MDAyOjAgcyA4MCAwNiAwNjAwIDAwMDAgMDAwYSAxMCA8CmZmZmY4
ODAwNjljNjM2MDAgMzA2MzAxNTcgQyBDaToxOjAwMjowIC0zMiAwCmZmZmY4ODAwNjljNjM1MDAg
MzA2MzAzNDcgUyBDaToxOjAwMjowIHMgODAgMDYgMDYwMCAwMDAwIDAwMGEgMTAgPApmZmZmODgw
MDY5YzYzNTAwIDMwNjUwMTYwIEMgQ2k6MTowMDI6MCAtMzIgMApmZmZmODgwMDY5YzYzOTAwIDMw
NjUwMzM0IFMgQ2k6MTowMDI6MCBzIDgwIDA2IDA2MDAgMDAwMCAwMDBhIDEwIDwKZmZmZjg4MDA2
OWM2MzkwMCAzMDY3MDE2MyBDIENpOjE6MDAyOjAgLTMyIDAKZmZmZjg4MDA2OWM2M2EwMCAzMDY3
MDU1MyBTIENpOjE6MDAyOjAgcyA4MCAwNiAwMjAwIDAwMDAgMDAwOSA5IDwKZmZmZjg4MDA2OWM2
M2EwMCAzMDY5MDE3MCBDIENpOjE6MDAyOjAgMCA5ID0gMDkwMjhmMDAgMDEwMzAwODAgMDAKZmZm
Zjg4MDA2OWM2M2UwMCAzMDY5MDM3OCBTIENpOjE6MDAyOjAgcyA4MCAwNiAwMjAwIDAwMDAgMDA4
ZiAxNDMgPApmZmZmODgwMDY5YzYzZTAwIDMwNzEwMTY5IEMgQ2k6MTowMDI6MCAwIDE0MyA9IDA5
MDI4ZjAwIDAxMDMwMDgwIDAwMDkwNDAzIDAwMDAwZTAxIDAwMDAwOTI0IDAzMDAwMTAzIDdjMDAz
MzI4IDAxMDIwNGRiCmZmZmY4ODAwNmE0OWQzMDAgMzA3MjQ0MzQgUyBDaToxOjAwMjowIHMgODAg
MDYgMDMwMCAwMDAwIDAwZmYgMjU1IDwKZmZmZjg4MDA2YTQ5ZDMwMCAzMDc2MDE3MCBDIENpOjE6
MDAyOjAgMCA0ID0gMDQwMzA5MDQKZmZmZjg4MDA2YTQ5ZDEwMCAzMDc2MDM3NiBTIENpOjE6MDAy
OjAgcyA4MCAwNiAwM2ZmIDA0MDkgMDBmZiAyNTUgPApmZmZmODgwMDZhNDlkMTAwIDMwODAwMTY5
IEMgQ2k6MTowMDI6MCAwIDQgPSAwNDAzNjEwMApmZmZmODgwMDZhNDlkNDAwIDMwODAwNTI5IFMg
Q2k6MTowMDI6MCBzIDgwIDA2IDAzNTMgMDQwOSAwMGZmIDI1NSA8CmZmZmY4ODAwNmE0OWQ0MDAg
MzA4NDAxNzIgQyBDaToxOjAwMjowIDAgNCA9IDA0MDM2MTAwCmZmZmY4ODAwNmE0OWQ1MDAgMzA4
NDA1MzQgUyBDaToxOjAwMjowIHMgODAgMDYgMDMwNSAwNDA5IDAwZmYgMjU1IDwKZmZmZjg4MDA2
YTQ5ZDUwMCAzMDg4MDE1OSBDIENpOjE6MDAyOjAgMCA0ID0gMDQwMzYxMDAKZmZmZjg4MDA2YTQ5
ZDYwMCAzMDg5Mjg2MCBTIENvOjE6MDAyOjAgcyAwMCAwOSAwMDAzIDAwMDAgMDAwMCAwCmZmZmY4
ODAwNmE0OWQ2MDAgMzA5MzAxOTAgQyBDbzoxOjAwMjowIDAgMApmZmZmODgwMDZhNDlkNzAwIDMw
OTM1NjQxIFMgQ2k6MTowMDI6MCBzIDgwIDA2IDAzMzMgMDQwOSAwMGZmIDI1NSA8CmZmZmY4ODAw
NmE0OWQ3MDAgMzA5ODAxNzAgQyBDaToxOjAwMjowIDAgNCA9IDA0MDM2MTAwCmZmZmY4ODAwNmE0
OWQ4MDAgMzExNzQ0MDggUyBDaToxOjAwMTowIHMgYTMgMDAgMDAwMCAwMDAxIDAwMDQgNCA8CmZm
ZmY4ODAwNmE0OWQ4MDAgMzExNzQ0ODggQyBDaToxOjAwMTowIDAgNCA9IDAzMDEwMDAwCmZmZmY4
ODAwNmIzZDYxMDAgMzE1NjQ2NTcgQyBJaToxOjAwMToxIDA6MjA0OCAxID0gMDIKZmZmZjg4MDA2
YjNkNjEwMCAzMTU2NDczNiBTIElpOjE6MDAxOjEgLTExNToyMDQ4IDQgPApmZmZmODgwMDZiNjdi
MjAwIDMxNTY1ODQ5IFMgQ2k6MTowMDE6MCBzIGEzIDAwIDAwMDAgMDAwMSAwMDA0IDQgPApmZmZm
ODgwMDZiM2Q2MTAwIDMxNTY1OTk4IEMgSWk6MTowMDE6MSAwOjIwNDggMSA9IDAyCmZmZmY4ODAw
NmIzZDYxMDAgMzE1NjYwMzYgUyBJaToxOjAwMToxIC0xMTU6MjA0OCA0IDwKZmZmZjg4MDA2YjY3
YjIwMCAzMTU2NjA2MSBDIENpOjE6MDAxOjAgMCA0ID0gMDAwMTAxMDAKZmZmZjg4MDA2YjY3YjMw
MCAzMTU2NjIxNSBTIENvOjE6MDAxOjAgcyAyMyAwMSAwMDEwIDAwMDEgMDAwMCAwCmZmZmY4ODAw
NmI2N2IzMDAgMzE1NjY2OTEgQyBDbzoxOjAwMTowIDAgMApmZmZmODgwMDZiNjdiZjAwIDMxNTgy
MDU3IFMgQ2k6MTowMDE6MCBzIGEzIDAwIDAwMDAgMDAwMSAwMDA0IDQgPApmZmZmODgwMDZiNjdi
ZjAwIDMxNTgyMzU5IEMgQ2k6MTowMDE6MCAwIDQgPSAwMDAxMDAwMApmZmZmODgwMDZiNjdiZDAw
IDMxNjMwMjQ4IFMgQ2k6MTowMDE6MCBzIGEzIDAwIDAwMDAgMDAwMSAwMDA0IDQgPApmZmZmODgw
MDZiNjdiZDAwIDMxNjMwMzQ5IEMgQ2k6MTowMDE6MCAwIDQgPSAwMDAxMDAwMApmZmZmODgwMDZi
NjdiYjAwIDMxNjgwMjQ0IFMgQ2k6MTowMDE6MCBzIGEzIDAwIDAwMDAgMDAwMSAwMDA0IDQgPApm
ZmZmODgwMDZiNjdiYjAwIDMxNjgwMzYyIEMgQ2k6MTowMDE6MCAwIDQgPSAwMDAxMDAwMApmZmZm
ODgwMDZiNjdiNDAwIDMxNzMwMjYyIFMgQ2k6MTowMDE6MCBzIGEzIDAwIDAwMDAgMDAwMSAwMDA0
IDQgPApmZmZmODgwMDZiNjdiNDAwIDMxNzMwMzgxIEMgQ2k6MTowMDE6MCAwIDQgPSAwMDAxMDAw
MApmZmZmODgwMDZiNjdiZTAwIDMxNzgwMjM5IFMgQ2k6MTowMDE6MCBzIGEzIDAwIDAwMDAgMDAw
MSAwMDA0IDQgPApmZmZmODgwMDZiNjdiZTAwIDMxNzgwMzU5IEMgQ2k6MTowMDE6MCAwIDQgPSAw
MDAxMDAwMApmZmZmODgwMDZiNjdiYzAwIDMxNzgwNTAzIFMgQ2k6MTowMDE6MCBzIGEzIDAwIDAw
MDAgMDAwMSAwMDA0IDQgPApmZmZmODgwMDZiNjdiYzAwIDMxNzgwNTk1IEMgQ2k6MTowMDE6MCAw
IDQgPSAwMDAxMDAwMApmZmZmODgwMDZiM2Q2MTAwIDMxNzgwNzU4IEMgSWk6MTowMDE6MSAtMjoy
MDQ4IDAK
--001a113cf410f8289a055a1854eb--
