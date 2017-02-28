Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59202 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751435AbdB1VQp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 16:16:45 -0500
Date: Tue, 28 Feb 2017 23:13:34 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v2 3/3] v4l: vsp1: wpf: Implement rotation support
Message-ID: <20170228211334.GC3220@valkosipuli.retiisi.org.uk>
References: <20170228150320.10104-1-laurent.pinchart+renesas@ideasonboard.com>
 <20170228150320.10104-4-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170228150320.10104-4-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Feb 28, 2017 at 05:03:20PM +0200, Laurent Pinchart wrote:
> Some WPF instances, on Gen3 devices, can perform 90° rotation when
> writing frames to memory. Implement support for this using the
> V4L2_CID_ROTATE control.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_rpf.c   |   2 +-
>  drivers/media/platform/vsp1/vsp1_rwpf.c  |   5 +
>  drivers/media/platform/vsp1/vsp1_rwpf.h  |   3 +-
>  drivers/media/platform/vsp1/vsp1_video.c |  12 +-
>  drivers/media/platform/vsp1/vsp1_wpf.c   | 205 +++++++++++++++++++++++--------
>  5 files changed, 175 insertions(+), 52 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
> index f5a9a4c8c74d..8feddd59cf8d 100644
> --- a/drivers/media/platform/vsp1/vsp1_rpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_rpf.c
> @@ -106,7 +106,7 @@ static void rpf_configure(struct vsp1_entity *entity,
>  			 * of the pipeline.
>  			 */
>  			output = vsp1_entity_get_pad_format(wpf, wpf->config,
> -							    RWPF_PAD_SOURCE);
> +							    RWPF_PAD_SINK);
>  
>  			crop.width = pipe->partition.width * input_width
>  				   / output->width;
> diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
> index 7d52c88a583e..cfd8f1904fa6 100644
> --- a/drivers/media/platform/vsp1/vsp1_rwpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
> @@ -121,6 +121,11 @@ static int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
>  					    RWPF_PAD_SOURCE);
>  	*format = fmt->format;
>  
> +	if (rwpf->flip.rotate) {
> +		format->width = fmt->format.height;
> +		format->height = fmt->format.width;
> +	}
> +
>  done:
>  	mutex_unlock(&rwpf->entity.lock);
>  	return ret;
> diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
> index 1c98aff3da5d..b4ffc38f48af 100644
> --- a/drivers/media/platform/vsp1/vsp1_rwpf.h
> +++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
> @@ -56,9 +56,10 @@ struct vsp1_rwpf {
>  
>  	struct {
>  		spinlock_t lock;
> -		struct v4l2_ctrl *ctrls[2];
> +		struct v4l2_ctrl *ctrls[3];

At least what comes to this patch --- having a field for each control would
look much nicer in the code. Is there a particular reason for having an
array with all the controls in it?

>  		unsigned int pending;
>  		unsigned int active;
> +		bool rotate;
>  	} flip;
>  
>  	struct vsp1_rwpf_memory mem;

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
