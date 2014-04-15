Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailex.mailcore.me ([94.136.40.62]:49977 "EHLO
	mailex.mailcore.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaDOKl4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 06:41:56 -0400
Message-ID: <534D0CD5.3090906@sca-uk.com>
Date: Tue, 15 Apr 2014 11:41:25 +0100
From: it-support <it@sca-uk.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: stoth@kernellabs.com
Subject: Re: [PATCH] cx23885: add support for Hauppauge ImpactVCB-e
References: <534BE92F.3010501@xs4all.nl>
In-Reply-To: <534BE92F.3010501@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guys,

This is a very noobie question,  but my 'patch' command does not return 
to the command prompt.

I assume that my problem is one (or all four) of:

1) the patch doesn't start or end where I think it does (I assume the 
first line is

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c

and the last line is:

  #define GPIO_1 0x00000002

2) I have put it in the wrong directory (I tried:

~/linuxtv/media_build/linux/drivers/media/pci/cx23885/

and

~/linuxtv/media_build

3) My patch syntax is wrong.  I run it in the same directory as the file 
like this: patch -b cx23885.diff

4) I don't need to apply because Steve has already patched it into 
linuxtv and I get it automaticallw when I build linux tv.

Regards

Steve


On 14/04/14 14:57, Hans Verkuil wrote:
> This patch adds support for the Hauppauge ImpactVCB-e card to cx23885.
>
> Tested with Composite input and S-Video.
>
> While I do get audio it is very choppy. It is not clear whether that is
> a general cx23885 driver problem or specific to this board. If it is specific
> to the board, then I might have missed something.
>
> Steven (Toth, not Cookson ;-) ), do you have an idea what it might be?
>
> Regards,
>
> 	Hans
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>   drivers/media/pci/cx23885/cx23885-cards.c | 30 +++++++++++++++++++++++++++++-
>   drivers/media/pci/cx23885/cx23885-video.c |  1 +
>   drivers/media/pci/cx23885/cx23885.h       |  1 +
>   3 files changed, 31 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
> index 79f20c8..49a3711 100644
> --- a/drivers/media/pci/cx23885/cx23885-cards.c
> +++ b/drivers/media/pci/cx23885/cx23885-cards.c
> @@ -649,7 +649,25 @@ struct cx23885_board cx23885_boards[] = {
>   				  CX25840_NONE1_CH3,
>   			.amux   = CX25840_AUDIO6,
>   		} },
> -	}
> +	},
> +	[CX23885_BOARD_HAUPPAUGE_IMPACTVCBE] = {
> +		.name		= "Hauppauge ImpactVCB-e",
> +		.porta		= CX23885_ANALOG_VIDEO,
> +		.input          = {{
> +			.type   = CX23885_VMUX_COMPOSITE1,
> +			.vmux   = CX25840_VIN7_CH3 |
> +				  CX25840_VIN4_CH2 |
> +				  CX25840_VIN6_CH1,
> +			.amux   = CX25840_AUDIO7,
> +		}, {
> +			.type   = CX23885_VMUX_SVIDEO,
> +			.vmux   = CX25840_VIN7_CH3 |
> +				  CX25840_VIN4_CH2 |
> +				  CX25840_VIN8_CH1 |
> +				  CX25840_SVIDEO_ON,
> +			.amux   = CX25840_AUDIO7,
> +		} },
> +	},
>   };
>   const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
>   
> @@ -897,6 +915,10 @@ struct cx23885_subid cx23885_subids[] = {
>   		.subvendor = 0x1461,
>   		.subdevice = 0xd939,
>   		.card      = CX23885_BOARD_AVERMEDIA_HC81R,
> +	}, {
> +		.subvendor = 0x0070,
> +		.subdevice = 0x7133,
> +		.card      = CX23885_BOARD_HAUPPAUGE_IMPACTVCBE,
>   	},
>   };
>   const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
> @@ -977,6 +999,9 @@ static void hauppauge_eeprom(struct cx23885_dev *dev, u8 *eeprom_data)
>   	case 71009:
>   		/* WinTV-HVR1200 (PCIe, Retail, full height)
>   		 * DVB-T and basic analog */
> +	case 71100:
> +		/* WinTV-ImpactVCB-e (PCIe, Retail, half height)
> +		 * Basic analog */
>   	case 71359:
>   		/* WinTV-HVR1200 (PCIe, OEM, half height)
>   		 * DVB-T and basic analog */
> @@ -1701,6 +1726,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
>   	case CX23885_BOARD_HAUPPAUGE_HVR1850:
>   	case CX23885_BOARD_HAUPPAUGE_HVR1290:
>   	case CX23885_BOARD_HAUPPAUGE_HVR4400:
> +	case CX23885_BOARD_HAUPPAUGE_IMPACTVCBE:
>   		if (dev->i2c_bus[0].i2c_rc == 0)
>   			hauppauge_eeprom(dev, eeprom+0xc0);
>   		break;
> @@ -1807,6 +1833,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
>   	case CX23885_BOARD_HAUPPAUGE_HVR1200:
>   	case CX23885_BOARD_HAUPPAUGE_HVR1700:
>   	case CX23885_BOARD_HAUPPAUGE_HVR1400:
> +	case CX23885_BOARD_HAUPPAUGE_IMPACTVCBE:
>   	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
>   	case CX23885_BOARD_LEADTEK_WINFAST_PXPVR2200:
>   	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000:
> @@ -1835,6 +1862,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
>   			break;
>   	case CX23885_BOARD_HAUPPAUGE_HVR1250:
>   	case CX23885_BOARD_HAUPPAUGE_HVR1800:
> +	case CX23885_BOARD_HAUPPAUGE_IMPACTVCBE:
>   	case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
>   	case CX23885_BOARD_HAUPPAUGE_HVR1700:
>   	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
> diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
> index 7891f34..976fe5d 100644
> --- a/drivers/media/pci/cx23885/cx23885-video.c
> +++ b/drivers/media/pci/cx23885/cx23885-video.c
> @@ -507,6 +507,7 @@ static int cx23885_video_mux(struct cx23885_dev *dev, unsigned int input)
>   	if ((dev->board == CX23885_BOARD_HAUPPAUGE_HVR1800) ||
>   		(dev->board == CX23885_BOARD_MPX885) ||
>   		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1250) ||
> +		(dev->board == CX23885_BOARD_HAUPPAUGE_IMPACTVCBE) ||
>   		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255) ||
>   		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255_22111) ||
>   		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1850) ||
> diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
> index 0fa4048..6a4b20e 100644
> --- a/drivers/media/pci/cx23885/cx23885.h
> +++ b/drivers/media/pci/cx23885/cx23885.h
> @@ -96,6 +96,7 @@
>   #define CX23885_BOARD_TBS_6981                 40
>   #define CX23885_BOARD_TBS_6980                 41
>   #define CX23885_BOARD_LEADTEK_WINFAST_PXPVR2200 42
> +#define CX23885_BOARD_HAUPPAUGE_IMPACTVCBE     43
>   
>   #define GPIO_0 0x00000001
>   #define GPIO_1 0x00000002

