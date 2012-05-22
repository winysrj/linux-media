Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:16946 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2EVNrS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 09:47:18 -0400
Received: from eusync4.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M4F00JQYFIXEP@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 May 2012 14:44:57 +0100 (BST)
Received: from [106.116.48.223] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0M4F00DAKFMQ9T00@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 May 2012 14:47:16 +0100 (BST)
Date: Tue, 22 May 2012 15:47:12 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH] dma-buf: add get_dma_buf()
In-reply-to: <1331913881-13105-1-git-send-email-rob.clark@linaro.org>
To: Rob Clark <rob.clark@linaro.org>
Cc: linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, patches@linaro.org,
	sumit.semwal@linaro.org, daniel@ffwll.ch, airlied@redhat.com,
	Rob Clark <rob@ti.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?B?J+uwleqyveuvvCc=?= <kyungmin.park@samsung.com>,
	InKi Dae <daeinki@gmail.com>
Message-id: <4FBB98E0.8040600@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <1331913881-13105-1-git-send-email-rob.clark@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I think I discovered an interesting issue with dma_buf.
I found out that dma_buf_fd does not increase reference
count for dma_buf::file. This leads to potential kernel
crash triggered by user space. Please, take a look on
the scenario below:

The applications spawns two thread. One of them is exporting DMABUF.

      Thread I         |   Thread II       | Comments
-----------------------+-------------------+-----------------------------------
dbuf = dma_buf_export  |                   | dma_buf is creates, refcount is 1
fd = dma_buf_fd(dbuf)  |                   | assume fd is set to 42, refcount is still 1
                       |      close(42)    | The file descriptor is closed asynchronously, dbuf's refcount drops to 0
                       |  dma_buf_release  | dbuf structure is freed, dbuf becomes a dangling pointer
int size = dbuf->size; |                   | the dbuf is dereferenced, causing a kernel crash
-----------------------+-------------------+-----------------------------------

I think that the problem could be fixed in two ways.
a) forcing driver developer to call get_dma_buf just before calling dma_buf_fd.
b) increasing dma_buf->file's reference count at dma_buf_fd

I prefer solution (b) because it prevents symmetry between dma_buf_fd and close.
I mean that dma_buf_fd increases reference count, close decreases it.

What is your opinion about the issue?

Regards,
Tomasz Stanislawski



On 03/16/2012 05:04 PM, Rob Clark wrote:
> From: Rob Clark <rob@ti.com>
> 
> Works in a similar way to get_file(), and is needed in cases such as
> when the exporter needs to also keep a reference to the dmabuf (that
> is later released with a dma_buf_put()), and possibly other similar
> cases.
> 
> Signed-off-by: Rob Clark <rob@ti.com>
> ---
