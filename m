Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx01.sz.bfs.de ([194.94.69.103]:62695 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932345Ab0EDOaF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 May 2010 10:30:05 -0400
Message-ID: <4BE02F66.8060300@bfs.de>
Date: Tue, 04 May 2010 16:29:58 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Adams.xu@azwave.com.cn, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch -next 1/2] media/az6027: doing dma on the stack
References: <20100504121429.GW29093@bicker>
In-Reply-To: <20100504121429.GW29093@bicker>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Dan Carpenter schrieb:
> I changed the dma buffers to use allocated memory instead of stack
> memory.
> 
> The reason for this is documented in Documentation/DMA-API-HOWTO.txt
> under the section:  "What memory is DMA'able?"  That document was only
> added a couple weeks ago and there are still lots of modules which
> haven't been corrected yet.  Btw. Smatch includes a pretty good test to
> find places which use stack memory as a dma buffer.  That's how I found
> these.  (http://smatch.sf.net).
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/media/dvb/dvb-usb/az6027.c b/drivers/media/dvb/dvb-usb/az6027.c
> index 8934788..baaa301 100644
> --- a/drivers/media/dvb/dvb-usb/az6027.c
> +++ b/drivers/media/dvb/dvb-usb/az6027.c
> @@ -417,11 +417,15 @@ static int az6027_ci_read_attribute_mem(struct dvb_ca_en50221 *ca,
>  	u16 value;
>  	u16 index;
>  	int blen;
> -	u8 b[12];
> +	u8 *b;
>  
>  	if (slot != 0)
>  		return -EINVAL;
>  
> +	b = kmalloc(12, GFP_KERNEL);
> +	if (!b)
> +		return -ENOMEM;
> +
>  	mutex_lock(&state->ca_mutex);
>  
>  	req = 0xC1;


Hi Dan,
i am not sure if that is the way to go.
iff i understand the code correctly the b[12] seems to overcommit  only
blen bytes (not 12) is needed. There must be a cheaper way to send a few bytes
of space to send a command to a device. Perhaps gregKH has a hint ?

re,
 wh
