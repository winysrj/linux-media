Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38230 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754146Ab3LDARA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Dec 2013 19:17:00 -0500
Date: Wed, 4 Dec 2013 02:16:21 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Daniel Jeong <gshark.jeong@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-media@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH -next] [media] media: i2c: lm3560: fix missing unlock
 error in lm3560_get_ctrl().
Message-ID: <20131204001621.GC30652@valkosipuli.retiisi.org.uk>
References: <1384400607-18504-1-git-send-email-gshark.jeong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384400607-18504-1-git-send-email-gshark.jeong@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

Thanks for the patch. (Dropping LKML; this isn't relevant there.)

On Thu, Nov 14, 2013 at 12:43:27PM +0900, Daniel Jeong wrote:
> Add the missing unlock before return from function lm3560_get_ctrl()
> to avoid deadlock. Thanks to Dan Carpenter.
> 
> Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
> ---
>  drivers/media/i2c/lm3560.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/i2c/lm3560.c b/drivers/media/i2c/lm3560.c
> index 3317a9a..5d6eef0 100644
> --- a/drivers/media/i2c/lm3560.c
> +++ b/drivers/media/i2c/lm3560.c
> @@ -172,16 +172,16 @@ static int lm3560_flash_brt_ctrl(struct lm3560_flash *flash,
>  static int lm3560_get_ctrl(struct v4l2_ctrl *ctrl, enum lm3560_led_id led_no)
>  {
>  	struct lm3560_flash *flash = to_lm3560_flash(ctrl, led_no);
> +	int rval = -EINVAL;
>  
>  	mutex_lock(&flash->lock);
>  
>  	if (ctrl->id == V4L2_CID_FLASH_FAULT) {
> -		int rval;
>  		s32 fault = 0;
>  		unsigned int reg_val;
>  		rval = regmap_read(flash->regmap, REG_FLAG, &reg_val);
>  		if (rval < 0)
> -			return rval;
> +			goto out;
>  		if (rval & FAULT_SHORT_CIRCUIT)
>  			fault |= V4L2_FLASH_FAULT_SHORT_CIRCUIT;
>  		if (rval & FAULT_OVERTEMP)
> @@ -189,11 +189,11 @@ static int lm3560_get_ctrl(struct v4l2_ctrl *ctrl, enum lm3560_led_id led_no)
>  		if (rval & FAULT_TIMEOUT)
>  			fault |= V4L2_FLASH_FAULT_TIMEOUT;
>  		ctrl->cur.val = fault;
> -		return 0;
>  	}
>  
> +out:
>  	mutex_unlock(&flash->lock);
> -	return -EINVAL;
> +	return rval;
>  }
>  
>  static int lm3560_set_ctrl(struct v4l2_ctrl *ctrl, enum lm3560_led_id led_no)

The patch itself looks fine, but have you actually tested rading any fault
codes? Hint: regmap_read() returns zero on success. Yeah, I know... fault
codes can be a pain to test, and I, too, missed this on the first review
round.

I can take the patch to my tree and send a pull req if that's fine for you.
I case you also intend to write another, I'll take both at the same time.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
