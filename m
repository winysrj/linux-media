Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48428 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab2JGMtr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Oct 2012 08:49:47 -0400
Date: Sun, 7 Oct 2012 09:49:35 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Palash Bandyopadhyay <Palash.Bandyopadhyay@conexant.com>,
	Sri Deevi <Srinivasa.Deevi@conexant.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	"Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
	Thomas Meyer <thomas@m3y3r.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] cx25821: testing the wrong variable
Message-ID: <20121007094935.61084364@infradead.org>
In-Reply-To: <20120929071253.GD10993@elgon.mountain>
References: <20120929071253.GD10993@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 29 Sep 2012 10:12:53 +0300
Dan Carpenter <dan.carpenter@oracle.com> escreveu:

> ->input_filename could be NULL here.  The intent was to test
> ->_filename.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> I'm not totally convinced that using /root/vid411.yuv is the right idea.

Agreed.

Palash, Sri,

Why do we need those files?

Regards,
Mauro

> 
> diff --git a/drivers/media/pci/cx25821/cx25821-video-upstream.c b/drivers/media/pci/cx25821/cx25821-video-upstream.c
> index 52c13e0..6759fff 100644
> --- a/drivers/media/pci/cx25821/cx25821-video-upstream.c
> +++ b/drivers/media/pci/cx25821/cx25821-video-upstream.c
> @@ -808,7 +808,7 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
>  	}
>  
>  	/* Default if filename is empty string */
> -	if (strcmp(dev->input_filename, "") == 0) {
> +	if (strcmp(dev->_filename, "") == 0) {
>  		if (dev->_isNTSC) {
>  			dev->_filename =
>  				(dev->_pixel_format == PIXEL_FRMT_411) ?
> diff --git a/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c b/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
> index c8c94fb..d33fc1a 100644
> --- a/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
> +++ b/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
> @@ -761,7 +761,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
>  	}
>  
>  	/* Default if filename is empty string */
> -	if (strcmp(dev->input_filename_ch2, "") == 0) {
> +	if (strcmp(dev->_filename_ch2, "") == 0) {
>  		if (dev->_isNTSC_ch2) {
>  			dev->_filename_ch2 = (dev->_pixel_format_ch2 ==
>  				PIXEL_FRMT_411) ? "/root/vid411.yuv" :
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
