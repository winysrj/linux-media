Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:33169 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbbGSOkg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2015 10:40:36 -0400
Received: by igbpg9 with SMTP id pg9so22697593igb.0
        for <linux-media@vger.kernel.org>; Sun, 19 Jul 2015 07:40:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55A8C1C8.9040909@xs4all.nl>
References: <1435318645-20565-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
	<55A8C1C8.9040909@xs4all.nl>
Date: Sun, 19 Jul 2015 17:40:35 +0300
Message-ID: <CALi4nho_C2ffjryTREBy2V7X+W1Hpcu6SZFW8q+r+xhBagmgTw@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] V4L2: platform: Add Renesas R-Car JPEG codec driver.
From: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"j.anaszewski" <j.anaszewski@samsung.com>,
	Kamil Debski <kamil@wypas.org>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I've made some changes to driver(mostly minor, like  sequence v4l2_buf
field filling and so on)to make it pass "v4l2-compliance -s" test(MMAP
part), but suddenly get stuck with USERPTR part. First there is WARN
about zero bytesused.
I suppose it should be fixed in v4l2-compliance, is that correct? Or
driver should handle it somehow(maybe drop buffers with zero bytesused
in buf_queue)?
Second there is possible deadlock warning... AFAIU it's false
positive. Is that correct?

Here is logs.

[   40.664929] ======================================================
[   40.671241] [ INFO: possible circular locking dependency detected ]
[   40.677644] 4.1.0-dirty #8 Tainted: G        W
[   40.682714] -------------------------------------------------------
[   40.689114] v4l2-compliance/781 is trying to acquire lock:
[   40.694715]  (&mm->mmap_sem){++++++}, at: [<c02a3e54>]
__buf_prepare+0x258/0x340
[   40.702326]
but task is already holding lock:
[   40.708284]  (&jpu->mutex){+.+.+.}, at: [<c028f580>] v4l2_ioctl+0x58/0xa4
[   40.715272]
which lock already depends on the new lock.

[   40.723628]
the existing dependency chain (in reverse order) is:
[   40.731271]
-> #1 (&jpu->mutex){+.+.+.}:
[   40.735501]        [<c029faac>] v4l2_m2m_fop_mmap+0x4c/0x70
[   40.741207]        [<c028f4e8>] v4l2_mmap+0x40/0x80
[   40.746205]        [<c00c75b0>] mmap_region+0x2cc/0x538
[   40.751560]        [<c00c7aec>] do_mmap_pgoff+0x2d0/0x344
[   40.757090]        [<c00b70a4>] vm_mmap_pgoff+0x64/0x94
[   40.762441]        [<c00c5e28>] SyS_mmap_pgoff+0x68/0x98
[   40.767882]        [<c000fe00>] ret_fast_syscall+0x0/0x54
[   40.773414]
-> #0 (&mm->mmap_sem){++++++}:
[   40.777820]        [<c03f3558>] down_read+0x3c/0x80
[   40.782819]        [<c02a3e54>] __buf_prepare+0x258/0x340
[   40.788348]        [<c02a577c>] vb2_internal_qbuf+0x50/0x1ec
[   40.794143]        [<c029f3dc>] v4l2_m2m_qbuf+0x20/0x38
[   40.799497]        [<c0292a18>] v4l_qbuf+0x3c/0x40
[   40.804405]        [<c02941bc>] __video_do_ioctl+0x17c/0x28c
[   40.810200]        [<c0294564>] video_usercopy+0x298/0x404
[   40.815817]        [<c028f5a4>] v4l2_ioctl+0x7c/0xa4
[   40.820903]        [<c00eb158>] do_vfs_ioctl+0x5f4/0x65c
[   40.826344]        [<c00eb1f4>] SyS_ioctl+0x34/0x58
[   40.831341]        [<c000fe00>] ret_fast_syscall+0x0/0x54
[   40.836872]
other info that might help us debug this:

[   40.845050]  Possible unsafe locking scenario:

