Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx01-fr.bfs.de ([193.174.231.67]:32360 "EHLO mx01-fr.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbbCVTdy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2015 15:33:54 -0400
Message-ID: <550F1917.1080602@bfs.de>
Date: Sun, 22 Mar 2015 20:33:43 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: Silvan Jegen <s.jegen@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2] [media] mantis: fix error handling
References: <20150216090408.GW5206@mwanda> <1427044578-16551-1-git-send-email-s.jegen@gmail.com>
In-Reply-To: <1427044578-16551-1-git-send-email-s.jegen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Am 22.03.2015 18:16, schrieb Silvan Jegen:
> Remove dead code, make goto label names more expressive and add a label
> in order to call mantis_dvb_exit if mantis_uart_init fails.
> 
> Also make sure that mantis_pci_exit is called if we fail the
> mantis_stream_control call and that we call mantis_i2c_exit if
> mantis_get_mac fails.
> 
> Signed-off-by: Silvan Jegen <s.jegen@gmail.com>
> ---
> V2 Changes (due to Dan Carpenter's review):
> 	- Remove dead code, do not activate it
> 	- Make goto labels more expressive
> 	- Add a call to mantis_dvb_exit
> 
>  drivers/media/pci/mantis/mantis_cards.c | 33 ++++++++++++++++-----------------
>  1 file changed, 16 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/media/pci/mantis/mantis_cards.c b/drivers/media/pci/mantis/mantis_cards.c
> index 801fc55..70df61e 100644
> --- a/drivers/media/pci/mantis/mantis_cards.c
> +++ b/drivers/media/pci/mantis/mantis_cards.c
> @@ -170,7 +170,7 @@ static int mantis_pci_probe(struct pci_dev *pdev,
>  	if (mantis == NULL) {
>  		printk(KERN_ERR "%s ERROR: Out of memory\n", __func__);
>  		err = -ENOMEM;
> -		goto fail0;
> +		return err;
>  	}
>  
>  	mantis->num		= devs;
> @@ -183,70 +183,69 @@ static int mantis_pci_probe(struct pci_dev *pdev,
>  	err = mantis_pci_init(mantis);
>  	if (err) {
>  		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis PCI initialization failed <%d>", err);
> -		goto fail1;
> +		goto err_free_mantis;
>  	}
>  
>  	err = mantis_stream_control(mantis, STREAM_TO_HIF);
>  	if (err < 0) {
>  		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis stream control failed <%d>", err);
> -		goto fail1;
> +		goto err_pci_exit;
>  	}
>  
>  	err = mantis_i2c_init(mantis);
>  	if (err < 0) {
>  		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis I2C initialization failed <%d>", err);
> -		goto fail2;
> +		goto err_pci_exit;
>  	}
>  
>  	err = mantis_get_mac(mantis);
>  	if (err < 0) {
>  		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis MAC address read failed <%d>", err);
> -		goto fail2;
> +		goto err_i2c_exit;
>  	}
>  
>  	err = mantis_dma_init(mantis);
>  	if (err < 0) {
>  		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis DMA initialization failed <%d>", err);
> -		goto fail3;
> +		goto err_i2c_exit;
>  	}
>  
>  	err = mantis_dvb_init(mantis);
>  	if (err < 0) {
>  		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis DVB initialization failed <%d>", err);
> -		goto fail4;
> +		goto err_dma_exit;
>  	}
> +
>  	err = mantis_uart_init(mantis);
>  	if (err < 0) {
>  		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis UART initialization failed <%d>", err);
> -		goto fail6;
> +		goto err_dvb_exit;
>  	}
>  
>  	devs++;
>  
>  	return err;
>  

Hi Silvan Jegen,
i found the dprintk() a bit confusing, if i understand the code correctly it will always print on error:

the dprintf found in if (err<0) like :
 dprintk(MANTIS_ERROR, 1, "ERROR: Mantis DVB initialization failed <%d>", err);
and then
  dprintk(MANTIS_ERROR, 1, "ERROR: Mantis DVB exit! <%d>", err);

maybe this is more a question for the maintainer, but this seems a bit useless.

re,
 wh


> +err_dvb_exit:
> +	dprintk(MANTIS_ERROR, 1, "ERROR: Mantis DVB exit! <%d>", err);
> +	mantis_dvb_exit(mantis);
>  
> -	dprintk(MANTIS_ERROR, 1, "ERROR: Mantis UART exit! <%d>", err);
> -	mantis_uart_exit(mantis);
> -
> -fail6:
> -fail4:
> +err_dma_exit:
>  	dprintk(MANTIS_ERROR, 1, "ERROR: Mantis DMA exit! <%d>", err);
>  	mantis_dma_exit(mantis);
>  
> -fail3:
> +err_i2c_exit:
>  	dprintk(MANTIS_ERROR, 1, "ERROR: Mantis I2C exit! <%d>", err);
>  	mantis_i2c_exit(mantis);
>  
> -fail2:
> +err_pci_exit:
>  	dprintk(MANTIS_ERROR, 1, "ERROR: Mantis PCI exit! <%d>", err);
>  	mantis_pci_exit(mantis);
>  
> -fail1:
> +err_free_mantis:
>  	dprintk(MANTIS_ERROR, 1, "ERROR: Mantis free! <%d>", err);
>  	kfree(mantis);
>  
> -fail0:
>  	return err;
>  }
>  
