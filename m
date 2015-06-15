Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f48.google.com ([209.85.213.48]:36004 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbbFOMw6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 08:52:58 -0400
MIME-Version: 1.0
In-Reply-To: <1434126678-7978-10-git-send-email-ricardo.ribalda@gmail.com>
References: <1434126678-7978-1-git-send-email-ricardo.ribalda@gmail.com> <1434126678-7978-10-git-send-email-ricardo.ribalda@gmail.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Mon, 15 Jun 2015 13:52:27 +0100
Message-ID: <CA+V-a8vPUfNQKHe2Enn3n3vvb-okF1-r=8-0ZgrfD63_j80wNQ@mail.gmail.com>
Subject: Re: [PATCH 09/12] media/i2c/tvp7002: Remove compat control ops
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Axel Lin <axel.lin@ingics.com>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 12, 2015 at 5:31 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> They are no longer used in old non-control-framework
> bridge drivers.
>
> Reported-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad

> ---
>  drivers/media/i2c/tvp7002.c | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
> index 05077cffd235..f617d8b745ee 100644
> --- a/drivers/media/i2c/tvp7002.c
> +++ b/drivers/media/i2c/tvp7002.c
> @@ -861,13 +861,6 @@ tvp7002_set_pad_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cf
>  /* V4L2 core operation handlers */
>  static const struct v4l2_subdev_core_ops tvp7002_core_ops = {
>         .log_status = tvp7002_log_status,
> -       .g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
> -       .try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
> -       .s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
> -       .g_ctrl = v4l2_subdev_g_ctrl,
> -       .s_ctrl = v4l2_subdev_s_ctrl,
> -       .queryctrl = v4l2_subdev_queryctrl,
> -       .querymenu = v4l2_subdev_querymenu,
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>         .g_register = tvp7002_g_register,
>         .s_register = tvp7002_s_register,
> --
> 2.1.4
>
