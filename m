Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24994 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750792AbdEFCKO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 May 2017 22:10:14 -0400
Date: Sat, 6 May 2017 05:09:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Gideon Sheril <elmocia@gmail.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        rvarsha016@gmail.com, julia.lawall@lip6.fr, alan@linux.intel.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/media/atomisp/platform/intel-mid change spaces
 to tabs and comma/assignment space padding
Message-ID: <20170506020952.wzfx2wefmwzxja3d@mwanda>
References: <1494032690-12302-1-git-send-email-elmocia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1494032690-12302-1-git-send-email-elmocia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Subject is too long.

On Sat, May 06, 2017 at 04:04:50AM +0300, Gideon Sheril wrote:
>  /* The atomisp uses type==0 for the end-of-list marker, so leave space. */
> @@ -152,13 +152,13 @@ const struct camera_af_platform_data *camera_get_af_platform_data(void)
>  EXPORT_SYMBOL_GPL(camera_get_af_platform_data);
>  
>  int atomisp_register_i2c_module(struct v4l2_subdev *subdev,
> -                                struct camera_sensor_platform_data *plat_data,
> -                                enum intel_v4l2_subdev_type type)
> +								struct camera_sensor_platform_data *plat_data,
> +								enum intel_v4l2_subdev_type type)

Huh???

>  {
>  	int i;
>  	struct i2c_board_info *bi;
>  	struct gmin_subdev *gs;
> -        struct i2c_client *client = v4l2_get_subdevdata(subdev);
> +		struct i2c_client *client = v4l2_get_subdevdata(subdev);


Wut?  How would this be correct?

regards,
dan carpenter
