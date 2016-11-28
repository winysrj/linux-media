Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:50527 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932857AbcK1Qvm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Nov 2016 11:51:42 -0500
Date: Mon, 28 Nov 2016 10:51:37 -0600
From: Benoit Parrot <bparrot@ti.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Nikhil Devshatwar <nikhil.nd@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-media@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] [media] media: ti-vpe: vpdma: fix a timeout loop
Message-ID: <20161128165137.GE5954@ti.com>
References: <20161125201957.GA30161@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20161125201957.GA30161@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dan,

Thanks for the patch.

Acked-by: Benoit Parrot <bparrot@ti.com>

Dan Carpenter <dan.carpenter@oracle.com> wrote on Sat [2016-Nov-26 00:28:34 +0300]:
> The check assumes that we end on zero but actually we end on -1.  Change
> the post-op to a pre-op so that we do end on zero.  Techinically now we
> only loop 499 times instead of 500 but that's fine.
> 
> Fixes: dc12b124353b ("[media] media: ti-vpe: vpdma: Add abort channel desc and cleanup APIs")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
> index 13bfd71..23472e3 100644
> --- a/drivers/media/platform/ti-vpe/vpdma.c
> +++ b/drivers/media/platform/ti-vpe/vpdma.c
> @@ -453,7 +453,7 @@ int vpdma_list_cleanup(struct vpdma_data *vpdma, int list_num,
>  	if (ret)
>  		return ret;
>  
> -	while (vpdma_list_busy(vpdma, list_num) && timeout--)
> +	while (vpdma_list_busy(vpdma, list_num) && --timeout)
>  		;
>  
>  	if (timeout == 0) {
