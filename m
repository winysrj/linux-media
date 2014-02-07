Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43906 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752339AbaBGPEy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Feb 2014 10:04:54 -0500
Date: Fri, 7 Feb 2014 17:04:17 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH v3] v4l2-subdev: Allow 32-bit compat ioctls
Message-ID: <20140207150417.GN15635@valkosipuli.retiisi.org.uk>
References: <52F4E95A.7000301@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F4E95A.7000301@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the update.

On Fri, Feb 07, 2014 at 03:10:34PM +0100, Hans Verkuil wrote:
...
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index d67210a..84b7cce 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -162,6 +162,9 @@ struct v4l2_subdev_core_ops {
>  	int (*g_std)(struct v4l2_subdev *sd, v4l2_std_id *norm);
>  	int (*s_std)(struct v4l2_subdev *sd, v4l2_std_id norm);
>  	long (*ioctl)(struct v4l2_subdev *sd, unsigned int cmd, void *arg);
> +#ifdef CONFIG_COMPAT
> +	long (*compat_ioctl32)(struct v4l2_subdev *sd, unsigned int cmd, unsigned long arg);

I'd wrap this. I can understanding not wrapping lines in IOCTL definitions
but I see much less reason to do so here.

> +#endif
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>  	int (*g_register)(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg);
>  	int (*s_register)(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg);

Tested-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
