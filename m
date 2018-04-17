Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:39555 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbeDQEgy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 00:36:54 -0400
Received: by mail-io0-f194.google.com with SMTP id v13so20787063iob.6
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 21:36:54 -0700 (PDT)
Received: from mail-it0-f46.google.com (mail-it0-f46.google.com. [209.85.214.46])
        by smtp.gmail.com with ESMTPSA id f6sm6783103ioj.18.2018.04.16.21.36.53
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Apr 2018 21:36:53 -0700 (PDT)
Received: by mail-it0-f46.google.com with SMTP id t192-v6so13646401itc.1
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 21:36:53 -0700 (PDT)
MIME-Version: 1.0
References: <20180409142026.19369-1-hverkuil@xs4all.nl> <20180409142026.19369-21-hverkuil@xs4all.nl>
In-Reply-To: <20180409142026.19369-21-hverkuil@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Tue, 17 Apr 2018 04:36:42 +0000
Message-ID: <CAPBb6MX0hVJfwDnQNZ_Zrb2uvuOE-6-v5pzR=ML0N3cwo7wBdw@mail.gmail.com>
Subject: Re: [RFCv11 PATCH 20/29] videobuf2-v4l2: integrate with media requests
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 9, 2018 at 11:21 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>

> This implements the V4L2 part of the request support. The main
> change is that vb2_qbuf and vb2_prepare_buf now have a new
> media_device pointer. This required changes to several drivers
> that did not use the vb2_ioctl_qbuf/prepare_buf helper functions.

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>   drivers/media/common/videobuf2/videobuf2-v4l2.c  | 84
++++++++++++++++++++----
>   drivers/media/platform/omap3isp/ispvideo.c       |  2 +-
>   drivers/media/platform/s3c-camif/camif-capture.c |  4 +-
>   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c     |  4 +-
>   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c     |  4 +-
>   drivers/media/platform/soc_camera/soc_camera.c   |  4 +-
>   drivers/media/usb/uvc/uvc_queue.c                |  5 +-
>   drivers/media/usb/uvc/uvc_v4l2.c                 |  3 +-
>   drivers/media/usb/uvc/uvcvideo.h                 |  1 +
>   drivers/media/v4l2-core/v4l2-mem2mem.c           |  7 +-
>   drivers/staging/media/davinci_vpfe/vpfe_video.c  |  3 +-
>   drivers/staging/media/omap4iss/iss_video.c       |  3 +-
>   drivers/usb/gadget/function/uvc_queue.c          |  2 +-
>   include/media/videobuf2-v4l2.h                   | 12 +++-
>   14 files changed, 106 insertions(+), 32 deletions(-)

> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c
b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index b8d370b97cca..73c1fd4da58a 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -25,6 +25,7 @@
>   #include <linux/kthread.h>

>   #include <media/v4l2-dev.h>
> +#include <media/v4l2-device.h>
>   #include <media/v4l2-fh.h>
>   #include <media/v4l2-event.h>
>   #include <media/v4l2-common.h>
> @@ -40,10 +41,12 @@ module_param(debug, int, 0644);
>                          pr_info("vb2-v4l2: %s: " fmt, __func__, ## arg); \
>          } while (0)

> -/* Flags that are set by the vb2 core */
> +/* Flags that are set by us */
>   #define V4L2_BUFFER_MASK_FLAGS (V4L2_BUF_FLAG_MAPPED |
V4L2_BUF_FLAG_QUEUED | \
>                                   V4L2_BUF_FLAG_DONE | V4L2_BUF_FLAG_ERROR
| \
>                                   V4L2_BUF_FLAG_PREPARED | \
> +                                V4L2_BUF_FLAG_IN_REQUEST | \
> +                                V4L2_BUF_FLAG_REQUEST_FD | \
>                                   V4L2_BUF_FLAG_TIMESTAMP_MASK)
>   /* Output buffer flags that should be passed on to the driver */
>   #define V4L2_BUFFER_OUT_FLAGS  (V4L2_BUF_FLAG_PFRAME |
V4L2_BUF_FLAG_BFRAME | \
> @@ -318,13 +321,17 @@ static int vb2_fill_vb2_v4l2_buffer(struct
vb2_buffer *vb, struct v4l2_buffer *b
>          return 0;
>   }

