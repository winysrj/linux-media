Return-path: <linux-media-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40258 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752931AbcKST6z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Nov 2016 14:58:55 -0500
Date: Sat, 19 Nov 2016 19:58:50 +0000
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Sean Young <sean@mess.org>
Subject: Re: [PATCH] [media] cx88: make checkpatch.pl happy
Message-ID: <20161119195850.GA11418@dell-m4800.home>
References: <8729e94b8ef1fd4a17631d6a0c81b8a10b7d3a54.1479557581.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8729e94b8ef1fd4a17631d6a0c81b8a10b7d3a54.1479557581.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is from checkpatch run on cx88 source files with "-f", not your
patch files, right? I guess it might produce less changes if run on
patches.

On Sat, Nov 19, 2016 at 10:14:05AM -0200, Mauro Carvalho Chehab wrote:
> Usually, I don't like fixing coding style issues on non-staging
> drivers, as it could be a mess pretty easy, and could become like
> a snow ball. That's the case of recent changes on two changesets:
> they disalign some statements.

In my understanding, commits dedicated to style fixes on non-staging are
discouraged because they clutter git log and "git blame" view. But new
commits are encouraged to be style-perfect.

And in case of discussed alignment breakage, I expected that you make
this your fixup (the current patch) really a git-ish fixup and just
merge it into 09/35 patch. As I see it's published in media tree master
already and you are not going to force-push there; maybe a bit of
latency in pushing patches to media tree after publishing them for
review would prevent this sort of inconvenience.

P. S. (Running away from rotten tomatoes) another way to avoid such
painful alignment issues is to legalize "one-more-tab" indentation for
trailing parts of lines, alignment on opening brace is brittle IMHO.


> --- a/drivers/media/pci/cx88/cx88-blackbird.c
> +++ b/drivers/media/pci/cx88/cx88-blackbird.c

