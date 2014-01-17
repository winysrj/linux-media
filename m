Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34746 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaAQPOT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 10:14:19 -0500
Message-ID: <52D948C9.60807@iki.fi>
Date: Fri, 17 Jan 2014 17:14:17 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 6/6] v4l: disable lockdep on vb2_fop_mmap()
References: <1388292700-18369-1-git-send-email-crope@iki.fi> <1388292700-18369-7-git-send-email-crope@iki.fi> <52D90012.6080608@xs4all.nl>
In-Reply-To: <52D90012.6080608@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

On 17.01.2014 12:04, Hans Verkuil wrote:
> Hi Antti,
>
> Is this still needed after this commit was merged?
>
> http://git.linuxtv.org/media_tree.git/commit/b18a8ff29d80b132018d33479e86ab8ecaee6b46

It didn't fix the problem.

I could reproduce that issue easily using vivi and Cheese (webcam app).

1) Compile Kernel with lockdep debug. For me these seems to be enabled:
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_LOCKDEP=y
CONFIG_DEBUG_LOCKDEP=y

2) Load virtual video driver (vivi)
# modprobe vivi

3) Start Cheese
$ cheese

Lockdep error appears to system log just after Cheese is started. I 
think it is related to mmap.

regards
Antti


tammi 17 17:07:38 localhost.localdomain kernel: media: Linux media 
interface: v0.10
tammi 17 17:07:38 localhost.localdomain kernel: Linux video capture 
interface: v2.00
tammi 17 17:07:38 localhost.localdomain kernel: vivi-000: V4L2 device 
registered as video0
tammi 17 17:07:38 localhost.localdomain kernel: Video Technology 
Magazine Virtual Video Capture Board ver 0.8.1 successfully loaded.
tammi 17 17:07:50 localhost.localdomain /etc/gdm/Xsession[1521]: Window 
manager warning: Buggy client sent a _NET_ACTIVE_WINDOW message with a 
timestamp of 0 for 0x3200024 (Cheese)
tammi 17 17:07:50 localhost.localdomain /etc/gdm/Xsession[1521]: Window 
manager warning: meta_window_activate called by a pager with a 0 
timestamp; the pager needs to be fixed.
tammi 17 17:07:50 localhost.localdomain kernel: tammi 17 17:07:50 
localhost.localdomain kernel: 
======================================================
tammi 17 17:07:50 localhost.localdomain kernel: [ INFO: possible 
circular locking dependency detected ]
tammi 17 17:07:50 localhost.localdomain kernel: 3.13.0-rc1+ #79 Tainted: 
G         C O
tammi 17 17:07:50 localhost.localdomain kernel: 
-------------------------------------------------------
tammi 17 17:07:50 localhost.localdomain kernel: video_source:sr/8871 is 
trying to acquire lock:
tammi 17 17:07:50 localhost.localdomain kernel: 
(&dev->mutex#2){+.+.+.}, at: [<ffffffffa06a8df3>] vb2_fop_mmap+0x33/0x90 
[videobuf2_core]
tammi 17 17:07:50 localhost.localdomain kernel:
                                                 but task is already 
holding lock:
tammi 17 17:07:50 localhost.localdomain kernel: 
(&mm->mmap_sem){++++++}, at: [<ffffffff8117825f>] vm_mmap_pgoff+0x6f/0xc0
tammi 17 17:07:50 localhost.localdomain kernel:
                                                 which lock already 
depends on the new lock.
tammi 17 17:07:50 localhost.localdomain kernel:
                                                 the existing dependency 
chain (in reverse order) is:
tammi 17 17:07:50 localhost.localdomain kernel:
                                                 -> #1 
(&mm->mmap_sem){++++++}:
tammi 17 17:07:50 localhost.localdomain kernel: 
[<ffffffff810bb386>] __lock_acquire+0x3d6/0xc40
tammi 17 17:07:50 localhost.localdomain kernel: 
[<ffffffff810bbca0>] lock_acquire+0xb0/0x150
tammi 17 17:07:50 localhost.localdomain kernel: 
[<ffffffff81181f3c>] might_fault+0x8c/0xb0
tammi 17 17:07:50 localhost.localdomain kernel: 
[<ffffffffa067dc15>] video_usercopy+0x375/0x5e0 [videodev]
tammi 17 17:07:50 localhost.localdomain kernel: 
[<ffffffffa067de95>] video_ioctl2+0x15/0x20 [videodev]
tammi 17 17:07:50 localhost.localdomain kernel: 
[<ffffffffa0677703>] v4l2_ioctl+0x123/0x160 [videodev]
tammi 17 17:07:50 localhost.localdomain kernel: 
[<ffffffff811e0590>] do_vfs_ioctl+0x300/0x520
tammi 17 17:07:50 localhost.localdomain kernel: 
[<ffffffff811e0831>] SyS_ioctl+0x81/0xa0
tammi 17 17:07:50 localhost.localdomain kernel: 
[<ffffffff816ca729>] system_call_fastpath+0x16/0x1b
tammi 17 17:07:50 localhost.localdomain kernel:
                                                 -> #0 
(&dev->mutex#2){+.+.+.}:
tammi 17 17:07:50 localhost.localdomain kernel: 
[<ffffffff810b96b7>] validate_chain.isra.36+0x10d7/0x1130
tammi 17 17:07:50 localhost.localdomain kernel: 
[<ffffffff810bb386>] __lock_acquire+0x3d6/0xc40
tammi 17 17:07:50 localhost.localdomain kernel: 
[<ffffffff810bbca0>] lock_acquire+0xb0/0x150
tammi 17 17:07:50 localhost.localdomain kernel: 
[<ffffffff816bf1c7>] mutex_lock_interruptible_nested+0x77/0x460
tammi 17 17:07:50 localhost.localdomain kernel: 
[<ffffffffa06a8df3>] vb2_fop_mmap+0x33/0x90 [videobuf2_core]
tammi 17 17:07:50 localhost.localdomain kernel: 
[<ffffffffa067711a>] v4l2_mmap+0x5a/0xa0 [videodev]
tammi 17 17:07:50 localhost.localdomain kernel: 
[<ffffffff8118da7d>] mmap_region+0x3cd/0x5a0
tammi 17 17:07:50 localhost.localdomain kernel: 
[<ffffffff8118dfa7>] do_mmap_pgoff+0x357/0x3e0
tammi 17 17:07:50 localhost.localdomain kernel: 
[<ffffffff81178280>] vm_mmap_pgoff+0x90/0xc0
tammi 17 17:07:50 localhost.localdomain kernel: 
[<ffffffff8118c553>] SyS_mmap_pgoff+0x1d3/0x270
tammi 17 17:07:50 localhost.localdomain kernel: 
[<ffffffff810191a2>] SyS_mmap+0x22/0x30
tammi 17 17:07:50 localhost.localdomain kernel: 
[<ffffffff816ca729>] system_call_fastpath+0x16/0x1b
tammi 17 17:07:50 localhost.localdomain kernel:
                                                 other info that might 
help us debug this:
tammi 17 17:07:50 localhost.localdomain kernel:  Possible unsafe locking 
scenario:
tammi 17 17:07:50 localhost.localdomain kernel:        CPU0 
        CPU1
tammi 17 17:07:50 localhost.localdomain kernel:        ---- 
        ----
tammi 17 17:07:50 localhost.localdomain kernel:   lock(&mm->mmap_sem);
tammi 17 17:07:50 localhost.localdomain kernel: 
        lock(&dev->mutex#2);
tammi 17 17:07:50 localhost.localdomain kernel: 
        lock(&mm->mmap_sem);
tammi 17 17:07:50 localhost.localdomain kernel:   lock(&dev->mutex#2);
tammi 17 17:07:50 localhost.localdomain kernel:
                                                  *** DEADLOCK ***
tammi 17 17:07:50 localhost.localdomain kernel: 1 lock held by 
video_source:sr/8871:
tammi 17 17:07:50 localhost.localdomain kernel:  #0: 
(&mm->mmap_sem){++++++}, at: [<ffffffff8117825f>] vm_mmap_pgoff+0x6f/0xc0
tammi 17 17:07:50 localhost.localdomain kernel:
                                                 stack backtrace:
tammi 17 17:07:50 localhost.localdomain kernel: CPU: 3 PID: 8871 Comm: 
video_source:sr Tainted: G         C O 3.13.0-rc1+ #79
tammi 17 17:07:50 localhost.localdomain kernel: Hardware name: System 
manufacturer System Product Name/M5A78L-M/USB3, BIOS 1801    11/12/2013
tammi 17 17:07:50 localhost.localdomain kernel:  ffffffff824f9bd0 
ffff880083075b68 ffffffff816b8da9 ffffffff824f9bd0
tammi 17 17:07:50 localhost.localdomain kernel:  ffff880083075ba8 
ffffffff816b2c9b ffff880083075be0 0000000000000000
tammi 17 17:07:50 localhost.localdomain kernel:  ffff8801ee6fc378 
0000000000000001 ffff8801ee6fbcf0 ffff8801ee6fc378
tammi 17 17:07:50 localhost.localdomain kernel: Call Trace:
tammi 17 17:07:50 localhost.localdomain kernel:  [<ffffffff816b8da9>] 
dump_stack+0x4d/0x66
tammi 17 17:07:50 localhost.localdomain kernel:  [<ffffffff816b2c9b>] 
print_circular_bug+0x200/0x20e
tammi 17 17:07:50 localhost.localdomain kernel:  [<ffffffff810b96b7>] 
validate_chain.isra.36+0x10d7/0x1130
tammi 17 17:07:50 localhost.localdomain kernel:  [<ffffffff810bb3a7>] ? 
__lock_acquire+0x3f7/0xc40
tammi 17 17:07:50 localhost.localdomain kernel:  [<ffffffff8101c413>] ? 
native_sched_clock+0x13/0x80
tammi 17 17:07:50 localhost.localdomain kernel:  [<ffffffff810bb386>] 
__lock_acquire+0x3d6/0xc40
tammi 17 17:07:50 localhost.localdomain kernel:  [<ffffffff8101c413>] ? 
native_sched_clock+0x13/0x80
tammi 17 17:07:50 localhost.localdomain kernel:  [<ffffffff8101c489>] ? 
sched_clock+0x9/0x10
tammi 17 17:07:50 localhost.localdomain kernel:  [<ffffffff810bbca0>] 
lock_acquire+0xb0/0x150
tammi 17 17:07:50 localhost.localdomain kernel:  [<ffffffffa06a8df3>] ? 
vb2_fop_mmap+0x33/0x90 [videobuf2_core]
tammi 17 17:07:50 localhost.localdomain kernel:  [<ffffffff816bf1c7>] 
mutex_lock_interruptible_nested+0x77/0x460
tammi 17 17:07:50 localhost.localdomain kernel:  [<ffffffffa06a8df3>] ? 
vb2_fop_mmap+0x33/0x90 [videobuf2_core]
tammi 17 17:07:50 localhost.localdomain kernel:  [<ffffffffa06a8df3>] ? 
vb2_fop_mmap+0x33/0x90 [videobuf2_core]
tammi 17 17:07:50 localhost.localdomain kernel:  [<ffffffffa06a8df3>] 
vb2_fop_mmap+0x33/0x90 [videobuf2_core]
tammi 17 17:07:50 localhost.localdomain kernel:  [<ffffffffa067711a>] 
v4l2_mmap+0x5a/0xa0 [videodev]
tammi 17 17:07:50 localhost.localdomain kernel:  [<ffffffff8118da7d>] 
mmap_region+0x3cd/0x5a0
tammi 17 17:07:50 localhost.localdomain kernel:  [<ffffffff8118dfa7>] 
do_mmap_pgoff+0x357/0x3e0
tammi 17 17:07:50 localhost.localdomain kernel:  [<ffffffff81178280>] 
vm_mmap_pgoff+0x90/0xc0
tammi 17 17:07:50 localhost.localdomain kernel:  [<ffffffff8118c553>] 
SyS_mmap_pgoff+0x1d3/0x270
tammi 17 17:07:50 localhost.localdomain kernel:  [<ffffffff810191a2>] 
SyS_mmap+0x22/0x30
tammi 17 17:07:50 localhost.localdomain kernel:  [<ffffffff816ca729>] 
system_call_fastpath+0x16/0x1b





>
> Regards,
>
> 	Hans
>
> On 12/29/2013 05:51 AM, Antti Palosaari wrote:
>> Avoid that lockdep warning:
>>
>> [ INFO: possible circular locking dependency detected ]
>> 3.13.0-rc1+ #77 Tainted: G         C O
>> -------------------------------------------------------
>> video_source:sr/32072 is trying to acquire lock:
>>   (&dev->mutex#2){+.+.+.}, at: [<ffffffffa073fde3>] vb2_fop_mmap+0x33/0x90 [videobuf2_core]
>>
>>                                                  but task is already holding lock:
>>   (&mm->mmap_sem){++++++}, at: [<ffffffff8117825f>] vm_mmap_pgoff+0x6f/0xc0
>>
>>   Possible unsafe locking scenario:
>>         CPU0                    CPU1
>>         ----                    ----
>>    lock(&mm->mmap_sem);
>>                                 lock(&dev->mutex#2);
>>                                 lock(&mm->mmap_sem);
>>    lock(&dev->mutex#2);
>>                                                   *** DEADLOCK ***
>>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>   drivers/media/v4l2-core/videobuf2-core.c | 14 +++++++++++++-
>>   1 file changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index 12df9fd..2a74295 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -2641,12 +2641,24 @@ int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
>>   	struct video_device *vdev = video_devdata(file);
>>   	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
>>   	int err;
>> +	/*
>> +	 * FIXME: Ugly hack. Disable possible lockdep as it detects possible
>> +	 * deadlock. "INFO: possible circular locking dependency detected"
>> +	 */
>> +	lockdep_off();
>>
>> -	if (lock && mutex_lock_interruptible(lock))
>> +	if (lock && mutex_lock_interruptible(lock)) {
>> +		lockdep_on();
>>   		return -ERESTARTSYS;
>> +	}
>> +
>>   	err = vb2_mmap(vdev->queue, vma);
>> +
>>   	if (lock)
>>   		mutex_unlock(lock);
>> +
>> +	lockdep_on();
>> +
>>   	return err;
>>   }
>>   EXPORT_SYMBOL_GPL(vb2_fop_mmap);
>>
>


-- 
http://palosaari.fi/
