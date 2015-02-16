Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:48305 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932259AbbBPLTg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 06:19:36 -0500
Message-ID: <54E1D22D.7050402@xs4all.nl>
Date: Mon, 16 Feb 2015 12:19:09 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Nicholas Mc Guire <hofrat@osadl.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Wolfram Sang <wsa@the-dreams.de>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] media: radio: handle timeouts
References: <1423126602-6639-1-git-send-email-hofrat@osadl.org>
In-Reply-To: <1423126602-6639-1-git-send-email-hofrat@osadl.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicholas,

On 02/05/2015 09:56 AM, Nicholas Mc Guire wrote:
> Add handling for timeout case.
> 
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> ---
> Some error state/error information seems be get lost int the current code.
> (line-numbers are from 3.19.0-rc7.
> 
> Assume that on line 827 core->write succeeds but the following 
> wait_for_completion_timeout times out and the radio->irq_received condition 
> is not satisfied resulting in   goto out;
> 
> 827       r = core->write(core, WL1273_TUNER_MODE_SET, TUNER_MODE_AUTO_SEEK);
> 828       if (r)
> 829               goto out;
> 830
> 831       wait_for_completion_timeout(&radio->busy, msecs_to_jiffies(1000));
> 832       if (!(radio->irq_received & WL1273_BL_EVENT))
> 833               goto out;
> 
> 
> A similar situation is at line 955 - 859 where a tiemout could occure
> and the reported value would be the success value from core->write.
> 
> 852       reinit_completion(&radio->busy);
> 853       dev_dbg(radio->dev, "%s: BUSY\n", __func__);
> 854
> 855       r = core->write(core, WL1273_TUNER_MODE_SET, TUNER_MODE_AUTO_SEEK);
> 856       if (r)
> 857               goto out;
> 858
> 859       wait_for_completion_timeout(&radio->busy, msecs_to_jiffies(1000)
> 
> the problem is that the value of r now is the "success" value from core->write
> and any timeout and/or failure to detect the expected interrupt is not 
> reported in 
> 
> 860 out:
> 861       dev_dbg(radio->dev, "%s: Err: %d\n", __func__, r);
> 862       return r;
> 
> Should the wait_for_completion_timeout not report the timeout event by setting 
> r to -ETIMEOUT ? respectively use if (!(radio->irq_received & WL1273_BL_EVENT))
> to check and set -ETIMEOUT there ?
> 
> Comparing this with wl1273_fm_set_tx_freq - the below patch might be suitable 
> way to handle timeout - but this needs a review by someone who knows the 
> details of the driver - so this is really just a guess.

While I am certainly not an expert, I agree that the current situation is bad.

I'm taking your patch as-is, since returning a proper error here seems to make
much more sense.

Regards,

	Hans

> 
> Patch was only compile tested with x86_64_defconfig + CONFIG_MEDIA_SUPPORT=m
> CONFIG_MEDIA_CAMERA_SUPPORT=y, CONFIG_V4L_PLATFORM_DRIVERS=y,
> CONFIG_MEDIA_RADIO_SUPPORT=y, RADIO_ADAPTER=y, CONFIG_RADIO_WL1273=m
> 
> Patch is against 3.19.0-rc7 (localversion-next is -next-20150204)
> 
>  drivers/media/radio/radio-wl1273.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
> index 571c7f6..6830523 100644
> --- a/drivers/media/radio/radio-wl1273.c
> +++ b/drivers/media/radio/radio-wl1273.c
> @@ -828,9 +828,12 @@ static int wl1273_fm_set_seek(struct wl1273_device *radio,
>  	if (r)
>  		goto out;
>  
> +	/* wait for the FR IRQ */
>  	wait_for_completion_timeout(&radio->busy, msecs_to_jiffies(1000));
> -	if (!(radio->irq_received & WL1273_BL_EVENT))
> +	if (!(radio->irq_received & WL1273_BL_EVENT)) {
> +		r = -ETIMEDOUT;
>  		goto out;
> +	}
>  
>  	radio->irq_received &= ~WL1273_BL_EVENT;
>  
> @@ -856,7 +859,9 @@ static int wl1273_fm_set_seek(struct wl1273_device *radio,
>  	if (r)
>  		goto out;
>  
> -	wait_for_completion_timeout(&radio->busy, msecs_to_jiffies(1000));
> +	/* wait for the FR IRQ */
> +	if (!wait_for_completion_timeout(&radio->busy, msecs_to_jiffies(1000)))
> +		r = -ETIMEDOUT;
>  out:
>  	dev_dbg(radio->dev, "%s: Err: %d\n", __func__, r);
>  	return r;
> 

