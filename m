Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:50540 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754073AbeDPK4O (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 06:56:14 -0400
Date: Mon, 16 Apr 2018 13:56:11 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v2 03/10] media: ov772x: create subdevice device node
Message-ID: <20180416105610.2lgmkqqlkicr2l27@paasikivi.fi.intel.com>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
 <1523847111-12986-4-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1523847111-12986-4-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akinobu,

On Mon, Apr 16, 2018 at 11:51:44AM +0900, Akinobu Mita wrote:
> Set the V4L2_SUBDEV_FL_HAS_DEVNODE flag for the subdevice so that the
> subdevice device node is created.
> 
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> * v2
> - No changes
> 
>  drivers/media/i2c/ov772x.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> index 8badd6f..188f2f1 100644
> --- a/drivers/media/i2c/ov772x.c
> +++ b/drivers/media/i2c/ov772x.c
> @@ -1287,6 +1287,7 @@ static int ov772x_probe(struct i2c_client *client,
>  	priv->info = client->dev.platform_data;
>  
>  	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
> +	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;

Could you move this patch as the last in the set, so that you're enabling
the sub-device interface only when all the changes to support it are
actually there?

>  	v4l2_ctrl_handler_init(&priv->hdl, 3);
>  	v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
>  			  V4L2_CID_VFLIP, 0, 1, 1, 0);

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
