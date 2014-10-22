Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4640 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499AbaJVKwt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Oct 2014 06:52:49 -0400
Message-ID: <54478C57.3000101@xs4all.nl>
Date: Wed, 22 Oct 2014 12:52:07 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>,
	linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Jim Davis <jim.epost@gmail.com>
Subject: Re: [PATCH -next] media: tw68: fix build errors and warnings
References: <5432CBE7.1040901@infradead.org>
In-Reply-To: <5432CBE7.1040901@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Randy,

After analyzing this it became clear that the I2C_ALGOBIT select was bogus
since this driver doesn't use i2c at all. I've posted a new patch fixing that.

Thanks,

	Hans

On 10/06/2014 07:05 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>
> Fix build errors and kconfig warning: since 'select' does not check
> Kconfig symbol dependencies, add that dependency explicitly.
>
> VIDEO_TW68 selects I2C_ALGOBIT, so it should depend on I2C to
> prevent build errors and warnings.
>
> warning: (CAN_PEAK_PCIEC && SFC && IGB && VIDEO_TW68 && DRM && FB_DDC && FB_VIA) selects I2C_ALGOBIT which has unmet direct dependencies (I2C)
>    CC [M]  drivers/i2c/algos/i2c-algo-bit.o
> ../drivers/i2c/algos/i2c-algo-bit.c: In function 'i2c_bit_add_bus':
> ../drivers/i2c/algos/i2c-algo-bit.c:658:33: error: 'i2c_add_adapter' undeclared (first use in this function)
> ../drivers/i2c/algos/i2c-algo-bit.c:658:33: note: each undeclared identifier is reported only once for each function it appears in
> ../drivers/i2c/algos/i2c-algo-bit.c: In function 'i2c_bit_add_numbered_bus':
> ../drivers/i2c/algos/i2c-algo-bit.c:664:33: error: 'i2c_add_numbered_adapter' undeclared (first use in this function)
> ../drivers/i2c/algos/i2c-algo-bit.c: In function 'i2c_bit_add_bus':
> ../drivers/i2c/algos/i2c-algo-bit.c:659:1: warning: control reaches end of non-void function [-Wreturn-type]
> ../drivers/i2c/algos/i2c-algo-bit.c: In function 'i2c_bit_add_numbered_bus':
> ../drivers/i2c/algos/i2c-algo-bit.c:665:1: warning: control reaches end of non-void function [-Wreturn-type]
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>   drivers/media/pci/tw68/Kconfig |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-next-20141001.orig/drivers/media/pci/tw68/Kconfig
> +++ linux-next-20141001/drivers/media/pci/tw68/Kconfig
> @@ -1,6 +1,6 @@
>   config VIDEO_TW68
>   	tristate "Techwell tw68x Video For Linux"
> -	depends on VIDEO_DEV && PCI && VIDEO_V4L2
> +	depends on VIDEO_DEV && PCI && VIDEO_V4L2 && I2C
>   	select I2C_ALGOBIT
>   	select VIDEOBUF2_DMA_SG
>   	---help---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