> -static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct
v4l2_buffer *b,
> -                                   const char *opname)
> +static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct
media_device *mdev,
> +                                   struct v4l2_buffer *b,
> +                                   const char *opname,
> +                                   struct media_request **p_req)
>   {
> +       struct media_request *req;
>          struct vb2_v4l2_buffer *vbuf;
>          struct vb2_buffer *vb;
>          int ret;

> +       *p_req = NULL;
>          if (b->type != q->type) {
>                  dprintk(1, "%s: invalid buffer type\n", opname);
>                  return -EINVAL;
> @@ -354,7 +361,38 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue
*q, struct v4l2_buffer *b,

>          /* Copy relevant information provided by the userspace */
>          memset(vbuf->planes, 0, sizeof(vbuf->planes[0]) * vb->num_planes);
> -       return vb2_fill_vb2_v4l2_buffer(vb, b);
> +       ret = vb2_fill_vb2_v4l2_buffer(vb, b);
> +       if (ret)
> +               return ret;
> +
> +       if (!(b->flags & V4L2_BUF_FLAG_REQUEST_FD))
> +               return 0;
> +
> +       if (vb->state != VB2_BUF_STATE_DEQUEUED) {
> +               dprintk(1, "%s: buffer is not in dequeued state\n",
opname);
> +               return -EINVAL;
> +       }
> +
> +       if (b->request_fd < 0) {
> +               dprintk(1, "%s: request_fd < 0\n", opname);
> +               return -EINVAL;
> +       }
> +
> +       req = media_request_find(mdev, b->request_fd);
> +       if (IS_ERR(req)) {
> +               dprintk(1, "%s: invalid request_fd\n", opname);
> +               return PTR_ERR(req);
> +       }
> +
> +       if (req->state != MEDIA_REQUEST_STATE_IDLE) {
> +               dprintk(1, "%s: request is not idle\n", opname);
> +               media_request_put(req);
> +               return -EBUSY;
> +       }
> +
> +       *p_req = req;
> +
> +       return 0;
>   }

>   /*
> @@ -437,6 +475,9 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb,
void *pb)
>          case VB2_BUF_STATE_ACTIVE:
>                  b->flags |= V4L2_BUF_FLAG_QUEUED;
>                  break;
> +       case VB2_BUF_STATE_IN_REQUEST:
> +               b->flags |= V4L2_BUF_FLAG_IN_REQUEST;
> +               break;
>          case VB2_BUF_STATE_ERROR:
>                  b->flags |= V4L2_BUF_FLAG_ERROR;
>                  /* fall through */
> @@ -455,6 +496,10 @@ static void __fill_v4l2_buffer(struct vb2_buffer
*vb, void *pb)

>          if (vb2_buffer_in_use(q, vb))
>                  b->flags |= V4L2_BUF_FLAG_MAPPED;
> +       if (vb->req_obj.req) {
> +               b->flags |= V4L2_BUF_FLAG_REQUEST_FD;
> +               b->request_fd = -1;
> +       }

>          if (!q->is_output &&
>                  b->flags & V4L2_BUF_FLAG_DONE &&
> @@ -533,8 +578,10 @@ int vb2_reqbufs(struct vb2_queue *q, struct
v4l2_requestbuffers *req)
>   }
>   EXPORT_SYMBOL_GPL(vb2_reqbufs);

> -int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
> +int vb2_prepare_buf(struct vb2_queue *q, struct media_device *mdev,
> +                   struct v4l2_buffer *b)
>   {
> +       struct media_request *req;
>          int ret;

>          if (vb2_fileio_is_active(q)) {
> @@ -542,9 +589,13 @@ int vb2_prepare_buf(struct vb2_queue *q, struct
v4l2_buffer *b)
>                  return -EBUSY;
>          }

> -       ret = vb2_queue_or_prepare_buf(q, b, "prepare_buf");
> -
> -       return ret ? ret : vb2_core_prepare_buf(q, b->index, b, NULL);
> +       ret = vb2_queue_or_prepare_buf(q, mdev, b, "prepare_buf", &req);
> +       if (ret)
> +               return ret;
> +       ret = vb2_core_prepare_buf(q, b->index, b, req);
> +       if (req)
> +               media_request_put(req);
> +       return ret;
>   }
>   EXPORT_SYMBOL_GPL(vb2_prepare_buf);

> @@ -602,8 +653,10 @@ int vb2_create_bufs(struct vb2_queue *q, struct
v4l2_create_buffers *create)
>   }
>   EXPORT_SYMBOL_GPL(vb2_create_bufs);

