Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <4963CA95.9080607@linuxtv.org>
Date: Tue, 06 Jan 2009 16:18:13 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
References: <4963C93A.1060708@rtr.ca>
In-Reply-To: <4963C93A.1060708@rtr.ca>
Cc: linux-acpi@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
	linux-dvb@linuxtv.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-dvb] [v4l-dvb-maintainer] 2.6.28: Oops at
 acpi_ds_exec_end_op+0x1b: kills machine
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Mark Lord wrote:
> This happened on our Mythtv box at startup this morning:
> The Oops happened once only, at system startup, on initial device probe.
> Not reproduceable, so probably a rare race of some kind.
> The xc5000 module was loaded with "init_fw=1" to force f/w load on modprobe.
>
> 2.6.28 kernel, SMP, x86_64, two CPUs (Core2duo 1.86GHz), 2GB RAM.
>
> Oops text typed in by hand from screen photos
> ( original photos: http://rtr.ca/xc5000_lockup )
> ...
> xc5000: firmware read 12332 bytes.
> xc5000: firmware upload
> BUG kernel NULL pointer dereference at 000000000000000c
> IP: [<ffffffff8038fbcf>] acpi_ds_exec_end_op+0x1b/0x3c4
> PGD 7c8cd067 PUD 7d411067 PMD 0
> Oops: 0000 [#1] PREEMPT SMP
> last sysfs file: /sys/class/firmware/i2c-2/loading
> CPU 0
> ...
> Modules linked in: xc5000 au8522 tea5767 tda9887 tda8290 tea5761 fuse au0828(+)
> dvd_core usbhid tuner_simple tuner_types snd_hda_intel msp3400 ... nvidia(P) ...
> ...
> Pid: 2383, comm: modprobe Tainted: P A 2.6.28 #9  
> RIP: 0010:[<ffffffff8038fbcf>]  [<ffffffff8038fbcf>] acpi_ds_exec_end_op+0x1b/0x3c4
> RSP: 0018:ffff88007a095ad8  EFLAGS: 00010296
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88007f8588f0
> R10: ffff88007f8a4d40 R11: ffff8800000bf9e0 R12: 0000000000000000
> R13: ffff88007e43bc10 R14: ffff88007a0ac000 R15: ffff88007e43bc10
> FS:  00007f844d5666e0(0000) GS:ffffffff8060f540(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> ...
> Process modprobe (pid: 2383, threadinfo ffff88007a094000, task ffff88007fa043d0)
> Stack:
>  ffff88007a085380 0000000000000000 ffff88007a085380 ffffffffa09cfb28
>  ffff88007e43bc10 ffffffffa09f263f ffff88007a095b18 ffff88007a085380
>  ffffc200109e6000 ffff88007a085380 000000000000f9f9 00000000000094d7
> Call Trace:
> xc_load_fw_and_init_tuner+0x14b/0x29c [xc5000]
> i2c_transfer+0x8a/0x94
> xc5000_init+0x3d/0x6f [xc5000]
> xc5000_attach+0x22c/0x256 [xc5000]
> __symbol_get+0x2c/0xd3
> au0828+dvb_register+0x2ec/x5cb [au0828]
> au0828_usb_probe+0x10c/0x140 [au0828]
> usb_match_id+0x32/0x58 [usbcore]
> usb_probe_interface+0xfb/0x132 [usbcore]
> driver_probe_device+0xb5/0x159
> __driver_attach+0x59/0x80
> __driver_attach+0x0/0x80
> bus_for_each_dev+0x44/0x78
> bus_add_driver+0xac/0x1f2
> driver_register+0xa2/0x11f
> usb_register_driver+0x7e/0xe0 [usbcore]
> au0828_init+0x0/0xbb [au0828]
> au0828_init+0xa1/0xbb [au0828]
> _stext+0x56/0x14f
> vma_link+0x90/0xa2
> update_curr+0x49/0xf0
> enqueue_task_fair+0x14c/0x161
> check_preempt_wakeup+0xf4/0x124
> try_to_wake_up+0x16a/0x17c
> sys_init_module+0xa0/0x1a9
> system_call_fastpath+0x16/0x1b
> Code: 00 66 c7 40 0c c0 00 89 d8 48 83 c4 18 5b 5d c3 41 55 41 54 55 48 89
>  48 83 ec 08 48 8b 87 08 03 00 00 4c 8b a7 00 03 00 00 <8a> 50 0c 8a 40 0?
>  c8 83 f9 0a 75 25 41 0f b7 4c 24 0a 48
> RIP  [<ffffffff8038fbcf>] acpi_ds_exec_end_op+0x1b/0x3c4
>  RSP <ffff88007a095ad8>
> CR2: 000000000000000c
> ---[ end trace c23df576c022eb7e ]---
>
> Could someone perhaps explain how acpi_ds_exec_end_op even enters the
> picture here?  I'm confused by that.
>
> The driver was doing/completing an i2c firmware transfer at the time of
> the oops.


We removed the "init_fw" module option from the xc5000 module.  It is no 
longer necessary, and prevents us from taking advantage of power saving 
capabilities.

So, the OOPS itself is moot.  How did acpi_ds_exec_end_op enter the 
picture???  That I have no idea.  Can you try to reproduce that will a 
clean (not tainted) kernel?

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
