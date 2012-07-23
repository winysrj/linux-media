Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:58663 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187Ab2GWS01 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 14:26:27 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id q6NIQPwE019086
	for <linux-media@vger.kernel.org>; Mon, 23 Jul 2012 13:26:26 -0500
Message-ID: <500D974C.4090703@ti.com>
Date: Mon, 23 Jul 2012 23:56:20 +0530
From: Sekhar Nori <nsekhar@ti.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.lad@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH] davinci: vpss: enable vpss clocks
References: <1342793497-27793-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1342793497-27793-1-git-send-email-prabhakar.lad@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

On 7/20/2012 7:41 PM, Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> By default the VPSS clocks are only enabled in capture driver.
> and display wont work if the capture is not enabled. This
> patch adds support to enable the VPSS clocks in VPSS driver.
> This way we can enable/disable capture and display and use it
> independently.

With this description, I would expect to see some lines related to clock
enable being removed from capture driver, but I don't see that. Are you
sure there is no duplicate enable of of clocks happening after this patch?

> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> ---
>  drivers/media/video/davinci/vpss.c |   38 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 38 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/davinci/vpss.c b/drivers/media/video/davinci/vpss.c
> index 3e5cf27..30283bb 100644
> --- a/drivers/media/video/davinci/vpss.c
> +++ b/drivers/media/video/davinci/vpss.c
> @@ -25,6 +25,9 @@
>  #include <linux/spinlock.h>
>  #include <linux/compiler.h>
>  #include <linux/io.h>
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +
>  #include <mach/hardware.h>
>  #include <media/davinci/vpss.h>
>  
> @@ -104,6 +107,10 @@ struct vpss_oper_config {
>  	enum vpss_platform_type platform;
>  	spinlock_t vpss_lock;
>  	struct vpss_hw_ops hw_ops;
> +	/* Master clock */
> +	struct clk *mclk;
> +	/* slave clock */
> +	struct clk *sclk;
>  };
>  
>  static struct vpss_oper_config oper_cfg;
> @@ -381,6 +388,29 @@ static int __init vpss_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  	}
>  
> +	/* Get and enable Master clock */
> +	oper_cfg.mclk = clk_get(&pdev->dev, "master");
> +	if (IS_ERR(oper_cfg.mclk)) {
> +		status = PTR_ERR(oper_cfg.mclk);
> +		goto fail_getclk;
> +	}
> +	if (clk_enable(oper_cfg.mclk)) {
> +		status = -ENODEV;
> +		goto fail_mclk;
> +	}
> +	if (oper_cfg.platform == DM355 || oper_cfg.platform == DM644X) {
> +		/* Get and enable Slave clock */
> +		oper_cfg.sclk = clk_get(&pdev->dev, "slave");

Clock API is already a platform abstraction. So, to check for device
type here is incorrect. This way, you are not actually using the
abstraction.

Why are you enabling slave clock only for DM355 and DM644X? I suspect
since the IP is reused between these devices, the IP still has a slave
clock on all other platforms - only it may be a constant clock on those
platforms. If that's the case, the driver should still request for both
master and slave clocks on all platforms and have the platform define
the slave clock as a constant clock where required.

> +		if (IS_ERR(oper_cfg.sclk)) {
> +			status = PTR_ERR(oper_cfg.sclk);
> +			goto fail_mclk;
> +		}
> +		if (clk_enable(oper_cfg.sclk)) {
> +			status = -ENODEV;

Why override the status that clk_enable() is giving you?

Thanks,
Sekhar