> -int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
> +int vb2_qbuf(struct vb2_queue *q, struct media_device *mdev,
> +            struct v4l2_buffer *b)

That extra mdev argument is request-specific and not very nice to have here.
Isn't it possible instead to obtain the media_device by looking up through
the
queue, or at least to cache a pointer to the media_device inside vb2_queue
when
requests are in use? After all a queue can only be used with one
media_device.

Btw, that's also one of the reasons why I used to put request management
data
into its own structure instead of having it directly in media_device.
Non-request users would wonder what is a media_device doing here. With a
dedicated struct to manage requests, the intent is at least clear. Even if
we
mandate the use of media_device, it's never a bad idea to clearly sort your
data members by purpose.

>   {
> +       struct media_request *req;
>          int ret;

>          if (vb2_fileio_is_active(q)) {
> @@ -611,8 +664,13 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer
*b)
>                  return -EBUSY;
>          }

> -       ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
> -       return ret ? ret : vb2_core_qbuf(q, b->index, b, NULL);
> +       ret = vb2_queue_or_prepare_buf(q, mdev, b, "qbuf", &req);
> +       if (ret)
> +               return ret;
> +       ret = vb2_core_qbuf(q, b->index, b, req);
> +       if (req)
> +               media_request_put(req);
> +       return ret;
>   }
>   EXPORT_SYMBOL_GPL(vb2_qbuf);

> @@ -802,7 +860,7 @@ int vb2_ioctl_prepare_buf(struct file *file, void
*priv,

>          if (vb2_queue_is_busy(vdev, file))
>                  return -EBUSY;
> -       return vb2_prepare_buf(vdev->queue, p);
> +       return vb2_prepare_buf(vdev->queue, vdev->v4l2_dev->mdev, p);
>   }
>   EXPORT_SYMBOL_GPL(vb2_ioctl_prepare_buf);

> @@ -821,7 +879,7 @@ int vb2_ioctl_qbuf(struct file *file, void *priv,
struct v4l2_buffer *p)

>          if (vb2_queue_is_busy(vdev, file))
>                  return -EBUSY;
> -       return vb2_qbuf(vdev->queue, p);
> +       return vb2_qbuf(vdev->queue, vdev->v4l2_dev->mdev, p);
>   }
>   EXPORT_SYMBOL_GPL(vb2_ioctl_qbuf);

> diff --git a/drivers/media/platform/omap3isp/ispvideo.c
b/drivers/media/platform/omap3isp/ispvideo.c
> index bd564c2e767f..9fecbd8c6edd 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -940,7 +940,7 @@ isp_video_qbuf(struct file *file, void *fh, struct
v4l2_buffer *b)
>          int ret;

>          mutex_lock(&video->queue_lock);
> -       ret = vb2_qbuf(&vfh->queue, b);
> +       ret = vb2_qbuf(&vfh->queue, video->video.v4l2_dev->mdev, b);
>          mutex_unlock(&video->queue_lock);

