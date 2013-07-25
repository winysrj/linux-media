Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx01-sz.bfs.de ([194.94.69.67]:37313 "EHLO mx01-sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756882Ab3GYRfp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 13:35:45 -0400
Message-ID: <51F16065.40804@bfs.de>
Date: Thu, 25 Jul 2013 19:29:09 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Antti Palosaari <crope@iki.fi>,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] bt8xx: info leak in ca_get_slot_info()
References: <20130725164621.GA6945@elgon.mountain>
In-Reply-To: <20130725164621.GA6945@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Am 25.07.2013 18:46, schrieb Dan Carpenter:
> p_ca_slot_info was allocated with kmalloc() so we need to clear it
> before passing it to the user.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/media/pci/bt8xx/dst_ca.c b/drivers/media/pci/bt8xx/dst_ca.c
> index 0e788fc..6b9dc3f 100644
> --- a/drivers/media/pci/bt8xx/dst_ca.c
> +++ b/drivers/media/pci/bt8xx/dst_ca.c
> @@ -302,8 +302,11 @@ static int ca_get_slot_info(struct dst_state *state, struct ca_slot_info *p_ca_s
>  		p_ca_slot_info->flags = CA_CI_MODULE_READY;
>  		p_ca_slot_info->num = 1;
>  		p_ca_slot_info->type = CA_CI;
> -	} else
> +	} else {
>  		p_ca_slot_info->flags = 0;
> +		p_ca_slot_info->num = 0;
> +		p_ca_slot_info->type = 0;
> +	}
>  
>  	if (copy_to_user(arg, p_ca_slot_info, sizeof (struct ca_slot_info)))
>  		return -EFAULT;

note: i have no clue how p_ca_slot_info looks like,
but to avoid information leaks via compiler padding etc. i could be more wise
to do a  memset(p_ca_slot_info,0,sizeof (struct ca_slot_info))
and then set the
	p_ca_slot_info->flags = CA_CI_MODULE_READY;
	p_ca_slot_info->num = 1;
	p_ca_slot_info->type = CA_CI;

just my 2 cents,
re,
 wh
