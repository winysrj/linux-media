Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35329 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751664AbdFNVOa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 17:14:30 -0400
Subject: Re: [PATCH 4/8] v4l2-flash: Use led_classdev instead of
 led_classdev_flash for indicator
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497433639-13101-5-git-send-email-sakari.ailus@linux.intel.com>
Cc: devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org, pavel@ucw.cz
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <08d56c9c-1afd-e613-3c1c-d6430ece4114@gmail.com>
Date: Wed, 14 Jun 2017 23:13:43 +0200
MIME-Version: 1.0
In-Reply-To: <1497433639-13101-5-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 06/14/2017 11:47 AM, Sakari Ailus wrote:
> The V4L2 flash class initialisation expects struct led_classdev_flash that
> describes an indicator but only uses struct led_classdev which is a field
> iled_cdev in the struct. Use struct iled_cdev only.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/v4l2-flash-led-class.c | 19 +++++++------------
>  include/media/v4l2-flash-led-class.h           |  6 +++---
>  2 files changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-flash-led-class.c b/drivers/media/v4l2-core/v4l2-flash-led-class.c
> index 7b82881..6d69119 100644
> --- a/drivers/media/v4l2-core/v4l2-flash-led-class.c
> +++ b/drivers/media/v4l2-core/v4l2-flash-led-class.c
> @@ -110,7 +110,7 @@ static void v4l2_flash_set_led_brightness(struct v4l2_flash *v4l2_flash,
>  		led_set_brightness_sync(&v4l2_flash->fled_cdev->led_cdev,
>  					brightness);
>  	} else {
> -		led_set_brightness_sync(&v4l2_flash->iled_cdev->led_cdev,
> +		led_set_brightness_sync(v4l2_flash->iled_cdev,
>  					brightness);
>  	}
>  }
> @@ -133,7 +133,7 @@ static int v4l2_flash_update_led_brightness(struct v4l2_flash *v4l2_flash,
>  			return 0;
>  		led_cdev = &v4l2_flash->fled_cdev->led_cdev;
>  	} else {
> -		led_cdev = &v4l2_flash->iled_cdev->led_cdev;
> +		led_cdev = v4l2_flash->iled_cdev;
>  	}
>  
>  	ret = led_update_brightness(led_cdev);
> @@ -529,8 +529,7 @@ static int v4l2_flash_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>  	struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
>  	struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev;
>  	struct led_classdev *led_cdev = &fled_cdev->led_cdev;
> -	struct led_classdev_flash *iled_cdev = v4l2_flash->iled_cdev;
> -	struct led_classdev *led_cdev_ind = NULL;
> +	struct led_classdev *led_cdev_ind = v4l2_flash->iled_cdev;
>  	int ret = 0;
>  
>  	if (!v4l2_fh_is_singular(&fh->vfh))
> @@ -543,9 +542,7 @@ static int v4l2_flash_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>  
>  	mutex_unlock(&led_cdev->led_access);
>  
> -	if (iled_cdev) {
> -		led_cdev_ind = &iled_cdev->led_cdev;
> -
> +	if (led_cdev_ind) {
>  		mutex_lock(&led_cdev_ind->led_access);
>  
>  		led_sysfs_disable(led_cdev_ind);
> @@ -578,7 +575,7 @@ static int v4l2_flash_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>  	struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
>  	struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev;
>  	struct led_classdev *led_cdev = &fled_cdev->led_cdev;
> -	struct led_classdev_flash *iled_cdev = v4l2_flash->iled_cdev;
> +	struct led_classdev *led_cdev_ind = v4l2_flash->iled_cdev;
>  	int ret = 0;
>  
>  	if (!v4l2_fh_is_singular(&fh->vfh))
> @@ -593,9 +590,7 @@ static int v4l2_flash_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>  
>  	mutex_unlock(&led_cdev->led_access);
>  
> -	if (iled_cdev) {
> -		struct led_classdev *led_cdev_ind = &iled_cdev->led_cdev;
> -
> +	if (led_cdev_ind) {
>  		mutex_lock(&led_cdev_ind->led_access);
>  		led_sysfs_enable(led_cdev_ind);
>  		mutex_unlock(&led_cdev_ind->led_access);
> @@ -614,7 +609,7 @@ static const struct v4l2_subdev_ops v4l2_flash_subdev_ops;
>  struct v4l2_flash *v4l2_flash_init(
>  	struct device *dev, struct fwnode_handle *fwn,
>  	struct led_classdev_flash *fled_cdev,
> -	struct led_classdev_flash *iled_cdev,
> +	struct led_classdev *iled_cdev,
>  	const struct v4l2_flash_ops *ops,
>  	struct v4l2_flash_config *config)
>  {
> diff --git a/include/media/v4l2-flash-led-class.h b/include/media/v4l2-flash-led-class.h
> index f9dcd54..54e31a8 100644
> --- a/include/media/v4l2-flash-led-class.h
> +++ b/include/media/v4l2-flash-led-class.h
> @@ -85,7 +85,7 @@ struct v4l2_flash_config {
>   */
>  struct v4l2_flash {
>  	struct led_classdev_flash *fled_cdev;
> -	struct led_classdev_flash *iled_cdev;
> +	struct led_classdev *iled_cdev;
>  	const struct v4l2_flash_ops *ops;
>  
>  	struct v4l2_subdev sd;
> @@ -124,7 +124,7 @@ static inline struct v4l2_flash *v4l2_ctrl_to_v4l2_flash(struct v4l2_ctrl *c)
>  struct v4l2_flash *v4l2_flash_init(
>  	struct device *dev, struct fwnode_handle *fwn,
>  	struct led_classdev_flash *fled_cdev,
> -	struct led_classdev_flash *iled_cdev,
> +	struct led_classdev *iled_cdev,
>  	const struct v4l2_flash_ops *ops,
>  	struct v4l2_flash_config *config);
>  
> @@ -140,7 +140,7 @@ void v4l2_flash_release(struct v4l2_flash *v4l2_flash);
>  static inline struct v4l2_flash *v4l2_flash_init(
>  	struct device *dev, struct fwnode_handle *fwn,
>  	struct led_classdev_flash *fled_cdev,
> -	struct led_classdev_flash *iled_cdev,
> +	struct led_classdev *iled_cdev,
>  	const struct v4l2_flash_ops *ops,
>  	struct v4l2_flash_config *config)
>  {
> 

Reviewed-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>

-- 
Best regards,
Jacek Anaszewski