>          return ret;
> diff --git a/drivers/media/platform/s3c-camif/camif-capture.c
b/drivers/media/platform/s3c-camif/camif-capture.c
> index 9ab8e7ee2e1e..fafb6da3e804 100644
> --- a/drivers/media/platform/s3c-camif/camif-capture.c
> +++ b/drivers/media/platform/s3c-camif/camif-capture.c
> @@ -941,7 +941,7 @@ static int s3c_camif_qbuf(struct file *file, void
*priv,
>          if (vp->owner && vp->owner != priv)
>                  return -EBUSY;

> -       return vb2_qbuf(&vp->vb_queue, buf);
> +       return vb2_qbuf(&vp->vb_queue, vp->vdev.v4l2_dev->mdev, buf);
>   }

>   static int s3c_camif_dqbuf(struct file *file, void *priv,
> @@ -979,7 +979,7 @@ static int s3c_camif_prepare_buf(struct file *file,
void *priv,
>                                   struct v4l2_buffer *b)
>   {
>          struct camif_vp *vp = video_drvdata(file);
> -       return vb2_prepare_buf(&vp->vb_queue, b);
> +       return vb2_prepare_buf(&vp->vb_queue, vp->vdev.v4l2_dev->mdev, b);
>   }

>   static int s3c_camif_g_selection(struct file *file, void *priv,
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> index 5cf4d9921264..3d863e3f5798 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -632,9 +632,9 @@ static int vidioc_qbuf(struct file *file, void *priv,
struct v4l2_buffer *buf)
>                  return -EIO;
>          }
>          if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> -               return vb2_qbuf(&ctx->vq_src, buf);
> +               return vb2_qbuf(&ctx->vq_src, NULL, buf);
>          else if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> -               return vb2_qbuf(&ctx->vq_dst, buf);
> +               return vb2_qbuf(&ctx->vq_dst, NULL, buf);
>          return -EINVAL;
>   }

> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index 5c0462ca9993..ed12d5d062e8 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -1621,9 +1621,9 @@ static int vidioc_qbuf(struct file *file, void
*priv, struct v4l2_buffer *buf)
>                          mfc_err("Call on QBUF after EOS command\n");
>                          return -EIO;
>                  }
> -               return vb2_qbuf(&ctx->vq_src, buf);
> +               return vb2_qbuf(&ctx->vq_src, NULL, buf);
>          } else if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> -               return vb2_qbuf(&ctx->vq_dst, buf);
> +               return vb2_qbuf(&ctx->vq_dst, NULL, buf);
>          }
>          return -EINVAL;
>   }
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c
b/drivers/media/platform/soc_camera/soc_camera.c
> index e6787abc34ae..08adf9a79420 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -394,7 +394,7 @@ static int soc_camera_qbuf(struct file *file, void
*priv,
>          if (icd->streamer != file)
>                  return -EBUSY;

> -       return vb2_qbuf(&icd->vb2_vidq, p);
> +       return vb2_qbuf(&icd->vb2_vidq, NULL, p);
>   }

