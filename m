Return-path: <mchehab@gaivota>
Received: from zone0.gcu-squad.org ([212.85.147.21]:38124 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab0IFHNA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Sep 2010 03:13:00 -0400
Date: Mon, 6 Sep 2010 09:12:50 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	p.osciak@samsung.com, s.nawrocki@samsung.com,
	Tobias Lorenz <tobias.lorenz@gmx.net>,
	Joonyoung Shim <jy0922.shim@samsung.com>,
	Douglas Schilling Landgraf <dougsland@redhat.com>
Subject: Re: [PATCH 8/8] v4l: radio: si470x: fix unneeded free_irq() call
Message-ID: <20100906091250.189a9e08@hyperion.delvare>
In-Reply-To: <1283756030-28634-9-git-send-email-m.szyprowski@samsung.com>
References: <1283756030-28634-1-git-send-email-m.szyprowski@samsung.com>
	<1283756030-28634-9-git-send-email-m.szyprowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Mon, 06 Sep 2010 08:53:50 +0200, Marek Szyprowski wrote:
> In case of error during probe() the driver calls free_irq() function
> on not yet allocated irq. This patches fixes the call sequence in case of
> the error.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> CC: Tobias Lorenz <tobias.lorenz@gmx.net>
> CC: Joonyoung Shim <jy0922.shim@samsung.com>
> CC: Douglas Schilling Landgraf <dougsland@redhat.com>
> CC: Jean Delvare <khali@linux-fr.org>
> ---
>  drivers/media/radio/si470x/radio-si470x-i2c.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
> index 67a4ec8..4ce541a 100644
> --- a/drivers/media/radio/si470x/radio-si470x-i2c.c
> +++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
> @@ -395,7 +395,7 @@ static int __devinit si470x_i2c_probe(struct i2c_client *client,
>  	radio->registers[POWERCFG] = POWERCFG_ENABLE;
>  	if (si470x_set_register(radio, POWERCFG) < 0) {
>  		retval = -EIO;
> -		goto err_all;
> +		goto err_video;
>  	}
>  	msleep(110);
>  

Good catch.

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
