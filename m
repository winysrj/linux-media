Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:43204 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754025AbbFOKXs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 06:23:48 -0400
Message-ID: <557EA7A2.8060403@xs4all.nl>
Date: Mon, 15 Jun 2015 12:23:30 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Axel Lin <axel.lin@ingics.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 05/12] media/i2c/sr030pc30: Remove compat control ops
References: <1434126678-7978-1-git-send-email-ricardo.ribalda@gmail.com> <1434126678-7978-6-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1434126678-7978-6-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sylwester,

Can you confirm that this is only used with bridge drivers that use the
control framework? Actually, this driver isn't used by any bridge driver
in the kernel tree, but it is probably in use by out-of-tree code.

I'd like your Ack (or Nack) before I merge this.

Note that eventually these legacy support ops will disappear once all
bridge drivers in the kernel have been converted to the control framework.

Regards,

	Hans


On 06/12/2015 06:31 PM, Ricardo Ribalda Delgado wrote:
> They are no longer used in old non-control-framework
> bridge drivers.
> 
> Reported-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/i2c/sr030pc30.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/media/i2c/sr030pc30.c b/drivers/media/i2c/sr030pc30.c
> index b62b6ddc4356..229dc76c44a5 100644
> --- a/drivers/media/i2c/sr030pc30.c
> +++ b/drivers/media/i2c/sr030pc30.c
> @@ -636,13 +636,6 @@ static const struct v4l2_ctrl_ops sr030pc30_ctrl_ops = {
>  
>  static const struct v4l2_subdev_core_ops sr030pc30_core_ops = {
>  	.s_power	= sr030pc30_s_power,
> -	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
> -	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
> -	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
> -	.g_ctrl = v4l2_subdev_g_ctrl,
> -	.s_ctrl = v4l2_subdev_s_ctrl,
> -	.queryctrl = v4l2_subdev_queryctrl,
> -	.querymenu = v4l2_subdev_querymenu,
>  };
>  
>  static const struct v4l2_subdev_pad_ops sr030pc30_pad_ops = {
> 

