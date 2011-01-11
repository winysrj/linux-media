Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:61566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756267Ab1AKUIO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 15:08:14 -0500
Message-ID: <4D2CD4CA.7090507@redhat.com>
Date: Tue, 11 Jan 2011 20:08:10 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PATCHES FOR 2.6.38] Videbuf2 framework, NOON010PC30 sensor
 driver and s5p-fimc updates
References: <4D21FDC1.7000803@samsung.com>
In-Reply-To: <4D21FDC1.7000803@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 03-01-2011 14:48, Sylwester Nawrocki escreveu:
> Hi Mauro,
> 
> Please pull from our tree for the following items:

> 6. Patches for SAA7134 driver for Videbuf2 testing.

There's something wrong with those patches. I got lots of errors: 

  CC [M]  /home/v4l/new_build/v4l/saa7134-tvaudio.o
/home/v4l/new_build/v4l/saa7134-core.c: In function 'saa7134_dma_free':
/home/v4l/new_build/v4l/saa7134-core.c:262: warning: unused variable 'dma'
/home/v4l/new_build/v4l/saa7134-core.c: In function 'saa7134_finidev':
/home/v4l/new_build/v4l/saa7134-core.c:1006: warning: unused variable 'mops'
/home/v4l/new_build/v4l/saa7134-core.c: In function 'saa7134_buffer_requeue':
/home/v4l/new_build/v4l/saa7134-core.c:1085: error: 'struct saa7134_buf' has no member named 'vb'
/home/v4l/new_build/v4l/saa7134-core.c:1085: warning: type defaults to 'int' in declaration of '__mptr'
/home/v4l/new_build/v4l/saa7134-core.c:1085: warning: initialization from incompatible pointer type
/home/v4l/new_build/v4l/saa7134-core.c:1085: error: 'struct saa7134_buf' has no member named 'vb'
/home/v4l/new_build/v4l/saa7134-ts.c: In function 'buffer_activate':
/home/v4l/new_build/v4l/saa7134-ts.c:49: error: 'struct saa7134_buf' has no member named 'vb'
/home/v4l/new_build/v4l/saa7134-ts.c:54: error: 'struct saa7134_buf' has no member named 'vb'
/home/v4l/new_build/v4l/saa7134-ts.c: In function 'buffer_prepare':
/home/v4l/new_build/v4l/saa7134-ts.c:79: error: 'struct saa7134_buf' has no member named 'vb'
/home/v4l/new_build/v4l/saa7134-ts.c:79: warning: type defaults to 'int' in declaration of '__mptr'
/home/v4l/new_build/v4l/saa7134-ts.c:79: warning: initialization from incompatible pointer type
/home/v4l/new_build/v4l/saa7134-ts.c:79: error: 'struct saa7134_buf' has no member named 'vb'
/home/v4l/new_build/v4l/saa7134-ts.c:89: error: 'struct saa7134_buf' has no member named 'vb'
/home/v4l/new_build/v4l/saa7134-ts.c:89: error: 'struct saa7134_buf' has no member named 'vb'
/home/v4l/new_build/v4l/saa7134-ts.c:92: error: 'struct saa7134_buf' has no member named 'vb'
/home/v4l/new_build/v4l/saa7134-ts.c:93: warning: passing argument 1 of 'saa7134_dma_free' from incompatible pointer type
/home/v4l/new_build/v4l/saa7134.h:728: note: expected 'struct vb2_queue *' but argument is of type 'struct videobuf_queue *'
/home/v4l/new_build/v4l/saa7134-ts.c:96: error: 'struct saa7134_buf' has no member named 'vb'
/home/v4l/new_build/v4l/saa7134-ts.c:98: error: 'struct saa7134_buf' has no member named 'vb'
/home/v4l/new_build/v4l/saa7134-ts.c:102: error: 'struct saa7134_buf' has no member named 'vb'
/home/v4l/new_build/v4l/saa7134-ts.c:103: error: 'struct saa7134_buf' has no member named 'vb'
/home/v4l/new_build/v4l/saa7134-ts.c:104: error: 'struct saa7134_buf' has no member named 'vb'
/home/v4l/new_build/v4l/saa7134-ts.c:107: error: 'struct saa7134_buf' has no member named 'vb'
/home/v4l/new_build/v4l/saa7134-ts.c:118: error: 'struct saa7134_buf' has no member named 'vb'
/home/v4l/new_build/v4l/saa7134-ts.c:120: error: 'struct saa7134_buf' has no member named 'vb'
/home/v4l/new_build/v4l/saa7134-ts.c:124: warning: passing argument 1 of 'saa7134_dma_free' from incompatible pointer type
/home/v4l/new_build/v4l/saa7134.h:728: note: expected 'struct vb2_queue *' but argument is of type 'struct videobuf_queue *'
/home/v4l/new_build/v4l/saa7134-ts.c: In function 'buffer_queue':
/home/v4l/new_build/v4l/saa7134-ts.c:144: error: 'struct saa7134_buf' has no member named 'vb'
/home/v4l/new_build/v4l/saa7134-ts.c:144: warning: type defaults to 'int' in declaration of '__mptr'
/home/v4l/new_build/v4l/saa7134-ts.c:144: warning: initialization from incompatible pointer type
/home/v4l/new_build/v4l/saa7134-ts.c:144: error: 'struct saa7134_buf' has no member named 'vb'
/home/v4l/new_build/v4l/saa7134-ts.c: In function 'buffer_release':
/home/v4l/new_build/v4l/saa7134-ts.c:151: error: 'struct saa7134_buf' has no member named 'vb'
/home/v4l/new_build/v4l/saa7134-ts.c:151: warning: type defaults to 'int' in declaration of '__mptr'
/home/v4l/new_build/v4l/saa7134-ts.c:151: warning: initialization from incompatible pointer type
/home/v4l/new_build/v4l/saa7134-ts.c:151: error: 'struct saa7134_buf' has no member named 'vb'
/home/v4l/new_build/v4l/saa7134-ts.c:157: warning: passing argument 1 of 'saa7134_dma_free' from incompatible pointer type
/home/v4l/new_build/v4l/saa7134.h:728: note: expected 'struct vb2_queue *' but argument is of type 'struct videobuf_queue *'
/home/v4l/new_build/v4l/saa7134-ts.c: In function 'saa7134_irq_ts_done':
/home/v4l/new_build/v4l/saa7134-ts.c:306: error: 'struct saa7134_buf' has no member named 'vb'
/home/v4l/new_build/v4l/saa7134-tvaudio.c: In function 'mute_input_7134':
/home/v4l/new_build/v4l/saa7134-tvaudio.c:197: error: 'struct saa7134_board' has no member named 'radio'
/home/v4l/new_build/v4l/saa7134-tvaudio.c: In function 'tvaudio_thread_ddep':
/home/v4l/new_build/v4l/saa7134-tvaudio.c:791: error: 'struct saa7134_board' has no member named 'radio'

Ok, those are the last ones from the patch series.

Please answer/fix the issues I've pointed, in order to allow me to finish vb2 tests
and move those stuff forward.

Thanks!
Mauro
