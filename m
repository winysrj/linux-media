Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756941Ab1FURxJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 13:53:09 -0400
Message-ID: <4E00DA73.1090903@redhat.com>
Date: Tue, 21 Jun 2011 14:52:51 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmljaGFyZCBSw7ZqZm9ycw==?=
	<richard.rojfors@pelagicore.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 2/2] radio-timb: Add open function which finds tuner and
 DSP via I2C
References: <1307717332.2420.30.camel@debian>
In-Reply-To: <1307717332.2420.30.camel@debian>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 10-06-2011 11:48, Richard Röjfors escreveu:
> This patch uses the platform data and finds a tuner and DSP. This is
> done when the user calls open. Not during probe, to allow shorter bootup
> time of the system.
> This piece of code was actually missing earlier, many of the functions
> were not useful without DSP and tuner.
> 
> Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
> ---
> diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
> index a185610..64a5e19 100644
> --- a/drivers/media/radio/radio-timb.c
> +++ b/drivers/media/radio/radio-timb.c
> @@ -141,9 +141,42 @@ static const struct v4l2_ioctl_ops timbradio_ioctl_ops = {
>  	.vidioc_s_ctrl		= timbradio_vidioc_s_ctrl
>  };
>  
> +static int timbradio_fops_open(struct file *file)
> +{
> +	struct timbradio *tr = video_drvdata(file);
> +	struct i2c_adapter *adapt;
> +
> +	/* find the I2C bus */
> +	adapt = i2c_get_adapter(tr->pdata.i2c_adapter);
> +	if (!adapt) {
> +		printk(KERN_ERR DRIVER_NAME": No I2C bus\n");
> +		return -ENODEV;
> +	}
> +
> +	/* now find the tuner and dsp */
> +	if (!tr->sd_dsp)
> +		tr->sd_dsp = v4l2_i2c_new_subdev_board(&tr->v4l2_dev, adapt,
> +			tr->pdata.dsp, NULL);
> +
> +	if (!tr->sd_tuner)
> +		tr->sd_tuner = v4l2_i2c_new_subdev_board(&tr->v4l2_dev, adapt,
> +			tr->pdata.tuner, NULL);
> +
> +	i2c_put_adapter(adapt);

Hmm... it doesn't look right to me to do that for every device
open. You should probably do it at device probe, and move i2c_put_adapter
to device removal.

> +
> +	if (!tr->sd_tuner || !tr->sd_dsp) {
> +		printk(KERN_ERR DRIVER_NAME
> +			": Failed to get tuner or DSP\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
>  static const struct v4l2_file_operations timbradio_fops = {
>  	.owner		= THIS_MODULE,
>  	.unlocked_ioctl	= video_ioctl2,
> +	.open		= timbradio_fops_open,
>  };
>  
>  static int __devinit timbradio_probe(struct platform_device *pdev)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