>   static int soc_camera_dqbuf(struct file *file, void *priv,
> @@ -430,7 +430,7 @@ static int soc_camera_prepare_buf(struct file *file,
void *priv,
>   {
>          struct soc_camera_device *icd = file->private_data;

> -       return vb2_prepare_buf(&icd->vb2_vidq, b);
> +       return vb2_prepare_buf(&icd->vb2_vidq, NULL, b);
>   }

>   static int soc_camera_expbuf(struct file *file, void *priv,
> diff --git a/drivers/media/usb/uvc/uvc_queue.c
b/drivers/media/usb/uvc/uvc_queue.c
> index fecccb5e7628..8964e16f2b22 100644
> --- a/drivers/media/usb/uvc/uvc_queue.c
> +++ b/drivers/media/usb/uvc/uvc_queue.c
> @@ -300,12 +300,13 @@ int uvc_create_buffers(struct uvc_video_queue
*queue,
>          return ret;
>   }

> -int uvc_queue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer
*buf)
> +int uvc_queue_buffer(struct uvc_video_queue *queue,
> +                    struct media_device *mdev, struct v4l2_buffer *buf)
>   {
>          int ret;

>          mutex_lock(&queue->mutex);
> -       ret = vb2_qbuf(&queue->queue, buf);
> +       ret = vb2_qbuf(&queue->queue, mdev, buf);
>          mutex_unlock(&queue->mutex);

>          return ret;
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
b/drivers/media/usb/uvc/uvc_v4l2.c
> index bd32914259ae..3da5fdc002ac 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -751,7 +751,8 @@ static int uvc_ioctl_qbuf(struct file *file, void
*fh, struct v4l2_buffer *buf)
>          if (!uvc_has_privileges(handle))
>                  return -EBUSY;

> -       return uvc_queue_buffer(&stream->queue, buf);
> +       return uvc_queue_buffer(&stream->queue,
> +                               stream->vdev.v4l2_dev->mdev, buf);
>   }

>   static int uvc_ioctl_expbuf(struct file *file, void *fh,
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
b/drivers/media/usb/uvc/uvcvideo.h
> index be5cf179228b..bc9ed18f043c 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -680,6 +680,7 @@ int uvc_query_buffer(struct uvc_video_queue *queue,
>   int uvc_create_buffers(struct uvc_video_queue *queue,
>                         struct v4l2_create_buffers *v4l2_cb);
>   int uvc_queue_buffer(struct uvc_video_queue *queue,
> +                    struct media_device *mdev,
>                       struct v4l2_buffer *v4l2_buf);
>   int uvc_export_buffer(struct uvc_video_queue *queue,
>                        struct v4l2_exportbuffer *exp);
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c
b/drivers/media/v4l2-core/v4l2-mem2mem.c
> index c4f963d96a79..438f1b869319 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -20,6 +20,7 @@
>   #include <media/videobuf2-v4l2.h>
>   #include <media/v4l2-mem2mem.h>
>   #include <media/v4l2-dev.h>
> +#include <media/v4l2-device.h>
>   #include <media/v4l2-fh.h>
>   #include <media/v4l2-event.h>

> @@ -388,11 +389,12 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_querybuf);
>   int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
>                    struct v4l2_buffer *buf)
>   {
> +       struct video_device *vdev = video_devdata(file);
>          struct vb2_queue *vq;
>          int ret;

>          vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
> -       ret = vb2_qbuf(vq, buf);
> +       ret = vb2_qbuf(vq, vdev->v4l2_dev->mdev, buf);
>          if (!ret)
>                  v4l2_m2m_try_schedule(m2m_ctx);

> @@ -413,11 +415,12 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_dqbuf);
>   int v4l2_m2m_prepare_buf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
>                           struct v4l2_buffer *buf)
>   {
> +       struct video_device *vdev = video_devdata(file);
>          struct vb2_queue *vq;
>          int ret;

>          vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
> -       ret = vb2_prepare_buf(vq, buf);
> +       ret = vb2_prepare_buf(vq, vdev->v4l2_dev->mdev, buf);
>          if (!ret)
>                  v4l2_m2m_try_schedule(m2m_ctx);

> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c
b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> index 588743a6fd8a..00bf28e830d4 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -1426,7 +1426,8 @@ static int vpfe_qbuf(struct file *file, void *priv,
>                  return -EACCES;
>          }

> -       return vb2_qbuf(&video->buffer_queue, p);
> +       return vb2_qbuf(&video->buffer_queue,
> +                       video->video_dev.v4l2_dev->mdev, p);
>   }

>   /*
> diff --git a/drivers/staging/media/omap4iss/iss_video.c
b/drivers/staging/media/omap4iss/iss_video.c
> index a3a83424a926..a35d1004b522 100644
> --- a/drivers/staging/media/omap4iss/iss_video.c
> +++ b/drivers/staging/media/omap4iss/iss_video.c
> @@ -805,9 +805,10 @@ iss_video_querybuf(struct file *file, void *fh,
struct v4l2_buffer *b)
>   static int
>   iss_video_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
>   {
> +       struct iss_video *video = video_drvdata(file);
>          struct iss_video_fh *vfh = to_iss_video_fh(fh);

> -       return vb2_qbuf(&vfh->queue, b);
> +       return vb2_qbuf(&vfh->queue, video->video.v4l2_dev->mdev, b);
>   }

>   static int
> diff --git a/drivers/usb/gadget/function/uvc_queue.c
b/drivers/usb/gadget/function/uvc_queue.c
> index 9e33d5206d54..f2497cb96abb 100644
> --- a/drivers/usb/gadget/function/uvc_queue.c
> +++ b/drivers/usb/gadget/function/uvc_queue.c
> @@ -166,7 +166,7 @@ int uvcg_queue_buffer(struct uvc_video_queue *queue,
struct v4l2_buffer *buf)
>          unsigned long flags;
>          int ret;

> -       ret = vb2_qbuf(&queue->queue, buf);
> +       ret = vb2_qbuf(&queue->queue, NULL, buf);
>          if (ret < 0)
>                  return ret;

> diff --git a/include/media/videobuf2-v4l2.h
b/include/media/videobuf2-v4l2.h
> index 097bf3e6951d..cf312ab4e7e8 100644
> --- a/include/media/videobuf2-v4l2.h
> +++ b/include/media/videobuf2-v4l2.h
> @@ -79,6 +79,7 @@ int vb2_create_bufs(struct vb2_queue *q, struct
v4l2_create_buffers *create);
>    * vb2_prepare_buf() - Pass ownership of a buffer from userspace to the
kernel
>    *
>    * @q:         pointer to &struct vb2_queue with videobuf2 queue.
> + * @mdev:      pointer to &struct media_device, may be NULL.
>    * @b:         buffer structure passed from userspace to
>    *             &v4l2_ioctl_ops->vidioc_prepare_buf handler in driver
>    *
> @@ -90,15 +91,19 @@ int vb2_create_bufs(struct vb2_queue *q, struct
v4l2_create_buffers *create);
>    * #) verifies the passed buffer,
>    * #) calls &vb2_ops->buf_prepare callback in the driver (if provided),
>    *    in which driver-specific buffer initialization can be performed.
> + * #) if @b->request_fd is non-zero and @mdev->ops->req_queue is set,
> + *    then bind the prepared buffer to the request.
>    *
>    * The return values from this function are intended to be directly
returned
>    * from &v4l2_ioctl_ops->vidioc_prepare_buf handler in driver.
>    */
> -int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
> +int vb2_prepare_buf(struct vb2_queue *q, struct media_device *mdev,
> +                   struct v4l2_buffer *b);

>   /**
>    * vb2_qbuf() - Queue a buffer from userspace
>    * @q:         pointer to &struct vb2_queue with videobuf2 queue.
> + * @mdev:      pointer to &struct media_device, may be NULL.
>    * @b:         buffer structure passed from userspace to
>    *             &v4l2_ioctl_ops->vidioc_qbuf handler in driver
>    *
> @@ -107,6 +112,8 @@ int vb2_prepare_buf(struct vb2_queue *q, struct
v4l2_buffer *b);
>    * This function:
>    *
>    * #) verifies the passed buffer;
> + * #) if @b->request_fd is non-zero and @mdev->ops->req_queue is set,
> + *    then bind the buffer to the request.
>    * #) if necessary, calls &vb2_ops->buf_prepare callback in the driver
>    *    (if provided), in which driver-specific buffer initialization can
>    *    be performed;
> @@ -116,7 +123,8 @@ int vb2_prepare_buf(struct vb2_queue *q, struct
v4l2_buffer *b);
>    * The return values from this function are intended to be directly
returned
>    * from &v4l2_ioctl_ops->vidioc_qbuf handler in driver.
>    */
> -int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
> +int vb2_qbuf(struct vb2_queue *q, struct media_device *mdev,
> +            struct v4l2_buffer *b);

>   /**
>    * vb2_expbuf() - Export a buffer as a file descriptor
> --
> 2.16.3
