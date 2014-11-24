Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56443 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbaKXSY4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 13:24:56 -0500
Date: Mon, 24 Nov 2014 16:24:51 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH for v3.18] media: use sg = sg_next(sg) instead of sg++
Message-ID: <20141124162451.5de16d9d@recife.lan>
In-Reply-To: <546F03F8.9000301@xs4all.nl>
References: <546F03F8.9000301@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 21 Nov 2014 10:20:56 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Several drivers (mostly copy-and-paste) still used sg++ instead of
> sg = sg_next(sg). Fix them since sg++ won't work if contiguous scatter
> entries where combined into one larger entry.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: stable@vger.kernel.org      # for v3.7 and up
> ---
>  drivers/media/pci/bt8xx/bttv-risc.c      | 12 ++++++------
>  drivers/media/pci/cx23885/cx23885-core.c |  6 +++---
>  drivers/media/pci/cx25821/cx25821-core.c | 12 ++++++------
>  drivers/media/pci/cx88/cx88-core.c       |  6 +++---
>  drivers/media/pci/ivtv/ivtv-udma.c       |  2 +-
>  5 files changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/pci/bt8xx/bttv-risc.c b/drivers/media/pci/bt8xx/bttv-risc.c
> index 82cc47d..4d3f05a 100644
> --- a/drivers/media/pci/bt8xx/bttv-risc.c
> +++ b/drivers/media/pci/bt8xx/bttv-risc.c
> @@ -84,7 +84,7 @@ bttv_risc_packed(struct bttv *btv, struct btcx_riscmem *risc,
>  			continue;
>  		while (offset && offset >= sg_dma_len(sg)) {
>  			offset -= sg_dma_len(sg);
> -			sg++;
> +			sg = sg_next(sg);
>  		}
>  		if (bpl <= sg_dma_len(sg)-offset) {
>  			/* fits into current chunk */
> @@ -100,13 +100,13 @@ bttv_risc_packed(struct bttv *btv, struct btcx_riscmem *risc,
>  			*(rp++)=cpu_to_le32(sg_dma_address(sg)+offset);
>  			todo -= (sg_dma_len(sg)-offset);
>  			offset = 0;
> -			sg++;
> +			sg = sg_next(sg);
>  			while (todo > sg_dma_len(sg)) {
>  				*(rp++)=cpu_to_le32(BT848_RISC_WRITE|
>  						    sg_dma_len(sg));
>  				*(rp++)=cpu_to_le32(sg_dma_address(sg));
>  				todo -= sg_dma_len(sg);
> -				sg++;
> +				sg = sg_next(sg);
>  			}
>  			*(rp++)=cpu_to_le32(BT848_RISC_WRITE|BT848_RISC_EOL|
>  					    todo);
> @@ -187,15 +187,15 @@ bttv_risc_planar(struct bttv *btv, struct btcx_riscmem *risc,
>  			/* go to next sg entry if needed */
>  			while (yoffset && yoffset >= sg_dma_len(ysg)) {
>  				yoffset -= sg_dma_len(ysg);
> -				ysg++;
> +				ysg = sg_next(ysg);
>  			}
>  			while (uoffset && uoffset >= sg_dma_len(usg)) {
>  				uoffset -= sg_dma_len(usg);
> -				usg++;
> +				usg = sg_next(usg);
>  			}
>  			while (voffset && voffset >= sg_dma_len(vsg)) {
>  				voffset -= sg_dma_len(vsg);
> -				vsg++;
> +				vsg = sg_next(vsg);
>  			}
>  
>  			/* calculate max number of bytes we can write */
> diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
> index 331edda..3bd386c 100644
> --- a/drivers/media/pci/cx23885/cx23885-core.c
> +++ b/drivers/media/pci/cx23885/cx23885-core.c
> @@ -1078,7 +1078,7 @@ static __le32 *cx23885_risc_field(__le32 *rp, struct scatterlist *sglist,
>  	for (line = 0; line < lines; line++) {
>  		while (offset && offset >= sg_dma_len(sg)) {
>  			offset -= sg_dma_len(sg);
> -			sg++;
> +			sg = sg_next(sg);
>  		}
>  
>  		if (lpi && line > 0 && !(line % lpi))
> @@ -1101,14 +1101,14 @@ static __le32 *cx23885_risc_field(__le32 *rp, struct scatterlist *sglist,
>  			*(rp++) = cpu_to_le32(0); /* bits 63-32 */
>  			todo -= (sg_dma_len(sg)-offset);
>  			offset = 0;
> -			sg++;
> +			sg = sg_next(sg);
>  			while (todo > sg_dma_len(sg)) {
>  				*(rp++) = cpu_to_le32(RISC_WRITE|
>  						    sg_dma_len(sg));
>  				*(rp++) = cpu_to_le32(sg_dma_address(sg));
>  				*(rp++) = cpu_to_le32(0); /* bits 63-32 */
>  				todo -= sg_dma_len(sg);
> -				sg++;
> +				sg = sg_next(sg);
>  			}
>  			*(rp++) = cpu_to_le32(RISC_WRITE|RISC_EOL|todo);
>  			*(rp++) = cpu_to_le32(sg_dma_address(sg));
> diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
> index e81173c..389fffd 100644
> --- a/drivers/media/pci/cx25821/cx25821-core.c
> +++ b/drivers/media/pci/cx25821/cx25821-core.c
> @@ -996,7 +996,7 @@ static __le32 *cx25821_risc_field(__le32 * rp, struct scatterlist *sglist,
>  	for (line = 0; line < lines; line++) {
>  		while (offset && offset >= sg_dma_len(sg)) {
>  			offset -= sg_dma_len(sg);
> -			sg++;
> +			sg = sg_next(sg);
>  		}
>  		if (bpl <= sg_dma_len(sg) - offset) {
>  			/* fits into current chunk */
> @@ -1014,14 +1014,14 @@ static __le32 *cx25821_risc_field(__le32 * rp, struct scatterlist *sglist,
>  			*(rp++) = cpu_to_le32(0);	/* bits 63-32 */
>  			todo -= (sg_dma_len(sg) - offset);
>  			offset = 0;
> -			sg++;
> +			sg = sg_next(sg);
>  			while (todo > sg_dma_len(sg)) {
>  				*(rp++) = cpu_to_le32(RISC_WRITE |
>  						sg_dma_len(sg));
>  				*(rp++) = cpu_to_le32(sg_dma_address(sg));
>  				*(rp++) = cpu_to_le32(0);	/* bits 63-32 */
>  				todo -= sg_dma_len(sg);
> -				sg++;
> +				sg = sg_next(sg);
>  			}
>  			*(rp++) = cpu_to_le32(RISC_WRITE | RISC_EOL | todo);
>  			*(rp++) = cpu_to_le32(sg_dma_address(sg));
> @@ -1101,7 +1101,7 @@ static __le32 *cx25821_risc_field_audio(__le32 * rp, struct scatterlist *sglist,
>  	for (line = 0; line < lines; line++) {
>  		while (offset && offset >= sg_dma_len(sg)) {
>  			offset -= sg_dma_len(sg);
> -			sg++;
> +			sg = sg_next(sg);
>  		}
>  
>  		if (lpi && line > 0 && !(line % lpi))
> @@ -1125,14 +1125,14 @@ static __le32 *cx25821_risc_field_audio(__le32 * rp, struct scatterlist *sglist,
>  			*(rp++) = cpu_to_le32(0);	/* bits 63-32 */
>  			todo -= (sg_dma_len(sg) - offset);
>  			offset = 0;
> -			sg++;
> +			sg = sg_next(sg);
>  			while (todo > sg_dma_len(sg)) {
>  				*(rp++) = cpu_to_le32(RISC_WRITE |
>  						sg_dma_len(sg));
>  				*(rp++) = cpu_to_le32(sg_dma_address(sg));
>  				*(rp++) = cpu_to_le32(0);	/* bits 63-32 */
>  				todo -= sg_dma_len(sg);
> -				sg++;
> +				sg = sg_next(sg);
>  			}
>  			*(rp++) = cpu_to_le32(RISC_WRITE | RISC_EOL | todo);
>  			*(rp++) = cpu_to_le32(sg_dma_address(sg));
> diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
> index 9fa4acb..dee177e 100644
> --- a/drivers/media/pci/cx88/cx88-core.c
> +++ b/drivers/media/pci/cx88/cx88-core.c
> @@ -95,7 +95,7 @@ static __le32* cx88_risc_field(__le32 *rp, struct scatterlist *sglist,
>  	for (line = 0; line < lines; line++) {
>  		while (offset && offset >= sg_dma_len(sg)) {
>  			offset -= sg_dma_len(sg);
> -			sg++;
> +			sg = sg_next(sg);
>  		}
>  		if (lpi && line>0 && !(line % lpi))
>  			sol = RISC_SOL | RISC_IRQ1 | RISC_CNT_INC;
> @@ -114,13 +114,13 @@ static __le32* cx88_risc_field(__le32 *rp, struct scatterlist *sglist,
>  			*(rp++)=cpu_to_le32(sg_dma_address(sg)+offset);
>  			todo -= (sg_dma_len(sg)-offset);
>  			offset = 0;
> -			sg++;
> +			sg = sg_next(sg);
>  			while (todo > sg_dma_len(sg)) {
>  				*(rp++)=cpu_to_le32(RISC_WRITE|
>  						    sg_dma_len(sg));
>  				*(rp++)=cpu_to_le32(sg_dma_address(sg));
>  				todo -= sg_dma_len(sg);
> -				sg++;
> +				sg = sg_next(sg);
>  			}
>  			*(rp++)=cpu_to_le32(RISC_WRITE|RISC_EOL|todo);
>  			*(rp++)=cpu_to_le32(sg_dma_address(sg));
> diff --git a/drivers/media/pci/ivtv/ivtv-udma.c b/drivers/media/pci/ivtv/ivtv-udma.c
> index 7338cb2..bee2329 100644
> --- a/drivers/media/pci/ivtv/ivtv-udma.c
> +++ b/drivers/media/pci/ivtv/ivtv-udma.c
> @@ -76,7 +76,7 @@ void ivtv_udma_fill_sg_array (struct ivtv_user_dma *dma, u32 buffer_offset, u32
>  	int i;
>  	struct scatterlist *sg;
>  
> -	for (i = 0, sg = dma->SGlist; i < dma->SG_length; i++, sg++) {
> +	for (i = 0, sg = dma->SGlist; i < dma->SG_length; i++, sg = sg_next(sg)) {

This hunk seems awkward, at least on my eyes. 

As you've pointed at the description, S/G can be grouped into bigger
segments. So, the maximum number of S/G can actually be less than
dma->SGlist.

The proper fix here seems to convert it into a while that will stop
if the accumulated size matches the transfer size, just like the loops
at the other similar drivers.

>  		dma->SGarray[i].size = cpu_to_le32(sg_dma_len(sg));
>  		dma->SGarray[i].src = cpu_to_le32(sg_dma_address(sg));
>  		dma->SGarray[i].dst = cpu_to_le32(buffer_offset);
