Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2854 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab3JNHsI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Oct 2013 03:48:08 -0400
Message-ID: <525BA19F.7060107@xs4all.nl>
Date: Mon, 14 Oct 2013 09:47:43 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: Possible race condition on videobuf2?
References: <CAPybu_3hqBYK-ka8BQDz8XCAxPrJDdJoyPiB+hd+Mkfavx2Mog@mail.gmail.com> <525ACD6B.4020205@xs4all.nl> <CAPybu_1HhiG2Skdoc4N=hN=qeZxWDXdQ6wbKCAoCLgdG=w+N6Q@mail.gmail.com>
In-Reply-To: <CAPybu_1HhiG2Skdoc4N=hN=qeZxWDXdQ6wbKCAoCLgdG=w+N6Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/14/13 09:42, Ricardo Ribalda Delgado wrote:
> Hello Hans
> 
> Thanks for your feedback. I have send a patch to the list with your suggestion.
> 
> If I dont apply my patch, but your your branch I still get the error:

Thanks for testing this. I suspected that might be the case.

What exactly is the sequence that reproduces this error? Ctrl-C in the middle of
a read()? Multiple threads accessing the same file handle?

Regards,

	Hans

> 
> 
> Thanks!
> 
> 
> [   57.567944] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000260
> [   57.567980] IP: [<ffffffffa07ab963>]
> __vb2_perform_fileio+0x363/0x600 [videobuf2_core]
> [   57.568013] PGD 15952a067 PUD 159519067 PMD 0
> [   57.568032] Oops: 0000 [#1] SMP
> [   57.568045] Modules linked in: nfc qtec_xform gpio_xilinx
> qt5023_video videobuf2_vmalloc videobuf2_dma_sg videobuf2_memops
> videobuf2_core qtec_pcie qtec_cmosis qtec_white qtec_mem fglrx(PO)
> spi_xilinx spi_bitbang qt5023
> [   57.568109] CPU: 1 PID: 1213 Comm: java Tainted: P           O
> 3.11.0-qtec-standard+ #112
> [   57.568122] Hardware name: QTechnology QT5022/QT5022, BIOS
> PM_2.1.0.309 X64 05/23/2013
> [   57.568134] task: ffff88014aa98000 ti: ffff88014aa94000 task.ti:
> ffff88014aa94000
> [   57.568144] RIP: 0010:[<ffffffffa07ab963>]  [<ffffffffa07ab963>]
> __vb2_perform_fileio+0x363/0x600 [videobuf2_core]
> [   57.568168] RSP: 0018:ffff88014aa95e48  EFLAGS: 00010246
> [   57.568178] RAX: 0000000000000000 RBX: ffff88015694e870 RCX: 0000000000000000
> [   57.568187] RDX: 0000000000000000 RSI: ffff88015694c400 RDI: ffff88015694c400
> [   57.568195] RBP: ffff88014aa95e98 R08: 0000000000000000 R09: 0000000000000001
> [   57.568204] R10: ffffea00055c2880 R11: ffff88014aa95fd8 R12: ffff88015694e800
> [   57.568213] R13: 000000000021de00 R14: ffff88015727f0b8 R15: 000000000126ae20
> [   57.568224] FS:  00007fc23bbda700(0000) GS:ffff88015ed00000(0000)
> knlGS:0000000000000000
> [   57.568233] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   57.568241] CR2: 0000000000000260 CR3: 0000000156931000 CR4: 00000000000007e0
> [   57.568248] Stack:
> [   57.568254]  ffff880159632910 0000000000000000 ffff880100000001
> 0000000059bd0820
> [   57.568270]  ffff88014aa95f50 ffff88015727f720 ffff880159632900
> ffff88015727f340
> [   57.568285]  000000000021de00 ffff88014aa95f50 ffff88014aa95ed8
> ffffffffa07abe09
> [   57.568300] Call Trace:
> [   57.568328]  [<ffffffffa07abe09>] vb2_fop_read+0xb9/0x110 [videobuf2_core]
> [   57.568351]  [<ffffffff81534985>] v4l2_read+0x65/0xb0
> [   57.568372]  [<ffffffff81166bea>] vfs_read+0x9a/0x150
> [   57.568388]  [<ffffffff81167649>] SyS_read+0x49/0xa0
> [   57.568407]  [<ffffffff81760479>] tracesys+0xd0/0xd5
> [   57.568415] Code: 89 c2 44 8b 4d c0 4c 8b 45 b8 0f 8f 2d 02 00 00
> 85 d2 48 63 c2 0f 85 86 fd ff ff 41 83 84 24 78 03 00 00 01 31 d2 4b
> 8b 4c c6 48 <8b> 81 60 02 00 00 85 c0 74 05 8b 41 58 89 c2 89 43 08 80
> 63 10
> [   57.568566] RIP  [<ffffffffa07ab963>]
> __vb2_perform_fileio+0x363/0x600 [videobuf2_core]
> [   57.568587]  RSP <ffff88014aa95e48>
> [   57.568594] CR2: 0000000000000260
> [   57.568606] ---[ end trace d664b8a0460e8ca5 ]---
> 
> 
> 
> On Sun, Oct 13, 2013 at 6:42 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Ricardo,
>>
>> On 10/13/2013 03:03 PM, Ricardo Ribalda Delgado wrote:
>>> Hello
>>>
>>> These days I have been testing an app that uses the old read/write
>>> API. It is interfacing a videobuf2-sg driver.
>>>
>>> Once in a while I get an oops on the vb2_perform_fileio function.
>>>
>>> After digging a while I have been able to fix the bug like this:
>>>
>>> int vb2_fop_release(struct file *file)
>>>  {
>>>   struct video_device *vdev = video_devdata(file);
>>> + struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
>>>
>>> + if (lock)
>>> + mutex_lock(lock);
>>>   if (file->private_data == vdev->queue->owner) {
>>>   vb2_queue_release(vdev->queue);
>>>   vdev->queue->owner = NULL;
>>>   }
>>> + if (lock)
>>> + mutex_unlock(lock);
>>>   return v4l2_fh_release(file);
>>>  }
>>>  EXPORT_SYMBOL_GPL(vb2_fop_release);
>>>
>>> (or at least, I havent seen the oops since then).
>>>
>>> I was wondering if this a real bug on vb2 and I shall post a proper
>>> patch or the device driver is doing something out of spec.
>>>
>>> vb2_perform_fileio+0x372 corresponds to
>>>
>>>   memset(&fileio->b, 0, sizeof(fileio->b));
>>>
>>> My theory is that:
>>>
>>> fileio = q->fileio;
>>> if (!fileio){
>>> ...
>>> q->fileio = NULL;
>>>
>>> can be prone to race conditions if the lock is not held on release.
>>
>> This would not surprise me.
>>
>> I have a number of vb2 patches in this branch:
>>
>> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/vb2-thread
>>
>> Among others it replaces the 'q->fileio = NULL' hack by a proper solution.
>>
>> It will be interesting to see if my patch series in that branch would fix your
>> problem as well.
>>
>> That said, I do think vb2_fop_release should take the lock regardless, although
>> I would put the mutex_lock inside the 'if' that checks the owner.
>>
>> Regards,
>>
>>         Hans
>>
>>>
>>>
>>> [ 308.297741] BUG: unable to handle kernel NULL pointer dereference at
>>> 0000000000000260
>>> [ 308.297759] IP: [<ffffffffa07a9fd2>] vb2_perform_fileio+0x372/0x610
>>> [videobuf2_core]
>>> [ 308.297794] PGD 159719067 PUD 158119067 PMD 0
>>> [ 308.297812] Oops: 0000 #1 SMP
>>> [ 308.297826] Modules linked in: qt5023_video videobuf2_dma_sg
>>> qtec_xform videobuf2_vmalloc videobuf2_memops videobuf2_core
>>> qtec_white qtec_mem gpio_xilinx qtec_cmosis qtec_pcie fglrx(PO)
>>> spi_xilinx spi_bitbang qt5023
>>> [ 308.297888] CPU: 1 PID: 2189 Comm: java Tainted: P O 3.11.0-qtec-standard #1
>>> [ 308.297919] Hardware name: QTechnology QT5022/QT5022, BIOS
>>> PM_2.1.0.309 X64 05/23/2013
>>> [ 308.297952] task: ffff8801564e1690 ti: ffff88014dc02000 task.ti:
>>> ffff88014dc02000
>>> [ 308.297962] RIP: 0010:[<ffffffffa07a9fd2>] [<ffffffffa07a9fd2>]
>>> vb2_perform_fileio+0x372/0x610 [videobuf2_core]
>>> [ 308.297985] RSP: 0018:ffff88014dc03df8 EFLAGS: 00010202
>>> [ 308.297995] RAX: 0000000000000000 RBX: ffff880158a23000 RCX: dead000000100100
>>> [ 308.298003] RDX: 0000000000000000 RSI: dead000000200200 RDI: 0000000000000000
>>> [ 308.298012] RBP: ffff88014dc03e58 R08: 0000000000000000 R09: 0000000000000001
>>> [ 308.298020] R10: ffffea00051e8380 R11: ffff88014dc03fd8 R12: ffff880158a23070
>>> [ 308.298029] R13: ffff8801549040b8 R14: 0000000000198000 R15: 0000000001887e60
>>> [ 308.298040] FS: 00007f65130d5700(0000) GS:ffff88015ed00000(0000)
>>> knlGS:0000000000000000
>>> [ 308.298049] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [ 308.298057] CR2: 0000000000000260 CR3: 0000000159630000 CR4: 00000000000007e0
>>> [ 308.298064] Stack:
>>> [ 308.298071] ffff880156416c00 0000000000198000 0000000000000000
>>> ffff880100000001
>>> [ 308.298087] ffff88014dc03f50 00000000810a79ca 0002000000000001
>>> ffff880154904718
>>> [ 308.298101] ffff880156416c00 0000000000198000 ffff880154904338
>>> ffff88014dc03f50
>>> [ 308.298116] Call Trace:
>>> [ 308.298143] [<ffffffffa07aa3c4>] vb2_read+0x14/0x20 [videobuf2_core]
>>> [ 308.298198] [<ffffffffa07aa494>] vb2_fop_read+0xc4/0x120 [videobuf2_core]
>>> [ 308.298252] [<ffffffff8154ee9e>] v4l2_read+0x7e/0xc0
>>> [ 308.298296] [<ffffffff8116e639>] vfs_read+0xa9/0x160
>>> [ 308.298312] [<ffffffff8116e882>] SyS_read+0x52/0xb0
>>> [ 308.298328] [<ffffffff81784179>] tracesys+0xd0/0xd5
>>> [ 308.298335] Code: e5 d6 ff ff 83 3d be 24 00 00 04 89 c2 4c 8b 45 b0
>>> 44 8b 4d b8 0f 8f 20 02 00 00 85 d2 75 32 83 83 78 03 00 00 01 4b 8b
>>> 44 c5 48 <8b> 88 60 02 00 00 85 c9 0f 84 b0 00 00 00 8b 40 58 89 c2 41
>>> 89
>>> [ 308.298487] RIP [<ffffffffa07a9fd2>] vb2_perform_fileio+0x372/0x610
>>> [videobuf2_core]
>>> [ 308.298507] RSP <ffff88014dc03df8>
>>> [ 308.298514] CR2: 0000000000000260
>>> [ 308.298526] ---[ end trace e8f01717c96d1e41 ]---
>>>
>>
> 
> 
> 

