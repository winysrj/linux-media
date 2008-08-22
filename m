Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thomas.schorpp@googlemail.com>) id 1KWT9Z-0002PT-K9
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 11:41:58 +0200
Received: by gv-out-0910.google.com with SMTP id n29so116527gve.16
	for <linux-dvb@linuxtv.org>; Fri, 22 Aug 2008 02:41:53 -0700 (PDT)
Message-ID: <48AE89DD.5090307@gmail.com>
Date: Fri, 22 Aug 2008 11:41:49 +0200
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <1219357399.6770.12.camel@youkaida>
In-Reply-To: <1219357399.6770.12.camel@youkaida>
From: thomas schorpp <thomas.schorpp@googlemail.com>
Subject: Re: [linux-dvb] New firmware for dib0700 (Nova-T-500 and others)
Reply-To: thomas.schorpp@gmail.com
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

Nicolas Will wrote:
> All,
> 
> There is a new firmware file fixing the last cause for i2c errors and
> disconnects and providing a new, more modular i2c request formatting.
> 

this is not firmware since it does not occur with the "other OS" and it's gone better 
upgrading 2.6.24->2.6.26.2 but the driver is still buggy:

do lsusb and...

INFO: task khubd:1966 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
khubd         D ffff81003dca9bc0     0  1966      2
 ffff81003dca9bb0 0000000000000046 ffff81003eeb6220 ffff81003f0ea7d0
 ffff81003eeb6478 ffff81003eeb6478 ffff81003dca9b90 ffffffff80245e8f
 ffff81003dca9bb0 ffff81003dd33800 ffff81003dca9bc0 0000000000000000
Call Trace:
 [<ffffffff80245e8f>] ? kthread_stop+0x7f/0x90
 [<ffffffffa0099645>] :dvb_core:dvb_unregister_frontend+0xb5/0x100
 [<ffffffff80246150>] ? autoremove_wake_function+0x0/0x40
 [<ffffffffa021bf0d>] :dvb_usb:dvb_usb_adapter_frontend_exit+0x1d/0x40
 [<ffffffffa021b42c>] :dvb_usb:dvb_usb_exit+0x4c/0xe0
 [<ffffffffa021b505>] :dvb_usb:dvb_usb_device_exit+0x45/0x60
 [<ffffffffa00f3e47>] :usbcore:usb_unbind_interface+0x47/0x90
 [<ffffffff804cd57d>] __device_release_driver+0x9d/0xe0
 [<ffffffff804cd70b>] device_release_driver+0x2b/0x40
 [<ffffffff804cc9e5>] bus_remove_device+0xb5/0xf0
 [<ffffffff804cb133>] device_del+0x123/0x190
 [<ffffffffa00f1054>] :usbcore:usb_disable_device+0x94/0x120
 [<ffffffffa00ec233>] :usbcore:usb_disconnect+0xb3/0x140
 [<ffffffffa00ecf2e>] :usbcore:hub_thread+0x37e/0x1210
 [<ffffffff80209ccf>] ? __switch_to+0x1f/0x3b0
 [<ffffffff80246150>] ? autoremove_wake_function+0x0/0x40
 [<ffffffffa00ecbb0>] ? :usbcore:hub_thread+0x0/0x1210
 [<ffffffff80245bd9>] kthread+0x49/0x80
 [<ffffffff8020c1e8>] child_rip+0xa/0x12
 [<ffffffff80245b90>] ? kthread+0x0/0x80
 [<ffffffff8020c1de>] ? child_rip+0x0/0x12

y
tom



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
