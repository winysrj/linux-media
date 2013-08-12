Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:46138 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab3HLJzk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Aug 2013 05:55:40 -0400
From: Inki Dae <inki.dae@samsung.com>
To: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	'Linux ARM Kernel' <linux-arm-kernel@lists.infradead.org>,
	linux-media@vger.kernel.org, linaro-kernel@lists.linaro.org
References: <20130617182127.GM2718@n2100.arm.linux.org.uk>
 <007301ce6be4$8d5c6040$a81520c0$%dae@samsung.com>
 <20130618084308.GU2718@n2100.arm.linux.org.uk>
 <008a01ce6c02$e00a9f50$a01fddf0$%dae@samsung.com>
 <1371548849.4276.6.camel@weser.hi.pengutronix.de>
 <008601ce6cb0$2c8cec40$85a6c4c0$%dae@samsung.com>
 <1371637326.4230.24.camel@weser.hi.pengutronix.de>
 <00ae01ce6cd9$f4834630$dd89d290$%dae@samsung.com>
 <1371645247.4230.41.camel@weser.hi.pengutronix.de>
 <CAAQKjZNJD4HpnJQ7iE+Gez36066M6U0YQeUEdA0+UcSOKqeghg@mail.gmail.com>
 <20130619182925.GL2718@n2100.arm.linux.org.uk>
 <00da01ce6d81$76eb3d60$64c1b820$%dae@samsung.com>
 <1371714427.4230.64.camel@weser.hi.pengutronix.de>
 <00db01ce6d8f$a3c23dd0$eb46b970$%dae@samsung.com>
 <1371723063.4114.12.camel@weser.hi.pengutronix.de>
In-reply-to: 
Subject: About buffer sychronization mechanism and cache operation
Date: Mon, 12 Aug 2013 18:55:25 +0900
Message-id: <000001ce9742$11b5dcd0$35219670$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,


The purpose of this email is to get other opinions and advices to buffer synchronization mechanism, and coupling cache operation feature with the buffer synchronization mechanism. First of all, I am not a native English speaker so I'm not sure that I can convey my intention to you. And I'm not a specialist in Linux than other people so also there might be my missing points. 

I had posted the buffer synchronization mechanism called dmabuf sync framework like below,
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-June/177045.html

And I'm sending this email before posting next version with more stable patch set and features. The purpose of this framework is to provide not only buffer access control to CPU and DMA but also easy-to-use interfaces for device drivers and user application. This framework can be used for all DMA devices using system memory as DMA buffer, especially for most ARM based SoCs.
    
There are two cases we are using this buffer synchronization framework. One is to primarily enhance GPU rendering performance on Tizen platform in case of 3d app with compositing mode that the 3d app draws something in off-screen buffer.
    
And other is to couple buffer access control and cache operation between CPU and DMA; the cache operation is done by the dmabuf sync framework in kernel side.

    
Why do we need buffer access control between CPU and DMA?
---------------------------------------------------------
    
The below shows simple 3D software layers,
    
                    3D Application
      -----------------------------------------
        Standard OpenGL ES and EGL Interfaces  ------- [A]
      -----------------------------------------
      MALI OpenGL ES and EGL Native modules --------- [B]
      -----------------------------------------
         Exynos DRM Driver    |    GPU Driver ---------- [C]
    
3d application requests 3d rendering through A. And then B fills a 3d command buffer with the requests from A. And then 3D application calls glFlush so that the 3d command buffer can be submitted to C, and rendered by GPU hardware. Internally, glFlush(also glFinish) will call a function of native module[B] glFinish blocks caller's task until all GL execution is complete. On the other hand, glFlush forces execution of GL commands but doesn't block the caller's task until the completion.
    
In composting mode, in case of using glFinish, the 3d rendering performance is quite lower than using glFlush because glFinish makes CPU blocked until the execution of the 3d commands is completed. However, the use of glFlush has one issue that the shared buffer with GPU could be broken when CPU accesses the shared buffer at once after glFlush because CPU cannot be aware of the completion of GPU access to the shared buffer: actually, Tizen platform internally calls only eglSwapBuffer instead of glFlush and glFinish, and whether flushing or finishing is decided according to compositing mode or not. So in such case, we would need buffer access control between CPU and DMA for more performance.

    
About cache operation
---------------------
    
The dmabuf sync framework can include cache operation feature, and the below shows how the cache operation based on dmabuf sync framework is performed,
   device driver in kernel or fctrl in user land
          dmabuf_sync_lock or dmabuf_sync_single_lock
               check before and after buffer access
                  dma_buf_begin_cpu_access or dma_buf_end_cpu_access
                         begin_cpu_access or end_cpu_access of exporter
                                dma_sync_sg_for_device or dma_sync_sg_for_cpu
    
In case that using dmabuf sync framework, kernel can be aware of when CPU and DMA access to a shared buffer is completed so we can do cache operation in kernel so that way, we can couple buffer access control and cache operation. So with this, we can avoid that user land overuses cache operation.
    
I guess most Linux based platforms are using cachable mapped buffer for more performance: in case that CPU frequently accesses the shared buffer which is shared with DMA, the use of cachable mapped buffer is more fast than the use of non-cachable. However, this way could make cache operation overused by user land because only user land can be aware of the completion of CPU or DMA access to the shared buffer so user land could request cache operations every time it wants even the cache operation is unnecessary. That is how user land could overuse cache operations.
    
To Android, Chrome OS, and other forks,

Are there other cases that buffer access control between CPU and DMA is needed? I know Android sync driver and KDS are already being used for Android, Chrome OS, and so on.
How does your platform do cache operation? And How do you think about coupling buffer access control and cache operation between CPU and DMA?.

Lastly, I think we may need Linux generic buffer synchronization mechanism that uses only Linux standard interfaces (dmabuf) including user land interfaces (fcntl and select system calls), and the dmabuf sync framework could meet it.


Thanks,
Inki Dae

