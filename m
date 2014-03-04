Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:62645 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239AbaCDLHo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Mar 2014 06:07:44 -0500
Received: by mail-ob0-f179.google.com with SMTP id va2so3372271obc.10
        for <linux-media@vger.kernel.org>; Tue, 04 Mar 2014 03:07:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52FF57E9.2020707@xs4all.nl>
References: <52FF57E9.2020707@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 4 Mar 2014 12:07:23 +0100
Message-ID: <CAPybu_05T4aDzYPWHKJ-buGdUjZmicHbk84FD=Ok8nfjtDSCDw@mail.gmail.com>
Subject: Re: [REVIEWv2 PATCH 39/34] v4l2-ctrls: allow HIDDEN controls in the
 user class
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Ricardo Ribalda <ricardo.ribalda@gmail.com>

(Sorry for the delay)

On Sat, Feb 15, 2014 at 1:04 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Previously hidden controls were not allowed in the user class due to
> backwards compatibility reasons (QUERYCTRL should not see them), but
> by simply testing if QUERYCTRL found a hidden control and returning
> -EINVAL this limitation can be lifted.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index bc30c50..859ac29 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1853,15 +1853,6 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>         /* Complex controls are always hidden */
>         if (is_matrix || type >= V4L2_CTRL_COMPLEX_TYPES)
>                 flags |= V4L2_CTRL_FLAG_HIDDEN;
> -       /*
> -        * No hidden controls are allowed in the USER class
> -        * due to backwards compatibility with old applications.
> -        */
> -       if (V4L2_CTRL_ID2CLASS(id) == V4L2_CTRL_CLASS_USER &&
> -           (flags & V4L2_CTRL_FLAG_HIDDEN)) {
> -               handler_set_err(hdl, -EINVAL);
> -               return NULL;
> -       }
>         err = check_range(type, min, max, step, def);
>         if (err) {
>                 handler_set_err(hdl, err);
> @@ -2469,6 +2460,9 @@ int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc)
>         if (rc)
>                 return rc;
>
> +       /* VIDIOC_QUERYCTRL is not allowed to see hidden controls */
> +       if (qc->flags & V4L2_CTRL_FLAG_HIDDEN)
> +               return -EINVAL;
>         qc->id = qec.id;
>         qc->type = qec.type;
>         qc->flags = qec.flags;
> --
> 1.8.5.2
>



-- 
Ricardo Ribalda
