Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51773 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751987AbaAXKf4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jan 2014 05:35:56 -0500
Date: Fri, 24 Jan 2014 12:35:19 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	laurent.pinchart@ideasonboard.com, t.stanislaws@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 02/21] v4l2-ctrls: add unit string.
Message-ID: <20140124103519.GA13820@valkosipuli.retiisi.org.uk>
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl>
 <1390221974-28194-3-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1390221974-28194-3-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patchset!

On Mon, Jan 20, 2014 at 01:45:55PM +0100, Hans Verkuil wrote:
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 0b347e8..3998049 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -85,6 +85,7 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
>    * @ops:	The control ops.
>    * @id:	The control ID.
>    * @name:	The control name.
> +  * @unit:	The control's unit. May be NULL.
>    * @type:	The control type.
>    * @minimum:	The control's minimum value.
>    * @maximum:	The control's maximum value.
> @@ -130,6 +131,7 @@ struct v4l2_ctrl {
>  	const struct v4l2_ctrl_ops *ops;
>  	u32 id;
>  	const char *name;
> +	const char *unit;

What would you think of using a numeric value (with the standardised units
#defined)? I think using a string begs for unmanaged unit usage. Code that
deals with units might work with one driver but not with another since it
uses a slightly different string for unit x.

A prefix could be potentially nice, too, so ms and µs would still have the
same unit but a different prefix.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
