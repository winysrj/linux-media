Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:30268 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab3LRLWG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Dec 2013 06:22:06 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MY000A0G28S6A00@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 Dec 2013 06:22:04 -0500 (EST)
Date: Wed, 18 Dec 2013 09:21:58 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, sw0312.kim@samsung.com,
	andrzej.p@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 09/16] s5p-jpeg: Split jpeg-hw.h to jpeg-hw-s5p.c and
 jpeg-hw-s5p.c
Message-id: <20131218092158.4102dc89@samsung.com>
In-reply-to: <1385373503-1657-10-git-send-email-j.anaszewski@samsung.com>
References: <1385373503-1657-1-git-send-email-j.anaszewski@samsung.com>
 <1385373503-1657-10-git-send-email-j.anaszewski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 25 Nov 2013 10:58:16 +0100
Jacek Anaszewski <j.anaszewski@samsung.com> escreveu:

> Move function definitions from jpeg-hw.h to jpeg-hw-s5p.c
> and put function declarations in the jpeg-hw-s5p.h.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

...

> +void jpeg_reset(void __iomem *regs);
> +void jpeg_poweron(void __iomem *regs);
> +void jpeg_input_raw_mode(void __iomem *regs, unsigned long mode);
> +void jpeg_input_raw_y16(void __iomem *regs, bool y16);
> +void jpeg_proc_mode(void __iomem *regs, unsigned long mode);
> +void jpeg_subsampling_mode(void __iomem *regs, unsigned int mode);
> +unsigned int jpeg_get_subsampling_mode(void __iomem *regs);
> +void jpeg_dri(void __iomem *regs, unsigned int dri);
> +void jpeg_qtbl(void __iomem *regs, unsigned int t, unsigned int n);
> +void jpeg_htbl_ac(void __iomem *regs, unsigned int t);
> +void jpeg_htbl_dc(void __iomem *regs, unsigned int t);
> +void jpeg_y(void __iomem *regs, unsigned int y);
> +void jpeg_x(void __iomem *regs, unsigned int x);
> +void jpeg_rst_int_enable(void __iomem *regs, bool enable);
> +void jpeg_data_num_int_enable(void __iomem *regs, bool enable);
> +void jpeg_final_mcu_num_int_enable(void __iomem *regs, bool enbl);
> +void jpeg_timer_enable(void __iomem *regs, unsigned long val);
> +void jpeg_timer_disable(void __iomem *regs);
> +int jpeg_timer_stat(void __iomem *regs);
> +void jpeg_clear_timer_stat(void __iomem *regs);
> +void jpeg_enc_stream_int(void __iomem *regs, unsigned long size);
> +int jpeg_enc_stream_stat(void __iomem *regs);
> +void jpeg_clear_enc_stream_stat(void __iomem *regs);
> +void jpeg_outform_raw(void __iomem *regs, unsigned long format);
> +void jpeg_jpgadr(void __iomem *regs, unsigned long addr);
> +void jpeg_imgadr(void __iomem *regs, unsigned long addr);
> +void jpeg_coef(void __iomem *regs, unsigned int i,
> +			     unsigned int j, unsigned int coef);
> +void jpeg_start(void __iomem *regs);
> +int jpeg_result_stat_ok(void __iomem *regs);
> +int jpeg_stream_stat_ok(void __iomem *regs);
> +void jpeg_clear_int(void __iomem *regs);
> +unsigned int jpeg_compressed_size(void __iomem *regs);


NACK. Please don't pollute Kernel name space. 

Those functions are specific to s5p. They should all be prepended by s5p_, 
or otherwise it will risk to cause conflicts with other global symbols
that could have the same name, for kernels compiled will allyesconfig.

Regards,
-- 

Cheers,
Mauro
