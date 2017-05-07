Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:51340 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752954AbdEGV4a (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 7 May 2017 17:56:30 -0400
Date: Sun, 7 May 2017 08:52:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Gideon Sheril <elmocia@gmail.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        rvarsha016@gmail.com, julia.lawall@lip6.fr, alan@linux.intel.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix spaces ERROR in atomisp_gmin_platform.c
Message-ID: <20170507055240.562dz4hzjllicto7@mwanda>
References: <20170506020952.wzfx2wefmwzxja3d@mwanda>
 <1494075383-8682-1-git-send-email-elmocia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1494075383-8682-1-git-send-email-elmocia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 06, 2017 at 03:56:23PM +0300, Gideon Sheril wrote:
>  int atomisp_register_i2c_module(struct v4l2_subdev *subdev,
> -                                struct camera_sensor_platform_data *plat_data,
> -                                enum intel_v4l2_subdev_type type)
> +	struct camera_sensor_platform_data *plat_data,
> +	enum intel_v4l2_subdev_type type)

It was aligned properly before, it just used spaces instead of tabs.

> +		dev_info(&client->dev,
> +			"camera pdata: port: %d lanes: %d order: %8.8x\n",
> +			port, lanes, bayer_order);

This introduces a checkpatch.pl warning.  Do it like this:

[tab][tab][tab][space]"camera pdata: port: %d lanes: %d order: %8.8x\n",

regards,
dan carpenter
