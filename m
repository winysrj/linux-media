Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51320 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751448AbeBSH0N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 02:26:13 -0500
Date: Mon, 19 Feb 2018 10:25:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Quytelda Kahja <quytelda@tamalin.org>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, hans.verkuil@cisco.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] Staging: bcm2048: Fix function argument alignment in
 radio-bcm2048.c.
Message-ID: <20180219072550.hz4vpomsaz2ajrnm@mwanda>
References: <20180219004446.28771-1-quytelda@tamalin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180219004446.28771-1-quytelda@tamalin.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 18, 2018 at 04:44:46PM -0800, Quytelda Kahja wrote:
> Fix a coding style problem.
> 
> Signed-off-by: Quytelda Kahja <quytelda@tamalin.org>
> ---
>  drivers/staging/media/bcm2048/radio-bcm2048.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
> index 06d1920150da..94141a11e51b 100644
> --- a/drivers/staging/media/bcm2048/radio-bcm2048.c
> +++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
> @@ -1846,6 +1846,7 @@ static int bcm2048_deinit(struct bcm2048_device *bdev)
>  static int bcm2048_probe(struct bcm2048_device *bdev)
>  {
>  	int err;
> +	u8 default_threshold = BCM2048_DEFAULT_RSSI_THRESHOLD;
>  
>  	err = bcm2048_set_power_state(bdev, BCM2048_POWER_ON);
>  	if (err < 0)
> @@ -1863,8 +1864,7 @@ static int bcm2048_probe(struct bcm2048_device *bdev)
>  	if (err < 0)
>  		goto unlock;
>  
> -	err = bcm2048_set_fm_search_rssi_threshold(bdev,
> -					BCM2048_DEFAULT_RSSI_THRESHOLD);
> +	err = bcm2048_set_fm_search_rssi_threshold(bdev, default_threshold);

Nah.  Don't do this.

There were some of your earlier patches where I thought:

	gdm->tty_dev->send_func(...

Could be shortened to:

	tty->send_func(...

So sometimes introducing shorter aliases is the right thing.  But here
it just makes it look like a variable when it's a constant.  It's makes
the code slightly less readable.

Just ignore the warning.

regards,
dan carpenter
