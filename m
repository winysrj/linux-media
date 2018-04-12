Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:38194 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750788AbeDLIaJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 04:30:09 -0400
Received: by mail-vk0-f67.google.com with SMTP id b16so2756274vka.5
        for <linux-media@vger.kernel.org>; Thu, 12 Apr 2018 01:30:08 -0700 (PDT)
MIME-Version: 1.0
References: <20180409142026.19369-1-hverkuil@xs4all.nl> <20180409142026.19369-23-hverkuil@xs4all.nl>
In-Reply-To: <20180409142026.19369-23-hverkuil@xs4all.nl>
From: Tomasz Figa <tfiga@google.com>
Date: Thu, 12 Apr 2018 08:29:57 +0000
Message-ID: <CAAFQd5Ckqhb2qEBdsBfG2iKTE4G76PFPep5KhEDJA=1m4wFA5Q@mail.gmail.com>
Subject: Re: [RFCv11 PATCH 22/29] videobuf2-v4l2: add vb2_request_queue helper
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 9, 2018 at 11:20 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>

> Generic helper function that checks if there are buffers in
> the request and if so, prepares and queues all objects in the
> request.

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>   drivers/media/common/videobuf2/videobuf2-v4l2.c | 39
+++++++++++++++++++++++++
>   include/media/videobuf2-v4l2.h                  |  3 ++
>   2 files changed, 42 insertions(+)

> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c
b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index 73c1fd4da58a..3d0c74bb4220 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -1061,6 +1061,45 @@ void vb2_ops_wait_finish(struct vb2_queue *vq)
>   }
>   EXPORT_SYMBOL_GPL(vb2_ops_wait_finish);

> +int vb2_request_queue(struct media_request *req)
> +{
> +       struct media_request_object *obj;
> +       struct media_request_object *failed_obj = NULL;
> +       int ret = 0;
> +
> +       if (!vb2_core_request_has_buffers(req))
> +               return -ENOENT;
> +
> +       list_for_each_entry(obj, &req->objects, list) {
> +               if (!obj->ops->prepare)
> +                       continue;
> +
> +               ret = obj->ops->prepare(obj);
> +
> +               if (ret) {
> +                       failed_obj = obj;
> +                       break;
> +               }
> +       }
> +
> +       if (ret) {
> +               list_for_each_entry(obj, &req->objects, list) {
> +                       if (obj == failed_obj)
> +                               break;

nit: If we use list_for_each_entry_continue_reverse() here, we wouldn't
need failed_obj.

Best regards,
Tomasz
