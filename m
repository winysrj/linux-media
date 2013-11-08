Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757565Ab3KHUNr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Nov 2013 15:13:47 -0500
From: David Howells <dhowells@redhat.com>
To: Antti Palosaari <crope@iki.fi>
cc: dhowells@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jean Delvare <khali@linux-fr.org>, linux-media@vger.kernel.org
Subject: Deadlock between M88DS3103 and M88TS2022 drivers from I2C parentage
Date: Fri, 08 Nov 2013 20:13:03 +0000
Message-ID: <13806.1383941583@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Antti,

This patch:

	http://git.linuxtv.org/anttip/media_tree.git/commit/a0e4024e85ec053699bb4878ccc0800333f84a42

That sets the parentage relationship between the M88DS3103 and M88TS2022
drivers that you have here:

	http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/pctv_461e

can cause a deadlock:

[<ffffffff81648359>] schedule+0x29/0x70
[<ffffffff81649406>] __rt_mutex_slowlock+0x46/0xc0
[<ffffffff8164959f>] rt_mutex_slowlock+0xaf/0x180
[<ffffffff8164970c>] rt_mutex_lock+0x3c/0x40
[<ffffffffa0000595>] i2c_lock_adapter+0x25/0x40 [i2c_core]
[<ffffffffa0000bdd>] i2c_transfer+0x7d/0xc0 [i2c_core]
[<ffffffffa020a0aa>] m88ds3103_tuner_i2c_xfer+0x7a/0x170 [m88ds3103]
[<ffffffffa00001fc>] __i2c_transfer+0x5c/0x70 [i2c_core]
[<ffffffffa0000bbc>] i2c_transfer+0x5c/0xc0 [i2c_core]
[<ffffffffa0211516>] m88ts2022_rd_regs.isra.1.constprop.6+0x76/0xd0 [m88ts2022]
[<ffffffffa0212141>] m88ts2022_attach+0x61/0xf20 [m88ts2022]
[<ffffffffa0345184>] dvb_register+0x104/0x28a0 [cx23885]
[<ffffffff810b361a>] ? msg_print_text+0xea/0x1d0
[<ffffffff810b4854>] ? wake_up_klogd+0x34/0x50
[<ffffffff810b4a75>] ? console_unlock+0x205/0x3f0
[<ffffffffa025b1b2>] ? videobuf_queue_core_init+0x112/0x1e0 [videobuf_core]
[<ffffffffa0347dd8>] cx23885_dvb_register+0x128/0x160 [cx23885]
[<ffffffffa03425bf>] cx23885_initdev+0xf5f/0x12f0 [cx23885]
[<ffffffff8132a3fe>] local_pci_probe+0x3e/0x70
[<ffffffff8132b6e1>] pci_device_probe+0x121/0x130
[<ffffffff813ed587>] driver_probe_device+0x87/0x390
[<ffffffff813ed963>] __driver_attach+0x93/0xa0
[<ffffffff813ed8d0>] ? __device_attach+0x40/0x40
[<ffffffff813eb4c3>] bus_for_each_dev+0x63/0xa0
[<ffffffff813ecfde>] driver_attach+0x1e/0x20
[<ffffffff813ecb78>] bus_add_driver+0x1e8/0x2a0
[<ffffffffa0364000>] ? 0xffffffffa0363fff
[<ffffffff813edfa4>] driver_register+0x74/0x150
[<ffffffffa0364000>] ? 0xffffffffa0363fff
[<ffffffff8132a28b>] __pci_register_driver+0x4b/0x50
[<ffffffffa0364033>] cx23885_init+0x33/0x1000 [cx23885]
[<ffffffff810020fa>] do_one_initcall+0xfa/0x1b0
[<ffffffff810524b3>] ? set_memory_nx+0x43/0x50
[<ffffffff810cc62d>] load_module+0x1bbd/0x2660
[<ffffffff810c8930>] ? store_uevent+0x40/0x40
[<ffffffff810cd246>] SyS_finit_module+0x86/0xb0
[<ffffffff81652899>] system_call_fastpath+0x16/0x1b

The problem appears to be:

 (1) The i2c_lock_adapter() function will recurse up the tree to the ultimate
     ancestor of the specified i2c_adapter and lock that

 (2) m88ds3103_attach() sets up an i2c_adapter record for its tuner that calls
     back to the m88ds3103_tuner_i2c_xfer() function.

 (3) With the aforementioned patch, m88ds3103_attach() sets the tuner's
     i2c_adapter record parent pointer to point to the demod's i2c_adapter -
     thereby sharing the lock between them.

 (4) The m88ts2022 register functions call i2c_transfer() which locks the
     demod lock, not the tuner lock.  This goes to m88ds3103_tuner_i2c_xfer()
     to do the work, which calls i2c_transfer() again - which *also* tries to
     lock the demod lock.  Deadlock.

As an aside, should m88ds3103_tuner_i2c_xfer() close the gate again after it
has sent the message?

The way out looks like it might be give the tuner a pair of callbacks, one to
open the gate and one to close it.  Then have the tuner call the gate opener,
send the message itself and then call the gate closer.

David