[   40.851098]        CPU0                    CPU1
[   40.855725]        ----                    ----
[   40.860350]   lock(&jpu->mutex);
[   40.863669]                                lock(&mm->mmap_sem);
[   40.869735]                                lock(&jpu->mutex);
[   40.875623]   lock(&mm->mmap_sem);
[   40.879119]
 *** DEADLOCK ***

[   40.885173] 1 lock held by v4l2-compliance/781:
[   40.889799]  #0:  (&jpu->mutex){+.+.+.}, at: [<c028f580>]
v4l2_ioctl+0x58/0xa4
[   40.897240]
stack backtrace:
[   40.901700] CPU: 0 PID: 781 Comm: v4l2-compliance Tainted: G
W       4.1.0-dirty #8
[   40.910140] Hardware name: Generic R8A7791 (Flattened Device Tree)
[   40.916469] [<c0015c6c>] (unwind_backtrace) from [<c0012b48>]
(show_stack+0x10/0x14)
[   40.924391] [<c0012b48>] (show_stack) from [<c03ef030>]
(dump_stack+0x7c/0xb0)
[   40.931778] [<c03ef030>] (dump_stack) from [<c03eda60>]
(print_circular_bug+0x284/0x2d8)
[   40.940054] [<c03eda60>] (print_circular_bug) from [<c0063f58>]
(__lock_acquire+0x1258/0x1a2c)
[   40.948859] [<c0063f58>] (__lock_acquire) from [<c0064bd8>]
(lock_acquire+0x6c/0x8c)
[   40.956778] [<c0064bd8>] (lock_acquire) from [<c03f3558>]
(down_read+0x3c/0x80)
[   40.964254] [<c03f3558>] (down_read) from [<c02a3e54>]
(__buf_prepare+0x258/0x340)
[   40.971996] [<c02a3e54>] (__buf_prepare) from [<c02a577c>]
(vb2_internal_qbuf+0x50/0x1ec)
[   40.980360] [<c02a577c>] (vb2_internal_qbuf) from [<c029f3dc>]
(v4l2_m2m_qbuf+0x20/0x38)
[   40.988634] [<c029f3dc>] (v4l2_m2m_qbuf) from [<c0292a18>]
(v4l_qbuf+0x3c/0x40)
[   40.996109] [<c0292a18>] (v4l_qbuf) from [<c02941bc>]
(__video_do_ioctl+0x17c/0x28c)
[   41.004027] [<c02941bc>] (__video_do_ioctl) from [<c0294564>]
(video_usercopy+0x298/0x404)
[   41.012479] [<c0294564>] (video_usercopy) from [<c028f5a4>]
(v4l2_ioctl+0x7c/0xa4)
[   41.020222] [<c028f5a4>] (v4l2_ioctl) from [<c00eb158>]
(do_vfs_ioctl+0x5f4/0x65c)
[   41.027963] [<c00eb158>] (do_vfs_ioctl) from [<c00eb1f4>]
(SyS_ioctl+0x34/0x58)
[   41.035439] [<c00eb1f4>] (SyS_ioctl) from [<c000fe00>]
(ret_fast_syscall+0x0/0x54)
[   41.043244] vb2: __qbuf_userptr: userspace address for plane 0
changed, reacquiring memory
[   41.051720] vb2: __qbuf_userptr: call_memop(eeac0008, 0, get_userptr)
[   41.058331] got only 0 of 1 user pages
[   41.062166] failed to get user pages
[   41.065847] vb2: __qbuf_userptr: failed acquiring userspace memory
for plane 0
[   41.073231] vb2: __buf_prepare: buffer preparation failed: -14
[   41.079318] vb2: __qbuf_userptr: userspace address for plane 0
changed, reacquiring memory
[   41.087782] vb2: __qbuf_userptr: call_memop(eeac0008, 0, get_userptr)
[   41.094361] vb2: __qbuf_userptr: failed acquiring userspace memory
for plane 0
[   41.101777] vb2: __buf_prepare: buffer preparation failed: -22
[   41.107763] vb2: __qbuf_userptr: userspace address for plane 0
changed, reacquiring memory
[   41.116231] vb2: __qbuf_userptr: call_memop(eeac0008, 0, get_userptr)
[   41.122815] vb2: __qbuf_userptr: failed acquiring userspace memory
for plane 0
[   41.130217] vb2: __buf_prepare: buffer preparation failed: -22
[   41.136225] vb2: counters for queue eeac0008:
[   41.140677] vb2:     setup: 1 start_streaming: 0 stop_streaming: 0
[   41.147022] vb2:     wait_prepare: 0 wait_finish: 0
[   41.152012] vb2:   counters for queue eeac0008, buffer 0:
[   41.157554] vb2:     buf_init: 0 buf_cleanup: 0 buf_prepare: 0 buf_finish: 0
[   41.164771] vb2:     buf_queue: 0 buf_done: 0
[   41.169224] vb2:     alloc: 0 put: 0 prepare: 0 finish: 0 mmap: 0
[   41.175472] vb2:     get_userptr: 0 put_userptr: 0
[   41.180379] vb2:     attach_dmabuf: 0 detach_dmabuf: 0 map_dmabuf:
0 unmap_dmabuf: 0
[   41.188314] vb2:     get_dmabuf: 0 num_users: 0 vaddr: 0 cookie: 0
[   41.194633] vb2:   counters for queue eeac0008, buffer 1:
[   41.200174] vb2:     buf_init: 0 buf_cleanup: 0 buf_prepare: 0 buf_finish: 0
[   41.207391] vb2:     buf_queue: 0 buf_done: 0
[   41.211844] vb2:     alloc: 0 put: 0 prepare: 0 finish: 0 mmap: 0
[   41.218092] vb2:     get_userptr: 0 put_userptr: 0
[   41.222999] vb2:     attach_dmabuf: 0 detach_dmabuf: 0 map_dmabuf:
0 unmap_dmabuf: 0
[   41.230933] vb2:     get_dmabuf: 0 num_users: 0 vaddr: 0 cookie: 0
[   19.510789] ------------[ cut here ]------------
[   19.515571] WARNING: CPU: 1 PID: 780 at
drivers/media/v4l2-core/videobuf2-core.c:1251
__fill_vb2_buffer+0x5c/0x36c()
[   19.526352] CPU: 1 PID: 780 Comm: v4l2-compliance Not tainted 4.1.0-dirty #15
[   19.533640] Hardware name: Generic R8A7791 (Flattened Device Tree)
[   19.540002] [<c001594c>] (unwind_backtrace) from [<c0012b1c>]
(show_stack+0x10/0x14)
[   19.547956] [<c0012b1c>] (show_stack) from [<c03ef118>]
(dump_stack+0x7c/0xb0)
[   19.555372] [<c03ef118>] (dump_stack) from [<c0026488>]
(warn_slowpath_common+0x7c/0xa8)
[   19.563648] [<c0026488>] (warn_slowpath_common) from [<c002656c>]
(warn_slowpath_null+0x18/0x1c)
[   19.572655] [<c002656c>] (warn_slowpath_null) from [<c02a1d00>]
(__fill_vb2_buffer+0x5c/0x36c)
[   19.581482] [<c02a1d00>] (__fill_vb2_buffer) from [<c02a3e30>]
(__buf_prepare+0x1c0/0x340)
[   19.589958] [<c02a3e30>] (__buf_prepare) from [<c02a57f0>]
(vb2_internal_qbuf+0x50/0x1ec)
[   19.598351] [<c02a57f0>] (vb2_internal_qbuf) from [<c029f450>]
(v4l2_m2m_qbuf+0x20/0x38)
[   19.606650] [<c029f450>] (v4l2_m2m_qbuf) from [<c0292a8c>]
(v4l_qbuf+0x3c/0x40)
[   19.614133] [<c0292a8c>] (v4l_qbuf) from [<c0294230>]
(__video_do_ioctl+0x17c/0x28c)
[   19.622086] [<c0294230>] (__video_do_ioctl) from [<c02945d8>]
(video_usercopy+0x298/0x404)
[   19.630574] [<c02945d8>] (video_usercopy) from [<c028f618>]
(v4l2_ioctl+0x7c/0xa4)
[   19.638343] [<c028f618>] (v4l2_ioctl) from [<c00eb1b0>]
(do_vfs_ioctl+0x5f4/0x65c)
[   19.646109] [<c00eb1b0>] (do_vfs_ioctl) from [<c00eb24c>]
(SyS_ioctl+0x34/0x58)
[   19.653587] [<c00eb24c>] (SyS_ioctl) from [<c000fe00>]
(ret_fast_syscall+0x0/0x54)
[   19.661342] ---[ end trace 9eb4bed9a8748820 ]---
[   19.666078] use of bytesused == 0 is deprecated and will be removed
in the future,
[   19.673808] use the actual size instead.


