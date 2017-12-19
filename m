Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40102 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751198AbdLSPnR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 10:43:17 -0500
Date: Tue, 19 Dec 2017 17:43:13 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>, mchehab@s-opensource.com,
        laurent.pinchart@ideasonboard.com, ivo.g.dimitrov.75@gmail.com,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org, niklas.soderlund@ragnatech.se
Subject: Re: [PATCH] media: add operation to get configuration of "the other
 side" of the link
Message-ID: <20171219154313.6dn3fauij7iw7rev@valkosipuli.retiisi.org.uk>
References: <20161224152031.GA8420@amd>
 <20170203123508.GA10286@amd>
 <20170203130740.GB12291@valkosipuli.retiisi.org.uk>
 <20170203210610.GA18379@amd>
 <20170203213454.GD12291@valkosipuli.retiisi.org.uk>
 <20170204215610.GA9243@amd>
 <20170204223350.GF12291@valkosipuli.retiisi.org.uk>
 <20170205211219.GA27072@amd>
 <20170205234011.nyttcpurodvoztor@earth>
 <20170206093748.GA17017@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170206093748.GA17017@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Mon, Feb 06, 2017 at 10:37:48AM +0100, Pavel Machek wrote:
> 
> Normally, link configuration can be determined at probe time... but
> Nokia N900 has two cameras, and can switch between them at runtime, so
> that mechanism is not suitable here.
> 
> Add a hook that tells us link configuration.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index cf778c5..74148b9 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -25,6 +25,7 @@
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-fh.h>
>  #include <media/v4l2-mediabus.h>
> +#include <media/v4l2-of.h>
>  
>  /* generic v4l2_device notify callback notification values */
>  #define V4L2_SUBDEV_IR_RX_NOTIFY		_IOW('v', 0, u32)
> @@ -383,6 +384,8 @@ struct v4l2_mbus_frame_desc {
>   * @s_rx_buffer: set a host allocated memory buffer for the subdev. The subdev
>   *	can adjust @size to a lower value and must not write more data to the
>   *	buffer starting at @data than the original value of @size.
> + *
> + * @g_endpoint_config: get link configuration required by this device.
>   */
>  struct v4l2_subdev_video_ops {
>  	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 config);
> @@ -415,6 +418,8 @@ struct v4l2_subdev_video_ops {
>  			     const struct v4l2_mbus_config *cfg);
>  	int (*s_rx_buffer)(struct v4l2_subdev *sd, void *buf,
>  			   unsigned int *size);
> +	int (*g_endpoint_config)(struct v4l2_subdev *sd,
> +			    struct v4l2_of_endpoint *cfg);
>  };
>  
>  /**
> 
> 
> 
> 

I think Laurent has a board that has a similar issue.

I'd like to address such issues in conjunction with the CSI-2 virtual
channel and data type support, with the patches in the vc branch here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=vc>

V4L2 OF (or fwnode) endpoint alone doesn't contain all the related
information, and it'd be nice if the solution was indeed independent of OF
(or fwnode).

Niklas has been working on more driver support for this so we're getting
closer to having these merged.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
