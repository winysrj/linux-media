Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33839 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab3G2MbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 08:31:25 -0400
Message-ID: <1375101048.4223.11.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v2 6/8] [media] coda: dynamic IRAM setup for decoder
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?ISO-8859-1?Q?Ga=EBtan?= Carlier <gcembed@gmail.com>,
	Wei Yongjun <weiyj.lk@gmail.com>
Date: Mon, 29 Jul 2013 14:30:48 +0200
In-Reply-To: <20130726121841.10f9fe17@samsung.com>
References: <1371801334-22324-1-git-send-email-p.zabel@pengutronix.de>
	 <1371801334-22324-7-git-send-email-p.zabel@pengutronix.de>
	 <20130726121841.10f9fe17@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Am Freitag, den 26.07.2013, 12:18 -0300 schrieb Mauro Carvalho Chehab:
> Em Fri, 21 Jun 2013 09:55:32 +0200
> Philipp Zabel <p.zabel@pengutronix.de> escreveu:
> 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> 
> Please add a description for the patch.

Sorry I missed this, description is the same as for the encoder IRAM
setup:

"This sets up IRAM areas used as temporary memory for the different
 hardware units depending on the frame size."

regards
Philipp

> Thanks!
> Mauro
> 
> > ---
> >  drivers/media/platform/coda.c | 50 +++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 48 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> > index 1f3bd43..856a93e 100644
> > --- a/drivers/media/platform/coda.c
> > +++ b/drivers/media/platform/coda.c
> > @@ -1212,6 +1212,7 @@ static void coda_setup_iram(struct coda_ctx *ctx)
> >  	int ipacdc_size;
> >  	int bitram_size;
> >  	int dbk_size;
> > +	int ovl_size;
> >  	int mb_width;
> >  	int me_size;
> >  	int size;
> > @@ -1273,7 +1274,47 @@ static void coda_setup_iram(struct coda_ctx *ctx)
> >  			size -= ipacdc_size;
> >  		}
> >  
> > -		/* OVL disabled for encoder */
> > +		/* OVL and BTP disabled for encoder */
> > +	} else if (ctx->inst_type == CODA_INST_DECODER) {
> > +		struct coda_q_data *q_data_dst;
> > +		int mb_height;
> > +
> > +		q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> > +		mb_width = DIV_ROUND_UP(q_data_dst->width, 16);
> > +		mb_height = DIV_ROUND_UP(q_data_dst->height, 16);
> > +
> > +		dbk_size = round_up(256 * mb_width, 1024);
> > +		if (size >= dbk_size) {
> > +			iram_info->axi_sram_use |= CODA7_USE_HOST_DBK_ENABLE;
> > +			iram_info->buf_dbk_y_use = dev->iram_paddr;
> > +			iram_info->buf_dbk_c_use = dev->iram_paddr +
> > +						   dbk_size / 2;
> > +			size -= dbk_size;
> > +		} else {
> > +			goto out;
> > +		}
> > +
> > +		bitram_size = round_up(128 * mb_width, 1024);
> > +		if (size >= bitram_size) {
> > +			iram_info->axi_sram_use |= CODA7_USE_HOST_BIT_ENABLE;
> > +			iram_info->buf_bit_use = iram_info->buf_dbk_c_use +
> > +						 dbk_size / 2;
> > +			size -= bitram_size;
> > +		} else {
> > +			goto out;
> > +		}
> > +
> > +		ipacdc_size = round_up(128 * mb_width, 1024);
> > +		if (size >= ipacdc_size) {
> > +			iram_info->axi_sram_use |= CODA7_USE_HOST_IP_ENABLE;
> > +			iram_info->buf_ip_ac_dc_use = iram_info->buf_bit_use +
> > +						      bitram_size;
> > +			size -= ipacdc_size;
> > +		} else {
> > +			goto out;
> > +		}
> > +
> > +		ovl_size = round_up(80 * mb_width, 1024);
> >  	}
> >  
> >  out:
> > @@ -1300,7 +1341,12 @@ out:
> >  
> >  	if (dev->devtype->product == CODA_7541) {
> >  		/* TODO - Enabling these causes picture errors on CODA7541 */
> > -		if (ctx->inst_type == CODA_INST_ENCODER) {
> > +		if (ctx->inst_type == CODA_INST_DECODER) {
> > +			/* fw 1.4.50 */
> > +			iram_info->axi_sram_use &= ~(CODA7_USE_HOST_IP_ENABLE |
> > +						     CODA7_USE_IP_ENABLE);
> > +		} else {
> > +			/* fw 13.4.29 */
> >  			iram_info->axi_sram_use &= ~(CODA7_USE_HOST_IP_ENABLE |
> >  						     CODA7_USE_HOST_DBK_ENABLE |
> >  						     CODA7_USE_IP_ENABLE |
> 
> 


