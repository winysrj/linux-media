Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3754 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3AUJke (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 04:40:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH] noon010p30: Remove unneeded v4l2 control compatibility ops
Date: Mon, 21 Jan 2013 10:40:24 +0100
Cc: linux-media@vger.kernel.org
References: <1358631493-12822-1-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1358631493-12822-1-git-send-email-sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301211040.24755.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat January 19 2013 22:38:13 Sylwester Nawrocki wrote:
> All host drivers using this subdev driver are already converted
> to use the control framework so the compatibility ops can be dropped.
> 
> Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/i2c/noon010pc30.c |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/i2c/noon010pc30.c b/drivers/media/i2c/noon010pc30.c
> index 440c129..8554b47 100644
> --- a/drivers/media/i2c/noon010pc30.c
> +++ b/drivers/media/i2c/noon010pc30.c
> @@ -660,13 +660,6 @@ static const struct v4l2_ctrl_ops noon010_ctrl_ops = {
>  
>  static const struct v4l2_subdev_core_ops noon010_core_ops = {
>  	.s_power	= noon010_s_power,
> -	.g_ctrl		= v4l2_subdev_g_ctrl,
> -	.s_ctrl		= v4l2_subdev_s_ctrl,
> -	.queryctrl	= v4l2_subdev_queryctrl,
> -	.querymenu	= v4l2_subdev_querymenu,
> -	.g_ext_ctrls	= v4l2_subdev_g_ext_ctrls,
> -	.try_ext_ctrls	= v4l2_subdev_try_ext_ctrls,
> -	.s_ext_ctrls	= v4l2_subdev_s_ext_ctrls,
>  	.log_status	= noon010_log_status,
>  };
>  
> 
