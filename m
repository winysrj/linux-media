Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50174 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932238AbaFCMcb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Jun 2014 08:32:31 -0400
Date: Tue, 3 Jun 2014 15:32:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/3] media-ctl: libv4l2subdev: Add DV timings support
Message-ID: <20140603123224.GI2073@valkosipuli.retiisi.org.uk>
References: <1401721804-30133-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1401721804-30133-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401721804-30133-2-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Jun 02, 2014 at 05:10:02PM +0200, Laurent Pinchart wrote:
> Expose the pad-level get caps, query, get and set DV timings ioctls.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  utils/media-ctl/libv4l2subdev.c | 72 +++++++++++++++++++++++++++++++++++++++++
>  utils/media-ctl/v4l2subdev.h    | 53 ++++++++++++++++++++++++++++++
>  2 files changed, 125 insertions(+)
> 
> diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
> index 14daffa..8015330 100644
> --- a/utils/media-ctl/libv4l2subdev.c
> +++ b/utils/media-ctl/libv4l2subdev.c
> @@ -189,6 +189,78 @@ int v4l2_subdev_set_selection(struct media_entity *entity,
>  	return 0;
>  }
>  
> +int v4l2_subdev_get_dv_timings_caps(struct media_entity *entity,
> +	struct v4l2_dv_timings_cap *caps)
> +{
> +	unsigned int pad = caps->pad;
> +	int ret;
> +
> +	ret = v4l2_subdev_open(entity);
> +	if (ret < 0)
> +		return ret;

In every function v4l2_subdev_open() is called before the ioctl command. How
about implementing a wrapper which does both, and using that before this
patch?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
