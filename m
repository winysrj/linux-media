Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48202 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab2BCPvO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2012 10:51:14 -0500
Received: by vbjk17 with SMTP id k17so2630957vbj.19
        for <linux-media@vger.kernel.org>; Fri, 03 Feb 2012 07:51:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1327326675-8431-6-git-send-email-t.stanislaws@samsung.com>
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com> <1327326675-8431-6-git-send-email-t.stanislaws@samsung.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Fri, 3 Feb 2012 07:50:34 -0800
Message-ID: <CAMm-=zDnNev25-9t5jXK_wuormpr5D1zEFtunDzVTp_PWnkO9g@mail.gmail.com>
Subject: Re: [PATCH 05/10] v4l: add buffer exporting via dmabuf
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	sumit.semwal@ti.com, jesse.barker@linaro.org, rob@ti.com,
	daniel@ffwll.ch, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Mon, Jan 23, 2012 at 05:51, Tomasz Stanislawski
<t.stanislaws@samsung.com> wrote:
> This patch adds extension to V4L2 api. It allow to export a mmap buffer as file
> descriptor. New ioctl VIDIOC_EXPBUF is added. It takes a buffer offset used by
> mmap and return a file descriptor on success.
>
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/v4l2-compat-ioctl32.c |    1 +
>  drivers/media/video/v4l2-ioctl.c          |   11 +++++++++++
>  include/linux/videodev2.h                 |    1 +
>  include/media/v4l2-ioctl.h                |    1 +
>  4 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
> index c68531b..0f18b5e 100644
> --- a/drivers/media/video/v4l2-compat-ioctl32.c
> +++ b/drivers/media/video/v4l2-compat-ioctl32.c
> @@ -954,6 +954,7 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
>        case VIDIOC_S_FBUF32:
>        case VIDIOC_OVERLAY32:
>        case VIDIOC_QBUF32:
> +       case VIDIOC_EXPBUF:
>        case VIDIOC_DQBUF32:
>        case VIDIOC_STREAMON32:
>        case VIDIOC_STREAMOFF32:
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index e1da8fc..cb29e00 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -207,6 +207,7 @@ static const char *v4l2_ioctls[] = {
>        [_IOC_NR(VIDIOC_S_FBUF)]           = "VIDIOC_S_FBUF",
>        [_IOC_NR(VIDIOC_OVERLAY)]          = "VIDIOC_OVERLAY",
>        [_IOC_NR(VIDIOC_QBUF)]             = "VIDIOC_QBUF",
> +       [_IOC_NR(VIDIOC_EXPBUF)]           = "VIDIOC_EXPBUF",
>        [_IOC_NR(VIDIOC_DQBUF)]            = "VIDIOC_DQBUF",
>        [_IOC_NR(VIDIOC_STREAMON)]         = "VIDIOC_STREAMON",
>        [_IOC_NR(VIDIOC_STREAMOFF)]        = "VIDIOC_STREAMOFF",
> @@ -932,6 +933,16 @@ static long __video_do_ioctl(struct file *file,
>                        dbgbuf(cmd, vfd, p);
>                break;
>        }
> +       case VIDIOC_EXPBUF:
> +       {
> +               unsigned int *p = arg;
> +
> +               if (!ops->vidioc_expbuf)
> +                       break;
> +
> +               ret = ops->vidioc_expbuf(file, fh, *p);
> +               break;
> +       }

Personally, I believe we shouldn't just limit this to one u32
argument. Granted, right now this indeed is enough for MMAP buffers,
but maybe we should be careful here and not make future additions
impossible? Perhaps, in the future, a use case surfaces that requires
a different argument than an offset? Or maybe new memory types are
added to V4L2 and this prevents us from supporting them? Or, perhaps,
dmabuf adds new functionality that could be controlled from the
userspace (some flags or something for example) and we wouldn't be
able to support them here?

I just feel this is not symmetric to the other parts of V4L2 API and
does not leave us prepared for any future additions to V4L2 and/or
dmabuf. I feel we should use a structure here instead and keep it
symmetric with REQBUFS and other ioctls (with regards to memory types,
union for offset/etc.), and also add a few reserved fields.

[snip]

-- 
Best regards,
Pawel Osciak
