Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43045 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaLQTtD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Dec 2014 14:49:03 -0500
Received: from dyn3-82-128-190-202.psoas.suomi.net ([82.128.190.202] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1Y1Kaj-0007Nv-7U
	for linux-media@vger.kernel.org; Wed, 17 Dec 2014 21:49:01 +0200
Message-ID: <5491DE2C.3070604@iki.fi>
Date: Wed, 17 Dec 2014 21:49:00 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: RegMap recursive locking I2C mux adapter
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!
After I converted some drivers to RegMap, I ran following lockdep 
warning about recursive locking and possible deadlock.

That is because tuner driver access I2C bus through demod driver and 
both drivers are using RegMap. It does not happen if tuner driver does 
not use RegMap API, but plain I2C access. As demod provides I2C bus for 
tuner driver it is natural there is two RegMap locks which are called 
nested order, tuner access I2C, but those RegMaps (mutex) are different. 
For my eyes this looks false positive?

Here is what connections looks like:
  ___________         ____________         ____________
|  USB IF   |       |   demod    |       |    tuner   |
|-----------|       |------------|       |------------|
|           |--I2C--|-----/ -----|--I2C--|            |
|I2C master |       |  I2C mux   |       | I2C slave  |
|___________|       |____________|       |____________|


** regmap_unlock_mutex=ffff8800b11a9000 mutex=ffff8800b11a9000
** regmap_lock_mutex=ffff8800b11a9000 mutex=ffff8800b11a9000
** regmap_unlock_mutex=ffff8800b11a9000 mutex=ffff8800b11a9000
** regmap_lock_mutex=ffff8800b11a9000 mutex=ffff8800b11a9000
** regmap_unlock_mutex=ffff8800b11a9000 mutex=ffff8800b11a9000
** regmap_lock_mutex=ffff8800b11aa800 mutex=ffff8800b11aa800
** regmap_lock_mutex=ffff8800b11a9000 mutex=ffff8800b11a9000

=============================================
[ INFO: possible recursive locking detected ]
3.18.0-rc4+ #4 Tainted: G           O
---------------------------------------------
kdvb-ad-0-fe-0/2814 is trying to acquire lock:
  (&map->mutex){+.+.+.}, at: [<ffffffff814ec90f>] 
regmap_lock_mutex+0x2f/0x40

but task is already holding lock:
  (&map->mutex){+.+.+.}, at: [<ffffffff814ec90f>] 
regmap_lock_mutex+0x2f/0x40

other info that might help us debug this:
  Possible unsafe locking scenario:
        CPU0
        ----
   lock(&map->mutex);
   lock(&map->mutex);

  *** DEADLOCK ***
  May be due to missing lock nesting notation
1 lock held by kdvb-ad-0-fe-0/2814:
  #0:  (&map->mutex){+.+.+.}, at: [<ffffffff814ec90f>] 
regmap_lock_mutex+0x2f/0x40

stack backtrace:
CPU: 3 PID: 2814 Comm: kdvb-ad-0-fe-0 Tainted: G           O 
3.18.0-rc4+ #4
Hardware name: System manufacturer System Product Name/M5A78L-M/USB3, 
BIOS 2001    09/11/2014
  0000000000000000 00000000410c8772 ffff880293af3868 ffffffff817a6f82
  0000000000000000 ffff8800b3462be0 ffff880293af3968 ffffffff810e7f94
  ffff880293af3888 00000000410c8772 ffffffff82dfee60 ffffffff81ab8f89
Call Trace:
  [<ffffffff817a6f82>] dump_stack+0x4e/0x68
  [<ffffffff810e7f94>] __lock_acquire+0x1ea4/0x1f50
  [<ffffffff810e2a7d>] ? trace_hardirqs_off+0xd/0x10
  [<ffffffff817b01f3>] ? _raw_spin_lock_irqsave+0x83/0xa0
  [<ffffffff810e13e6>] ? up+0x16/0x50
  [<ffffffff810e2a7d>] ? trace_hardirqs_off+0xd/0x10
  [<ffffffff817af8bf>] ? _raw_spin_unlock_irqrestore+0x5f/0x70
  [<ffffffff810e9069>] lock_acquire+0xc9/0x170
  [<ffffffff814ec90f>] ? regmap_lock_mutex+0x2f/0x40
  [<ffffffff817ab50e>] mutex_lock_nested+0x7e/0x430
  [<ffffffff814ec90f>] ? regmap_lock_mutex+0x2f/0x40
  [<ffffffff814ec90f>] ? regmap_lock_mutex+0x2f/0x40
  [<ffffffff817a530b>] ? printk+0x70/0x86
  [<ffffffff8110d9e8>] ? mod_timer+0x168/0x240
  [<ffffffff814ec90f>] regmap_lock_mutex+0x2f/0x40
  [<ffffffff814f08d9>] regmap_update_bits+0x29/0x60
  [<ffffffffa03e9778>] rtl2832_select+0x38/0x70 [rtl2832]
  [<ffffffffa039b03d>] i2c_mux_master_xfer+0x3d/0x90 [i2c_mux]
  [<ffffffff815da493>] __i2c_transfer+0x73/0x2e0
  [<ffffffff815dbaba>] i2c_transfer+0x5a/0xc0
  [<ffffffff815dbb6e>] i2c_master_send+0x4e/0x70
  [<ffffffffa03ff25a>] regmap_i2c_write+0x1a/0x50 [regmap_i2c]
  [<ffffffff817ab713>] ? mutex_lock_nested+0x283/0x430
  [<ffffffff814f06b2>] _regmap_raw_write+0x862/0x880
  [<ffffffff814ec90f>] ? regmap_lock_mutex+0x2f/0x40
  [<ffffffff814f0744>] _regmap_bus_raw_write+0x74/0xa0
  [<ffffffff814ef3d2>] _regmap_write+0x92/0x140
  [<ffffffff814f0b7b>] regmap_write+0x4b/0x70
  [<ffffffffa032b090>] ? dvb_frontend_release+0x110/0x110 [dvb_core]
  [<ffffffffa05141d4>] e4000_init+0x34/0x210 [e4000]
  [<ffffffffa032a029>] dvb_frontend_init+0x59/0xc0 [dvb_core]
  [<ffffffff810bde30>] ? finish_task_switch+0x80/0x180
  [<ffffffff810bddf2>] ? finish_task_switch+0x42/0x180
  [<ffffffffa032b116>] dvb_frontend_thread+0x86/0x7b0 [dvb_core]
  [<ffffffff817a9203>] ? __schedule+0x343/0x930
  [<ffffffffa032b090>] ? dvb_frontend_release+0x110/0x110 [dvb_core]
  [<ffffffff810b826b>] kthread+0x10b/0x130
  [<ffffffff81020099>] ? sched_clock+0x9/0x10
  [<ffffffff810b8160>] ? kthread_create_on_node+0x250/0x250
  [<ffffffff817b063c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b8160>] ? kthread_create_on_node+0x250/0x250
** regmap_unlock_mutex=ffff8800b11a9000 mutex=ffff8800b11a9000
** regmap_unlock_mutex=ffff8800b11aa800 mutex=ffff8800b11aa800
** regmap_lock_mutex=ffff8800b11aa800 mutex=ffff8800b11aa800
** regmap_lock_mutex=ffff8800b11a9000 mutex=ffff8800b11a9000
** regmap_unlock_mutex=ffff8800b11a9000 mutex=ffff8800b11a9000
** regmap_unlock_mutex=ffff8800b11aa800 mutex=ffff8800b11aa800
** regmap_lock_mutex=ffff8800b11aa800 mutex=ffff8800b11aa800
** regmap_lock_mutex=ffff8800b11a9000 mutex=ffff8800b11a9000
** regmap_unlock_mutex=ffff8800b11a9000 mutex=ffff8800b11a9000
** regmap_unlock_mutex=ffff8800b11aa800 mutex=ffff8800b11aa800
** regmap_lock_mutex=ffff8800b11aa800 mutex=ffff8800b11aa800

Antti

-- 
http://palosaari.fi/
