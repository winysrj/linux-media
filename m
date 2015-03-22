Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44593 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbbCVWsa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2015 18:48:30 -0400
Date: Mon, 23 Mar 2015 01:48:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Silvan Jegen <s.jegen@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] [media] mantis: fix error handling
Message-ID: <20150322224831.GF16501@mwanda>
References: <20150216090408.GW5206@mwanda>
 <1427044578-16551-1-git-send-email-s.jegen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1427044578-16551-1-git-send-email-s.jegen@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Good, but still a couple nits.

On Sun, Mar 22, 2015 at 06:16:18PM +0100, Silvan Jegen wrote:
> --- a/drivers/media/pci/mantis/mantis_cards.c
> +++ b/drivers/media/pci/mantis/mantis_cards.c
> @@ -170,7 +170,7 @@ static int mantis_pci_probe(struct pci_dev *pdev,
>  	if (mantis == NULL) {
>  		printk(KERN_ERR "%s ERROR: Out of memory\n", __func__);
>  		err = -ENOMEM;
> -		goto fail0;
> +		return err;

Just:
		return -ENOMEM;


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

	return 0;

That was in the original, but let's just clean it up as well.

>  
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


Remove all these dprintks in the error handling.

regards,
dan carpenter

