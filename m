Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48815 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422804AbcBQNfV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 08:35:21 -0500
Date: Wed, 17 Feb 2016 11:35:15 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org,
	Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH] [media] coda: add support for native order firmware
 files with Freescale header
Message-ID: <20160217113515.19c0f87a@recife.lan>
In-Reply-To: <1455715270-23757-1-git-send-email-p.zabel@pengutronix.de>
References: <1455715270-23757-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 17 Feb 2016 14:21:10 +0100
Philipp Zabel <p.zabel@pengutronix.de> escreveu:

> Freescale distribute their VPU firmware files with a 16 byte header
> in BIT processor native order. This patch allows to detect the header
> and to reorder the firmware on the fly.
> With this patch it should be possible to use the distributed
> vpu_fw_imx{53,6q,6d}.bin files directly after renaming them to
> v4l-coda*-imx{53,6q,6dl}.bin.

IMHO, the best would be to add another patch to support the files with
their original names, falling back to v4l-coda*. We do this on other
drivers where more than one firmware file could be used.

> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> ---
>  drivers/media/platform/coda/coda-common.c | 35 +++++++++++++++++++++++++++++--
>  1 file changed, 33 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index 2d782ce..0bc544d 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -1950,6 +1950,38 @@ static int coda_register_device(struct coda_dev *dev, int i)
>  	return video_register_device(vfd, VFL_TYPE_GRABBER, 0);
>  }
>  
> +static void coda_copy_firmware(struct coda_dev *dev, const u8 * const buf,
> +			       size_t size)
> +{
> +	u32 *src = (u32 *)buf;
> +
> +	/* Check if the firmware has a 16-byte Freescale header, skip it */
> +	if (buf[0] == 'M' && buf[1] == 'X')
> +		src += 4;
> +	/*
> +	 * Check whether the firmware is in native order or pre-reordered for
> +	 * memory access. The first instruction opcode always is 0xe40e.
> +	 */
> +	if (__le16_to_cpup((__le16 *)src) == 0xe40e) {
> +		u32 *dst = dev->codebuf.vaddr;
> +		int i;
> +
> +		/* Firmware in native order, reorder while copying */
> +		if (dev->devtype->product == CODA_DX6) {
> +			for (i = 0; i < (size - 16) / 4; i++)
> +				dst[i] = (src[i] << 16) | (src[i] >> 16);
> +		} else {
> +			for (i = 0; i < (size - 16) / 4; i += 2) {
> +				dst[i] = (src[i + 1] << 16) | (src[i + 1] >> 16);
> +				dst[i + 1] = (src[i] << 16) | (src[i] >> 16);
> +			}
> +		}
> +	} else {
> +		/* Copy the already reordered firmware image */
> +		memcpy(dev->codebuf.vaddr, src, size);
> +	}
> +}
> +
>  static void coda_fw_callback(const struct firmware *fw, void *context)
>  {
>  	struct coda_dev *dev = context;
> @@ -1967,8 +1999,7 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
>  	if (ret < 0)
>  		goto put_pm;
>  
> -	/* Copy the whole firmware image to the code buffer */
> -	memcpy(dev->codebuf.vaddr, fw->data, fw->size);
> +	coda_copy_firmware(dev, fw->data, fw->size);
>  	release_firmware(fw);
>  
>  	ret = coda_hw_init(dev);


-- 
Thanks,
Mauro
