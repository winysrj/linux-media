Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54324 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752187AbaE0N33 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 May 2014 09:29:29 -0400
Date: Tue, 27 May 2014 16:29:25 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: vsp1: sru: Handle control handler initialization
 errors
Message-ID: <20140527132925.GA2073@valkosipuli.retiisi.org.uk>
References: <1401144409-13217-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401144409-13217-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 27, 2014 at 12:46:49AM +0200, Laurent Pinchart wrote:
> Bail out when the SRU control handler fails to initialize.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_sru.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
> index aa0e04c..79efcaf 100644
> --- a/drivers/media/platform/vsp1/vsp1_sru.c
> +++ b/drivers/media/platform/vsp1/vsp1_sru.c
> @@ -348,6 +348,14 @@ struct vsp1_sru *vsp1_sru_create(struct vsp1_device *vsp1)
>  	/* Initialize the control handler. */
>  	v4l2_ctrl_handler_init(&sru->ctrls, 1);
>  	v4l2_ctrl_new_custom(&sru->ctrls, &sru_intensity_control, NULL);
> +
> +	if (sru->ctrls.error) {
> +		dev_err(vsp1->dev, "sru: failed to initialize controls\n");
> +		ret = sru->ctrls.error;
> +		v4l2_ctrl_handler_free(&sru->ctrls);
> +		return ERR_PTR(ret);
> +	}
> +
>  	v4l2_ctrl_handler_setup(&sru->ctrls);
>  	sru->entity.subdev.ctrl_handler = &sru->ctrls;
>  

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
