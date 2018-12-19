Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED47C43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 11:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A02221850
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 11:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbeLSLIg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 06:08:36 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:34330 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727088AbeLSLIg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 06:08:36 -0500
Received: from [IPv6:2001:a62:180a:4401:23b6:57c7:ac31:7c25] (unknown [IPv6:2001:a62:180a:4401:23b6:57c7:ac31:7c25])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: zzam)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 9862B335C06;
        Wed, 19 Dec 2018 11:08:33 +0000 (UTC)
Subject: Re: [PATCH v2] cx23885: only reset DMA on problematic CPUs
To:     Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org,
        mchehab@kernel.org, markus.dobel@gmx.de, alexdeucher@gmail.com
References: <20181206173204.21b9366e@coco.lan>
 <1545173976-16992-1-git-send-email-brad@nextdimension.cc>
From:   Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <adfe3a56-7a20-6935-1118-ff73f275bd6a@gentoo.org>
Date:   Wed, 19 Dec 2018 12:08:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <1545173976-16992-1-git-send-email-brad@nextdimension.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Am 18.12.18 um 23:59 schrieb Brad Love:
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

Hi Brad,
I found one issue. See below.

Regards
Matthias

> ---
> Changes since v1:
> - Added module option for three way control
> - Removed '7' from pci id description, Ryzen 3 is the same id
> 
>  drivers/media/pci/cx23885/cx23885-core.c | 54 ++++++++++++++++++++++++++++++--
>  drivers/media/pci/cx23885/cx23885.h      |  2 ++
>  2 files changed, 54 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
> index 39804d8..fb721c7 100644
> --- a/drivers/media/pci/cx23885/cx23885-core.c
> +++ b/drivers/media/pci/cx23885/cx23885-core.c
...
> @@ -2058,6 +2076,36 @@ void cx23885_gpio_enable(struct cx23885_dev *dev, u32 mask, int asoutput)
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
> +	for (i = 0; i < sizeof(broken_dev_id); i++) {
This is broken. sizeof delivers the size in bytes, not in number of
array elements. ARRAY_SIZE is what you want.

> +		pdev = pci_get_device(broken_dev_id[i].vendor, broken_dev_id[i].dev, NULL);
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
> @@ -2069,6 +2117,8 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
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
> 

