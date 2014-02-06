Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40061 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752315AbaBFRd2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Feb 2014 12:33:28 -0500
Date: Thu, 6 Feb 2014 19:33:23 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 06/47] v4l: Add pad-level DV timings subdev operations
Message-ID: <20140206173323.GJ15635@valkosipuli.retiisi.org.uk>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1391618558-5580-7-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391618558-5580-7-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Feb 05, 2014 at 05:41:57PM +0100, Laurent Pinchart wrote:
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  include/media/v4l2-subdev.h    | 4 ++++
>  include/uapi/linux/videodev2.h | 8 ++++++--
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index d67210a..2c7355a 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -505,6 +505,10 @@ struct v4l2_subdev_pad_ops {
>  			     struct v4l2_subdev_selection *sel);
>  	int (*get_edid)(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid);
>  	int (*set_edid)(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid);
> +	int (*dv_timings_cap)(struct v4l2_subdev *sd,
> +			      struct v4l2_dv_timings_cap *cap);
> +	int (*enum_dv_timings)(struct v4l2_subdev *sd,
> +			       struct v4l2_enum_dv_timings *timings);

Do you think there would be use for these in the user space API? The
argument structs are defined in the user space header. The driver does also
export a sub-device node.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
