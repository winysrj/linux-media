Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37712 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408AbZFPTUx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 15:20:53 -0400
Date: Tue, 16 Jun 2009 16:20:51 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: David Wong <davidtlwong@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] lgs8gxx: add lgs8g75 support
Message-ID: <20090616162051.57510242@pedra.chehab.org>
In-Reply-To: <15ed362e0906110539j6edc0ca6o773b9a8866ae5b6a@mail.gmail.com>
References: <15ed362e0906110539j6edc0ca6o773b9a8866ae5b6a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 11 Jun 2009 20:39:12 +0800
David Wong <davidtlwong@gmail.com> escreveu:

> @@ -238,21 +384,26 @@
>  					  u8 *finished)
>  {
>  	int ret = 0;
> -	u8 t;
> +	u8 reg, mask, val;
>  
> -	ret = lgs8gxx_read_reg(priv, 0xA4, &t);
> -	if (ret != 0)
> -		return ret;
> +	if (priv->config->prod == LGS8GXX_PROD_LGS8G75) {
> +		reg = 0x1f; mask = 0xC0; val = 0x80;
> +	} else {
> +		reg = 0xA4; mask = 0x03; val = 0x01;
> +	}

Please, one statement per line.

> +	if (priv->config->prod == LGS8GXX_PROD_LGS8G75) {
> +		reg_total = 0x28; reg_err = 0x2C;
> +	} else {
> +		reg_total = 0xD0; reg_err = 0xD4;
> +	}

Please, one statement per line.




Cheers,
Mauro