[   20.015330] ======================================================
[   20.021641] [ INFO: possible circular locking dependency detected ]
[   20.028044] 4.1.0-dirty #15 Tainted: G        W
[   20.033203] -------------------------------------------------------
[   20.039604] v4l2-compliance/780 is trying to acquire lock:
[   20.045204]  (&mm->mmap_sem){++++++}, at: [<c02a3ec8>]
__buf_prepare+0x258/0x340
[   20.052812]
but task is already holding lock:
[   20.058770]  (&jpu->mutex){+.+.+.}, at: [<c028f5f4>] v4l2_ioctl+0x58/0xa4
[   20.065757]
which lock already depends on the new lock.

[   20.074113]
the existing dependency chain (in reverse order) is:
[   20.081755]
-> #1 (&jpu->mutex){+.+.+.}:
[   20.085984]        [<c029fb20>] v4l2_m2m_fop_mmap+0x4c/0x70
[   20.091690]        [<c028f55c>] v4l2_mmap+0x40/0x80
[   20.096688]        [<c00c7608>] mmap_region+0x2cc/0x538
[   20.102042]        [<c00c7b44>] do_mmap_pgoff+0x2d0/0x344
[   20.107572]        [<c00b7128>] vm_mmap_pgoff+0x64/0x94
[   20.112923]        [<c00c5e80>] SyS_mmap_pgoff+0x68/0x98
[   20.118363]        [<c000fe00>] ret_fast_syscall+0x0/0x54
[   20.123895]
-> #0 (&mm->mmap_sem){++++++}:
[   20.128300]        [<c03f3640>] down_read+0x3c/0x80
[   20.133300]        [<c02a3ec8>] __buf_prepare+0x258/0x340
[   20.138827]        [<c02a57f0>] vb2_internal_qbuf+0x50/0x1ec
[   20.144622]        [<c029f450>] v4l2_m2m_qbuf+0x20/0x38
[   20.149976]        [<c0292a8c>] v4l_qbuf+0x3c/0x40
[   20.154884]        [<c0294230>] __video_do_ioctl+0x17c/0x28c
[   20.160679]        [<c02945d8>] video_usercopy+0x298/0x404
[   20.166296]        [<c028f618>] v4l2_ioctl+0x7c/0xa4
[   20.171382]        [<c00eb1b0>] do_vfs_ioctl+0x5f4/0x65c
[   20.176824]        [<c00eb24c>] SyS_ioctl+0x34/0x58
[   20.181820]        [<c000fe00>] ret_fast_syscall+0x0/0x54
[   20.187350]
other info that might help us debug this:

