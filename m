Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbbFHSSQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2015 14:18:16 -0400
Message-ID: <5575DC66.2060208@redhat.com>
Date: Mon, 08 Jun 2015 11:18:14 -0700
From: Laura Abbott <labbott@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: BUG: sleeping function called from invalid context at drivers/media/common/siano/smscoreapi.c:1655
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

We've gotten several reports of sleeping in atomic from the siano driver:

BUG: sleeping function called from invalid context at drivers/media/common/siano/smscoreapi.c:1655
in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: swapper/0
no locks held by swapper/0/0.
irq event stamp: 523335
hardirqs last  enabled at (523334): [<ffffffff8161c415>] __usb_hcd_giveback_urb+0xd5/0x170
hardirqs last disabled at (523335): [<ffffffff8161c3c5>] __usb_hcd_giveback_urb+0x85/0x170
softirqs last  enabled at (523324): [<ffffffff810b11b1>] _local_bh_enable+0x21/0x50
softirqs last disabled at (523325): [<ffffffff810b3245>] irq_exit+0x145/0x150
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.0.4-301.fc22.x86_64+debug #1
Hardware name: MSI MS-7788/H61M-P20 (G3) (MS-7788), BIOS V1.9 01/10/2013
  0000000000000000 04dae392e057b00a ffff880216803cd8 ffffffff81881788
  0000000000000000 ffffffff81e124e0 ffff880216803d08 ffffffff810dc669
  ffff880216803d28 ffffffffa0427290 0000000000000677 0000000000000000
Call Trace:
  <IRQ>  [<ffffffff81881788>] dump_stack+0x4c/0x65
  [<ffffffff810dc669>] ___might_sleep+0x189/0x250
  [<ffffffff810dc77d>] __might_sleep+0x4d/0x90
  [<ffffffffa0420a85>] smscore_getbuffer+0x35/0xc0 [smsmdtv]
  [<ffffffffa042015e>] ? list_add_locked+0x3e/0x50 [smsmdtv]
  [<ffffffffa04122ed>] smsusb_submit_urb+0x9d/0xd0 [smsusb]
  [<ffffffffa04123e0>] smsusb_onresponse+0xc0/0x1d0 [smsusb]
  [<ffffffff8161c3ce>] __usb_hcd_giveback_urb+0x8e/0x170
  [<ffffffff8161c556>] usb_giveback_urb_bh+0xa6/0x100
  [<ffffffff810b194f>] tasklet_action+0x1af/0x2c0
  [<ffffffff810b2a3c>] __do_softirq+0xec/0x670
  [<ffffffff810b3245>] irq_exit+0x145/0x150
  [<ffffffff8188e248>] do_IRQ+0x58/0xf0
  [<ffffffff8188bdf2>] common_interrupt+0x72/0x72
  <EOI>  [<ffffffff816e06f2>] ? cpuidle_enter_state+0x62/0x2f0
  [<ffffffff816e06eb>] ? cpuidle_enter_state+0x5b/0x2f0
  [<ffffffff816e09b7>] cpuidle_enter+0x17/0x20
  [<ffffffff810ff5e4>] cpu_startup_entry+0x374/0x5e0
  [<ffffffff818767a8>] rest_init+0x138/0x140
  [<ffffffff8212c074>] start_kernel+0x4d4/0x4f5
  [<ffffffff8212b120>] ? early_idt_handlers+0x120/0x120
  [<ffffffff8212b339>] x86_64_start_reservations+0x2a/0x2c
  [<ffffffff8212b49c>] x86_64_start_kernel+0x161/0x184

I didn't see any fixes already present in the tree and I don't know
enough about the driver to get around the wait_event. Any ideas?

Thanks,
Laura
