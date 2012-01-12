Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:32907 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab2ALRND (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jan 2012 12:13:03 -0500
Received: by qcsg13 with SMTP id g13so1171088qcs.19
        for <linux-media@vger.kernel.org>; Thu, 12 Jan 2012 09:13:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F0F0BEF.8040002@gmail.com>
References: <4F0C3D1B.2010904@gmail.com>
	<4F0CE040.7020904@iki.fi>
	<4F0DE0C2.5050907@gmail.com>
	<4F0F08DB.4050301@gmail.com>
	<4F0F0BEF.8040002@gmail.com>
Date: Thu, 12 Jan 2012 17:13:01 +0000
Message-ID: <CAH4Ag-BGukfwtU0-92Q0k5-KwMnZ=KTL1L_bLUaHRkORB9n8jg@mail.gmail.com>
Subject: Re: Possible regression in 3.2 kernel with PCTV Nanostick T2 (em28xx,
 cxd2820r and tda18271)
From: Simon Jones <sijones2010@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I'm still unsure about the first. It might be a 32/64-bit problem (based on
> evidence from Simon Jones), it might be flaky hardware or it might be a real
> problem. I'm planning to build the 3.2.0 kernel (minus the linux-media
> patches) for 64-bit on different hardware and see what happens.
>
> As for the second I suspect it might be a kaffeine problem. It might just
> need recompiling with the new headers or it might need some work on it. I'll
> investigate that after I've solved the first regression.
>

Might have been a bit prem on the working perfect.... cam home to the
wife saying the system has crashed... looked in the logs and this is
reported:

Jan 12 05:27:59 localhost kernel: [308040.577546] xhci_hcd
0000:02:00.0: WARN: buffer overrun event on endpoint
---> This error has occured since I built the system at christmas,
have been ignoring it because it didn't seem to cause any issues.

Jan 12 05:33:03 localhost kernel: [308344.766507] xhci_hcd
0000:02:00.0: WARN: babble error on endpoint
Jan 12 05:33:03 localhost kernel: [308344.766541] hub 1-0:1.0: port 1
disabled by hub (EMI?), re-enabling...
Jan 12 05:33:03 localhost kernel: [308344.766546] usb 1-1: USB
disconnect, device number 2
Jan 12 05:33:03 localhost kernel: [308344.766602] em28xx #0:
disconnecting em28xx #0 video
Jan 12 05:33:04 localhost kernel: [308344.805942] cxd2820r: i2c rd
failed ret:-19 reg:10 len:1
Jan 12 05:33:04 localhost kernel: [308344.849191] cxd2820r: i2c rd
failed ret:-19 reg:26 len:2
Jan 12 05:33:04 localhost kernel: [308344.859414] em28xx #0: V4L2
device video0 deregistered
Jan 12 05:33:04 localhost kernel: [308344.889276] cxd2820r: i2c rd
failed ret:-19 reg:28 len:2
Jan 12 05:36:00 localhost kernel: [308521.689250] INFO: task khubd:140
blocked for more than 120 seconds.
Jan 12 05:36:00 localhost kernel: [308521.689256] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 12 05:36:00 localhost kernel: [308521.689262] khubd           D
0000000105821dfa     0   140      2 0x00000000
Jan 12 05:36:00 localhost kernel: [308521.689272]  ffff8804227e9b80
0000000000000046 ffff880400000000 00000000435d27dc
Jan 12 05:36:00 localhost kernel: [308521.689282]  ffff880423637200
ffff8804227e9fd8 ffff8804227e9fd8 ffff8804227e9fd8
Jan 12 05:36:00 localhost kernel: [308521.689290]  ffff8804244cf200
ffff880423637200 ffff8804227e9b30 ffffffff814156f8
Jan 12 05:36:00 localhost kernel: [308521.689299] Call Trace:
Jan 12 05:36:00 localhost kernel: [308521.689311]
[<ffffffff814156f8>] ? wait_for_common+0x128/0x160
Jan 12 05:36:00 localhost kernel: [308521.689323]
[<ffffffff8105cf70>] ? try_to_wake_up+0x290/0x290
Jan 12 05:36:00 localhost kernel: [308521.689330]
[<ffffffff8141574d>] ? wait_for_completion+0x1d/0x20
Jan 12 05:36:00 localhost kernel: [308521.689337]
[<ffffffff8141640f>] schedule+0x3f/0x60
Jan 12 05:36:00 localhost kernel: [308521.689366]
[<ffffffffa028f2c5>] dvb_unregister_frontend+0xc5/0x110 [dvb_core]
Jan 12 05:36:00 localhost kernel: [308521.689376]
[<ffffffff810868f0>] ? abort_exclusive_wait+0xb0/0xb0
Jan 12 05:36:00 localhost kernel: [308521.689386]
[<ffffffffa01fda22>] em28xx_dvb_fini+0xf2/0x150 [em28xx_dvb]
Jan 12 05:36:00 localhost kernel: [308521.689400]
[<ffffffffa037606e>] em28xx_close_extension+0x3e/0xa0 [em28xx]
Jan 12 05:36:00 localhost kernel: [308521.689410]
[<ffffffffa0373ef5>] em28xx_usb_disconnect+0xe5/0x190 [em28xx]
Jan 12 05:36:00 localhost kernel: [308521.689436]
[<ffffffffa0011242>] usb_unbind_interface+0x52/0x180 [usbcore]
Jan 12 05:36:00 localhost kernel: [308521.689448]
[<ffffffff8130071c>] __device_release_driver+0x7c/0xe0
Jan 12 05:36:00 localhost kernel: [308521.689456]
[<ffffffff813007ac>] device_release_driver+0x2c/0x40
Jan 12 05:36:00 localhost kernel: [308521.689463]
[<ffffffff81300258>] bus_remove_device+0x78/0xb0
Jan 12 05:36:00 localhost kernel: [308521.689475]
[<ffffffff812fdb5d>] device_del+0x12d/0x1b0
Jan 12 05:36:00 localhost kernel: [308521.689482]
[<ffffffffa000ef9f>] usb_disable_device+0xaf/0x1d0 [usbcore]
Jan 12 05:36:00 localhost kernel: [308521.689489]
[<ffffffffa00073a8>] usb_disconnect+0x98/0x130 [usbcore]
Jan 12 05:36:00 localhost kernel: [308521.689497]
[<ffffffffa00092fc>] hub_thread+0xa4c/0x12d0 [usbcore]
Jan 12 05:36:00 localhost kernel: [308521.689500]
[<ffffffff810868f0>] ? abort_exclusive_wait+0xb0/0xb0
Jan 12 05:36:00 localhost kernel: [308521.689507]
[<ffffffffa00088b0>] ? usb_remote_wakeup+0x40/0x40 [usbcore]
Jan 12 05:36:00 localhost kernel: [308521.689510]
[<ffffffff81085fac>] kthread+0x8c/0xa0
Jan 12 05:36:00 localhost kernel: [308521.689513]
[<ffffffff8141bd74>] kernel_thread_helper+0x4/0x10
Jan 12 05:36:00 localhost kernel: [308521.689516]
[<ffffffff81085f20>] ? kthread_worker_fn+0x190/0x190
Jan 12 05:36:00 localhost kernel: [308521.689519]
[<ffffffff8141bd70>] ? gs_change+0x13/0x13


It goes on longer than this, but think it's the same repeated
information and call stack trace etc.

But this could just be related to the usb drivers being a bit unstable
on this motherboard.
