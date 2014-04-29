Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:30354 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933437AbaD2Jh2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Apr 2014 05:37:28 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N4S00C6DDEBPJ80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 29 Apr 2014 10:37:23 +0100 (BST)
Message-id: <535F72DE.4090702@samsung.com>
Date: Tue, 29 Apr 2014 11:37:34 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"open list:VIDEOBUF2 FRAMEWORK" <linux-media@vger.kernel.org>,
	sylvester.nawrocki@gmail.com, matthias.waechter@tttech.com,
	hans.verkuil@cisco.com
Subject: Re: [PATCH] videobuf2-dma-sg: Fix NULL pointer dereference BUG
References: <1398442289-12510-1-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1398442289-12510-1-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2014-04-25 18:11, Ricardo Ribalda Delgado wrote:
> vb2_get_vma() copy the content of the vma to a new structure but set
> some of its pointers to NULL.
>
> One of this pointer is used by follow_pte() called by follow_pfn()
> on io memory.
>
> This can lead to a NULL pointer derreference.
>
> The version of vma that has not been cleared must be used.
>
> [  406.143320] BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
> [  406.143427] IP: [<ffffffff8115204c>] follow_pfn+0x2c/0x70
> [  406.143491] PGD 6c3f0067 PUD 6c3ef067 PMD 0
> [  406.143546] Oops: 0000 [#1] SMP
> [  406.143587] Modules linked in: qtec_mem qt5023_video qtec_testgen qtec_xform videobuf2_core gpio_xilinx videobuf2_vmalloc videobuf2_dma_sg qtec_cmosis videobuf2_memops qtec_pcie qtec_white fglrx(PO) qt5023 spi_xilinx spi_bitbang
> [  406.143852] CPU: 0 PID: 299 Comm: tracker Tainted: P           O 3.13.0-qtec-standard #10
> [  406.143927] Hardware name: QTechnology QT5022/QT5022, BIOS PM_2.1.0.309 X64 04/04/2013
> [  406.144000] task: ffff880085c82d60 ti: ffff880085abe000 task.ti: ffff880085abe000
> [  406.144067] RIP: 0010:[<ffffffff8115204c>]  [<ffffffff8115204c>] follow_pfn+0x2c/0x70
> [  406.144145] RSP: 0018:ffff880085abf888  EFLAGS: 00010296
> [  406.144195] RAX: 0000000000000000 RBX: ffff880085abf8e0 RCX: ffff880085abf888
> [  406.144260] RDX: ffff880085abf890 RSI: 00007fc52e173000 RDI: ffff8800863cbe40
> [  406.144325] RBP: ffff880085abf8a8 R08: 0000000000000018 R09: ffff8800863cbf00
> [  406.144388] R10: ffff880086703b80 R11: 00000000000001e0 R12: 0000000000018000
> [  406.144452] R13: 0000000000000000 R14: ffffea0000000000 R15: ffff88015922fea0
> [  406.144517] FS:  00007fc536e7c740(0000) GS:ffff88015ec00000(0000) knlGS:0000000000000000
> [  406.144591] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  406.144644] CR2: 0000000000000040 CR3: 0000000066c9d000 CR4: 00000000000007f0
> [  406.144708] Stack:
> [  406.144731]  0000000000018000 00007fc52e18b000 0000000000000000 00007fc52e173000
> [  406.144813]  ffff880085abf918 ffffffffa083b2fd ffff880085ab1ba8 0000000000000000
> [  406.144894]  0000000000000000 0000000100000000 ffff880085abf928 ffff880159a20800
> [  406.144976] Call Trace:
> [  406.145011]  [<ffffffffa083b2fd>] vb2_dma_sg_get_userptr+0x14d/0x310 [videobuf2_dma_sg]
> [  406.145089]  [<ffffffffa08507df>] __qbuf_userptr+0xbf/0x3e0 [videobuf2_core]
> [  406.147229]  [<ffffffffa0041454>] ? mc_heap_lock_memory+0x1f4/0x490 [fglrx]
> [  406.149234]  [<ffffffff813428f3>] ? cpumask_next_and+0x23/0x50
> [  406.151223]  [<ffffffff810b2e38>] ? enqueue_task_fair+0x658/0xde0
> [  406.153199]  [<ffffffff81061888>] ? native_smp_send_reschedule+0x48/0x60
> [  406.155184]  [<ffffffff815836b9>] ? get_ctrl+0xa9/0xd0
> [  406.157161]  [<ffffffff8116f4e4>] ? __kmalloc+0x1a4/0x1b0
> [  406.159135]  [<ffffffffa0850b9c>] ? __vb2_queue_alloc+0x9c/0x4a0 [videobuf2_core]
> [  406.161130]  [<ffffffffa0852d08>] __buf_prepare+0x1a8/0x210 [videobuf2_core]
> [  406.163171]  [<ffffffffa0854c57>] __vb2_qbuf+0x27/0xcc [videobuf2_core]
> [  406.165229]  [<ffffffffa0851dfd>] vb2_queue_or_prepare_buf+0x1ed/0x270 [videobuf2_core]
> [  406.167325]  [<ffffffffa0854c30>] ? vb2_ioctl_querybuf+0x30/0x30 [videobuf2_core]
> [  406.169419]  [<ffffffffa0851e9c>] vb2_qbuf+0x1c/0x20 [videobuf2_core]
> [  406.171508]  [<ffffffffa0851ef8>] vb2_ioctl_qbuf+0x58/0x70 [videobuf2_core]
> [  406.173604]  [<ffffffff8157d3a8>] v4l_qbuf+0x48/0x60
> [  406.175681]  [<ffffffff8157b29c>] __video_do_ioctl+0x2bc/0x340
> [  406.177779]  [<ffffffff8116f43c>] ? __kmalloc+0xfc/0x1b0
> [  406.179883]  [<ffffffff8157cd0e>] ? video_usercopy+0x7e/0x470
> [  406.181961]  [<ffffffff8157ce81>] video_usercopy+0x1f1/0x470
> [  406.184021]  [<ffffffff8157afe0>] ? v4l_printk_ioctl+0xb0/0xb0
> [  406.186085]  [<ffffffff810ae1ed>] ? account_system_time+0x8d/0x190
> [  406.188149]  [<ffffffff8157d115>] video_ioctl2+0x15/0x20
> [  406.190216]  [<ffffffff815781b3>] v4l2_ioctl+0x123/0x160
> [  406.192251]  [<ffffffff810ce415>] ? rcu_eqs_enter+0x65/0xa0
> [  406.194256]  [<ffffffff81186b28>] do_vfs_ioctl+0x88/0x560
> [  406.196258]  [<ffffffff810ae145>] ? account_user_time+0x95/0xb0
> [  406.198262]  [<ffffffff810ae6a4>] ? vtime_account_user+0x44/0x70
> [  406.200215]  [<ffffffff81187091>] SyS_ioctl+0x91/0xb0
> [  406.202107]  [<ffffffff817be109>] tracesys+0xd0/0xd5
> [  406.203946] Code: 66 66 66 90 48 f7 47 50 00 44 00 00 b8 ea ff ff ff 74 52 55 48 89 e5 53 48 89 d3 48 8d 4d e0 48 8d 55 e8 48 83 ec 18 48 8b 47 40 <48> 8b 78 40 e8 8b fe ff ff 85 c0 75 27 48 8b 55 e8 48 b9 00 f0
> [  406.208011] RIP  [<ffffffff8115204c>] follow_pfn+0x2c/0x70
> [  406.209908]  RSP <ffff880085abf888>
> [  406.211760] CR2: 0000000000000040
> [  406.213676] ---[ end trace 996d9f64e6739a04 ]---
>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

I wasn't aware that follow_pfn might need to access some vma internals. 
You are right that the real vma should be used here instead of the dummy 
copy.

> ---
>   drivers/media/v4l2-core/videobuf2-dma-sg.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> index c779f21..adefc31 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -211,7 +211,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
>   		     ++num_pages_from_user, vaddr += PAGE_SIZE) {
>   			unsigned long pfn;
>   
> -			if (follow_pfn(buf->vma, vaddr, &pfn)) {
> +			if (follow_pfn(vma, vaddr, &pfn)) {
>   				dprintk(1, "no page for address %lu\n", vaddr);
>   				break;
>   			}

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

