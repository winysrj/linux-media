Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47912 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751190Ab3EPWf0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 May 2013 18:35:26 -0400
Date: Fri, 17 May 2013 01:34:51 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com
Subject: Re: [PATCH RFC v3 2/3] media: added managed v4l2 control
 initialization
Message-ID: <20130516223451.GA2077@valkosipuli.retiisi.org.uk>
References: <1368692074-483-1-git-send-email-a.hajda@samsung.com>
 <1368692074-483-3-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368692074-483-3-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

Thanks for the patchset!

On Thu, May 16, 2013 at 10:14:33AM +0200, Andrzej Hajda wrote:
> This patch adds managed version of initialization
> function for v4l2 control handler.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> v3:
> 	- removed managed cleanup
> v2:
> 	- added missing struct device forward declaration,
> 	- corrected few comments
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c |   32 ++++++++++++++++++++++++++++++++
>  include/media/v4l2-ctrls.h           |   16 ++++++++++++++++
>  2 files changed, 48 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index ebb8e48..f47ccfa 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1421,6 +1421,38 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
>  }
>  EXPORT_SYMBOL(v4l2_ctrl_handler_free);
>  
> +static void devm_v4l2_ctrl_handler_release(struct device *dev, void *res)
> +{
> +	struct v4l2_ctrl_handler **hdl = res;
> +
> +	v4l2_ctrl_handler_free(*hdl);

v4l2_ctrl_handler_free() acquires hdl->mutex which is independent of the
existence of hdl. By default hdl->lock is in the handler, but it may also be
elsewhere, e.g. in a driver-specific device struct such as struct
smiapp_sensor defined in drivers/media/i2c/smiapp/smiapp.h. I wonder if
anything guarantees that hdl->mutex still exists at the time the device is
removed.

I have to say I don't think it's neither meaningful to acquire that mutex in
v4l2_ctrl_handler_free(), though, since the whole going to be freed next
anyway: reference counting would be needed to prevent bad things from
happening, in case the drivers wouldn't take care of that.

> +}
> +

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
