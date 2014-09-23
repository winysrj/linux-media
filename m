Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4608 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681AbaIWLKu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 07:10:50 -0400
Message-ID: <5421550D.4070809@xs4all.nl>
Date: Tue, 23 Sep 2014 13:10:05 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/2] [media] saa7134: Remove unused status var
References: <37b38486a1497804b63482af58a945f0eee8893f.1411469967.git.mchehab@osg.samsung.com> <fa1d4addf88f8d419bc946f9f7debe3e8603d302.1411469967.git.mchehab@osg.samsung.com>
In-Reply-To: <fa1d4addf88f8d419bc946f9f7debe3e8603d302.1411469967.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/23/14 12:59, Mauro Carvalho Chehab wrote:
> drivers/media/pci/saa7134/saa7134-go7007.c: In function ‘saa7134_go7007_interface_reset’:
> drivers/media/pci/saa7134/saa7134-go7007.c:147:6: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

	Hans

> 
> diff --git a/drivers/media/pci/saa7134/saa7134-go7007.c b/drivers/media/pci/saa7134/saa7134-go7007.c
> index d9af6f3dc8af..4f63e1ddbb68 100644
> --- a/drivers/media/pci/saa7134/saa7134-go7007.c
> +++ b/drivers/media/pci/saa7134/saa7134-go7007.c
> @@ -144,7 +144,6 @@ static int saa7134_go7007_interface_reset(struct go7007 *go)
>  {
>  	struct saa7134_go7007 *saa = go->hpi_context;
>  	struct saa7134_dev *dev = saa->dev;
> -	u32 status;
>  	u16 intr_val, intr_data;
>  	int count = 20;
>  
> @@ -162,8 +161,8 @@ static int saa7134_go7007_interface_reset(struct go7007 *go)
>  	saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
>  	saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
>  
> -	status = saa_readb(SAA7134_GPIO_GPSTATUS2);
> -	/*pr_debug("status is %s\n", status & 0x40 ? "OK" : "not OK"); */
> +	saa_readb(SAA7134_GPIO_GPSTATUS2);
> +	/*pr_debug("status is %s\n", saa_readb(SAA7134_GPIO_GPSTATUS2) & 0x40 ? "OK" : "not OK"); */
>  
>  	/* enter command mode...(?) */
>  	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_REQ1);
> @@ -172,7 +171,7 @@ static int saa7134_go7007_interface_reset(struct go7007 *go)
>  	do {
>  		saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
>  		saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
> -		status = saa_readb(SAA7134_GPIO_GPSTATUS2);
> +		saa_readb(SAA7134_GPIO_GPSTATUS2);
>  		/*pr_info("gpio is %08x\n", saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2)); */
>  	} while (--count > 0);
>  
> 

