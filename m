Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39264 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753916AbdEQTVg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 15:21:36 -0400
Date: Wed, 17 May 2017 22:20:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kieran Bingham <kbingham@kernel.org>
Cc: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        geert@glider.be, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v3.1 1/2] v4l: subdev: tolerate null in
 media_entity_to_v4l2_subdev
Message-ID: <20170517192057.GT3227@valkosipuli.retiisi.org.uk>
References: <cover.ed561929790222fc2c4467d4e57072a8e4ba69f3.1495035409.git-series.kieran.bingham+renesas@ideasonboard.com>
 <38adea84b864609515b2db580a76954b1a114e3f.1495035409.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38adea84b864609515b2db580a76954b1a114e3f.1495035409.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Wed, May 17, 2017 at 04:38:14PM +0100, Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> Return NULL, if a null entity is parsed for it's v4l2_subdev
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  include/media/v4l2-subdev.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 5f1669c45642..72d7f28f38dc 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -829,7 +829,7 @@ struct v4l2_subdev {
>  };
>  
>  #define media_entity_to_v4l2_subdev(ent) \
> -	container_of(ent, struct v4l2_subdev, entity)
> +	(ent ? container_of(ent, struct v4l2_subdev, entity) : NULL)
>  #define vdev_to_v4l2_subdev(vdev) \
>  	((struct v4l2_subdev *)video_get_drvdata(vdev))
>  

The problem with this is that ent is now referenced twice. If the ent macro
argument has side effect, this would introduce bugs. It's unlikely, but
worth avoiding. Either use a macro or a function.

I think I'd use function for there's little use for supporting for const and
non-const arguments presumably. A simple static inline function should do.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
