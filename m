Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:44547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932558Ab1AKTbY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 14:31:24 -0500
Message-ID: <4D2CCC26.2000300@redhat.com>
Date: Tue, 11 Jan 2011 19:31:18 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PATCHES FOR 2.6.38] Videbuf2 framework, NOON010PC30 sensor
 driver and s5p-fimc updates
References: <4D21FDC1.7000803@samsung.com>
In-Reply-To: <4D21FDC1.7000803@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 03-01-2011 14:48, Sylwester Nawrocki escreveu:
> Hi Mauro,
> 
> Please pull from our tree for the following items:

> Sylwester Nawrocki (15):
>       v4l: mem2mem: port m2m_testdev to vb2

This one is also broken:

drivers/media/video/mem2mem_testdev.c: In function ‘device_isr’:
drivers/media/video/mem2mem_testdev.c:360: error: implicit declaration of function ‘v4l2_m2m_buf_done’
drivers/media/video/mem2mem_testdev.c: In function ‘vidioc_g_fmt’:
drivers/media/video/mem2mem_testdev.c:437: warning: assignment from incompatible pointer type
drivers/media/video/mem2mem_testdev.c: In function ‘vidioc_s_fmt’:
drivers/media/video/mem2mem_testdev.c:536: warning: assignment from incompatible pointer type
drivers/media/video/mem2mem_testdev.c: In function ‘m2mtest_buf_queue’:
drivers/media/video/mem2mem_testdev.c:795: warning: passing argument 2 of ‘v4l2_m2m_buf_queue’ from incompatible pointer type
include/media/v4l2-mem2mem.h:118: note: expected ‘struct videobuf_queue *’ but argument is of type ‘struct vb2_buffer *’
drivers/media/video/mem2mem_testdev.c:795: error: too few arguments to function ‘v4l2_m2m_buf_queue’
drivers/media/video/mem2mem_testdev.c: In function ‘queue_init’:
drivers/media/video/mem2mem_testdev.c:813: error: invalid application of ‘sizeof’ to incomplete type ‘struct v4l2_m2m_buffer’ 
drivers/media/video/mem2mem_testdev.c:825: error: invalid application of ‘sizeof’ to incomplete type ‘struct v4l2_m2m_buffer’ 
drivers/media/video/mem2mem_testdev.c: In function ‘m2mtest_open’:
drivers/media/video/mem2mem_testdev.c:850: warning: passing argument 2 of ‘v4l2_m2m_ctx_init’ from incompatible pointer type
include/media/v4l2-mem2mem.h:113: note: expected ‘struct v4l2_m2m_dev *’ but argument is of type ‘struct m2mtest_ctx *’
drivers/media/video/mem2mem_testdev.c:850: warning: passing argument 3 of ‘v4l2_m2m_ctx_init’ from incompatible pointer type
include/media/v4l2-mem2mem.h:113: note: expected ‘void (*)(void *, struct videobuf_queue *, enum v4l2_buf_type)’ but argument is of type ‘int (*)(void *, struct vb2_queue *, struct vb2_queue *)’
drivers/media/video/mem2mem_testdev.c: At top level:
drivers/media/video/mem2mem_testdev.c:917: error: unknown field ‘lock’ specified in initializer
drivers/media/video/mem2mem_testdev.c:917: warning: excess elements in struct initializer
drivers/media/video/mem2mem_testdev.c:917: warning: (near initialization for ‘m2m_ops’)
drivers/media/video/mem2mem_testdev.c:918: error: unknown field ‘unlock’ specified in initializer
drivers/media/video/mem2mem_testdev.c:918: warning: excess elements in struct initializer
drivers/media/video/mem2mem_testdev.c:918: warning: (near initialization for ‘m2m_ops’)

Cheers,
Mauro
