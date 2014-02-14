Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:39959 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaBNEky (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Feb 2014 23:40:54 -0500
Received: by mail-yk0-f171.google.com with SMTP id q9so21898973ykb.2
        for <linux-media@vger.kernel.org>; Thu, 13 Feb 2014 20:40:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392284450-41019-6-git-send-email-hverkuil@xs4all.nl>
References: <1392284450-41019-1-git-send-email-hverkuil@xs4all.nl> <1392284450-41019-6-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Fri, 14 Feb 2014 13:40:08 +0900
Message-ID: <CAMm-=zDGWYNFa79iyRC59r6R2FE-9fLTH=G++MR3TZepKTU1Ew@mail.gmail.com>
Subject: Re: [RFCv3 PATCH 05/10] vb2: fix buf_init/buf_cleanup call sequences
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 13, 2014 at 6:40 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Ensure that these ops are properly balanced.
>
> There two scenarios:

s/There two/There are two/

>
> 1) for MMAP buf_init is called when the buffers are created and buf_cleanup
>    must be called when the queue is finally freed. This scenario was always
>    working.
>
> 2) for USERPTR and DMABUF it is more complicated. When a buffer is queued
>    the code checks if all planes of this buffer have been acquired before.
>    If that's the case, then only buf_prepare has to be called. Otherwise
>    buf_clean needs to be called if the buffer was acquired before, then,

s/buf_clean/buf_cleanup/

>    once all changed planes have been (re)acquired, buf_init has to be
>    called again followed by buf_prepare. Should buf_prepare fail, then

s/again//

I know what you mean, but there is only one call to buf_init in this
particular sequence.

>    buf_cleanup must be called again because all planes will be released

s/again because all planes will be released/on the newly acquired
planes to release them/

>    in case of an error.
>
> Finally, in __vb2_queue_free we have to check if the buffer was actually
> acquired before calling buf_cleanup. While that it always true for MMAP
> mode, it is not necessarily true for the other modes. E.g. if you just
> call REQBUFS and close the filehandle, then buffers were ever queued and

s/ever/never/
s/filehandle/file handle/

> so no buf_init was ever called.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 100 +++++++++++++++++++++----------
>  1 file changed, 67 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 3756378..7766bf5 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -373,8 +373,10 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
>         /* Call driver-provided cleanup function for each buffer, if provided */
>         for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
>              ++buffer) {
> -               if (q->bufs[buffer])
> -                       call_vb_qop(q->bufs[buffer], buf_cleanup, q->bufs[buffer]);
> +               struct vb2_buffer *vb = q->bufs[buffer];
> +
> +               if (vb && vb->planes[0].mem_priv)
> +                       call_vb_qop(vb, buf_cleanup, vb);
>         }
>
>         /* Release video buffer memory */
> @@ -1161,6 +1163,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>         unsigned int plane;
>         int ret;
>         int write = !V4L2_TYPE_IS_OUTPUT(q->type);
> +       bool reacquired = vb->planes[0].mem_priv == NULL;

This requires a comment I feel. In general, I'm not especially happy
with the fact that we are making mem_priv != NULL equivalent to
buf_init() called and succeeded. It is true right now, but it'll be
very hard to make the association without previously seeing this very
patch I feel.

I don't see a perfect way to do this, but I'm strongly leaning towards
having a bool inited in the vb2_buffer. Really.

