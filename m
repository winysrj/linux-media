Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnxtsmtp2.conexant.com ([198.62.9.253]:25945 "EHLO
	cnxtsmtp2.conexant.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab2JHWj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 18:39:29 -0400
From: "Palash Bandyopadhyay" <Palash.Bandyopadhyay@conexant.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Sri Deevi" <Srinivasa.Deevi@conexant.com>
cc: "Dan Carpenter" <dan.carpenter@oracle.com>,
	"Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
	"Thomas Meyer" <thomas@m3y3r.de>,
	"Hans Verkuil" <hans.verkuil@cisco.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Mon, 8 Oct 2012 15:21:56 -0700
Subject: RE: [patch] [media] cx25821: testing the wrong variable
Message-ID: <0b1a920d-e3f3-44f9-916b-1efa81e6160c@cnxthub1.bbnet.ad>
References: <20120929071253.GD10993@elgon.mountain> <20121007094935.61084364@infradead.org>
In-Reply-To: <20121007094935.61084364@infradead.org>
Content-Language: en-US
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

  This is to be able to upstream data from the host to the device to be pushed out. I agree this is not an optimal way of doing things and had discussed with Hans on this last month.

  I will be making changes to the entire upstream path and get rid of this mechanism that we have in place here.

Rgds,
Palash

-----Original Message-----
From: Mauro Carvalho Chehab [mailto:mchehab@infradead.org] 
Sent: Sunday, October 07, 2012 5:50 AM
To: Palash Bandyopadhyay; Sri Deevi
Cc: Dan Carpenter; Leonid V. Fedorenchik; Thomas Meyer; Hans Verkuil; linux-media@vger.kernel.org; kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] cx25821: testing the wrong variable

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
> diff --git a/drivers/media/pci/cx25821/cx25821-video-upstream.c 
> b/drivers/media/pci/cx25821/cx25821-video-upstream.c
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
> diff --git a/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c 
> b/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
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
> To unsubscribe from this list: send the line "unsubscribe linux-media" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro

Conexant E-mail Firewall (Conexant.Com) made the following annotations
---------------------------------------------------------------------
********************** Legal Disclaimer **************************** 

"This email may contain confidential and privileged material for the sole use of the intended recipient. Any unauthorized review, use or distribution by others is strictly prohibited. If you have received the message in error, please advise the sender by reply email and delete the message. Thank you." 

********************************************************************** 

---------------------------------------------------------------------

