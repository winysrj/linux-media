Return-Path: <SRS0=s3Lq=O5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51637C43387
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 13:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 118FE21852
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 13:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545313415;
	bh=AGeH1tE4ZyN2ojS1SsMpunEKq8wHvYB52DntenjuB3c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=kA8ye7NVhMA+cdx6GtqOvkyDLkIuI4YQLAkDrd4JN6ssWQkYbjF2foeeKH7MgvF3h
	 USYFblUtcaLjGhIflNUKasOE9WZvpaLzBhyuMUAFqLwMMGSpx+7Wom2fmf7NUnUqr2
	 XFieQ5A2fq9S88SlK5T0CIYPuFKfE9kMFfYmWlpg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732676AbeLTNne (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 08:43:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:49860 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731126AbeLTNne (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 08:43:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CIqqsIIdkiwhATFhkgoN0rLkoD80z1DCfmT65oBqXuo=; b=eUjZhBGAapvN4nT28VsStGyzLH
        ZC1mTVytg5UQl0JIF1H0UqMZ1cvaaK7JK4mg645wOR7RJvI03EyFnFi+Ya4bz4VfGUvWrgA55Ty5A
        rlhbhdiwwKh+7Wf1GJ6Z4pi3COTpOKNaEA4gwdkDAQ9IriBQGWzgO1ONgP3hCvS/mdmHcvlsecXO4
        a/9A2I089gUW3i5vxfMBogAzLcLcfVM9F7U1MAqUzhT5LJTSXZlg7hD2UTuiGx8yr6EVFZxQu4qrN
        Aea5i50oulPTarur7XHeYQiSU4XHqcMejlHJ5pII4z1ZUJoB+XmvL1SjyPPmnItRii5xwebIxb5Iz
        hG660wug==;
Received: from [191.33.191.108] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gZybp-00021q-6s; Thu, 20 Dec 2018 13:43:29 +0000
Date:   Thu, 20 Dec 2018 11:43:25 -0200
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Brad Love <brad@nextdimension.cc>
Cc:     linux-media@vger.kernel.org, markus.dobel@gmx.de,
        alexdeucher@gmail.com, zzam@gentoo.org
Subject: Re: [PATCH v3] cx23885: only reset DMA on problematic CPUs
Message-ID: <20181220114325.39a0fcbc@coco.lan>
In-Reply-To: <1545239221-9393-1-git-send-email-brad@nextdimension.cc>
References: <1545173976-16992-1-git-send-email-brad@nextdimension.cc>
        <1545239221-9393-1-git-send-email-brad@nextdimension.cc>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 19 Dec 2018 11:07:01 -0600
Brad Love <brad@nextdimension.cc> escreveu:

> It is reported that commit 95f408bbc4e4 ("media: cx23885: Ryzen DMA
> related RiSC engine stall fixes") caused regresssions with other CPUs.
> 
> Ensure that the quirk will be applied only for the CPUs that
> are known to cause problems.
> 
> A module option is added for explicit control of the behaviour.
> 
> Fixes: 95f408bbc4e4 ("media: cx23885: Ryzen DMA related RiSC engine stall fixes")
> 
> Signed-off-by: Brad Love <brad@nextdimension.cc>

Thanks!

Patch applied and sent upstream.

Regards,
Mauro

> ---
> Since v2:
> - Replaced sizeof with ARRAY_SIZE
> - Fixed column 80 checkpatch complaint
> Changes since v1:
> - Added module option for three way control
> - Removed '7' from pci id description, Ryzen 3 is the same id
> 
>  drivers/media/pci/cx23885/cx23885-core.c | 55 ++++++++++++++++++++++++++++++--
>  drivers/media/pci/cx23885/cx23885.h      |  2 ++
>  2 files changed, 55 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
> index 39804d8..e2e3649 100644
> --- a/drivers/media/pci/cx23885/cx23885-core.c
> +++ b/drivers/media/pci/cx23885/cx23885-core.c
> @@ -23,6 +23,7 @@
>  #include <linux/moduleparam.h>
>  #include <linux/kmod.h>
>  #include <linux/kernel.h>
> +#include <linux/pci.h>
>  #include <linux/slab.h>
>  #include <linux/interrupt.h>
>  #include <linux/delay.h>
> @@ -41,6 +42,18 @@ MODULE_AUTHOR("Steven Toth <stoth@linuxtv.org>");
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(CX23885_VERSION);
>  
> +/*
> + * Some platforms have been found to require periodic resetting of the DMA
> + * engine. Ryzen and XEON platforms are known to be affected. The symptom
> + * encountered is "mpeg risc op code error". Only Ryzen platforms employ
> + * this workaround if the option equals 1. The workaround can be explicitly
> + * disabled for all platforms by setting to 0, the workaround can be forced
> + * on for any platform by setting to 2.
> + */
> +static unsigned int dma_reset_workaround = 1;
> +module_param(dma_reset_workaround, int, 0644);
> +MODULE_PARM_DESC(dma_reset_workaround, "periodic RiSC dma engine reset; 0-force disable, 1-driver detect (default), 2-force enable");
> +
>  static unsigned int debug;
>  module_param(debug, int, 0644);
>  MODULE_PARM_DESC(debug, "enable debug messages");
> @@ -603,8 +616,13 @@ static void cx23885_risc_disasm(struct cx23885_tsport *port,
>  
>  static void cx23885_clear_bridge_error(struct cx23885_dev *dev)
>  {
> -	uint32_t reg1_val = cx_read(TC_REQ); /* read-only */
> -	uint32_t reg2_val = cx_read(TC_REQ_SET);
> +	uint32_t reg1_val, reg2_val;
> +
> +	if (!dev->need_dma_reset)
> +		return;
> +
> +	reg1_val = cx_read(TC_REQ); /* read-only */
> +	reg2_val = cx_read(TC_REQ_SET);
>  
>  	if (reg1_val && reg2_val) {
>  		cx_write(TC_REQ, reg1_val);
> @@ -2058,6 +2076,37 @@ void cx23885_gpio_enable(struct cx23885_dev *dev, u32 mask, int asoutput)
>  	/* TODO: 23-19 */
>  }
>  
> +static struct {
> +	int vendor, dev;
> +} const broken_dev_id[] = {
> +	/* According with
> +	 * https://openbenchmarking.org/system/1703021-RI-AMDZEN08075/Ryzen%207%201800X/lspci,
> +	 * 0x1451 is PCI ID for the IOMMU found on Ryzen
> +	 */
> +	{ PCI_VENDOR_ID_AMD, 0x1451 },
> +};
> +
> +static bool cx23885_does_need_dma_reset(void)
> +{
> +	int i;
> +	struct pci_dev *pdev = NULL;
> +
> +	if (dma_reset_workaround == 0)
> +		return false;
> +	else if (dma_reset_workaround == 2)
> +		return true;
> +
> +	for (i = 0; i < ARRAY_SIZE(broken_dev_id); i++) {
> +		pdev = pci_get_device(broken_dev_id[i].vendor,
> +					broken_dev_id[i].dev, NULL);
> +		if (pdev) {
> +			pci_dev_put(pdev);
> +			return true;
> +		}
> +	}
> +	return false;
> +}
> +
>  static int cx23885_initdev(struct pci_dev *pci_dev,
>  			   const struct pci_device_id *pci_id)
>  {
> @@ -2069,6 +2118,8 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
>  	if (NULL == dev)
>  		return -ENOMEM;
>  
> +	dev->need_dma_reset = cx23885_does_need_dma_reset();
> +
>  	err = v4l2_device_register(&pci_dev->dev, &dev->v4l2_dev);
>  	if (err < 0)
>  		goto fail_free;
> diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
> index d54c7ee..cf965ef 100644
> --- a/drivers/media/pci/cx23885/cx23885.h
> +++ b/drivers/media/pci/cx23885/cx23885.h
> @@ -451,6 +451,8 @@ struct cx23885_dev {
>  	/* Analog raw audio */
>  	struct cx23885_audio_dev   *audio_dev;
>  
> +	/* Does the system require periodic DMA resets? */
> +	unsigned int		need_dma_reset:1;
>  };
>  
>  static inline struct cx23885_dev *to_cx23885(struct v4l2_device *v4l2_dev)



Thanks,
Mauro
