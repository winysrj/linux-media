Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57320 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751351AbdEDVzw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 May 2017 17:55:52 -0400
Date: Fri, 5 May 2017 00:55:48 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>, kernel@pengutronix.de
Subject: Re: [PATCH] [media] imx: switch from V4L2 OF to V4L2 fwnode API
Message-ID: <20170504215548.GD7456@valkosipuli.retiisi.org.uk>
References: <20170504133730.19934-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170504133730.19934-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thanks for the patch!

On Thu, May 04, 2017 at 03:37:30PM +0200, Philipp Zabel wrote:
...
> @@ -194,11 +195,11 @@ static int imx_media_subdev_bound(struct v4l2_async_notifier *notifier,
>  				  struct v4l2_async_subdev *asd)
>  {
>  	struct imx_media_dev *imxmd = notifier2dev(notifier);
> +	struct device_node *np = to_of_node(dev_fwnode(sd->dev));

dev_fwnode(sd->dev) isn't necessarily the same as sd->fwnode. How about
to_of_node(sd->fwnode) instead?

I realised I had left both v4l2_subdev->of_node and v4l2_subdev->fwnode;
v4l2_subdev->of_node is unused. I'll remove it.

The other changes seem good to me.

>  	struct imx_media_subdev *imxsd;
>  	int ret = -EINVAL;
>  
> -	imxsd = imx_media_find_async_subdev(imxmd, sd->of_node,
> -					    dev_name(sd->dev));
> +	imxsd = imx_media_find_async_subdev(imxmd, np, dev_name(sd->dev));
>  	if (!imxsd)
>  		goto out;
>  

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
