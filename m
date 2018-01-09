Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0218.hostedemail.com ([216.40.44.218]:42046 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753968AbeAIUta (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 15:49:30 -0500
Message-ID: <1515530966.9619.124.camel@perches.com>
Subject: Re: [PATCH 1/3] media/ttusb-budget: remove pci_zalloc_coherent abuse
From: Joe Perches <joe@perches.com>
To: Christoph Hellwig <hch@lst.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 09 Jan 2018 12:49:26 -0800
In-Reply-To: <20180109203939.5930-2-hch@lst.de>
References: <20180109203939.5930-1-hch@lst.de>
         <20180109203939.5930-2-hch@lst.de>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2018-01-09 at 21:39 +0100, Christoph Hellwig wrote:
> Switch to a plain kzalloc instea of pci_zalloc_coherent to allocate
> memory for the USB DMA.
[]
> diff --git a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
[]
> @@ -792,21 +791,15 @@ static void ttusb_free_iso_urbs(struct ttusb *ttusb)
> []
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

This message doesn't make sense anymore and it might as well
be deleted.

And it might be better to use kcalloc

	ttusb->iso_buffer = kcalloc(FRAMES_PER_ISO_BUF * ISO_BUF_COUNT,
				    ISO_FRAME_SIZE, GFP_KERNEL);
