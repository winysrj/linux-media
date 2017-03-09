Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43598 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754135AbdCISUx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Mar 2017 13:20:53 -0500
Date: Thu, 9 Mar 2017 20:19:38 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        devicetree@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv3 03/15] ov7670: fix g/s_parm
Message-ID: <20170309181938.GP3220@valkosipuli.retiisi.org.uk>
References: <20170306145616.38485-1-hverkuil@xs4all.nl>
 <20170306145616.38485-4-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170306145616.38485-4-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Mar 06, 2017 at 03:56:04PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Drop unnecesary memset. Drop the unnecessary extendedmode check and
> set the V4L2_CAP_TIMEPERFRAME capability.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/i2c/ov7670.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> index 9af8d3b8f848..50e4466a2b37 100644
> --- a/drivers/media/i2c/ov7670.c
> +++ b/drivers/media/i2c/ov7670.c
> @@ -1046,7 +1046,6 @@ static int ov7670_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
>  	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
>  
> -	memset(cp, 0, sizeof(struct v4l2_captureparm));
>  	cp->capability = V4L2_CAP_TIMEPERFRAME;
>  	info->devtype->get_framerate(sd, &cp->timeperframe);
>  
> @@ -1061,9 +1060,8 @@ static int ov7670_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
>  
>  	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
> -	if (cp->extendedmode != 0)
> -		return -EINVAL;
>  
> +	cp->capability = V4L2_CAP_TIMEPERFRAME;
>  	return info->devtype->set_framerate(sd, tpf);
>  }
>  

We seem to have two ways to specify the frame interval for sub-devices,
with roughly roughly similar number of users. s_parm() originates from
drivers that typically work on plain V4L2 interfaces whereas
s_frame_interval() is from native sub-device drivers.

Anyway,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
