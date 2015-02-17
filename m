Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:32929 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751674AbbBQOs6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 09:48:58 -0500
Message-ID: <54E354C1.7050201@xs4all.nl>
Date: Tue, 17 Feb 2015 15:48:33 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Arun Kumar K <arun.kk@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] media/v4l2-ctrls: Always run s_ctrl on volatile ctrls
References: <1424184090-14945-1-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1424184090-14945-1-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/17/2015 03:41 PM, Ricardo Ribalda Delgado wrote:
> Volatile controls can change their value outside the v4l-ctrl framework.
> We should ignore the cached written value of the ctrl when evaluating if
> we should run s_ctrl.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 45c5b47..693a473 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1609,6 +1609,12 @@ static int cluster_changed(struct v4l2_ctrl *master)
>  
>  		if (ctrl == NULL)
>  			continue;
> +
> +		if (ctrl->flags & V4L2_CTRL_FLAG_VOLATILE) {
> +			changed = true;

You need to explicitly set 'ctrl->has_changed = false;' here.

And a comment why it is set to false (to prevent sending the event) is
needed as well since it would look a bit weird otherwise.

Regards,

	Hans

> +			continue;
> +		}
> +
>  		for (idx = 0; !ctrl_changed && idx < ctrl->elems; idx++)
>  			ctrl_changed = !ctrl->type_ops->equal(ctrl, idx,
>  				ctrl->p_cur, ctrl->p_new);
> 

