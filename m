Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E9D6C43444
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 23:53:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40B2420866
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 23:53:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="E70gQbub"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728509AbfAOXxE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 18:53:04 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:49406 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728310AbfAOXxE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 18:53:04 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 42E0D530;
        Wed, 16 Jan 2019 00:53:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547596382;
        bh=dpCm7UcMQfT0/TwJjkKoTrRlSb4xNHCBIvc4YN2+8ZI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E70gQbubKRyxSWIfFmPU3NUYhCax3Xd5dsKGP5LfeTExLbWRitYHLIiwJq/PoFjpD
         b52FmVO/5pGyrYb559fumIgIyVUmEFsUfhuziBgqpljfuFmqGQjxZKI/bZw8lF3OPl
         ZGzUqP9G7c8Q8GEi1jBQdb8TrJYzJonCSzybhVAk=
Date:   Wed, 16 Jan 2019 01:53:03 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 17/30] v4l: subdev: compat: Implement handling for
 VIDIOC_SUBDEV_[GS]_ROUTING
Message-ID: <20190115235303.GG31088@pendragon.ideasonboard.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-18-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181101233144.31507-18-niklas.soderlund+renesas@ragnatech.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Fri, Nov 02, 2018 at 12:31:31AM +0100, Niklas Söderlund wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Implement compat IOCTL handling for VIDIOC_SUBDEV_G_ROUTING and
> VIDIOC_SUBDEV_S_ROUTING IOCTLs.

Let's instead design the ioctl in a way that doesn't require compat
handling.

> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 77 +++++++++++++++++++
>  1 file changed, 77 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index 6481212fda772c73..83af332763f41a6b 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -1045,6 +1045,66 @@ static int put_v4l2_event32(struct v4l2_event __user *p64,
>  	return 0;
>  }
>  
> +struct v4l2_subdev_routing32 {
> +	compat_caddr_t routes;
> +	__u32 num_routes;
> +	__u32 reserved[5];
> +};
> +
> +static int get_v4l2_subdev_routing(struct v4l2_subdev_routing __user *p64,
> +				   struct v4l2_subdev_routing32 __user *p32)
> +{
> +	struct v4l2_subdev_route __user *routes;
> +	compat_caddr_t p;
> +	u32 num_routes;
> +
> +	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)) ||
> +	    get_user(p, &p32->routes) ||
> +	    get_user(num_routes, &p32->num_routes) ||
> +	    put_user(num_routes, &p64->num_routes) ||
> +	    copy_in_user(&p64->reserved, &p32->reserved,
> +			 sizeof(p64->reserved)) ||
> +	    num_routes > U32_MAX / sizeof(*p64->routes))
> +		return -EFAULT;
> +
> +	routes = compat_ptr(p);
> +
> +	if (!access_ok(VERIFY_READ, routes,
> +		       num_routes * sizeof(*p64->routes)))
> +		return -EFAULT;
> +
> +	if (put_user((__force struct v4l2_subdev_route *)routes,
> +		     &p64->routes))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static int put_v4l2_subdev_routing(struct v4l2_subdev_routing __user *p64,
> +				   struct v4l2_subdev_routing32 __user *p32)
> +{
> +	struct v4l2_subdev_route __user *routes;
> +	compat_caddr_t p;
> +	u32 num_routes;
> +
> +	if (!access_ok(VERIFY_WRITE, p32, sizeof(*p32)) ||
> +	    get_user(p, &p32->routes) ||
> +	    get_user(num_routes, &p64->num_routes) ||
> +	    put_user(num_routes, &p32->num_routes) ||
> +	    copy_in_user(&p32->reserved, &p64->reserved,
> +			 sizeof(p64->reserved)) ||
> +	    num_routes > U32_MAX / sizeof(*p64->routes))
> +		return -EFAULT;
> +
> +	routes = compat_ptr(p);
> +
> +	if (!access_ok(VERIFY_WRITE, routes,
> +		       num_routes * sizeof(*p64->routes)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
>  struct v4l2_edid32 {
>  	__u32 pad;
>  	__u32 start_block;
> @@ -1117,6 +1177,8 @@ static int put_v4l2_edid32(struct v4l2_edid __user *p64,
>  #define VIDIOC_STREAMOFF32	_IOW ('V', 19, s32)
>  #define VIDIOC_G_INPUT32	_IOR ('V', 38, s32)
>  #define VIDIOC_S_INPUT32	_IOWR('V', 39, s32)
> +#define VIDIOC_SUBDEV_G_ROUTING32 _IOWR('V', 38, struct v4l2_subdev_routing32)
> +#define VIDIOC_SUBDEV_S_ROUTING32 _IOWR('V', 39, struct v4l2_subdev_routing32)
>  #define VIDIOC_G_OUTPUT32	_IOR ('V', 46, s32)
>  #define VIDIOC_S_OUTPUT32	_IOWR('V', 47, s32)
>  
> @@ -1195,6 +1257,8 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  	case VIDIOC_STREAMOFF32: cmd = VIDIOC_STREAMOFF; break;
>  	case VIDIOC_G_INPUT32: cmd = VIDIOC_G_INPUT; break;
>  	case VIDIOC_S_INPUT32: cmd = VIDIOC_S_INPUT; break;
> +	case VIDIOC_SUBDEV_G_ROUTING32: cmd = VIDIOC_SUBDEV_G_ROUTING; break;
> +	case VIDIOC_SUBDEV_S_ROUTING32: cmd = VIDIOC_SUBDEV_S_ROUTING; break;
>  	case VIDIOC_G_OUTPUT32: cmd = VIDIOC_G_OUTPUT; break;
>  	case VIDIOC_S_OUTPUT32: cmd = VIDIOC_S_OUTPUT; break;
>  	case VIDIOC_CREATE_BUFS32: cmd = VIDIOC_CREATE_BUFS; break;
> @@ -1227,6 +1291,15 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  		compatible_arg = 0;
>  		break;
>  
> +	case VIDIOC_SUBDEV_G_ROUTING:
> +	case VIDIOC_SUBDEV_S_ROUTING:
> +		err = alloc_userspace(sizeof(struct v4l2_subdev_routing),
> +				      0, &new_p64);
> +		if (!err)
> +			err = get_v4l2_subdev_routing(new_p64, p32);
> +		compatible_arg = 0;
> +		break;
> +
>  	case VIDIOC_G_EDID:
>  	case VIDIOC_S_EDID:
>  		err = alloc_userspace(sizeof(struct v4l2_edid), 0, &new_p64);
> @@ -1368,6 +1441,10 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  		if (put_v4l2_edid32(new_p64, p32))
>  			err = -EFAULT;
>  		break;
> +	case VIDIOC_SUBDEV_G_ROUTING:
> +	case VIDIOC_SUBDEV_S_ROUTING:
> +		err = put_v4l2_subdev_routing(new_p64, p32);
> +		break;
>  	}
>  	if (err)
>  		return err;

-- 
Regards,

Laurent Pinchart
