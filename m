Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0131.hostedemail.com ([216.40.44.131]:48785 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751812AbbBXEyp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 23:54:45 -0500
Message-ID: <1424753682.5342.9.camel@perches.com>
Subject: Re: [PATCH] drivers: media: i2c : s5c73m3: Replace dev_err with
 pr_err
From: Joe Perches <joe@perches.com>
To: Tapasweni Pathak <tapaswenipathak@gmail.com>
Cc: kyungmin.park@samsung.com, a.hajda@samsung.com,
	mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Mon, 23 Feb 2015 20:54:42 -0800
In-Reply-To: <20150224044731.GA5804@kt-Inspiron-3542>
References: <20150224044731.GA5804@kt-Inspiron-3542>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2015-02-24 at 10:17 +0530, Tapasweni Pathak wrote:
> Replace dev_err statement with pr_err to fix null dereference.
> 
> Found by Coccinelle.
> 
> Signed-off-by: Tapasweni Pathak <tapaswenipathak@gmail.com>
> ---
>  drivers/media/i2c/s5c73m3/s5c73m3-spi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
> index f60b265..63eb190 100644
> --- a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
> +++ b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
> @@ -52,7 +52,7 @@ static int spi_xmit(struct spi_device *spi_dev, void *addr, const int len,
>  		xfer.rx_buf = addr;
> 
>  	if (spi_dev == NULL) {
> -		dev_err(&spi_dev->dev, "SPI device is uninitialized\n");
> +		pr_err("SPI device is uninitialized\n");
>  		return -ENODEV;
>  	}

It'd be better to move this above the if (dir...) block
and use ratelimit/once it too

static int spi_xmit(struct spi_device *spi_dev, void *addr, const int len,
		    enum spi_direction dir)
{
	struct spi_message msg;
	int r;
	struct spi_transfer xfer = {
		.len	= len,
	};

	if (!spi_dev) {
		pr_err_once("SPI device is uninitialized\n");
		return -ENODEV;
	}

	if (dir == SPI_DIR_TX)
		xfer.tx_buf = addr;
	else
		xfer.rx_buf = addr;

	...

