Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:39325 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934AbaJ3Tjy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 15:39:54 -0400
Received: by mail-lb0-f170.google.com with SMTP id 10so4948855lbg.29
        for <linux-media@vger.kernel.org>; Thu, 30 Oct 2014 12:39:53 -0700 (PDT)
Date: Thu, 30 Oct 2014 21:39:51 +0200 (EET)
From: Olli Salonen <olli.salonen@iki.fi>
To: Nibble Max <nibble.max@gmail.com>
cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] cx23885: add DVBSky S950C and T980C RC support
In-Reply-To: <201410231802135463883@gmail.com>
Message-ID: <alpine.DEB.2.10.1410302139200.1436@dl160.lan>
References: <201410231802135463883@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Olli Salonen <olli.salonen@iki.fi>

On Thu, 23 Oct 2014, Nibble Max wrote:

> DVBSky s950ci dvb-s/s2 ci PCIe card:
> 1>dvb frontend: M88TS2022(tuner),M88DS3103(demod)
> 2>ci controller: CIMAX SP2 or its clone.
> 3>PCIe bridge: CX23885
>
> The patchs are based on the following patchs.
> Olli Salonen submit:
> https://patchwork.linuxtv.org/patch/26180/
> https://patchwork.linuxtv.org/patch/26183/
> https://patchwork.linuxtv.org/patch/26324/
> Nibble Max submit:
> https://patchwork.linuxtv.org/patch/26207/
>
> Signed-off-by: Nibble Max <nibble.max@gmail.com>
> ---
> drivers/media/pci/cx23885/cx23885-cards.c | 6 ++++++
> drivers/media/pci/cx23885/cx23885-input.c | 6 ++++++
> 2 files changed, 12 insertions(+)
>
> diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
> index ac34c27..d9ba48c 100644
> --- a/drivers/media/pci/cx23885/cx23885-cards.c
> +++ b/drivers/media/pci/cx23885/cx23885-cards.c
> @@ -1669,6 +1669,8 @@ int cx23885_ir_init(struct cx23885_dev *dev)
> 	case CX23885_BOARD_TBS_6980:
> 	case CX23885_BOARD_TBS_6981:
> 	case CX23885_BOARD_DVBSKY_T9580:
> +	case CX23885_BOARD_DVBSKY_T980C:
> +	case CX23885_BOARD_DVBSKY_S950C:
> 		if (!enable_885_ir)
> 			break;
> 		dev->sd_ir = cx23885_find_hw(dev, CX23885_HW_AV_CORE);
> @@ -1716,6 +1718,8 @@ void cx23885_ir_fini(struct cx23885_dev *dev)
> 	case CX23885_BOARD_TBS_6980:
> 	case CX23885_BOARD_TBS_6981:
> 	case CX23885_BOARD_DVBSKY_T9580:
> +	case CX23885_BOARD_DVBSKY_T980C:
> +	case CX23885_BOARD_DVBSKY_S950C:
> 		cx23885_irq_remove(dev, PCI_MSK_AV_CORE);
> 		/* sd_ir is a duplicate pointer to the AV Core, just clear it */
> 		dev->sd_ir = NULL;
> @@ -1764,6 +1768,8 @@ void cx23885_ir_pci_int_enable(struct cx23885_dev *dev)
> 	case CX23885_BOARD_TBS_6980:
> 	case CX23885_BOARD_TBS_6981:
> 	case CX23885_BOARD_DVBSKY_T9580:
> +	case CX23885_BOARD_DVBSKY_T980C:
> +	case CX23885_BOARD_DVBSKY_S950C:
> 		if (dev->sd_ir)
> 			cx23885_irq_add_enable(dev, PCI_MSK_AV_CORE);
> 		break;
> diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
> index f81c2f9..0bf6839 100644
> --- a/drivers/media/pci/cx23885/cx23885-input.c
> +++ b/drivers/media/pci/cx23885/cx23885-input.c
> @@ -88,6 +88,8 @@ void cx23885_input_rx_work_handler(struct cx23885_dev *dev, u32 events)
> 	case CX23885_BOARD_TBS_6980:
> 	case CX23885_BOARD_TBS_6981:
> 	case CX23885_BOARD_DVBSKY_T9580:
> +	case CX23885_BOARD_DVBSKY_T980C:
> +	case CX23885_BOARD_DVBSKY_S950C:
> 		/*
> 		 * The only boards we handle right now.  However other boards
> 		 * using the CX2388x integrated IR controller should be similar
> @@ -141,6 +143,8 @@ static int cx23885_input_ir_start(struct cx23885_dev *dev)
> 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
> 	case CX23885_BOARD_MYGICA_X8507:
> 	case CX23885_BOARD_DVBSKY_T9580:
> +	case CX23885_BOARD_DVBSKY_T980C:
> +	case CX23885_BOARD_DVBSKY_S950C:
> 		/*
> 		 * The IR controller on this board only returns pulse widths.
> 		 * Any other mode setting will fail to set up the device.
> @@ -308,6 +312,8 @@ int cx23885_input_init(struct cx23885_dev *dev)
> 		rc_map = RC_MAP_TBS_NEC;
> 		break;
> 	case CX23885_BOARD_DVBSKY_T9580:
> +	case CX23885_BOARD_DVBSKY_T980C:
> +	case CX23885_BOARD_DVBSKY_S950C:
> 		/* Integrated CX23885 IR controller */
> 		driver_type = RC_DRIVER_IR_RAW;
> 		allowed_protos = RC_BIT_ALL;
>
> -- 
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
