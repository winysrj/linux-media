Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:63275 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab3GLGMy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jul 2013 02:12:54 -0400
From: Inki Dae <inki.dae@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: maarten.lankhorst@canonical.com, daniel@ffwll.ch,
	robdclark@gmail.com, sumit.semwal@linaro.org,
	linux@arm.linux.org.uk, kyungmin.park@samsung.com,
	myungjoo.ham@samsung.com, yj44.cho@samsung.com,
	Inki Dae <inki.dae@samsung.com>
Subject: [RFC PATCH 0/2 v5] Introduce buffer synchronization framework
Date: Fri, 12 Jul 2013 15:12:44 +0900
Message-id: <1373609566-10784-1-git-send-email-inki.dae@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch set introduces a buffer synchronization framework based
on DMA BUF[1] and based on ww-mutexes[2] for lock mechanism.

The purpose of this framework is to provide not only buffer access
control to CPU and CPU, and CPU and DMA, and DMA and DMA but also
easy-to-use interfaces for device drivers and user application.
In addtion, this patch set suggests a way for enhancing performance.

For generic user mode interface, we have used fcntl system call[3].
As you know, user application sees a buffer object as a dma-buf file
descriptor. So fcntl() call with the file descriptor means to lock
some buffer region being managed by the dma-buf object.
For more detail, you can refer to the dma-buf-sync.txt in Documentation/

Moreover, we had tried to find how we could utilize limited hardware
resources more using buffer synchronization mechanism. And finally,
we have realized that it could enhance performance using multi threads
with this buffer synchronization mechanism: DMA and CPU works individually
so CPU could perform other works while DMA is performing some works,
and vise versa.

However, in the conventional way, that is not easy to do so because DMA
operation is depend on CPU operation, and vice versa.

Conventional way:
        User                                     Kernel
        ---------------------------------------------------------------------
        CPU writes something to src
        send the src to driver------------------------->
                                                 update DMA register
        request DMA start(1)--------------------------->
                                                 DMA start
                <---------completion signal(2)----------
        CPU accesses dst

        (1) Request DMA start after the CPU access to src buffer is completed.
        (2) Access dst buffer after DMA access to the dst buffer is completed.

On the other hand, if there is something to control buffer access between CPU
and DMA? The below shows that:

        User(thread a)          User(thread b)            Kernel
        ---------------------------------------------------------------------
        send a src to driver---------------------------------->
                                                          update DMA register
        lock the src
                                request DMA start(1)---------->
        CPU acccess to src
        unlock the src                                    lock src and dst
                                                          DMA start
                <-------------completion signal(2)-------------
        lock dst                                          DMA completion
        CPU access to dst                                 unlock src and dst
        unlock DST

        (1) Try to start DMA operation while CPU is accessing the src buffer.
        (2) Try CPU access to dst buffer while DMA is accessing the dst buffer.

	This means that CPU or DMA could do more works.

	In the same way, we could reduce hand shaking overhead between
	two processes when those processes need to share a shared buffer.
	There may be other cases that we could reduce overhead as well.


References:
[1] http://lwn.net/Articles/470339/
[2] https://patchwork.kernel.org/patch/2625361/
[3] http://linux.die.net/man/2/fcntl


Inki Dae (2):
  [RFC PATCH v5 1/2] dmabuf-sync: Introduce buffer synchronization framework
  [RFC PATCH v1 2/2] dma-buf: add lock callback for fcntl system call

 Documentation/dma-buf-sync.txt |  290 +++++++++++++++++
 drivers/base/Kconfig           |    7 +
 drivers/base/Makefile          |    1 +
 drivers/base/dma-buf.c         |   37 +++
 drivers/base/dmabuf-sync.c     |  674 ++++++++++++++++++++++++++++++++++++++++
 include/linux/dma-buf.h        |   16 +
 include/linux/dmabuf-sync.h    |  178 +++++++++++
 7 files changed, 1203 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/dma-buf-sync.txt
 create mode 100644 drivers/base/dmabuf-sync.c
 create mode 100644 include/linux/dmabuf-sync.h

-- 
1.7.5.4

