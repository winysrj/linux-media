Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33593 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751906AbdBUWHK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 17:07:10 -0500
Date: Tue, 21 Feb 2017 23:07:06 +0100
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] media: pci: saa7164: remove unnecessary code
Message-ID: <20170221220706.GB13525@gmail.com>
References: <20170221034657.GA4757@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170221034657.GA4757@embeddedgus>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 20, 2017 at 09:46:58PM -0600, Gustavo A. R. Silva wrote:
> Remove unnecessary variable 'loop'.
> 
Reviewed-by: Peter Senna Tschudin <peter.senna@gmail.com>
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> ---
>  drivers/media/pci/saa7164/saa7164-cmd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/media/pci/saa7164/saa7164-cmd.c b/drivers/media/pci/saa7164/saa7164-cmd.c
> index 45951b3..169c90a 100644
> --- a/drivers/media/pci/saa7164/saa7164-cmd.c
> +++ b/drivers/media/pci/saa7164/saa7164-cmd.c
> @@ -134,14 +134,13 @@ int saa7164_irq_dequeue(struct saa7164_dev *dev)
>   * -bus/c running buffer. */
>  static int saa7164_cmd_dequeue(struct saa7164_dev *dev)
>  {
> -	int loop = 1;
>  	int ret;
>  	u32 timeout;
>  	wait_queue_head_t *q = NULL;
>  	u8 tmp[512];
>  	dprintk(DBGLVL_CMD, "%s()\n", __func__);
>  
> -	while (loop) {
> +	while (true) {
>  
>  		struct tmComResInfo tRsp = { 0, 0, 0, 0, 0, 0 };
>  		ret = saa7164_bus_get(dev, &tRsp, NULL, 1);
> -- 
> 2.5.0
> 
