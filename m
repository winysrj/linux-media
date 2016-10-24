Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:9946 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934865AbcJXI1F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 04:27:05 -0400
From: Jean Christophe TROTIN <jean-christophe.trotin@st.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Mon, 24 Oct 2016 10:26:49 +0200
Subject: Re: [patch] [media] st-hva: fix some error handling in
 hva_hw_probe()
Message-ID: <9c07d71a-2d04-3733-4077-49838c23090c@st.com>
References: <20161014072928.GB15168@mwanda>
In-Reply-To: <20161014072928.GB15168@mwanda>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks,

Acked-by: Jean-Christophe Trotin <jean-christophe.trotin@st.com>

On 10/14/2016 09:32 AM, Dan Carpenter wrote:
> The devm_ioremap_resource() returns error pointers, never NULL.  The
> platform_get_resource() returns NULL on error, never error pointers.
> The error code needs to be set, as well.  The current code returns
> PTR_ERR(NULL) which is success.
>
> Fixes: 57b2c0628b60 ("[media] st-hva: multi-format video encoder V4L2 driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/media/platform/sti/hva/hva-hw.c b/drivers/media/platform/sti/hva/hva-hw.c
> index d341d49..cf2a8d8 100644
> --- a/drivers/media/platform/sti/hva/hva-hw.c
> +++ b/drivers/media/platform/sti/hva/hva-hw.c
> @@ -305,16 +305,16 @@ int hva_hw_probe(struct platform_device *pdev, struct hva_dev *hva)
>  	/* get memory for registers */
>  	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	hva->regs = devm_ioremap_resource(dev, regs);
> -	if (IS_ERR_OR_NULL(hva->regs)) {
> +	if (IS_ERR(hva->regs)) {
>  		dev_err(dev, "%s     failed to get regs\n", HVA_PREFIX);
>  		return PTR_ERR(hva->regs);
>  	}
>
>  	/* get memory for esram */
>  	esram = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -	if (IS_ERR_OR_NULL(esram)) {
> +	if (!esram) {
>  		dev_err(dev, "%s     failed to get esram\n", HVA_PREFIX);
> -		return PTR_ERR(esram);
> +		return -ENODEV;
>  	}
>  	hva->esram_addr = esram->start;
>  	hva->esram_size = resource_size(esram);
>