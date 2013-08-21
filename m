Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:52970 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3HUK4W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 06:56:22 -0400
Received: by mail-bk0-f43.google.com with SMTP id mz13so102727bkb.16
        for <linux-media@vger.kernel.org>; Wed, 21 Aug 2013 03:56:21 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 21 Aug 2013 18:56:21 +0800
Message-ID: <CALxrGmVAtz3x1aCUf5QArvp9J4ioXBObuhBdAL8J-p3yMeyppg@mail.gmail.com>
Subject: A false alarm for recursive lock in v4l2_ctrl_add_handler
From: Su Jiaquan <jiaquan.lnx@gmail.com>
To: hverkuil@xs4all.nl
Cc: linux-media <linux-media@vger.kernel.org>, jqsu@marvell.com,
	tianxf@marvell.com, xzhao10@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Recently when we enable LOCKDEP in our kernel, it detected a "possible
recursive locking". As we check the code, we found that it's just a
false alarm, the conceived scenario should never happen. Shell I
submit a patch to suppress it?

[    5.438446] c0 1 (swapper/0) =============================================
[    5.445526] c0 1 (swapper/0) [ INFO: possible recursive locking detected ]
[    5.452667] c0 1 (swapper/0) 3.4.39+ #2 Not tainted
[    5.457702] c0 1 (swapper/0) ---------------------------------------------
[    5.464874] c0 1 (swapper/0) swapper/0/1 is trying to acquire lock:
[    5.471252] c0 1 (swapper/0)  (&hdl->lock){+.+...}, at:
[<c03ca39c>] find_ref_lock+0x1c/0x3c
[    5.480499] c0 1 (swapper/0)
[    5.480499] c0 1 (swapper/0) but task is already holding lock:
[    5.489685] c0 1 (swapper/0)  (&hdl->lock){+.+...}, at:
[<c03cc7ec>] v4l2_ctrl_add_handler+0x48/0xa8
[    5.499603] c0 1 (swapper/0)
[    5.499633] c0 1 (swapper/0) other info that might help us debug this:
[    5.509521] c0 1 (swapper/0)  Possible unsafe locking scenario:
[    5.509521] c0 1 (swapper/0)
[    5.518768] c0 1 (swapper/0)        CPU0
[    5.522949] c0 1 (swapper/0)        ----
[    5.526977] c0 1 (swapper/0)   lock(&hdl->lock);
[    5.532073] c0 1 (swapper/0)   lock(&hdl->lock);
[    5.537078] c0 1 (swapper/0)
[    5.537078] c0 1 (swapper/0)  *** DEADLOCK ***
[    5.537109] c0 1 (swapper/0)
[    5.547973] c0 1 (swapper/0)  May be due to missing lock nesting notation
[    5.547973] c0 1 (swapper/0)
[    5.558135] c0 1 (swapper/0) 4 locks held by swapper/0/1:
[    5.563690] c0 1 (swapper/0)  #0:
(&__lockdep_no_validate__){......}, at: [<c034ae84>]
__driver_attach+0x40/0x8c
[    5.574859] c0 1 (swapper/0)  #1:
(&__lockdep_no_validate__){......}, at: [<c034ae94>]
__driver_attach+0x50/0x8c
[    5.585998] c0 1 (swapper/0)  #2:  (&ici->host_lock){+.+.+.}, at:
[<c03ddf3c>] soc_camera_host_register+0x1ac/0x8bc
[    5.597320] c0 1 (swapper/0)  #3:  (&hdl->lock){+.+...}, at:
[<c03cc7ec>] v4l2_ctrl_add_handler+0x48/0xa8
[    5.607757] c0 1 (swapper/0)
[    5.607757] c0 1 (swapper/0) stack backtrace:
[    5.615386] c0 1 (swapper/0) [<c0113d54>]
(unwind_backtrace+0x0/0x11c) from [<c0178c98>]
(__lock_acquire+0x17d8/0x187c)
[    5.626556] c0 1 (swapper/0) [<c0178c98>]
(__lock_acquire+0x17d8/0x187c) from [<c0179304>]
(lock_acquire+0x128/0x14c)
[    5.637512] c0 1 (swapper/0) [<c0179304>]
(lock_acquire+0x128/0x14c) from [<c05f52d0>]
(mutex_lock_nested+0x4c/0x3b0)
[    5.648406] c0 1 (swapper/0) [<c05f52d0>]
(mutex_lock_nested+0x4c/0x3b0) from [<c03ca39c>]
(find_ref_lock+0x1c/0x3c)
[    5.659210] c0 1 (swapper/0) [<c03ca39c>] (find_ref_lock+0x1c/0x3c)
from [<c03cc19c>] (handler_new_ref+0x34/0x18c)
[    5.669921] c0 1 (swapper/0) [<c03cc19c>]
(handler_new_ref+0x34/0x18c) from [<c03cc820>]
(v4l2_ctrl_add_handler+0x7c/0xa8)
[    5.681243] c0 1 (swapper/0) [<c03cc820>]
(v4l2_ctrl_add_handler+0x7c/0xa8) from [<c03de1a8>]
(soc_camera_host_register+0x418/0x8bc)
[    5.693481] c0 1 (swapper/0) [<c03de1a8>]
(soc_camera_host_register+0x418/0x8bc) from [<c05e9210>]
(mmp_camera_probe+0x168/0x1b0)
[    5.705474] c0 1 (swapper/0) [<c05e9210>]
(mmp_camera_probe+0x168/0x1b0) from [<c034bf30>]
(platform_drv_probe+0x14/0x18)
[    5.716766] c0 1 (swapper/0) [<c034bf30>]
(platform_drv_probe+0x14/0x18) from [<c034ac2c>]
(driver_probe_device+0x144/0x35c)
[    5.728393] c0 1 (swapper/0) [<c034ac2c>]
(driver_probe_device+0x144/0x35c) from [<c034aeac>]
(__driver_attach+0x68/0x8c)
[    5.739685] c0 1 (swapper/0) [<c034aeac>]
(__driver_attach+0x68/0x8c) from [<c0349270>]
(bus_for_each_dev+0x50/0x90)
[    5.750579] c0 1 (swapper/0) [<c0349270>]
(bus_for_each_dev+0x50/0x90) from [<c034a1e8>]
(bus_add_driver+0xd0/0x264)
[    5.761474] c0 1 (swapper/0) [<c034a1e8>]
(bus_add_driver+0xd0/0x264) from [<c034b3b0>]
(driver_register+0x9c/0x128)
[    5.772369] c0 1 (swapper/0) [<c034b3b0>]
(driver_register+0x9c/0x128) from [<c01085ac>]
(do_one_initcall+0x90/0x164)
[    5.783355] c0 1 (swapper/0) [<c01085ac>]
(do_one_initcall+0x90/0x164) from [<c08168e0>]
(kernel_init+0xf8/0x1b8)
[    5.793975] c0 1 (swapper/0) [<c08168e0>] (kernel_init+0xf8/0x1b8)
from [<c010ecac>] (kernel_thread_exit+0x0/0x8)