[   20.195528]  Possible unsafe locking scenario:

[   20.201576]        CPU0                    CPU1
[   20.206202]        ----                    ----
[   20.210827]   lock(&jpu->mutex);
[   20.214145]                                lock(&mm->mmap_sem);
[   20.220210]                                lock(&jpu->mutex);
[   20.226098]   lock(&mm->mmap_sem);
[   20.229594]
 *** DEADLOCK ***

[   20.235648] 1 lock held by v4l2-compliance/780:
[   20.240274]  #0:  (&jpu->mutex){+.+.+.}, at: [<c028f5f4>]
v4l2_ioctl+0x58/0xa4
[   20.247713]
stack backtrace:
[   20.252173] CPU: 1 PID: 780 Comm: v4l2-compliance Tainted: G
W       4.1.0-dirty #15
[   20.260702] Hardware name: Generic R8A7791 (Flattened Device Tree)
[   20.267030] [<c001594c>] (unwind_backtrace) from [<c0012b1c>]
(show_stack+0x10/0x14)
[   20.274951] [<c0012b1c>] (show_stack) from [<c03ef118>]
(dump_stack+0x7c/0xb0)
[   20.282338] [<c03ef118>] (dump_stack) from [<c03edb44>]
(print_circular_bug+0x284/0x2d8)
[   20.290613] [<c03edb44>] (print_circular_bug) from [<c0063fd0>]
(__lock_acquire+0x1258/0x1a2c)
[   20.299418] [<c0063fd0>] (__lock_acquire) from [<c0064c50>]
(lock_acquire+0x6c/0x8c)
[   20.307337] [<c0064c50>] (lock_acquire) from [<c03f3640>]
(down_read+0x3c/0x80)
[   20.314812] [<c03f3640>] (down_read) from [<c02a3ec8>]
(__buf_prepare+0x258/0x340)
[   20.322554] [<c02a3ec8>] (__buf_prepare) from [<c02a57f0>]
(vb2_internal_qbuf+0x50/0x1ec)
[   20.330918] [<c02a57f0>] (vb2_internal_qbuf) from [<c029f450>]
(v4l2_m2m_qbuf+0x20/0x38)
[   20.339192] [<c029f450>] (v4l2_m2m_qbuf) from [<c0292a8c>]
(v4l_qbuf+0x3c/0x40)
[   20.346666] [<c0292a8c>] (v4l_qbuf) from [<c0294230>]
(__video_do_ioctl+0x17c/0x28c)
[   20.354585] [<c0294230>] (__video_do_ioctl) from [<c02945d8>]
(video_usercopy+0x298/0x404)
[   20.363036] [<c02945d8>] (video_usercopy) from [<c028f618>]
(v4l2_ioctl+0x7c/0xa4)
[   20.370779] [<c028f618>] (v4l2_ioctl) from [<c00eb1b0>]
(do_vfs_ioctl+0x5f4/0x65c)
[   20.378519] [<c00eb1b0>] (do_vfs_ioctl) from [<c00eb24c>]
(SyS_ioctl+0x34/0x58)
[   20.385994] [<c00eb24c>] (SyS_ioctl) from [<c000fe00>]
(ret_fast_syscall+0x0/0x54)
[   20.393798] got only 0 of 1 user pages
[   20.397660] failed to get user pages



