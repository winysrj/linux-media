Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:51838 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751668AbeE2GRd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 02:17:33 -0400
Subject: Re: [PATCH v2] media: pxa_camera: avoid duplicate s_power calls
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1527435011-9318-1-git-send-email-akinobu.mita@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <638b94cd-7112-4f45-ffe2-a652cdc47492@xs4all.nl>
Date: Tue, 29 May 2018 08:17:27 +0200
MIME-Version: 1.0
In-Reply-To: <1527435011-9318-1-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akinobu,

On 05/27/2018 05:30 PM, Akinobu Mita wrote:
> The open() operation for the pxa_camera driver always calls s_power()
> operation to put its subdevice sensor in normal operation mode, and the
> release() operation always call s_power() operation to put the subdevice
> in power saving mode.
> 
> This requires the subdevice sensor driver to keep track of its power
> state in order to avoid putting the subdevice in power saving mode while
> the device is still opened by some users.
> 
> Many subdevice drivers handle it by the boilerplate code that increments
> and decrements an internal counter in s_power() like below:
> 
> 	/*
> 	 * If the power count is modified from 0 to != 0 or from != 0 to 0,
> 	 * update the power state.
> 	 */
> 	if (sensor->power_count == !on) {
> 		ret = ov5640_set_power(sensor, !!on);
> 		if (ret)
> 			goto out;
> 	}
> 
> 	/* Update the power count. */
> 	sensor->power_count += on ? 1 : -1;
> 
> However, some subdevice drivers don't handle it and may cause a problem
> with the pxa_camera driver if the video device is opened by more than
> two users at the same time.
> 
> Instead of propagating the boilerplate code for each subdevice driver
> that implement s_power, this introduces an trick that many V4L2 drivers
> are using with v4l2_fh_is_singular_file().
> 
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> * v2
> - Print warning message when s_power() is failed. (not printing warning
>   when _vb2_fop_release() is failed as it always returns zero for now)

Please note that v1 has already been merged, so if you can make a v3 rebased
on top of the latest media_tree master branch, then I'll queue that up for
4.18.

Regards,

	Hans

> 
>  drivers/media/platform/pxa_camera.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
> index c71a007..a35f461 100644
> --- a/drivers/media/platform/pxa_camera.c
> +++ b/drivers/media/platform/pxa_camera.c
> @@ -2040,6 +2040,9 @@ static int pxac_fops_camera_open(struct file *filp)
>  	if (ret < 0)
>  		goto out;
>  
> +	if (!v4l2_fh_is_singular_file(filp))
> +		goto out;
> +
>  	ret = sensor_call(pcdev, core, s_power, 1);
>  	if (ret)
>  		v4l2_fh_release(filp);
> @@ -2052,13 +2055,23 @@ static int pxac_fops_camera_release(struct file *filp)
>  {
>  	struct pxa_camera_dev *pcdev = video_drvdata(filp);
>  	int ret;
> -
> -	ret = vb2_fop_release(filp);
> -	if (ret < 0)
> -		return ret;
> +	bool fh_singular;
>  
>  	mutex_lock(&pcdev->mlock);
> -	ret = sensor_call(pcdev, core, s_power, 0);
> +
> +	fh_singular = v4l2_fh_is_singular_file(filp);
> +
> +	ret = _vb2_fop_release(filp, NULL);
> +
> +	if (fh_singular) {
> +		ret = sensor_call(pcdev, core, s_power, 0);
> +		if (ret) {
> +			dev_warn(pcdev_to_dev(pcdev),
> +				 "Failed to put subdevice in power saving mode: %d\n",
> +				 ret);
> +		}
> +	}
> +
>  	mutex_unlock(&pcdev->mlock);
>  
>  	return ret;
> 
