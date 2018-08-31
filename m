Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:35405 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728075AbeHaTDN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 15:03:13 -0400
Received: by mail-yb1-f195.google.com with SMTP id o17-v6so962584yba.2
        for <linux-media@vger.kernel.org>; Fri, 31 Aug 2018 07:55:21 -0700 (PDT)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com. [209.85.219.182])
        by smtp.gmail.com with ESMTPSA id o62-v6sm3657210ywf.109.2018.08.31.07.55.18
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Aug 2018 07:55:19 -0700 (PDT)
Received: by mail-yb1-f182.google.com with SMTP id d4-v6so963020ybl.0
        for <linux-media@vger.kernel.org>; Fri, 31 Aug 2018 07:55:18 -0700 (PDT)
MIME-Version: 1.0
References: <20180828134911.44086-1-hverkuil@xs4all.nl> <20180828134911.44086-8-hverkuil@xs4all.nl>
In-Reply-To: <20180828134911.44086-8-hverkuil@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 31 Aug 2018 23:55:05 +0900
Message-ID: <CAAFQd5DFOYt+SgWuGhLGEGz37oq9YGaL=ovkCdETX31AUDxYmQ@mail.gmail.com>
Subject: Re: [PATCHv2 07/10] v4l2-ctrls: use media_request_(un)lock_for_access
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Aug 28, 2018 at 10:49 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> When getting control values from a completed request, we have
> to protect the request against being re-inited why it is
> being accessed by calling media_request_(un)lock_for_access.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index ccaf3068de6d..cc266a4a6e88 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -3289,11 +3289,10 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
>                      struct v4l2_ext_controls *cs)
>  {
>         struct media_request_object *obj = NULL;
> +       struct media_request *req = NULL;
>         int ret;
>
>         if (cs->which == V4L2_CTRL_WHICH_REQUEST_VAL) {
> -               struct media_request *req;
> -
>                 if (!mdev || cs->request_fd < 0)
>                         return -EINVAL;
>
> @@ -3306,11 +3305,18 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
>                         return -EACCES;
>                 }
>
> +               ret = media_request_lock_for_access(req);
> +               if (ret) {
> +                       media_request_put(req);
> +                       return ret;
> +               }
> +
>                 obj = v4l2_ctrls_find_req_obj(hdl, req, false);
> -               /* Reference to the request held through obj */
> -               media_request_put(req);
> -               if (IS_ERR(obj))
> +               if (IS_ERR(obj)) {
> +                       media_request_unlock_for_access(req);
> +                       media_request_put(req);
>                         return PTR_ERR(obj);
> +               }
>
>                 hdl = container_of(obj, struct v4l2_ctrl_handler,
>                                    req_obj);
> @@ -3318,8 +3324,11 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
>
>         ret = v4l2_g_ext_ctrls_common(hdl, cs);
>
> -       if (obj)
> +       if (obj) {
> +               media_request_unlock_for_access(req);

We called media_request_lock_for_access() before looking up obj. Don't
we also need to  call media_request_unlock_for_access() regardless of
whether obj is non-NULL?

>                 media_request_object_put(obj);
> +               media_request_put(req);
> +       }
>         return ret;
>  }

Best regards,
Tomasz