> @@ -1061,7 +1092,8 @@ static int cx8802_blackbird_advise_acquire(struct cx8802_driver *drv)
>  
>  	switch (core->boardnr) {
>  	case CX88_BOARD_HAUPPAUGE_HVR1300:
> -		/* By default, core setup will leave the cx22702 out of reset, on the bus.
> +		/* By default, core setup will leave the cx22702 out of reset,
> +		 * on the bus.
>  		 * We left the hardware on power up with the cx22702 active.
>  		 * We're being given access to re-arrange the GPIOs.
>  		 * Take the bus off the cx22702 and put the cx23416 on it.

Let first line with "/*" be empty :)

> --- a/drivers/media/pci/cx88/cx88-core.c
> +++ b/drivers/media/pci/cx88/cx88-core.c

> @@ -102,28 +104,29 @@ static __le32 *cx88_risc_field(__le32 *rp, struct scatterlist *sglist,
>  			sol = RISC_SOL | RISC_IRQ1 | RISC_CNT_INC;
>  		else
>  			sol = RISC_SOL;
> -		if (bpl <= sg_dma_len(sg)-offset) {
> +		if (bpl <= sg_dma_len(sg) - offset) {
>  			/* fits into current chunk */
> -			*(rp++) = cpu_to_le32(RISC_WRITE|sol|RISC_EOL|bpl);
> -			*(rp++) = cpu_to_le32(sg_dma_address(sg)+offset);
> +			*(rp++) = cpu_to_le32(RISC_WRITE | sol |
> +					      RISC_EOL | bpl);
> +			*(rp++) = cpu_to_le32(sg_dma_address(sg) + offset);
>  			offset += bpl;
>  		} else {
>  			/* scanline needs to be split */
>  			todo = bpl;
> -			*(rp++) = cpu_to_le32(RISC_WRITE|sol|
> -					    (sg_dma_len(sg)-offset));
> -			*(rp++) = cpu_to_le32(sg_dma_address(sg)+offset);
> -			todo -= (sg_dma_len(sg)-offset);
> +			*(rp++) = cpu_to_le32(RISC_WRITE | sol |
> +					    (sg_dma_len(sg) - offset));

This is strange, but checkpatch --strict is really happy on this,
however there is a misalignment in added lines. Going to look into this
later.

> --- a/drivers/media/pci/cx88/cx88-input.c
> +++ b/drivers/media/pci/cx88/cx88-input.c
> @@ -62,11 +62,15 @@ static int ir_debug;
>  module_param(ir_debug, int, 0644);	/* debug level [IR] */
>  MODULE_PARM_DESC(ir_debug, "enable debug messages [IR]");
>  
> -#define ir_dprintk(fmt, arg...)	if (ir_debug) \
> -	printk(KERN_DEBUG "%s IR: " fmt, ir->core->name, ##arg)
> +#define ir_dprintk(fmt, arg...)	do {					\

Backslash stands out.

> --- a/drivers/media/pci/cx88/cx88-reg.h
> +++ b/drivers/media/pci/cx88/cx88-reg.h
> @@ -1,32 +1,32 @@
>  /*
> -
> -    cx88x-hw.h - CX2388x register offsets
> -
> -    Copyright (C) 1996,97,98 Ralph Metzler (rjkm@thp.uni-koeln.de)
> -		  2001 Michael Eskin
> -		  2002 Yurij Sysoev <yurij@naturesoft.net>
> -		  2003 Gerd Knorr <kraxel@bytesex.org>
> -
> -    This program is free software; you can redistribute it and/or modify
> -    it under the terms of the GNU General Public License as published by
> -    the Free Software Foundation; either version 2 of the License, or
> -    (at your option) any later version.
> -
> -    This program is distributed in the hope that it will be useful,
> -    but WITHOUT ANY WARRANTY; without even the implied warranty of
> -    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> -    GNU General Public License for more details.
> -
> -    You should have received a copy of the GNU General Public License
> -    along with this program; if not, write to the Free Software
> -    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> -*/
> + * cx88x-hw.h - CX2388x register offsets
> + *
> + * Copyright (C) 1996,97,98 Ralph Metzler (rjkm@thp.uni-koeln.de)
> + *		  2001 Michael Eskin
> + *		  2002 Yurij Sysoev <yurij@naturesoft.net>
> + *		  2003 Gerd Knorr <kraxel@bytesex.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */

Checkpatch is not happy of seeing FSF address.

> --- a/drivers/media/pci/cx88/cx88-tvaudio.c
> +++ b/drivers/media/pci/cx88/cx88-tvaudio.c

> @@ -797,19 +804,22 @@ void cx88_set_tvaudio(struct cx88_core *core)
>  		pr_info("unknown tv audio mode [%d]\n", core->tvaudio);
>  		break;
>  	}
> -	return;
>  }
> +EXPORT_SYMBOL(cx88_set_tvaudio);
>  
>  void cx88_newstation(struct cx88_core *core)
>  {
>  	core->audiomode_manual = UNSET;
>  	core->last_change = jiffies;
>  }
> +EXPORT_SYMBOL(cx88_newstation);
>  
>  void cx88_get_stereo(struct cx88_core *core, struct v4l2_tuner *t)
>  {
> -	static const char * const m[] = { "stereo", "dual mono", "mono", "sap" };
> -	static const char * const p[] = { "no pilot", "pilot c1", "pilot c2", "?" };
> +	static const char * const m[] = { "stereo", "dual mono",
> +					  "mono", "sap" };
> +	static const char * const p[] = { "no pilot", "pilot c1",
> +					   "pilot c2", "?" };

Strange misalignment.

> --- a/drivers/media/pci/cx88/cx88.h
> +++ b/drivers/media/pci/cx88/cx88.h

> @@ -567,7 +566,8 @@ struct cx8802_dev {
>  
>  	/* mpeg params */
>  	struct cx2341x_handler     cxhdl;
> -#endif
> +
> +	#endif

???

> @@ -589,40 +589,41 @@ struct cx8802_dev {
>  
>  /* ----------------------------------------------------------- */
>  
> -#define cx_read(reg)             readl(core->lmmio + ((reg)>>2))
> -#define cx_write(reg, value)      writel((value), core->lmmio + ((reg)>>2))
> -#define cx_writeb(reg, value)     writeb((value), core->bmmio + (reg))
> +#define cx_read(reg)             readl(core->lmmio + ((reg) >> 2))
> +#define cx_write(reg, value)     writel((value), core->lmmio + ((reg) >> 2))
> +#define cx_writeb(reg, value)    writeb((value), core->bmmio + (reg))
>  
>  #define cx_andor(reg, mask, value) \
> -  writel((readl(core->lmmio+((reg)>>2)) & ~(mask)) |\
> -  ((value) & (mask)), core->lmmio+((reg)>>2))
> -#define cx_set(reg, bit)          cx_andor((reg), (bit), (bit))
> -#define cx_clear(reg, bit)        cx_andor((reg), (bit), 0)
> +	writel((readl(core->lmmio + ((reg) >> 2)) & ~(mask)) |\
> +	((value) & (mask)), core->lmmio + ((reg) >> 2))
> +#define cx_set(reg, bit)         cx_andor((reg), (bit), (bit))
> +#define cx_clear(reg, bit)       cx_andor((reg), (bit), 0)
>  
>  #define cx_wait(d) { if (need_resched()) schedule(); else udelay(d); }
>  
>  /* shadow registers */
>  #define cx_sread(sreg)		    (core->shadow[sreg])
>  #define cx_swrite(sreg, reg, value) \
> -  (core->shadow[sreg] = value, \
> -   writel(core->shadow[sreg], core->lmmio + ((reg)>>2)))
> +	(core->shadow[sreg] = value, \
> +	writel(core->shadow[sreg], core->lmmio + ((reg) >> 2)))
>  #define cx_sandor(sreg, reg, mask, value) \
> -  (core->shadow[sreg] = (core->shadow[sreg] & ~(mask)) | ((value) & (mask)), \
> -   writel(core->shadow[sreg], core->lmmio + ((reg)>>2)))
> +	(core->shadow[sreg] = (core->shadow[sreg] & ~(mask)) | \
> +			       ((value) & (mask)), \
> +	writel(core->shadow[sreg], core->lmmio + ((reg) >> 2)))

I hate to be so boring, but last line is misaligned, one space is
lacking :)


Everything else seems fine.
