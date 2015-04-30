Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:39673 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705AbbD3GVO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 02:21:14 -0400
Message-ID: <5541C9D0.801@xs4all.nl>
Date: Thu, 30 Apr 2015 08:21:04 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Steven Toth <stoth@kernellabs.com>,
	Olli Salonen <olli.salonen@iki.fi>
Subject: Re: [PATCH 05/14] saa7164: Check if dev is NULL before dereferencing
 it
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com> <911c4403de95f55f0de9d2768269878a2da77e62.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <911c4403de95f55f0de9d2768269878a2da77e62.1430235781.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/28/2015 05:43 PM, Mauro Carvalho Chehab wrote:
> As reported by smatch:
> 	drivers/media/pci/saa7164/saa7164-core.c:631 saa7164_irq() warn: variable dereferenced before check 'dev' (see line 621)
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
> index 9cf3c6cba498..072dcc8f13d9 100644
> --- a/drivers/media/pci/saa7164/saa7164-core.c
> +++ b/drivers/media/pci/saa7164/saa7164-core.c
> @@ -618,12 +618,7 @@ static irqreturn_t saa7164_irq_ts(struct saa7164_port *port)
>  static irqreturn_t saa7164_irq(int irq, void *dev_id)
>  {
>  	struct saa7164_dev *dev = dev_id;
> -	struct saa7164_port *porta = &dev->ports[SAA7164_PORT_TS1];
> -	struct saa7164_port *portb = &dev->ports[SAA7164_PORT_TS2];
> -	struct saa7164_port *portc = &dev->ports[SAA7164_PORT_ENC1];
> -	struct saa7164_port *portd = &dev->ports[SAA7164_PORT_ENC2];
> -	struct saa7164_port *porte = &dev->ports[SAA7164_PORT_VBI1];
> -	struct saa7164_port *portf = &dev->ports[SAA7164_PORT_VBI2];
> +	struct saa7164_port *porta, *portb, *portc, *portd, *porte, *portf;
>  
>  	u32 intid, intstat[INT_SIZE/4];
>  	int i, handled = 0, bit;
> @@ -634,6 +629,13 @@ static irqreturn_t saa7164_irq(int irq, void *dev_id)
>  		goto out;
>  	}
>  
> +	porta = &dev->ports[SAA7164_PORT_TS1];
> +	portb = &dev->ports[SAA7164_PORT_TS2];
> +	portc = &dev->ports[SAA7164_PORT_ENC1];
> +	portd = &dev->ports[SAA7164_PORT_ENC2];
> +	porte = &dev->ports[SAA7164_PORT_VBI1];
> +	portf = &dev->ports[SAA7164_PORT_VBI2];
> +
>  	/* Check that the hardware is accessible. If the status bytes are
>  	 * 0xFF then the device is not accessible, the the IRQ belongs
>  	 * to another driver.
> 

