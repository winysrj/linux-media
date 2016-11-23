Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35769 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752746AbcKWBdK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 20:33:10 -0500
Date: Tue, 22 Nov 2016 17:31:02 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Andrew Duggan <aduggan@synaptics.com>,
        Chris Healy <cphealy@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nick Dyer <nick@shmanahar.org>,
        Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org
Subject: Re: [RFC] Input: synaptics-rmi4 - fix out-of-bounds memory access
Message-ID: <20161123013102.GA21078@dtor-ws>
References: <1479613618-11440-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1479613618-11440-1-git-send-email-linux@roeck-us.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guenter,

On Sat, Nov 19, 2016 at 07:46:58PM -0800, Guenter Roeck wrote:
> Kasan reports:
> 
> BUG: KASAN: slab-out-of-bounds in __fill_v4l2_buffer+0xc3/0x540
> 	[videobuf2_v4l2] at addr ffff8806c5e0c6cc
> Read of size 4 by task heatmap/14414
> CPU: 2 PID: 14414 Comm: heatmap Tainted: G    B      OE 4.9.0-rc5+ #1
> Hardware name: MSI MS-7924/H97M-G43(MS-7924), BIOS V2.0 04/15/2014
> ffff88010cf57940 ffffffff81606978 ffff8806fe803080 ffff8806c5e0c500
> ffff88010cf57968 ffffffff812fd131 ffff88010cf579f8 ffff8806c5e0c500
> ffff8806fe803080 ffff88010cf579e8 ffffffff812fd3ca 0000000000000010
> Call Trace:
> [<ffffffff81606978>] dump_stack+0x63/0x8b
> [<ffffffff812fd131>] kasan_object_err+0x21/0x70
> [<ffffffff812fd3ca>] kasan_report_error+0x1fa/0x4d0
> [<ffffffff812fdaf9>] kasan_report+0x39/0x40
> [<ffffffff812fc000>] ? __asan_load4+0x80/0x80
> [<ffffffffa0ae0553>] ? __fill_v4l2_buffer+0xc3/0x540 [videobuf2_v4l2]
> [<ffffffff812fbfe1>] __asan_load4+0x61/0x80
> [<ffffffffa0ae0553>] __fill_v4l2_buffer+0xc3/0x540 [videobuf2_v4l2]
> [<ffffffffa0ad038d>] ? __enqueue_in_driver+0xed/0x180 [videobuf2_core]
> [<ffffffffa0ad3021>] vb2_core_qbuf+0x191/0x320 [videobuf2_core]
> [<ffffffffa0ae1ba9>] vb2_qbuf+0x69/0x90 [videobuf2_v4l2]
> [<ffffffffa0ae1c43>] vb2_ioctl_qbuf+0x73/0x80 [videobuf2_v4l2]
> [<ffffffffa0a811b0>] v4l_qbuf+0x50/0x60 [videodev]
> [<ffffffffa0a8020f>] __video_do_ioctl+0x46f/0x4f0 [videodev]
> [<ffffffffa0a7fda0>] ? video_ioctl2+0x20/0x20 [videodev]
> [<ffffffff8112c6f4>] ? __wake_up+0x44/0x50
> [<ffffffffa0a7fa24>] video_usercopy+0x3b4/0x710 [videodev]
> [<ffffffffa0a7fda0>] ? video_ioctl2+0x20/0x20 [videodev]
> [<ffffffffa0a7f670>] ? v4l_enum_fmt+0x1290/0x1290 [videodev]
> [<ffffffff8132cb80>] ? do_loop_readv_writev+0x130/0x130
> [<ffffffffa0a7fd95>] video_ioctl2+0x15/0x20 [videodev]
> [<ffffffffa0a78a53>] v4l2_ioctl+0x123/0x160 [videodev]
> [<ffffffff8134dcce>] do_vfs_ioctl+0x12e/0x8c0
> [<ffffffff8134dba0>] ? ioctl_preallocate+0x140/0x140
> [<ffffffff8139927c>] ? __fsnotify_parent+0x2c/0x130
> [<ffffffff810d8e1a>] ? SyS_rt_sigaction+0xfa/0x160
> [<ffffffff810d8d20>] ? SyS_sigprocmask+0x1f0/0x1f0
> [<ffffffff8135e907>] ? __fget_light+0xa7/0xc0
> [<ffffffff8134e4d9>] SyS_ioctl+0x79/0x90
> [<ffffffff81c9a33b>] entry_SYSCALL_64_fastpath+0x1e/0xad
> Object at ffff8806c5e0c500, in cache kmalloc-512 size: 512
> Allocated:
> PID = 14414
> [<ffffffff8105ef2b>] save_stack_trace+0x1b/0x20
> [<ffffffff812fc4a6>] save_stack+0x46/0xd0
> [<ffffffff812fc71d>] kasan_kmalloc+0xad/0xe0
> [<ffffffff812f992f>] __kmalloc+0x12f/0x210
> [<ffffffffa0ad44ed>] __vb2_queue_alloc+0x9d/0x6a0 [videobuf2_core]
> [<ffffffffa0ad4dca>] vb2_core_reqbufs+0x2da/0x640 [videobuf2_core]
> [<ffffffffa0ae0ab8>] vb2_ioctl_reqbufs+0xd8/0x130 [videobuf2_v4l2]
> [<ffffffffa0a81fa0>] v4l_reqbufs+0x60/0x70 [videodev]
> [<ffffffffa0a8020f>] __video_do_ioctl+0x46f/0x4f0 [videodev]
> [<ffffffffa0a7fa24>] video_usercopy+0x3b4/0x710 [videodev]
> [<ffffffffa0a7fd95>] video_ioctl2+0x15/0x20 [videodev]
> [<ffffffffa0a78a53>] v4l2_ioctl+0x123/0x160 [videodev]
> [<ffffffff8134dcce>] do_vfs_ioctl+0x12e/0x8c0
> [<ffffffff8134e4d9>] SyS_ioctl+0x79/0x90
> [<ffffffff81c9a33b>] entry_SYSCALL_64_fastpath+0x1e/0xad
> Freed:
> PID = 1717
> [<ffffffff8105ef2b>] save_stack_trace+0x1b/0x20
> [<ffffffff812fc4a6>] save_stack+0x46/0xd0
> [<ffffffff812fcd01>] kasan_slab_free+0x71/0xb0
> [<ffffffff812f8b14>] kfree+0x94/0x190
> [<ffffffff81295f6a>] kvfree+0x2a/0x40
> [<ffffffffa0647e46>] i915_gem_execbuffer2+0x1d6/0x2e0 [i915]
> [<ffffffffa051969b>] drm_ioctl+0x35b/0x640 [drm]
> [<ffffffff8134dcce>] do_vfs_ioctl+0x12e/0x8c0
> [<ffffffff8134e4d9>] SyS_ioctl+0x79/0x90
> [<ffffffff81c9a33b>] entry_SYSCALL_64_fastpath+0x1e/0xad
> 
> The problematic code is
> 	b->flags = vbuf->flags;
> and all other code in __fill_v4l2_buffer() accessing variables from
> struct vb2_v4l2_buffer. That buffer is actually allocated as struct
> vb2_buffer. Accessing the flags in struct vb2_v4l2_buffer beyond struct
> vb2_buffer is causing the KASAN report.
> 
> Fixes: 3a762dbd5347 ("[media] Input: synaptics-rmi4 - add support for F54 ...")
> Cc: Nick Dyer <nick@shmanahar.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> RFC because if I have no idea if the fix is correct. Sure, KASAN is silent with
> this fix, but what bothers me is that the error is reported when copying
> variables from struct vb2_v4l2_buffer to struct v4l2_buffer, not earlier.
> This suggests that those variables (flags, field, timecode, sequence) are never
> written in the first place. Maybe that is as expected, and the variables are
> not supposed to be written, but I don't know that subsystem well enough to
> know the expected behavior.

I think we best ask media folks (CCed).

> 
>  drivers/input/rmi4/rmi_f54.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/input/rmi4/rmi_f54.c b/drivers/input/rmi4/rmi_f54.c
> index cf805b960866..ef91633acb6b 100644
> --- a/drivers/input/rmi4/rmi_f54.c
> +++ b/drivers/input/rmi4/rmi_f54.c
> @@ -363,7 +363,7 @@ static const struct vb2_ops rmi_f54_queue_ops = {
>  static const struct vb2_queue rmi_f54_queue = {
>  	.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
>  	.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ,
> -	.buf_struct_size = sizeof(struct vb2_buffer),
> +	.buf_struct_size = sizeof(struct vb2_v4l2_buffer),
>  	.ops = &rmi_f54_queue_ops,
>  	.mem_ops = &vb2_vmalloc_memops,
>  	.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC,
> -- 
> 2.5.0
> 

-- 
Dmitry
