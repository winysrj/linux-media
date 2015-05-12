Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41474 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932888AbbELOnF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2015 10:43:05 -0400
Message-ID: <55521177.6030009@iki.fi>
Date: Tue, 12 May 2015 17:43:03 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Adam Baker <linux@baker-net.org.uk>, linux-media@vger.kernel.org
Subject: Re: Locking in Si2157 and Si2168 drivers.
References: <554FD997.3020106@baker-net.org.uk>
In-Reply-To: <554FD997.3020106@baker-net.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/11/2015 01:20 AM, Adam Baker wrote:
> Hi,
>
> I think I've found a locking scenario that can potentially cause a
> deadlock situation in these drivers.
>
> I was trying to update the patch Antti Palosaari created to add support
> for signal stats to work with current git
> (https://patchwork.linuxtv.org/patch/25821/). I believe that the fact
> that this accesses the tuner I2C bus more frequently makes it much
> more likely to hit the issue but I suspect it exists but is very rare
> in the published kernel.
>
> When my version deadlocks I see call stacks for the two threads as
>
>
> [<ffffffff814e3bd4>] ? schedule_preempt_disabled+0x24/0x70
> [<ffffffff814e53ba>] ? __mutex_lock_slowpath+0x8a/0xf0
> [<ffffffff814e5436>] ? mutex_lock+0x16/0x25
> [<ffffffffa0722df7>] ? si2168_select+0x37/0x90 [si2168]
> [<ffffffffa070702f>] ? i2c_mux_master_xfer+0x2f/0x80 [i2c_mux]
> [<ffffffffa000c734>] ? __i2c_transfer+0x74/0x220 [i2c_core]
> [<ffffffffa000c961>] ? i2c_transfer+0x81/0xc0 [i2c_core]
> [<ffffffffa000c9d8>] ? i2c_master_send+0x38/0x50 [i2c_core]
> [<ffffffffa07b1134>] ? si2157_cmd_execute+0x44/0xd0 [si2157]
> [<ffffffff8101155e>] ? __switch_to+0xde/0x580
> [<ffffffffa07b1797>] ? si2157_stat_work+0x37/0x90 [si2157]
> [<ffffffff81078c0b>] ? process_one_work+0x14b/0x3c0
> [<ffffffff810792a4>] ? worker_thread+0x114/0x470
> [<ffffffff81079190>] ? rescuer_thread+0x310/0x310
> [<ffffffff8107dbe5>] ? kthread+0xc5/0xe0
> [<ffffffff8107db20>] ? kthread_create_on_node+0x170/0x170
> [<ffffffff814e6f7c>] ? ret_from_fork+0x7c/0xb0
> [<ffffffff8107db20>] ? kthread_create_on_node+0x170/0x170
>
>
> [<ffffffff814e575f>] ? __rt_mutex_slowlock+0x3f/0xc0
> [<ffffffff814e58e9>] ? rt_mutex_slowlock+0xa9/0x1e0
> [<ffffffff8108686f>] ? ttwu_do_wakeup+0xf/0xc0
> [<ffffffffa000c97d>] ? i2c_transfer+0x9d/0xc0 [i2c_core]
> [<ffffffffa000ca2b>] ? i2c_master_recv+0x3b/0x50 [i2c_core]
> [<ffffffffa07220ef>] ? si2168_cmd_execute+0x9f/0xd0 [si2168]
> [<ffffffffa07221a7>] ? si2168_read_status+0x87/0x170 [si2168]
> [<ffffffffa073d6a4>] ? dvb_frontend_ioctl_legacy.isra.9+0x94/0xb50 [dvb_core]
> [<ffffffff810baf3a>] ? hrtimer_try_to_cancel+0x3a/0xd0
> [<ffffffff810bafea>] ? hrtimer_cancel+0x1a/0x30
> [<ffffffff810ca35d>] ? futex_wait+0x17d/0x230
> [<ffffffff810ba890>] ? hrtimer_get_res+0x40/0x40
> [<ffffffffa073e260>] ? dvb_frontend_ioctl+0x100/0xe90 [dvb_core]
> [<ffffffffa0734970>] ? dvb_usercopy+0xa0/0x130 [dvb_core]
> [<ffffffffa073e160>] ? dvb_frontend_ioctl_legacy.isra.9+0xb50/0xb50 [dvb_core]
> [<ffffffff810cc355>] ? do_futex+0x105/0xa60
> [<ffffffff81197561>] ? cp_new_stat+0x111/0x130
> [<ffffffffa0734a1e>] ? dvb_generic_ioctl+0x1e/0x40 [dvb_core]
> [<ffffffff811a4a47>] ? do_vfs_ioctl+0x2e7/0x4f0
> [<ffffffff810ccd19>] ? SyS_futex+0x69/0x150
> [<ffffffff811a4cc9>] ? SyS_ioctl+0x79/0x90
> [<ffffffff814e7029>] ? system_call_fastpath+0x12/0x17
>
> I believe what has happened is the thread in the tuner has
>
> locked its own i2c_mutex in si2157_cmd_execute
> locked the parent bus_lock rt_mutex in i2c_transfer
> tried to lock the si2168 i2c_mutex in si2168_select
>
> The demod thread has locked its own i2c_mutex in si2168_cmd_execute
> tried to lock the adapter bus_lock rt_mutex in i2c_transfer
>
> Before I try to work out how to solve this it would be helpful to have
> a confirmation that I have understood the relationship between the various
> mutexes in use here. In particular I haven't completely followed the
> way parent I2C adapters are defined but it does seem logical that there
> should be one lock for the main bus and the bus on the far side of the
> gate.
>
> My current thought is that si2168_select doesn't need to take the
> si2168 i2c_mutex as the demod can't do anything with the bus anyway
> until the bus_lock is freed

You are correct about deadlock.

I2C mux adapter / adapter lock / used command IO, causes some headache here.

Reason why added that own lock to si2168 is that firmware command is 
executed using multiple I2C transactions, first request, then poll reply 
in a busy loop. I2C adapter lock covers only single transaction. So you 
have to limit somehow no other user could interrupt command execution.

Deadlock problem comes here only when si2168 is executing command and 
during that execution tuner driver makes request using si2168 I2C repeater.

normal case:
============================
-> si2168_read_status()
  -> si2168_cmd_execute()
   -> i2c_master_send()
       I2C adapter locked
       I2C adapter unlocked
   <- i2c_master_send()
   -> i2c_master_recv()
       I2C adapter locked
       I2C adapter unlocked
   <- i2c_master_recv()
  <- si2168_cmd_execute()
<- si2168_read_status()

Now, without the own "i2c_mutex" lock, tuner I2C request could interrupt 
reply polling as I2C adapter lock is released between i2c_master_send() 
and i2c_master_recv(). But having now 2 locks, I2C adapter lock and own 
"i2c_mutex" it leads to deadlock.

One solution is to use unlocked __i2c_transfer() and lock I2C adapter 
manually. IIRC there is also some kind of polling in I2C core when 
suitable error status is returned (EAGAIN?). Could that be used to delay 
tuner access? Feel free to study.

I am happy you pointed this out - it is clear tuner RSSI polling patch 
could not be merged before that issue is resolved. Thanks.

regards
Antti

-- 
http://palosaari.fi/
