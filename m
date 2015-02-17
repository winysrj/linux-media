Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:39799 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbbBQOqW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 09:46:22 -0500
MIME-Version: 1.0
In-Reply-To: <1424184090-14945-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1424184090-14945-1-git-send-email-ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 17 Feb 2015 15:46:00 +0100
Message-ID: <CAPybu_0hNHHZctBLpKD4NszmZdBbEjzLCusSxM8dxLfatkxpXg@mail.gmail.com>
Subject: Re: [PATCH 1/2] media/v4l2-ctrls: Always run s_ctrl on volatile ctrls
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Arun Kumar K <arun.kk@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is v3 of the patch.

I forgot to add it to the subject. I have marked v1 and v2 as
Superseded on patchwork

Thanks

On Tue, Feb 17, 2015 at 3:41 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
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
>                 if (ctrl == NULL)
>                         continue;
> +
> +               if (ctrl->flags & V4L2_CTRL_FLAG_VOLATILE) {
> +                       changed = true;
> +                       continue;
> +               }
> +
>                 for (idx = 0; !ctrl_changed && idx < ctrl->elems; idx++)
>                         ctrl_changed = !ctrl->type_ops->equal(ctrl, idx,
>                                 ctrl->p_cur, ctrl->p_new);
> --
> 2.1.4
>



-- 
Ricardo Ribalda
