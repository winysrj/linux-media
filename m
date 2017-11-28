Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:57902 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751801AbdK1Jvm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 04:51:42 -0500
Date: Tue, 28 Nov 2017 10:51:39 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Riccardo Schirone <sirmy15@gmail.com>
Cc: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] staging: improves comparisons readability in
 atomisp-ov5693
Message-ID: <20171128095139.GD675@w540>
References: <20171127214413.10749-1-sirmy15@gmail.com>
 <20171127214413.10749-4-sirmy15@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20171127214413.10749-4-sirmy15@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Riccardo,
   thanks for the patch

On Mon, Nov 27, 2017 at 10:44:12PM +0100, Riccardo Schirone wrote:
> Fix "Comparisons should place the constant on the right side of the
> test" issue.
>
> Signed-off-by: Riccardo Schirone <sirmy15@gmail.com>
> ---
>  drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
> index ecd607b7b005..4eeb478ae84b 100644
> --- a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
> +++ b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
> @@ -764,7 +764,7 @@ static int __ov5693_otp_read(struct v4l2_subdev *sd, u8 *buf)
>  		//pr_debug("BANK[%2d] %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x\n", i, *b, *(b+1), *(b+2), *(b+3), *(b+4), *(b+5), *(b+6), *(b+7), *(b+8), *(b+9), *(b+10), *(b+11), *(b+12), *(b+13), *(b+14), *(b+15));
>
>  		//Intel OTP map, try to read 320byts first.
> -		if (21 == i) {
> +		if (i == 21) {
>  			if ((*b) == 0) {
>  				dev->otp_size = 320;
>  				break;
> @@ -772,7 +772,7 @@ static int __ov5693_otp_read(struct v4l2_subdev *sd, u8 *buf)
>  				b = buf;
>  				continue;
>  			}
> -		} else if (24 == i) {		//if the first 320bytes data doesn't not exist, try to read the next 32bytes data.
> +		} else if (i == 24) {		//if the first 320bytes data doesn't not exist, try to read the next 32bytes data.
>  			if ((*b) == 0) {
>  				dev->otp_size = 32;
>  				break;
> @@ -780,7 +780,7 @@ static int __ov5693_otp_read(struct v4l2_subdev *sd, u8 *buf)
>  				b = buf;
>  				continue;
>  			}
> -		} else if (27 == i) {		//if the prvious 32bytes data doesn't exist, try to read the next 32bytes data again.
> +		} else if (i == 27) {		//if the prvious 32bytes data doesn't exist, try to read the next 32bytes data again.

I wonder why checkpatch does not complain about these C++ style
comments clearly exceeding 80 columns...

>  			if ((*b) == 0) {
>  				dev->otp_size = 32;
>  				break;
> @@ -1351,7 +1351,7 @@ static int __power_up(struct v4l2_subdev *sd)
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	int ret;
>
> -	if (NULL == dev->platform_data) {
> +	if (!dev->platform_data) {

Please mention in changelog that you're also substituting a comparison to
NULL with this.

Checkpatch points this out, didn't it?

Thanks
   j

>  		dev_err(&client->dev,
>  			"no camera_sensor_platform_data");
>  		return -ENODEV;
> @@ -1399,7 +1399,7 @@ static int power_down(struct v4l2_subdev *sd)
>  	int ret = 0;
>
>  	dev->focus = OV5693_INVALID_CONFIG;
> -	if (NULL == dev->platform_data) {
> +	if (!dev->platform_data) {
>  		dev_err(&client->dev,
>  			"no camera_sensor_platform_data");
>  		return -ENODEV;
> --
> 2.14.3
>
