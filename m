Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4712 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab3JMQmb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Oct 2013 12:42:31 -0400
Message-ID: <525ACD6B.4020205@xs4all.nl>
Date: Sun, 13 Oct 2013 18:42:19 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: Possible race condition on videobuf2?
References: <CAPybu_3hqBYK-ka8BQDz8XCAxPrJDdJoyPiB+hd+Mkfavx2Mog@mail.gmail.com>
In-Reply-To: <CAPybu_3hqBYK-ka8BQDz8XCAxPrJDdJoyPiB+hd+Mkfavx2Mog@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On 10/13/2013 03:03 PM, Ricardo Ribalda Delgado wrote:
> Hello
> 
> These days I have been testing an app that uses the old read/write
> API. It is interfacing a videobuf2-sg driver.
> 
> Once in a while I get an oops on the vb2_perform_fileio function.
> 
> After digging a while I have been able to fix the bug like this:
> 
> int vb2_fop_release(struct file *file)
>  {
>   struct video_device *vdev = video_devdata(file);
> + struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
> 
> + if (lock)
> + mutex_lock(lock);
>   if (file->private_data == vdev->queue->owner) {
>   vb2_queue_release(vdev->queue);
>   vdev->queue->owner = NULL;
>   }
> + if (lock)
> + mutex_unlock(lock);
>   return v4l2_fh_release(file);
>  }
>  EXPORT_SYMBOL_GPL(vb2_fop_release);
> 
> (or at least, I havent seen the oops since then).
> 
> I was wondering if this a real bug on vb2 and I shall post a proper
> patch or the device driver is doing something out of spec.
> 
> vb2_perform_fileio+0x372 corresponds to
> 
>   memset(&fileio->b, 0, sizeof(fileio->b));
> 
> My theory is that:
> 
> fileio = q->fileio;
> if (!fileio){
> ...
> q->fileio = NULL;
> 
> can be prone to race conditions if the lock is not held on release.

This would not surprise me.

I have a number of vb2 patches in this branch:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/vb2-thread

Among others it replaces the 'q->fileio = NULL' hack by a proper solution.

It will be interesting to see if my patch series in that branch would fix your
problem as well.

That said, I do think vb2_fop_release should take the lock regardless, although
I would put the mutex_lock inside the 'if' that checks the owner.

Regards,

	Hans

> 
> 
> [ 308.297741] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000260
> [ 308.297759] IP: [<ffffffffa07a9fd2>] vb2_perform_fileio+0x372/0x610
> [videobuf2_core]
> [ 308.297794] PGD 159719067 PUD 158119067 PMD 0
> [ 308.297812] Oops: 0000 #1 SMP
> [ 308.297826] Modules linked in: qt5023_video videobuf2_dma_sg
> qtec_xform videobuf2_vmalloc videobuf2_memops videobuf2_core
> qtec_white qtec_mem gpio_xilinx qtec_cmosis qtec_pcie fglrx(PO)
> spi_xilinx spi_bitbang qt5023
> [ 308.297888] CPU: 1 PID: 2189 Comm: java Tainted: P O 3.11.0-qtec-standard #1
> [ 308.297919] Hardware name: QTechnology QT5022/QT5022, BIOS
> PM_2.1.0.309 X64 05/23/2013
> [ 308.297952] task: ffff8801564e1690 ti: ffff88014dc02000 task.ti:
> ffff88014dc02000
> [ 308.297962] RIP: 0010:[<ffffffffa07a9fd2>] [<ffffffffa07a9fd2>]
> vb2_perform_fileio+0x372/0x610 [videobuf2_core]
> [ 308.297985] RSP: 0018:ffff88014dc03df8 EFLAGS: 00010202
> [ 308.297995] RAX: 0000000000000000 RBX: ffff880158a23000 RCX: dead000000100100
> [ 308.298003] RDX: 0000000000000000 RSI: dead000000200200 RDI: 0000000000000000
> [ 308.298012] RBP: ffff88014dc03e58 R08: 0000000000000000 R09: 0000000000000001
> [ 308.298020] R10: ffffea00051e8380 R11: ffff88014dc03fd8 R12: ffff880158a23070
> [ 308.298029] R13: ffff8801549040b8 R14: 0000000000198000 R15: 0000000001887e60
> [ 308.298040] FS: 00007f65130d5700(0000) GS:ffff88015ed00000(0000)
> knlGS:0000000000000000
> [ 308.298049] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 308.298057] CR2: 0000000000000260 CR3: 0000000159630000 CR4: 00000000000007e0
> [ 308.298064] Stack:
> [ 308.298071] ffff880156416c00 0000000000198000 0000000000000000
> ffff880100000001
> [ 308.298087] ffff88014dc03f50 00000000810a79ca 0002000000000001
> ffff880154904718
> [ 308.298101] ffff880156416c00 0000000000198000 ffff880154904338
> ffff88014dc03f50
> [ 308.298116] Call Trace:
> [ 308.298143] [<ffffffffa07aa3c4>] vb2_read+0x14/0x20 [videobuf2_core]
> [ 308.298198] [<ffffffffa07aa494>] vb2_fop_read+0xc4/0x120 [videobuf2_core]
> [ 308.298252] [<ffffffff8154ee9e>] v4l2_read+0x7e/0xc0
> [ 308.298296] [<ffffffff8116e639>] vfs_read+0xa9/0x160
> [ 308.298312] [<ffffffff8116e882>] SyS_read+0x52/0xb0
> [ 308.298328] [<ffffffff81784179>] tracesys+0xd0/0xd5
> [ 308.298335] Code: e5 d6 ff ff 83 3d be 24 00 00 04 89 c2 4c 8b 45 b0
> 44 8b 4d b8 0f 8f 20 02 00 00 85 d2 75 32 83 83 78 03 00 00 01 4b 8b
> 44 c5 48 <8b> 88 60 02 00 00 85 c9 0f 84 b0 00 00 00 8b 40 58 89 c2 41
> 89
> [ 308.298487] RIP [<ffffffffa07a9fd2>] vb2_perform_fileio+0x372/0x610
> [videobuf2_core]
> [ 308.298507] RSP <ffff88014dc03df8>
> [ 308.298514] CR2: 0000000000000260
> [ 308.298526] ---[ end trace e8f01717c96d1e41 ]---
> 

