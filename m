Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:34327 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab3LVOBU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Dec 2013 09:01:20 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MY7002ZUOA6SV40@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 22 Dec 2013 09:01:18 -0500 (EST)
Date: Sun, 22 Dec 2013 12:01:14 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 10/11] media: rc: img-ir: add Sharp decoder module
Message-id: <20131222120114.7aecbf9e@samsung.com>
In-reply-to: <1386947579-26703-11-git-send-email-james.hogan@imgtec.com>
References: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com>
 <1386947579-26703-11-git-send-email-james.hogan@imgtec.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 13 Dec 2013 15:12:58 +0000
James Hogan <james.hogan@imgtec.com> escreveu:

> Add an img-ir module for decoding the Sharp infrared protocol.

Patches 5 and 7-11 look OK to me.

While not required for patchset acceptance, it would be great if you could
also add an IR raw decoder for this protocol, specially if you can also
test it.

> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: linux-media@vger.kernel.org
> ---
>  drivers/media/rc/img-ir/Kconfig        |   7 ++
>  drivers/media/rc/img-ir/Makefile       |   1 +
>  drivers/media/rc/img-ir/img-ir-sharp.c | 115 +++++++++++++++++++++++++++++++++
>  3 files changed, 123 insertions(+)
>  create mode 100644 drivers/media/rc/img-ir/img-ir-sharp.c
> 
> diff --git a/drivers/media/rc/img-ir/Kconfig b/drivers/media/rc/img-ir/Kconfig
> index 38505188df0e..24e0966a3220 100644
> --- a/drivers/media/rc/img-ir/Kconfig
> +++ b/drivers/media/rc/img-ir/Kconfig
> @@ -45,3 +45,10 @@ config IR_IMG_SONY
>  	help
>  	   Say Y or M here to enable support for the Sony protocol in the ImgTec
>  	   infrared decoder block.
> +
> +config IR_IMG_SHARP
> +	tristate "Sharp protocol support"
> +	depends on IR_IMG && IR_IMG_HW
> +	help
> +	   Say Y or M here to enable support for the Sharp protocol in the
> +	   ImgTec infrared decoder block.
> diff --git a/drivers/media/rc/img-ir/Makefile b/drivers/media/rc/img-ir/Makefile
> index f3e7cc4f32e4..3c3ab4f1a9f1 100644
> --- a/drivers/media/rc/img-ir/Makefile
> +++ b/drivers/media/rc/img-ir/Makefile
> @@ -7,3 +7,4 @@ obj-$(CONFIG_IR_IMG)		+= img-ir.o
>  obj-$(CONFIG_IR_IMG_NEC)	+= img-ir-nec.o
>  obj-$(CONFIG_IR_IMG_JVC)	+= img-ir-jvc.o
>  obj-$(CONFIG_IR_IMG_SONY)	+= img-ir-sony.o
> +obj-$(CONFIG_IR_IMG_SHARP)	+= img-ir-sharp.o
> diff --git a/drivers/media/rc/img-ir/img-ir-sharp.c b/drivers/media/rc/img-ir/img-ir-sharp.c
> new file mode 100644
> index 000000000000..4d70abc088b4
> --- /dev/null
> +++ b/drivers/media/rc/img-ir/img-ir-sharp.c
> @@ -0,0 +1,115 @@
> +/*
> + * ImgTec IR Decoder setup for Sharp protocol.
> + *
> + * Copyright 2012-2013 Imagination Technologies Ltd.
> + */
> +
> +#include <linux/module.h>
> +
> +#include "img-ir-hw.h"
> +
> +/* Convert Sharp data to a scancode */
> +static int img_ir_sharp_scancode(int len, u64 raw, u64 protocols)
> +{
> +	unsigned int addr, cmd, exp, chk;
> +
> +	if (len != 15)
> +		return IMG_IR_ERR_INVALID;
> +
> +	addr = (raw >>   0) & 0x1f;
> +	cmd  = (raw >>   5) & 0xff;
> +	exp  = (raw >>  13) &  0x1;
> +	chk  = (raw >>  14) &  0x1;
> +
> +	/* validate data */
> +	if (!exp)
> +		return IMG_IR_ERR_INVALID;
> +	if (chk)
> +		/* probably the second half of the message */
> +		return IMG_IR_ERR_INVALID;
> +
> +	return addr << 8 | cmd;
> +}
> +
> +/* Convert Sharp scancode to Sharp data filter */
> +static int img_ir_sharp_filter(const struct img_ir_sc_filter *in,
> +			       struct img_ir_filter *out, u64 protocols)
> +{
> +	unsigned int addr, cmd, exp = 0, chk = 0;
> +	unsigned int addr_m, cmd_m, exp_m = 0, chk_m = 0;
> +
> +	addr   = (in->data >> 8) & 0x1f;
> +	addr_m = (in->mask >> 8) & 0x1f;
> +	cmd    = (in->data >> 0) & 0xff;
> +	cmd_m  = (in->mask >> 0) & 0xff;
> +	if (cmd_m) {
> +		/* if filtering commands, we can only match the first part */
> +		exp   = 1;
> +		exp_m = 1;
> +		chk   = 0;
> +		chk_m = 1;
> +	}
> +
> +	out->data = addr        |
> +		    cmd   <<  5 |
> +		    exp   << 13 |
> +		    chk   << 14;
> +	out->mask = addr_m      |
> +		    cmd_m <<  5 |
> +		    exp_m << 13 |
> +		    chk_m << 14;
> +
> +	return 0;
> +}
> +
> +/*
> + * Sharp decoder
> + * See also http://www.sbprojects.com/knowledge/ir/sharp.php
> + */
> +static struct img_ir_decoder img_ir_sharp = {
> +	.type = RC_BIT_SHARP,
> +	.control = {
> +		.decoden = 0,
> +		.decodend2 = 1,
> +		.code_type = IMG_IR_CODETYPE_PULSEDIST,
> +		.d1validsel = 1,
> +	},
> +	/* main timings */
> +	.timings = {
> +		/* 0 symbol */
> +		.s10 = {
> +			.pulse = { 320	/* 320 us */ },
> +			.space = { 680	/* 1 ms period */ },
> +		},
> +		/* 1 symbol */
> +		.s11 = {
> +			.pulse = { 320	/* 230 us */ },
> +			.space = { 1680	/* 2 ms period */ },
> +		},
> +		/* free time */
> +		.ft = {
> +			.minlen = 15,
> +			.maxlen = 15,
> +			.ft_min = 5000,	/* 5 ms */
> +		},
> +	},
> +	/* scancode logic */
> +	.scancode = img_ir_sharp_scancode,
> +	.filter = img_ir_sharp_filter,
> +};
> +
> +static int __init img_ir_sharp_init(void)
> +{
> +	return img_ir_register_decoder(&img_ir_sharp);
> +}
> +module_init(img_ir_sharp_init);
> +
> +static void __exit img_ir_sharp_exit(void)
> +{
> +	img_ir_unregister_decoder(&img_ir_sharp);
> +}
> +module_exit(img_ir_sharp_exit);
> +
> +MODULE_AUTHOR("Imagination Technologies Ltd.");
> +MODULE_DESCRIPTION("ImgTec IR Sharp protocol support");
> +MODULE_LICENSE("GPL");


-- 

Cheers,
Mauro
