Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2442 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3JAGj7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Oct 2013 02:39:59 -0400
Message-ID: <524A6E2B.6040605@xs4all.nl>
Date: Tue, 01 Oct 2013 08:39:39 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, m.chehab@samsung.com,
	Patrick Boettcher <patrick.boettcher@desy.de>
Subject: Re: [PATCH 1/9] [media] pci: flexcop: Remove redundant pci_set_drvdata
References: <1379666181-19546-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1379666181-19546-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/20/2013 10:36 AM, Sachin Kamat wrote:
> Driver core sets driver data to NULL upon failure or remove.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Patrick Boettcher <patrick.boettcher@desy.de>

For this patch series:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/pci/b2c2/flexcop-pci.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/media/pci/b2c2/flexcop-pci.c b/drivers/media/pci/b2c2/flexcop-pci.c
> index 447afbd..8b5e0b3 100644
> --- a/drivers/media/pci/b2c2/flexcop-pci.c
> +++ b/drivers/media/pci/b2c2/flexcop-pci.c
> @@ -319,7 +319,6 @@ static int flexcop_pci_init(struct flexcop_pci *fc_pci)
>  
>  err_pci_iounmap:
>  	pci_iounmap(fc_pci->pdev, fc_pci->io_mem);
> -	pci_set_drvdata(fc_pci->pdev, NULL);
>  err_pci_release_regions:
>  	pci_release_regions(fc_pci->pdev);
>  err_pci_disable_device:
> @@ -332,7 +331,6 @@ static void flexcop_pci_exit(struct flexcop_pci *fc_pci)
>  	if (fc_pci->init_state & FC_PCI_INIT) {
>  		free_irq(fc_pci->pdev->irq, fc_pci);
>  		pci_iounmap(fc_pci->pdev, fc_pci->io_mem);
> -		pci_set_drvdata(fc_pci->pdev, NULL);
>  		pci_release_regions(fc_pci->pdev);
>  		pci_disable_device(fc_pci->pdev);
>  	}
> 

