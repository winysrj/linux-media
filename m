Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:16741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756238Ab1AKSTP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 13:19:15 -0500
Message-ID: <4D2CBB3F.5050904@redhat.com>
Date: Tue, 11 Jan 2011 18:19:11 -0200
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

> Marek Szyprowski (4):
>       v4l: mem2mem: port to videobuf2

This one didn't compile:

drivers/media/video/mem2mem_testdev.c: In function ‘device_process’:
drivers/media/video/mem2mem_testdev.c:232: warning: assignment from incompatible pointer type
drivers/media/video/mem2mem_testdev.c:233: warning: assignment from incompatible pointer type
drivers/media/video/mem2mem_testdev.c: In function ‘vidioc_g_fmt’:
drivers/media/video/mem2mem_testdev.c:429: warning: assignment from incompatible pointer type
drivers/media/video/mem2mem_testdev.c: In function ‘vidioc_s_fmt’:
drivers/media/video/mem2mem_testdev.c:528: warning: assignment from incompatible pointer type
drivers/media/video/mem2mem_testdev.c: In function ‘m2mtest_buf_queue’:
drivers/media/video/mem2mem_testdev.c:828: warning: passing argument 2 of ‘v4l2_m2m_buf_queue’ from incompatible pointer type
include/media/v4l2-mem2mem.h:134: note: expected ‘struct vb2_buffer *’ but argument is of type ‘struct videobuf_queue *’
drivers/media/video/mem2mem_testdev.c:828: error: too many arguments to function ‘v4l2_m2m_buf_queue’
drivers/media/video/mem2mem_testdev.c: In function ‘m2mtest_open’:
drivers/media/video/mem2mem_testdev.c:869: warning: passing argument 1 of ‘v4l2_m2m_ctx_init’ from incompatible pointer type
include/media/v4l2-mem2mem.h:128: note: expected ‘struct v4l2_m2m_dev *’ but argument is of type ‘struct m2mtest_ctx *’
drivers/media/video/mem2mem_testdev.c:869: warning: passing argument 3 of ‘v4l2_m2m_ctx_init’ from incompatible pointer type
include/media/v4l2-mem2mem.h:128: note: expected ‘int (*)(void *, struct vb2_queue *, struct vb2_queue *)’ but argument is of type ‘void (*)(void *, struct videobuf_queue *, enum v4l2_buf_type)’

I'm removing it from my queue. Please, resend it with the fixes against my experimental tree.

Cheers,
Mauro
