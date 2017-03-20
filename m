Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02-sz.bfs.de ([194.94.69.103]:27485 "EHLO mx02-sz.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753075AbdCTMFt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 08:05:49 -0400
Message-ID: <58CFC561.8090104@bfs.de>
Date: Mon, 20 Mar 2017 13:04:49 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: Daeseok Youn <daeseok.youn@gmail.com>
CC: mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@linux.intel.com, singhalsimran0@gmail.com,
        dan.carpenter@oracle.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/4] staging: atomisp: simplify if statement in atomisp_get_sensor_fps()
References: <20170320105940.GA17472@SEL-JYOUN-D1>
In-Reply-To: <20170320105940.GA17472@SEL-JYOUN-D1>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Am 20.03.2017 11:59, schrieb Daeseok Youn:
> If v4l2_subdev_call() gets the global frame interval values,
> it returned 0 and it could be checked whether numerator is zero or not.
> 
> If the numerator is not zero, the fps could be calculated in this function.
> If not, it just returns 0.
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  .../media/atomisp/pci/atomisp2/atomisp_cmd.c       | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
> index 8bdb224..6bdd19e 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
> @@ -153,20 +153,18 @@ struct atomisp_acc_pipe *atomisp_to_acc_pipe(struct video_device *dev)
>  
>  static unsigned short atomisp_get_sensor_fps(struct atomisp_sub_device *asd)
>  {
> -	struct v4l2_subdev_frame_interval frame_interval;
> +	struct v4l2_subdev_frame_interval fi;
>  	struct atomisp_device *isp = asd->isp;
> -	unsigned short fps;
>  
> -	if (v4l2_subdev_call(isp->inputs[asd->input_curr].camera,
> -	    video, g_frame_interval, &frame_interval)) {
> -		fps = 0;
> -	} else {
> -		if (frame_interval.interval.numerator)
> -			fps = frame_interval.interval.denominator /
> -			    frame_interval.interval.numerator;
> -		else
> -			fps = 0;
> -	}
> +	unsigned short fps = 0;
> +	int ret;
> +
> +	ret = v4l2_subdev_call(isp->inputs[asd->input_curr].camera,
> +			       video, g_frame_interval, &fi);
> +
> +	if (!ret && fi.interval.numerator)
> +		fps = fi.interval.denominator / fi.interval.numerator;
> +
>  	return fps;
>  }



do you need to check ret at all ? if an error occurs can fi.interval.numerator
be something else than 0 ?

if ret is an ERRNO it would be wise to return ret not fps, but this may require
changes at other places also.

re,
 wh

>  
