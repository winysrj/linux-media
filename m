Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:33987 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751770AbeDJJcM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 05:32:12 -0400
Received: by mail-ua0-f193.google.com with SMTP id l21so6886134uak.1
        for <linux-media@vger.kernel.org>; Tue, 10 Apr 2018 02:32:11 -0700 (PDT)
MIME-Version: 1.0
References: <20180409142026.19369-1-hverkuil@xs4all.nl> <20180409142026.19369-13-hverkuil@xs4all.nl>
In-Reply-To: <20180409142026.19369-13-hverkuil@xs4all.nl>
From: Tomasz Figa <tfiga@google.com>
Date: Tue, 10 Apr 2018 09:32:00 +0000
Message-ID: <CAAFQd5BxsS4S_6sCKp=0hMvgrezVX80OJS9Bp+O+-i66GBDaAQ@mail.gmail.com>
Subject: Re: [RFCv11 PATCH 12/29] v4l2-ctrls: alloc memory for p_req
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Apr 9, 2018 at 11:21 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>

> To store request data the handler_new_ref() allocates memory
> for it if needed.

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>   drivers/media/v4l2-core/v4l2-ctrls.c | 20 ++++++++++++++++----
>   1 file changed, 16 insertions(+), 4 deletions(-)

> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
b/drivers/media/v4l2-core/v4l2-ctrls.c
> index d09f49530d9e..3c1b00baa8d0 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1997,13 +1997,18 @@ EXPORT_SYMBOL(v4l2_ctrl_find);
>   /* Allocate a new v4l2_ctrl_ref and hook it into the handler. */
>   static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
>                             struct v4l2_ctrl *ctrl,
> -                          bool from_other_dev)
> +                          struct v4l2_ctrl_ref **ctrl_ref,
> +                          bool from_other_dev, bool allocate_req)
>   {
>          struct v4l2_ctrl_ref *ref;
>          struct v4l2_ctrl_ref *new_ref;
>          u32 id = ctrl->id;
>          u32 class_ctrl = V4L2_CTRL_ID2WHICH(id) | 1;
>          int bucket = id % hdl->nr_of_buckets;   /* which bucket to use */
> +       unsigned int sz_extra = 0;
> +
> +       if (ctrl_ref)
> +               *ctrl_ref = NULL;

>          /*
>           * Automatically add the control class if it is not yet present
and
> @@ -2017,11 +2022,16 @@ static int handler_new_ref(struct
v4l2_ctrl_handler *hdl,
>          if (hdl->error)
>                  return hdl->error;

> -       new_ref = kzalloc(sizeof(*new_ref), GFP_KERNEL);
> +       if (allocate_req)
> +               sz_extra = ctrl->elems * ctrl->elem_size;
> +       new_ref = kzalloc(sizeof(*new_ref) + sz_extra, GFP_KERNEL);

I think we might want to use kvzalloc() here to cover allocation of big
elements and/or large arrays, without order>0 allocations killing the
systems.

I'm actually also wondering if it wouldn't be cleaner to just allocate the
extra data separately, since we store a pointer in new_ref->p_req.p anyway.

Best regards,
Tomasz
