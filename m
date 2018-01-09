Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751888AbeAIXpZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 18:45:25 -0500
Date: Tue, 9 Jan 2018 17:45:15 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-pci@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] media/ttusb-budget: remove pci_zalloc_coherent abuse
Message-ID: <20180109234515.GA153924@bhelgaas-glaptop.roam.corp.google.com>
References: <20180109203939.5930-1-hch@lst.de>
 <20180109203939.5930-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180109203939.5930-2-hch@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 09, 2018 at 09:39:37PM +0100, Christoph Hellwig wrote:
> Switch to a plain kzalloc instea of pci_zalloc_coherent to allocate
> memory for the USB DMA.

s/instea/instead/

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
> index a142b9dc0feb..b8619fb23351 100644
> --- a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
> +++ b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
> @@ -102,7 +102,6 @@ struct ttusb {
>  	unsigned int isoc_in_pipe;
>  
>  	void *iso_buffer;
> -	dma_addr_t iso_dma_handle;
>  
>  	struct urb *iso_urb[ISO_BUF_COUNT];
>  
> @@ -792,21 +791,15 @@ static void ttusb_free_iso_urbs(struct ttusb *ttusb)
>  
>  	for (i = 0; i < ISO_BUF_COUNT; i++)
>  		usb_free_urb(ttusb->iso_urb[i]);
> -
> -	pci_free_consistent(NULL,
> -			    ISO_FRAME_SIZE * FRAMES_PER_ISO_BUF *
> -			    ISO_BUF_COUNT, ttusb->iso_buffer,
> -			    ttusb->iso_dma_handle);
> +	kfree(ttusb->iso_buffer);
>  }
>  
>  static int ttusb_alloc_iso_urbs(struct ttusb *ttusb)
>  {
>  	int i;
>  
> -	ttusb->iso_buffer = pci_zalloc_consistent(NULL,
> -						  ISO_FRAME_SIZE * FRAMES_PER_ISO_BUF * ISO_BUF_COUNT,
> -						  &ttusb->iso_dma_handle);
> -
> +	ttusb->iso_buffer = kzalloc(ISO_FRAME_SIZE * FRAMES_PER_ISO_BUF *
> +			ISO_BUF_COUNT, GFP_KERNEL);
>  	if (!ttusb->iso_buffer) {
>  		dprintk("%s: pci_alloc_consistent - not enough memory\n",
>  			__func__);
> -- 
> 2.14.2
> 
