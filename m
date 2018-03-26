Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:44113 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbeCZGDP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 02:03:15 -0400
Received: by mail-ua0-f195.google.com with SMTP id s92so11335546uas.11
        for <linux-media@vger.kernel.org>; Sun, 25 Mar 2018 23:03:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1521839864-10146-7-git-send-email-sakari.ailus@linux.intel.com>
References: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com> <1521839864-10146-7-git-send-email-sakari.ailus@linux.intel.com>
From: Tomasz Figa <tfiga@google.com>
Date: Mon, 26 Mar 2018 15:02:53 +0900
Message-ID: <CAAFQd5BZEExQoAgx7UAzLhyEnFLDoMDj2SYp+9_39105rwktBA@mail.gmail.com>
Subject: Re: [RFC v2 06/10] vb2: Add support for requests
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Alexandre Courbot <acourbot@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

I would have appreciated being CCed on this series, but anyway, thanks
for sending it. Please see my comments inline.

On Sat, Mar 24, 2018 at 6:17 AM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> Associate a buffer to a request when it is queued and disassociate when it
> is done.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 43 ++++++++++++++++++++++++-
>  drivers/media/common/videobuf2/videobuf2-v4l2.c | 40 ++++++++++++++++++++++-
>  include/media/videobuf2-core.h                  | 19 +++++++++++
>  include/media/videobuf2-v4l2.h                  | 28 ++++++++++++++++
>  4 files changed, 128 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index d3f7bb3..b8535de 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -346,6 +346,9 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
>                         break;
>                 }
>
> +               if (q->class)
> +                       media_request_object_init(q->class, &vb->req_obj);
> +
>                 vb->state = VB2_BUF_STATE_DEQUEUED;
>                 vb->vb2_queue = q;
>                 vb->num_planes = num_planes;
> @@ -520,7 +523,10 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
>         /* Free videobuf buffers */
>         for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
>              ++buffer) {
> -               kfree(q->bufs[buffer]);
> +               if (q->class)
> +                       media_request_object_put(&q->bufs[buffer]->req_obj);
> +               else
> +                       kfree(q->bufs[buffer]);
>                 q->bufs[buffer] = NULL;
>         }
>
> @@ -944,6 +950,10 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>         default:
>                 /* Inform any processes that may be waiting for buffers */
>                 wake_up(&q->done_wq);
> +               if (vb->req_ref) {
> +                       media_request_ref_complete(vb->req_ref);
> +                       vb->req_ref = NULL;
> +               }
>                 break;
>         }
>  }
> @@ -1249,6 +1259,32 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
>                 return -EIO;
>         }
>
> +       if (vb->request_fd) {

0 is a perfectly valid FD.

> +               struct media_request *req;
> +               struct media_request_ref *ref;
> +
> +               if (!q->class) {
> +                       dprintk(1, "requests not enabled for the queue\n");
> +                       return -EINVAL;
> +               }
> +
> +               req = media_request_find(q->class->mdev, vb->request_fd);
> +               if (IS_ERR(req)) {
> +                       dprintk(1, "no request found for fd %d (%ld)\n",
> +                               vb->request_fd, PTR_ERR(req));
> +                       return PTR_ERR(req);
> +               }
> +
> +               ref = media_request_object_bind(req,
> +                                               &q->bufs[vb->index]->req_obj);
> +               media_request_put(req);
> +
> +               if (IS_ERR(ref))
> +                       return PTR_ERR(ref);
> +
> +               vb->req_ref = ref;
> +       }
> +

I'm not sure how this would work. The client calling QBUF with request
FD would end up queuing the buffer to the driver, which I'd say isn't
an expected side effect of something that is usually done early as
part of preparing the request.

As we agreed in the UAPI RFC, the buffer should be only prepared and
queued at request queue time and I believe Alex had it implemented
properly in his latest RFC v4. We should reuse that patch instead,
since we spent quite a bit of time to go through all the corner cases
and make sure it works for the most exotic use case we could imagine.

Best regards,
Tomasz
