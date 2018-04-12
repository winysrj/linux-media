Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57368 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752396AbeDLNfx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 09:35:53 -0400
Date: Thu, 12 Apr 2018 16:35:51 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>
Subject: Re: [RFCv11 PATCH 10/29] v4l2-ctrls: v4l2_ctrl_add_handler: add
 from_other_dev
Message-ID: <20180412133551.cohylcdimkrhuhrm@valkosipuli.retiisi.org.uk>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-11-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180409142026.19369-11-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I don't really have an opinion on the patch yet; a few trivial comments
below.

On Mon, Apr 09, 2018 at 04:20:07PM +0200, Hans Verkuil wrote:
...
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 5b445b5654f7..f8faa54b5e7e 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -247,6 +247,8 @@ struct v4l2_ctrl {
>   * @ctrl:	The actual control information.
>   * @helper:	Pointer to helper struct. Used internally in
>   *		``prepare_ext_ctrls`` function at ``v4l2-ctrl.c``.
> + * @from_other_dev: If true, then @ctrl was defined in another
> + *		device then the &struct v4l2_ctrl_handler.

s/then/than/

>   *
>   * Each control handler has a list of these refs. The list_head is used to
>   * keep a sorted-by-control-ID list of all controls, while the next pointer
> @@ -257,6 +259,7 @@ struct v4l2_ctrl_ref {
>  	struct v4l2_ctrl_ref *next;
>  	struct v4l2_ctrl *ctrl;
>  	struct v4l2_ctrl_helper *helper;
> +	bool from_other_dev;
>  };
>  
>  /**
> @@ -633,6 +636,8 @@ typedef bool (*v4l2_ctrl_filter)(const struct v4l2_ctrl *ctrl);
>   * @add:	The control handler whose controls you want to add to
>   *		the @hdl control handler.
>   * @filter:	This function will filter which controls should be added.
> + * @from_other_dev: If true, then the controls in @add were defined in another
> + *		device then @hdl.

s/then/than/

>   *
>   * Does nothing if either of the two handlers is a NULL pointer.
>   * If @filter is NULL, then all controls are added. Otherwise only those
> @@ -642,7 +647,8 @@ typedef bool (*v4l2_ctrl_filter)(const struct v4l2_ctrl *ctrl);
>   */
>  int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
>  			  struct v4l2_ctrl_handler *add,
> -			  v4l2_ctrl_filter filter);
> +			  v4l2_ctrl_filter filter,
> +			  bool from_other_dev);
>  
>  /**
>   * v4l2_ctrl_radio_filter() - Standard filter for radio controls.
> -- 
> 2.16.3
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