Driver Info:
        Driver name   : rcar_jpu
        Card type     : rcar_jpu encoder
        Bus info      : platform:fe980000.jpu
        Driver version: 4.1.0
        Capabilities  : 0x84204000
                Video Memory-to-Memory Multiplanar
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps   : 0x04204000
                Video Memory-to-Memory Multiplanar
                Streaming
                Extended Pix Format

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
        test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
        test second video open: OK
        test VIDIOC_QUERYCAP: OK
        test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
        test VIDIOC_DBG_G/S_REGISTER: OK
        test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
        test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
        test VIDIOC_ENUMAUDIO: OK (Not Supported)
        test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
        test VIDIOC_G/S_AUDIO: OK (Not Supported)
        Inputs: 0 Audio Inputs: 0 Tuners: 0

Output ioctls:
        test VIDIOC_G/S_MODULATOR: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_ENUMAUDOUT: OK (Not Supported)
        test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
        test VIDIOC_G/S_AUDOUT: OK (Not Supported)
        Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
        test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
        test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
        test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
        test VIDIOC_G/S_EDID: OK (Not Supported)

        Control ioctls:
                test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
                test VIDIOC_QUERYCTRL: OK
                test VIDIOC_G/S_CTRL: OK
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 2 Private Controls: 0

        Format ioctls:
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                test VIDIOC_G/S_PARM: OK (Not Supported)
                test VIDIOC_G_FBUF: OK (Not Supported)
                test VIDIOC_G_FMT: OK
                test VIDIOC_TRY_FMT: OK
                test VIDIOC_S_FMT: OK
                test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
                test Cropping: OK (Not Supported)
                test Composing: OK (Not Supported)
                test Scaling: OK

        Codec ioctls:
                test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
                test VIDIOC_G_ENC_INDEX: OK (Not Supported)
                test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

        Buffer ioctls:
                warn: v4l2-test-buffers.cpp(540): VIDIOC_CREATE_BUFS
