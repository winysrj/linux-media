Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873Ab0BVPS0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 10:18:26 -0500
Message-ID: <4B82A039.7060901@redhat.com>
Date: Mon, 22 Feb 2010 12:18:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: stefan.ringel@arcor.de
CC: linux-media@vger.kernel.org, dheitmueller@kernellabs.com
Subject: Re: [PATCH 2/3] tm6000: bugfix reading problems with demodulator
 zl10353
References: <1266783036-6549-1-git-send-email-stefan.ringel@arcor.de> <1266783036-6549-2-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1266783036-6549-2-git-send-email-stefan.ringel@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

stefan.ringel@arcor.de wrote:
> From: Stefan Ringel <stefan.ringel@arcor.de>

This patch depends on the previous one, so I can't apply it as-is.

Ah, please provide a better description for your patches. None of the patches you
submitted so far contains a single line but the subject. please read README.patches.
> 
> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
> ---
>  drivers/staging/tm6000/tm6000-i2c.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
> index b563129..6ae02b8 100644
> --- a/drivers/staging/tm6000/tm6000-i2c.c
> +++ b/drivers/staging/tm6000/tm6000-i2c.c
> @@ -54,9 +54,20 @@ int tm6000_i2c_send_regs(struct tm6000_core *dev, unsigned char addr, __u8 reg,
>  int tm6000_i2c_recv_regs(struct tm6000_core *dev, unsigned char addr, __u8 reg, char *buf, int len)
>  {
>  	int rc;
> +	u8 b[2];
>  
> +	if ((dev->caps.has_zl10353) && (dev->demod_addr << 1 == addr) && (reg % 2 == 0)) {
> +		reg -= 1;
> +		len += 1;
> +
> +		rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_VENDOR_TYPE | USB_RECIP_DEVICE,
> +			REQ_16_SET_GET_I2C_WR1_RDN, addr | reg << 8, 0, b, len);
> +
> +		*buf = b[1];
> +	} else {
>  		rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_VENDOR_TYPE | USB_RECIP_DEVICE,
>  			REQ_16_SET_GET_I2C_WR1_RDN, addr | reg << 8, 0, buf, len);
> +	}
>  
>  	return rc;
>  }


-- 

Cheers,
Mauro