mmp_camera_probe is our own camera driver, but suppose any camera
driver that register a soc_camera_host can trigger then same scenario.
The warning suggests when calling v4l2_ctrl_add_handler, @hdl and @add
are both passed to it, v4l2_ctrl_add_handler first lock @add with:

if (hdl->error)
        return hdl->error;
    mutex_lock(add->lock); <-- HERE!
    list_for_each_entry(ref, &add->ctrl_refs, node) {

later in handler_new_ref(hdl, ctrl), @hdl will be locked too:

static struct v4l2_ctrl_ref *find_ref_lock(
        struct v4l2_ctrl_handler *hdl, u32 id)
{
    struct v4l2_ctrl_ref *ref = NULL;

    if (hdl) {
        mutex_lock(hdl->lock);
        ref = find_ref(hdl, id);
        mutex_unlock(hdl->lock);
    }
    return ref;
}

So LOCKDEP conceives if two process each runs
v4l2_ctrl_add_handler(handler_A, handler_B) and
v4l2_ctrl_add_handler(handler_B, handler_A), a deadlock can happen.

As we know this should never happen becase any reasonable driver will
only add inferior handler to a superior handler, but never in the
reverse order. So this is a false alarm. I think we can suppress this
warning, in v4l2_ctrl_add_handler simply change

    if (hdl->error)
        return hdl->error;
-    mutex_lock(add->lock);
+    mutex_lock_nested(add->lock, SINGLE_DEPTH_NESTING);
    list_for_each_entry(ref, &add->ctrl_refs, node) {
        struct v4l2_ctrl *ctrl = ref->ctrl;

What do you think? if you confirm this as a false alarm, I can submit
a patch to fix it.

Jiaquan