not supported
                warn: v4l2-test-buffers.cpp(540): VIDIOC_CREATE_BUFS
not supported
                test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
                test VIDIOC_EXPBUF: OK (Not Supported)

Test input 0:

Streaming ioctls:
        test read/write: OK (Not Supported)
        test MMAP: OK
                fail: v4l2-test-buffers.cpp(1030): buf.qbuf(node)
                fail: v4l2-test-buffers.cpp(1073): setupUserPtr(node, q)
        test USERPTR: FAIL
        test DMABUF: Cannot test, specify --expbuf-device


Total: 45, Succeeded: 44, Failed: 1, Warnings: 2



2015-07-17 11:50 GMT+03:00 Hans Verkuil <hverkuil@xs4all.nl>:
> Hi Mikhail,
>
> On 06/26/2015 01:37 PM, Mikhail Ulyanov wrote:
>> Here's the driver for the Renesas R-Car JPEG processing unit.
>>
>> The driver is implemented within the V4L2 framework as a memory-to-memory
>> device.  It presents two video nodes to userspace, one for the encoding part,
>> and one for the decoding part.
>>
>> It was found that the only working mode for encoding is no markers output, so we
>> generate markers with software. In the current version of driver we also use
>> software JPEG header parsing because with hardware parsing performance is lower
>> than desired.
>>
>> From a userspace point of view the process is typical (S_FMT, REQBUF,
>> optionally QUERYBUF, QBUF, STREAMON, DQBUF) for both the source and destination
>> queues. STREAMON can return -EINVAL in case of mismatch of output and capture
>> queues format. Also during decoding driver can return buffers if queued
>> buffer with JPEG image contains image with inappropriate subsampling (e.g.
>> 4:2:0 in JPEG and 4:2:2 in capture).  If JPEG image and queue format dimensions
>> differ driver will return buffer on QBUF with VB2_BUF_STATE_ERROR flag.
>>
>> During encoding the available formats are: V4L2_PIX_FMT_NV12M,
>> V4L2_PIX_FMT_NV12, V4L2_PIX_FMT_NV16, V4L2_PIX_FMT_NV16M for source and
>> V4L2_PIX_FMT_JPEG for destination.
>>
>> During decoding the available formats are: V4L2_PIX_FMT_JPEG for source and
>> V4L2_PIX_FMT_NV12M, V4L2_PIX_FMT_NV16M, V4L2_PIX_FMT_NV12, V4L2_PIX_FMT_NV16
>> for destination.
>>
>> Performance of current version:
>> 1280x800 NV12 image encoding/decoding
>>       decoding ~122 FPS
>>       encoding ~191 FPS
>>
>> Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
>> ---
>>  Changes since v3:
>>     - driver file renamed to rcar_jpu.c
>>     - semiplanar formats NV12 and NV16 support
>>     - new callbacks streamon, job_abort and stop_streaming
>>     - extra processing error information printout irq handler
>>     - fill in JPEG header for encoded buffer in buf_finish
>>     - wrapped reading/writing to registers
>>     - vb2_set_plane_payload only for necessary buffer in buf_prepare
>>     - multiple buffers now supported
>>     - removed format setup with parsed info; rely only on users info
>>     - JPEG header parser redesigned
>>     - video_device structs embedded
>>     - video_device_alloc/release removed
>>     - "name" filed in format description removed
>>     - remove g_selection
>>     - start_streaming removed
>>
>> Changes since v2:
>>     - Kconfig entry reordered
>>     - unnecessary clk_disable_unprepare(jpu->clk) removed
>>     - ref_count fixed in jpu_resume
>>     - enable DMABUF in src_vq->io_modes
>>     - remove jpu_s_priority jpu_g_priority
>>     - jpu_g_selection fixed
>>     - timeout in jpu_reset added and hardware reset reworked
>>     - remove unused macros
>>     - JPEG header parsing now is software because of performance issues
>>       based on s5p-jpeg code
>>     - JPEG header generation redesigned:
>>       JPEG header(s) pre-generated and memcpy'ed on encoding
>>       we only fill the necessary fields
>>       more "transparent" header format description
>>     - S_FMT, G_FMT and TRY_FMT hooks redesigned
>>       partially inspired by VSP1 driver code
>>     - some code was reformatted
>>     - image formats handling redesigned
>>     - multi-planar V4L2 API now in use
>>     - now passes v4l2-compliance tool check
>>
>> Cnanges since v1:
>>     - s/g_fmt function simplified
>>     - default format for queues added
>>     - dumb vidioc functions added to be in compliance with standard api:
>>         jpu_s_priority, jpu_g_priority
>>     - standard v4l2_ctrl_subscribe_event and v4l2_event_unsubscribe
>>       now in use by the same reason
>>
>>  drivers/media/platform/Kconfig    |   11 +
>>  drivers/media/platform/Makefile   |    1 +
>>  drivers/media/platform/rcar_jpu.c | 1753 +++++++++++++++++++++++++++++++++++++
>>  3 files changed, 1765 insertions(+)
>>  create mode 100644 drivers/media/platform/rcar_jpu.c
>>
>
> This patch looks good. There are a few small things checkpatch gave me:
>
> WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
> #82:
> new file mode 100644
>
> WARNING: DT compatible string "renesas,jpu-r8a7790" appears un-documented -- check ./Documentation/devicetree/bindings/
> #1645: FILE: drivers/media/platform/rcar_jpu.c:1559:
> +       { .compatible = "renesas,jpu-r8a7790" }, /* H2 */
>
> WARNING: DT compatible string "renesas,jpu-r8a7791" appears un-documented -- check ./Documentation/devicetree/bindings/
> #1646: FILE: drivers/media/platform/rcar_jpu.c:1560:
> +       { .compatible = "renesas,jpu-r8a7791" }, /* M2-W */
>
> WARNING: DT compatible string "renesas,jpu-r8a7792" appears un-documented -- check ./Documentation/devicetree/bindings/
> #1647: FILE: drivers/media/platform/rcar_jpu.c:1561:
> +       { .compatible = "renesas,jpu-r8a7792" }, /* V2H */
>
> WARNING: DT compatible string "renesas,jpu-r8a7793" appears un-documented -- check ./Documentation/devicetree/bindings/
> #1648: FILE: drivers/media/platform/rcar_jpu.c:1562:
> +       { .compatible = "renesas,jpu-r8a7793" }, /* M2-N */
>
> So before I can commit I need a MAINTAINERS patch and DT documentation.
>
> I also noticed that the Kconfig patch says that the driver module is called jpu,
> but I think that should be rcar_jpu. If you can fix that?
>
> I would also like to have the v4l2-compliance output for both encoder and decoder.
>
> Try 'v4l2-compliance -s' for the encoder. This won't work for the decoder (v4l2-compliance
> can't generate JPEG images), so just run 'v4l2-compliance' for that one.
>
> Regards,
>
>         Hans



-- 
W.B.R, Mikhail.
