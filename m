Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8Q74FPg017794
	for <video4linux-list@redhat.com>; Fri, 26 Sep 2008 03:04:16 -0400
Received: from comal.ext.ti.com (comal.ext.ti.com [198.47.26.152])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8Q745fG023171
	for <video4linux-list@redhat.com>; Fri, 26 Sep 2008 03:04:05 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id m8Q73w5F031791
	for <video4linux-list@redhat.com>; Fri, 26 Sep 2008 02:04:04 -0500
Received: from dbde70.ent.ti.com (localhost [127.0.0.1])
	by dbdp20.itg.ti.com (8.13.8/8.13.8) with ESMTP id m8Q73vVI003006
	for <video4linux-list@redhat.com>; Fri, 26 Sep 2008 12:33:57 +0530 (IST)
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Fri, 26 Sep 2008 12:33:58 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403DBFE5F43@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: videobuf_iolock function fails for USERPTR?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

If I understand correctly, the videobuf_iolock function is responsible for 
mapping user pages to kernel. This works fine as long as user application allocates 
memory/buffer using some standard API (malloc/memalign).

But it fails where; user application has allocated memory/buffer using ioremap 
from another driver. The use case scenario is something -

	- Open V4L2 device (which supports scatter gather DMA)
	- Configure the parameters (especially .memory=V4L2_MEMORY_USERPTR)
	- Request and query the buffer
	- open another device which will be responsible for allocating memory
		Either using ioremap/dma_alloc_coherent/get_free_pages
	- Queue the buffers with buffer address received from previous step

Here it internally calls drv_prepare function, which call videobuf_iolock API for mapping the user pages to kernel and will create scatter-gather (dma->sglist) list. But this API returns from videobuf_dma_init_user_locked with -EFAULT.

I found the get_user_pages returns due to flag VM_IO and VM_PFNMAP for the corresponding vma.

Any suggestions on how can I achieve this?

Thanks,
Vaibhav Hiremath
Senior Software Engg.
Platform Support Products
Texas Instruments Inc
Ph: +91-80-25099927


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
