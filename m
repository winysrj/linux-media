Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58092 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbbERKwe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 06:52:34 -0400
Date: Mon, 18 May 2015 12:52:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jan Roemisch <maxx@spaceboyz.net>
Cc: Greg KH <gregkh@linuxfoundation.org>, pali.rohar@gmail.com,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] radio-bcm2048: Fix region selection
Message-ID: <20150518105232.GA15632@amd>
References: <20150516112227.GA10069@spaceboyz.net>
 <20150516140617.GA12433@kroah.com>
 <20150516152049.GB6140@turing.il.maxx.spaceboyz.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150516152049.GB6140@turing.il.maxx.spaceboyz.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat 2015-05-16 17:20:50, Jan Roemisch wrote:
> Removed "Japan wide band" region since this is impossible to do just
> like that. Additionally it's now possible to go back to non-Japanese regions
> without having to reload the module.

Acked-by: Pavel Machek <pavel@ucw.cz>

But note that you'll probably need to do one more resend, with

Signed-off-by:

line.

Thanks and best regards,
									Pavel

> Greetings
> Jan Roemisch
> 
> On Sat, May 16, 2015 at 07:06:17AM -0700, Greg KH wrote:
> > On Sat, May 16, 2015 at 01:22:27PM +0200, Jan Roemisch wrote:
> > > Oh sorry, the real name is Jan Roemisch.
> > 
> > Ok, thanks, can someone please fix up the patches and resend them?
> > 
> > greg k-h
> > 

> diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
> index 5382506..d2e7f1e 100644
> --- a/drivers/staging/media/bcm2048/radio-bcm2048.c
> +++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
> @@ -342,14 +342,6 @@ static struct region_info region_configs[] = {
>  		.deemphasis		= 50,
>  		.region			= 3,
>  	},
> -	/* Japan wide band */
> -	{
> -		.channel_spacing	= 10,
> -		.bottom_frequency	= 76000,
> -		.top_frequency		= 108000,
> -		.deemphasis		= 50,
> -		.region			= 4,
> -	},
>  };
>  
>  /*
> @@ -741,6 +733,18 @@ static int bcm2048_set_region(struct bcm2048_device *bdev, u8 region)
>  
>  	mutex_lock(&bdev->mutex);
>  	bdev->region_info = region_configs[region];
> +
> +	if (region_configs[region].bottom_frequency < 87500)
> +		bdev->cache_fm_ctrl |= BCM2048_BAND_SELECT;
> +	else
> +		bdev->cache_fm_ctrl &= ~BCM2048_BAND_SELECT;
> +
> +	err = bcm2048_send_command(bdev, BCM2048_I2C_FM_CTRL,
> +					bdev->cache_fm_ctrl);
> +	if (err) {
> +		mutex_unlock(&bdev->mutex);
> +		goto done;
> +	}
>  	mutex_unlock(&bdev->mutex);
>  
>  	if (bdev->frequency < region_configs[region].bottom_frequency ||


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
