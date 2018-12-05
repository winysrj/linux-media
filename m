Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8484C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 09:31:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E0742082B
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 09:31:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fdb5kfgE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E0742082B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbeLEJbR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 04:31:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:46496 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbeLEJbQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 04:31:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TiwITMHLJX58/UceJ3Uvhx9dfWDHYr1L1YUpJ51wCzw=; b=Fdb5kfgEDMjBhzVhWjge/tn6WV
        pf9VQY4p/jZOZ/PhSX2uK1mECpytFn1ZgB/hi3pLA4PxIjNoUKAQA6tY0PWJ1VjNt3pwvmnZqLEU7
        FbgjHC8Zjtm40BwiSJ5Mbb7o+oM0VkYMeibHhQMRfuuYYbC4pgudHP+2SH2O3V6qNegR2VN5f6/Ow
        /tHiMRf0dr9mSS5Lv3qH+a++j2HE/2x9lhaxWLbBtRaITot+oNa9U78ITJtp7zgnsFuKA3JGHMHeX
        irMugWLouOKlMLxdYMWh28MOew6Y/3/ZnJECLs1BTOn90e+yZbYbMfyE2ej7DvAfSGpjdnkHiQLZC
        8YtB7TPA==;
Received: from [191.33.148.129] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gUTWO-0006eh-SR; Wed, 05 Dec 2018 09:31:09 +0000
Date:   Wed, 5 Dec 2018 07:31:02 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Robin Murphy <robin.murphy@arm.com>, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org,
        Smitha T Murthy <smitha.t@samsung.com>,
        Rob Herring <robh@kernel.org>,
        Sylwester Nawrocki <snawrocki@kernel.org>
Subject: Re: [PATCH] media: s5p-mfc: Fix memdev DMA configuration
Message-ID: <20181205073102.310edc76@coco.lan>
In-Reply-To: <20180914121931eucas1p14292ee983fd9b4bb21968dffa303dde8~UQ3utL6mj2689726897eucas1p15@eucas1p1.samsung.com>
References: <CGME20180912164604epcas3p1ac72c0861ec182f50485959ac998ed52@epcas3p1.samsung.com>
        <d485dc3698304403620d5ed92d066942a6b68cfd.1536770587.git.robin.murphy@arm.com>
        <20180914121931eucas1p14292ee983fd9b4bb21968dffa303dde8~UQ3utL6mj2689726897eucas1p15@eucas1p1.samsung.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Fri, 14 Sep 2018 14:19:29 +0200
Marek Szyprowski <m.szyprowski@samsung.com> escreveu:

> Hi Robin,
> 
> On 2018-09-12 18:45, Robin Murphy wrote:
> > Having of_reserved_mem_device_init() forcibly reconfigure DMA for all
> > callers, potentially overriding the work done by a bus-specific
> > .dma_configure method earlier, is at best a bad idea and at worst
> > actively harmful. If drivers really need virtual devices to own
> > dma-coherent memory, they should explicitly configure those devices
> > based on the appropriate firmware node as they create them.
> >
> > It looks like the only driver not passing in a proper OF platform device
> > is s5p-mfc, so move the rogue of_dma_configure() call into that driver
> > where it logically belongs.
> >
> > CC: Smitha T Murthy <smitha.t@samsung.com>
> > CC: Marek Szyprowski <m.szyprowski@samsung.com>
> > CC: Rob Herring <robh@kernel.org>
> > Signed-off-by: Robin Murphy <robin.murphy@arm.com>  
> 
> Right, after recent cleanup dma ops initialization, MFC driver is
> a better place for calling of_dma_configure() on virtual devices.
> 
> Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>

This patch seems to fit better via OF/DT tree. Not sure if it was
merged there yet. In any case:

Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

> 
> > ---
> >   drivers/media/platform/s5p-mfc/s5p_mfc.c | 7 +++++++
> >   drivers/of/of_reserved_mem.c             | 4 ----
> >   2 files changed, 7 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> > index 927a1235408d..77eb4a4511c1 100644
> > --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> > @@ -1094,6 +1094,13 @@ static struct device *s5p_mfc_alloc_memdev(struct device *dev,
> >   	child->dma_mask = dev->dma_mask;
> >   	child->release = s5p_mfc_memdev_release;
> >   
> > +	/*
> > +	 * The memdevs are not proper OF platform devices, so in order for them
> > +	 * to be treated as valid DMA masters we need a bit of a hack to force
> > +	 * them to inherit the MFC node's DMA configuration.
> > +	 */
> > +	of_dma_configure(child, dev->of_node, true);
> > +
> >   	if (device_add(child) == 0) {
> >   		ret = of_reserved_mem_device_init_by_idx(child, dev->of_node,
> >   							 idx);
> > diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> > index 895c83e0c7b6..4ef6f4485335 100644
> > --- a/drivers/of/of_reserved_mem.c
> > +++ b/drivers/of/of_reserved_mem.c
> > @@ -350,10 +350,6 @@ int of_reserved_mem_device_init_by_idx(struct device *dev,
> >   		mutex_lock(&of_rmem_assigned_device_mutex);
> >   		list_add(&rd->list, &of_rmem_assigned_device_list);
> >   		mutex_unlock(&of_rmem_assigned_device_mutex);
> > -		/* ensure that dma_ops is set for virtual devices
> > -		 * using reserved memory
> > -		 */
> > -		of_dma_configure(dev, np, true);
> >   
> >   		dev_info(dev, "assigned reserved memory node %s\n", rmem->name);
> >   	} else {  
> 
> Best regards



Thanks,
Mauro