>
>         /* Copy relevant information provided by the userspace */
>         __fill_vb2_buffer(vb, b, planes);
> @@ -1186,12 +1189,16 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>                 }
>
>                 /* Release previously acquired memory if present */
> -               if (vb->planes[plane].mem_priv)
> +               if (vb->planes[plane].mem_priv) {
> +                       if (!reacquired) {
> +                               reacquired = true;
> +                               call_vb_qop(vb, buf_cleanup, vb);
> +                       }
>                         call_memop(vb, put_userptr, vb->planes[plane].mem_priv);
> +               }
>
>                 vb->planes[plane].mem_priv = NULL;
> -               vb->v4l2_planes[plane].m.userptr = 0;
> -               vb->v4l2_planes[plane].length = 0;
> +               memset(&vb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
>
>                 /* Acquire each plane's memory */
>                 mem_priv = call_memop(vb, get_userptr, q->alloc_ctx[plane],
> @@ -1208,23 +1215,34 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>         }
>
>         /*
> -        * Call driver-specific initialization on the newly acquired buffer,
> -        * if provided.
> -        */
> -       ret = call_vb_qop(vb, buf_init, vb);
> -       if (ret) {
> -               dprintk(1, "qbuf: buffer initialization failed\n");
> -               fail_vb_qop(vb, buf_init);
> -               goto err;
> -       }
> -
> -       /*
>          * Now that everything is in order, copy relevant information
>          * provided by userspace.
>          */
>         for (plane = 0; plane < vb->num_planes; ++plane)
>                 vb->v4l2_planes[plane] = planes[plane];
>
> +       if (reacquired) {l
> +               /*
> +                * One or more planes changed, so we must call buf_init to do
> +                * the driver-specific initialization on the newly acquired
> +                * buffer, if provided.
> +                */
> +               ret = call_vb_qop(vb, buf_init, vb);
> +               if (ret) {
> +                       dprintk(1, "qbuf: buffer initialization failed\n");
> +                       fail_vb_qop(vb, buf_init);
> +                       goto err;
> +               }
> +       }
> +
> +       ret = call_vb_qop(vb, buf_prepare, vb);
> +       if (ret) {
> +               dprintk(1, "qbuf: buffer preparation failed\n");
> +               fail_vb_qop(vb, buf_prepare);
> +               call_vb_qop(vb, buf_cleanup, vb);
> +               goto err;
> +       }
> +
>         return 0;
>  err:
>         /* In case of errors, release planes that were already acquired */
> @@ -1244,8 +1262,13 @@ err:
>   */
>  static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  {
> +       int ret;
> +
>         __fill_vb2_buffer(vb, b, vb->v4l2_planes);
> -       return 0;
> +       ret = call_vb_qop(vb, buf_prepare, vb);
> +       if (ret)
> +               fail_vb_qop(vb, buf_prepare);
> +       return ret;
>  }
>
>  /**
> @@ -1259,6 +1282,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>         unsigned int plane;
>         int ret;
>         int write = !V4L2_TYPE_IS_OUTPUT(q->type);
> +       bool reacquired = vb->planes[0].mem_priv == NULL;
>
>         /* Copy relevant information provided by the userspace */
>         __fill_vb2_buffer(vb, b, planes);
> @@ -1294,6 +1318,11 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>
>                 dprintk(1, "qbuf: buffer for plane %d changed\n", plane);
>
> +               if (!reacquired) {
> +                       reacquired = true;
> +                       call_vb_qop(vb, buf_cleanup, vb);
> +               }
> +
>                 /* Release previously acquired memory if present */
>                 __vb2_plane_dmabuf_put(vb, &vb->planes[plane]);
>                 memset(&vb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
> @@ -1329,23 +1358,33 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>         }
>
>         /*
> -        * Call driver-specific initialization on the newly acquired buffer,
> -        * if provided.
> -        */
> -       ret = call_vb_qop(vb, buf_init, vb);
> -       if (ret) {
> -               dprintk(1, "qbuf: buffer initialization failed\n");
> -               fail_vb_qop(vb, buf_init);
> -               goto err;
> -       }
> -
> -       /*
>          * Now that everything is in order, copy relevant information
>          * provided by userspace.
>          */
>         for (plane = 0; plane < vb->num_planes; ++plane)
>                 vb->v4l2_planes[plane] = planes[plane];
>
> +       if (reacquired) {

This sequence until 'return 0" is an exact same code as in
__qbuf_userptr. Could we extract this?
I'm thinking that we could do this:

- rename __qbuf_userptr and __qbuf_dmabuf to __acquire_userptr/dmabuf
and have them return whether reacquired
- extract the sequence above and call buf_prepare from __buf_prepare
for userptr and dmabuf after calling __acquire_*
- get rid of qbuf_dmabuf, instead just call buf_prepare from
__buf_prepare directly like for useptr and dmabuf

> +               /*
> +                * Call driver-specific initialization on the newly acquired buffer,
> +                * if provided.
> +                */
> +               ret = call_vb_qop(vb, buf_init, vb);
> +               if (ret) {
> +                       dprintk(1, "qbuf: buffer initialization failed\n");
> +                       fail_vb_qop(vb, buf_init);
> +                       goto err;
> +               }
> +       }
> +
> +       ret = call_vb_qop(vb, buf_prepare, vb);
> +       if (ret) {
> +               dprintk(1, "qbuf: buffer preparation failed\n");
> +               fail_vb_qop(vb, buf_prepare);
> +               call_vb_qop(vb, buf_cleanup, vb);

Should we explicitly set mem_priv to NULL here? This is one the issues
I have with using mem_priv, it's hard to reason if it's ok to do
buf_cleanup and expect mem_priv to be NULL here always.
Could we please add that inited bool into vb2_buffer to make it simpler?

> +               goto err;
> +       }
> +
>         return 0;
>  err:
>         /* In case of errors, release planes that were already acquired */
> @@ -1420,11 +1459,6 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>                 ret = -EINVAL;
>         }
>
> -       if (!ret) {
> -               ret = call_vb_qop(vb, buf_prepare, vb);
> -               if (ret)
> -                       fail_vb_qop(vb, buf_prepare);
> -       }
>         if (ret)
>                 dprintk(1, "qbuf: buffer preparation failed: %d\n", ret);
>         vb->state = ret ? VB2_BUF_STATE_DEQUEUED : VB2_BUF_STATE_PREPARED;
> --
> 1.8.4.rc3
>



-- 
Best regards,
Pawel Osciak
