Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750969AbdAMRN2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jan 2017 12:13:28 -0500
Date: Fri, 13 Jan 2017 11:13:21 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-pci@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        netdev@vger.kernel.org, linux-media@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: kill off pci_enable_msi_{exact,range}
Message-ID: <20170113171321.GA22776@bhelgaas-glaptop.roam.corp.google.com>
References: <1483994260-19797-1-git-send-email-hch@lst.de>
 <20170112212900.GE8312@bhelgaas-glaptop.roam.corp.google.com>
 <20170113075503.GA26014@lst.de>
 <20170113080553.GA26280@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170113080553.GA26280@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 13, 2017 at 09:05:53AM +0100, Christoph Hellwig wrote:
> On Fri, Jan 13, 2017 at 08:55:03AM +0100, Christoph Hellwig wrote:
> > On Thu, Jan 12, 2017 at 03:29:00PM -0600, Bjorn Helgaas wrote:
> > > Applied all three (with Tom's ack on the amd-xgbe patch) to pci/msi for
> > > v4.11, thanks!
> > 
> > Tom had just send me an event better version of the xgbe patch.  Tom,
> > maybe you can resend that relative to the PCI tree [1], so that we don't
> > lose it for next merge window?
> 
> Actually - Bjorn, your msi branch contains an empty commit from this
> thread:
> 
> 	https://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/commit/?h=pci/msi&id=7a8191de43faa9869b421a1b06075d8126ce7c0b

Yep, I botched that.  Thought I'd fixed it, but guess I got distracted.

> Maybe we should rebase it after all to avoid that?  In that case please
> pick up the xgbe patch from Tom below:

I dropped the empty commit and replaced the xgbe patch with the one below.
Can you take a look at [1] and make sure it's what you expected?

[1] https://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/msi

Thanks!

> ---
> From: Tom Lendacky <thomas.lendacky@amd.com>
> Subject: [PATCH] amd-xgbe: Update PCI support to use new IRQ functions
> 
> Some of the PCI MSI/MSI-X functions have been deprecated and it is
> recommended to use the new pci_alloc_irq_vectors() function. Convert
> the code over to use the new function. Also, modify the way in which
> the IRQs are requested - try for multiple MSI-X/MSI first, then a
> single MSI/legacy interrupt.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/net/ethernet/amd/xgbe/xgbe-pci.c |  128 +++++++++---------------------
>  drivers/net/ethernet/amd/xgbe/xgbe.h     |    8 +-
>  2 files changed, 41 insertions(+), 95 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
> index e76b7f6..e436902 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
> @@ -122,104 +122,40 @@
>  #include "xgbe.h"
>  #include "xgbe-common.h"
>  
> -static int xgbe_config_msi(struct xgbe_prv_data *pdata)
> +static int xgbe_config_multi_msi(struct xgbe_prv_data *pdata)
>  {
> -	unsigned int msi_count;
> +	unsigned int vector_count;
>  	unsigned int i, j;
>  	int ret;
>  
> -	msi_count = XGBE_MSIX_BASE_COUNT;
> -	msi_count += max(pdata->rx_ring_count,
> -			 pdata->tx_ring_count);
> -	msi_count = roundup_pow_of_two(msi_count);
> +	vector_count = XGBE_MSI_BASE_COUNT;
> +	vector_count += max(pdata->rx_ring_count,
> +			    pdata->tx_ring_count);
>  
> -	ret = pci_enable_msi_exact(pdata->pcidev, msi_count);
> +	ret = pci_alloc_irq_vectors(pdata->pcidev, XGBE_MSI_MIN_COUNT,
> +				    vector_count, PCI_IRQ_MSI | PCI_IRQ_MSIX);
>  	if (ret < 0) {
> -		dev_info(pdata->dev, "MSI request for %u interrupts failed\n",
> -			 msi_count);
> -
> -		ret = pci_enable_msi(pdata->pcidev);
> -		if (ret < 0) {
> -			dev_info(pdata->dev, "MSI enablement failed\n");
> -			return ret;
> -		}
> -
> -		msi_count = 1;
> -	}
> -
> -	pdata->irq_count = msi_count;
> -
> -	pdata->dev_irq = pdata->pcidev->irq;
> -
> -	if (msi_count > 1) {
> -		pdata->ecc_irq = pdata->pcidev->irq + 1;
> -		pdata->i2c_irq = pdata->pcidev->irq + 2;
> -		pdata->an_irq = pdata->pcidev->irq + 3;
> -
> -		for (i = XGBE_MSIX_BASE_COUNT, j = 0;
> -		     (i < msi_count) && (j < XGBE_MAX_DMA_CHANNELS);
> -		     i++, j++)
> -			pdata->channel_irq[j] = pdata->pcidev->irq + i;
> -		pdata->channel_irq_count = j;
> -
> -		pdata->per_channel_irq = 1;
> -		pdata->channel_irq_mode = XGBE_IRQ_MODE_LEVEL;
> -	} else {
> -		pdata->ecc_irq = pdata->pcidev->irq;
> -		pdata->i2c_irq = pdata->pcidev->irq;
> -		pdata->an_irq = pdata->pcidev->irq;
> -	}
> -
> -	if (netif_msg_probe(pdata))
> -		dev_dbg(pdata->dev, "MSI interrupts enabled\n");
> -
> -	return 0;
> -}
> -
> -static int xgbe_config_msix(struct xgbe_prv_data *pdata)
> -{
> -	unsigned int msix_count;
> -	unsigned int i, j;
> -	int ret;
> -
> -	msix_count = XGBE_MSIX_BASE_COUNT;
> -	msix_count += max(pdata->rx_ring_count,
> -			  pdata->tx_ring_count);
> -
> -	pdata->msix_entries = devm_kcalloc(pdata->dev, msix_count,
> -					   sizeof(struct msix_entry),
> -					   GFP_KERNEL);
> -	if (!pdata->msix_entries)
> -		return -ENOMEM;
> -
> -	for (i = 0; i < msix_count; i++)
> -		pdata->msix_entries[i].entry = i;
> -
> -	ret = pci_enable_msix_range(pdata->pcidev, pdata->msix_entries,
> -				    XGBE_MSIX_MIN_COUNT, msix_count);
> -	if (ret < 0) {
> -		dev_info(pdata->dev, "MSI-X enablement failed\n");
> -		devm_kfree(pdata->dev, pdata->msix_entries);
> -		pdata->msix_entries = NULL;
> +		dev_info(pdata->dev, "multi MSI/MSI-X enablement failed\n");
>  		return ret;
>  	}
>  
>  	pdata->irq_count = ret;
>  
> -	pdata->dev_irq = pdata->msix_entries[0].vector;
> -	pdata->ecc_irq = pdata->msix_entries[1].vector;
> -	pdata->i2c_irq = pdata->msix_entries[2].vector;
> -	pdata->an_irq = pdata->msix_entries[3].vector;
> +	pdata->dev_irq = pci_irq_vector(pdata->pcidev, 0);
> +	pdata->ecc_irq = pci_irq_vector(pdata->pcidev, 1);
> +	pdata->i2c_irq = pci_irq_vector(pdata->pcidev, 2);
> +	pdata->an_irq = pci_irq_vector(pdata->pcidev, 3);
>  
> -	for (i = XGBE_MSIX_BASE_COUNT, j = 0; i < ret; i++, j++)
> -		pdata->channel_irq[j] = pdata->msix_entries[i].vector;
> +	for (i = XGBE_MSI_BASE_COUNT, j = 0; i < ret; i++, j++)
> +		pdata->channel_irq[j] = pci_irq_vector(pdata->pcidev, i);
>  	pdata->channel_irq_count = j;
>  
>  	pdata->per_channel_irq = 1;
>  	pdata->channel_irq_mode = XGBE_IRQ_MODE_LEVEL;
>  
>  	if (netif_msg_probe(pdata))
> -		dev_dbg(pdata->dev, "MSI-X interrupts enabled\n");
> +		dev_dbg(pdata->dev, "multi %s interrupts enabled\n",
> +			pdata->pcidev->msix_enabled ? "MSI-X" : "MSI");
>  
>  	return 0;
>  }
> @@ -228,21 +164,28 @@ static int xgbe_config_irqs(struct xgbe_prv_data *pdata)
>  {
>  	int ret;
>  
> -	ret = xgbe_config_msix(pdata);
> +	ret = xgbe_config_multi_msi(pdata);
>  	if (!ret)
>  		goto out;
>  
> -	ret = xgbe_config_msi(pdata);
> -	if (!ret)
> -		goto out;
> +	ret = pci_alloc_irq_vectors(pdata->pcidev, 1, 1,
> +				    PCI_IRQ_LEGACY | PCI_IRQ_MSI);
> +	if (ret < 0) {
> +		dev_info(pdata->dev, "single IRQ enablement failed\n");
> +		return ret;
> +	}
>  
>  	pdata->irq_count = 1;
> -	pdata->irq_shared = 1;
> +	pdata->channel_irq_count = 1;
> +
> +	pdata->dev_irq = pci_irq_vector(pdata->pcidev, 0);
> +	pdata->ecc_irq = pci_irq_vector(pdata->pcidev, 0);
> +	pdata->i2c_irq = pci_irq_vector(pdata->pcidev, 0);
> +	pdata->an_irq = pci_irq_vector(pdata->pcidev, 0);
>  
> -	pdata->dev_irq = pdata->pcidev->irq;
> -	pdata->ecc_irq = pdata->pcidev->irq;
> -	pdata->i2c_irq = pdata->pcidev->irq;
> -	pdata->an_irq = pdata->pcidev->irq;
> +	if (netif_msg_probe(pdata))
> +		dev_dbg(pdata->dev, "single %s interrupt enabled\n",
> +			pdata->pcidev->msi_enabled ?  "MSI" : "legacy");
>  
>  out:
>  	if (netif_msg_probe(pdata)) {
> @@ -412,12 +355,15 @@ static int xgbe_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	/* Configure the netdev resource */
>  	ret = xgbe_config_netdev(pdata);
>  	if (ret)
> -		goto err_pci_enable;
> +		goto err_irq_vectors;
>  
>  	netdev_notice(pdata->netdev, "net device enabled\n");
>  
>  	return 0;
>  
> +err_irq_vectors:
> +	pci_free_irq_vectors(pdata->pcidev);
> +
>  err_pci_enable:
>  	xgbe_free_pdata(pdata);
>  
> @@ -433,6 +379,8 @@ static void xgbe_pci_remove(struct pci_dev *pdev)
>  
>  	xgbe_deconfig_netdev(pdata);
>  
> +	pci_free_irq_vectors(pdata->pcidev);
> +
>  	xgbe_free_pdata(pdata);
>  }
>  
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
> index f52a9bd..99f1c87 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe.h
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
> @@ -211,9 +211,9 @@
>  #define XGBE_MAC_PROP_OFFSET	0x1d000
>  #define XGBE_I2C_CTRL_OFFSET	0x1e000
>  
> -/* PCI MSIx support */
> -#define XGBE_MSIX_BASE_COUNT	4
> -#define XGBE_MSIX_MIN_COUNT	(XGBE_MSIX_BASE_COUNT + 1)
> +/* PCI MSI/MSIx support */
> +#define XGBE_MSI_BASE_COUNT	4
> +#define XGBE_MSI_MIN_COUNT	(XGBE_MSI_BASE_COUNT + 1)
>  
>  /* PCI clock frequencies */
>  #define XGBE_V2_DMA_CLOCK_FREQ	500000000	/* 500 MHz */
> @@ -980,14 +980,12 @@ struct xgbe_prv_data {
>  	unsigned int desc_ded_count;
>  	unsigned int desc_sec_count;
>  
> -	struct msix_entry *msix_entries;
>  	int dev_irq;
>  	int ecc_irq;
>  	int i2c_irq;
>  	int channel_irq[XGBE_MAX_DMA_CHANNELS];
>  
>  	unsigned int per_channel_irq;
> -	unsigned int irq_shared;
>  	unsigned int irq_count;
>  	unsigned int channel_irq_count;
>  	unsigned int channel_irq_mode;
> 
