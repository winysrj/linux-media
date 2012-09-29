Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx01.sz.bfs.de ([194.94.69.103]:39399 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab2I2Kwm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Sep 2012 06:52:42 -0400
Message-ID: <5066D2F6.10800@bfs.de>
Date: Sat, 29 Sep 2012 12:52:38 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
	Thomas Meyer <thomas@m3y3r.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] cx25821: testing the wrong variable
References: <20120929071253.GD10993@elgon.mountain>
In-Reply-To: <20120929071253.GD10993@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Am 29.09.2012 09:12, schrieb Dan Carpenter:
> ->input_filename could be NULL here.  The intent was to test
> ->_filename.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> I'm not totally convinced that using /root/vid411.yuv is the right idea.
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
>

In this case stcmp seems a bit of a overkill. A simple
*(dev->_filename_ch2) == 0
should be ok ?

re,
 wh
