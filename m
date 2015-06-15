Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f175.google.com ([209.85.160.175]:33002 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbbFOMvx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 08:51:53 -0400
MIME-Version: 1.0
In-Reply-To: <1434126678-7978-2-git-send-email-ricardo.ribalda@gmail.com>
References: <1434126678-7978-1-git-send-email-ricardo.ribalda@gmail.com> <1434126678-7978-2-git-send-email-ricardo.ribalda@gmail.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Mon, 15 Jun 2015 13:51:22 +0100
Message-ID: <CA+V-a8sMOXOX4MzoT4dQNNGS_GAwKM3Nxf4_=jX7Hjb2TCDz4g@mail.gmail.com>
Subject: Re: [PATCH 01/12] media/i2c/adv7343: Remove compat control ops
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
>  drivers/media/i2c/adv7343.c | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
> index 7c50833e7d17..d27283135490 100644
> --- a/drivers/media/i2c/adv7343.c
> +++ b/drivers/media/i2c/adv7343.c
> @@ -319,13 +319,6 @@ static const struct v4l2_ctrl_ops adv7343_ctrl_ops = {
>
>  static const struct v4l2_subdev_core_ops adv7343_core_ops = {
>         .log_status = adv7343_log_status,
> -       .g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
> -       .try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
> -       .s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
> -       .g_ctrl = v4l2_subdev_g_ctrl,
> -       .s_ctrl = v4l2_subdev_s_ctrl,
> -       .queryctrl = v4l2_subdev_queryctrl,
> -       .querymenu = v4l2_subdev_querymenu,
>  };
>
>  static int adv7343_s_std_output(struct v4l2_subdev *sd, v4l2_std_id std)
> --
> 2.1.4
>
