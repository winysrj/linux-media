Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:55567 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1032974AbeBOO3i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 09:29:38 -0500
Subject: Re: [PATCH] media: radio: Tuning bugfix for si470x over i2c
To: Douglas Fischer <fischerdouglasc@gmail.com>,
        linux-media@vger.kernel.org
References: <20180120141914.233d6d00@Constantine>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8eb3118e-ed8f-ec2a-06f2-c60b35ebfa31@xs4all.nl>
Date: Thu, 15 Feb 2018 15:29:37 +0100
MIME-Version: 1.0
In-Reply-To: <20180120141914.233d6d00@Constantine>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Douglas,

My apologies for the delay, but I have finally time to look at this.

First of all: all your patches are mangles. Your mailer probably is trying
to wrap around long lines and the end result is not usable. Please check this
next time.

Also, when you post newer versions of patches it is good practice to add a
version number: e.g. '[PATCHv3] media: radio: Tuning bugfix for si470x over i2c'.

That helps us keeping track of different versions.

On 20/01/18 20:19, Douglas Fischer wrote:
> Fixed si470x_set_channel() trying to tune before chip is turned
> on, which causes warnings in dmesg and when probing, makes driver
> wait for 3s for tuning timeout. This issue did not affect USB
> devices because they have a different probing sequence.
> 
> Signed-off-by: Douglas Fischer <fischerdouglasc@gmail.com>
> ---
> 
> diff -uprN linux.orig/drivers/media/radio/si470x/radio-si470x-common.c
> linux/drivers/media/radio/si470x/radio-si470x-common.c ---
> linux.orig/drivers/media/radio/si470x/radio-si470x-common.c
> 2018-01-15 21:58:10.675620432 -0500 +++
> linux/drivers/media/radio/si470x/radio-si470x-common.c
> 2018-01-16 17:04:59.706409128 -0500 @@ -207,29 +207,37 @@ static int
> si470x_set_chan(struct si470x unsigned long time_left; bool timed_out =
> false; 
> -	/* start tuning */
> -	radio->registers[CHANNEL] &= ~CHANNEL_CHAN;
> -	radio->registers[CHANNEL] |= CHANNEL_TUNE | chan;
> -	retval = si470x_set_register(radio, CHANNEL);
> -	if (retval < 0)
> -		goto done;
> +	retval = si470x_get_register(radio, POWERCFG);
> +	if (retval)
> +		return retval;
>  
> -	/* wait till tune operation has completed */
> -	reinit_completion(&radio->completion);
> -	time_left = wait_for_completion_timeout(&radio->completion,
> -
> msecs_to_jiffies(tune_timeout));
> -	if (time_left == 0)
> -		timed_out = true;
> +	if ( (radio->registers[POWERCFG] & POWERCFG_ENABLE) && 
> +		(radio->registers[POWERCFG] & POWERCFG_DMUTE) ) { 
>  

Just do:

	if (radio->registers[POWERCFG] & POWERCFG_ENABLE) & (POWERCFG_ENABLE | POWERCFG_DMUTE) !=
	    POWERCFG_ENABLE | POWERCFG_DMUTE)
		return 0;

And the remainder of the code can be indented one tab to the left. It's easier to read
and the diff is also smaller.

Regards,

	Hans

> -	if ((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0)
> -		dev_warn(&radio->videodev.dev, "tune does not
> complete\n");
> -	if (timed_out)
> -		dev_warn(&radio->videodev.dev,
> -			"tune timed out after %u ms\n", tune_timeout);
> +		/* start tuning */
> +		radio->registers[CHANNEL] &= ~CHANNEL_CHAN;
> +		radio->registers[CHANNEL] |= CHANNEL_TUNE | chan;
> +		retval = si470x_set_register(radio, CHANNEL);
> +		if (retval < 0)
> +			goto done;
>  
> -	/* stop tuning */
> -	radio->registers[CHANNEL] &= ~CHANNEL_TUNE;
> -	retval = si470x_set_register(radio, CHANNEL);
> +		/* wait till tune operation has completed */
> +		reinit_completion(&radio->completion);
> +		time_left =
> wait_for_completion_timeout(&radio->completion,
> +
> msecs_to_jiffies(tune_timeout));
> +		if (time_left == 0)
> +			timed_out = true;
> +	
> +		if ((radio->registers[STATUSRSSI] & STATUSRSSI_STC) ==
> 0)
> +			dev_warn(&radio->videodev.dev, "tune does not
> complete\n");
> +		if (timed_out)
> +			dev_warn(&radio->videodev.dev,
> +				"tune timed out after %u ms\n",
> tune_timeout);
> +	
> +		/* stop tuning */
> +		radio->registers[CHANNEL] &= ~CHANNEL_TUNE;
> +		retval = si470x_set_register(radio, CHANNEL);
> +	}
>  
>  done:
>  	return retval;
> 
