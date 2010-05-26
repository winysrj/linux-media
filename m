Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:58544 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab0EZMnq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 May 2010 08:43:46 -0400
Date: Wed, 26 May 2010 14:43:43 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Beholder Intl. Ltd. Dmitry Belimov" <d.belimov@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch v3 2/2] video/saa7134: remove duplicate break
Message-ID: <20100526144343.0c2369da@hyperion.delvare>
In-Reply-To: <20100525092149.GA13089@bicker>
References: <20100525092149.GA13089@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 25 May 2010 11:21:50 +0200, Dan Carpenter wrote:
> The original code had two break statements in a row.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Jean Delvare <khali@linux-fr.org>

> ---
> v3: Put this in a seperate patch.
> 
> diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
> index e5565e2..7691bf2 100644
> --- a/drivers/media/video/saa7134/saa7134-input.c
> +++ b/drivers/media/video/saa7134/saa7134-input.c
> @@ -815,7 +815,6 @@ int saa7134_input_init1(struct saa7134_dev *dev)
>  		mask_keyup   = 0x020000;
>  		polling      = 50; /* ms */
>  		break;
> -	break;
>  	}
>  	if (NULL == ir_codes) {
>  		printk("%s: Oops: IR config error [card=%d]\n",
> 


-- 
Jean Delvare
