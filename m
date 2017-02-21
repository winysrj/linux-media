Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35397 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751800AbdBUWFW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 17:05:22 -0500
Date: Tue, 21 Feb 2017 23:05:17 +0100
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] media: pci: saa7164: remove dead code
Message-ID: <20170221220517.GA13525@gmail.com>
References: <20170221034657.GA4757@embeddedgus>
 <20170221034959.GA4837@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170221034959.GA4837@embeddedgus>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 20, 2017 at 09:49:59PM -0600, Gustavo A. R. Silva wrote:
> Remove dead code. The following line of code is never reached:
> return SAA_OK;
> 
> Addresses-Coverity-ID: 114283
Reviewed-by: Peter Senna Tschudin <peter.senna@gmail.com>
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> ---
>  drivers/media/pci/saa7164/saa7164-cmd.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/media/pci/saa7164/saa7164-cmd.c b/drivers/media/pci/saa7164/saa7164-cmd.c
> index 169c90a..fb19498 100644
> --- a/drivers/media/pci/saa7164/saa7164-cmd.c
> +++ b/drivers/media/pci/saa7164/saa7164-cmd.c
> @@ -181,8 +181,6 @@ static int saa7164_cmd_dequeue(struct saa7164_dev *dev)
>  		wake_up(q);
>  		return SAA_OK;
>  	}
> -
> -	return SAA_OK;
>  }
>  
>  static int saa7164_cmd_set(struct saa7164_dev *dev, struct tmComResInfo *msg,
> -- 
> 2.5.0
> 
