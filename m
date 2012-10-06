Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1378 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab2JFMWk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Oct 2012 08:22:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCHv9 19/25] v4l: vb2: add buffer exporting via dmabuf
Date: Sat, 6 Oct 2012 14:22:27 +0200
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, zhangfei.gao@gmail.com,
	s.nawrocki@samsung.com, k.debski@samsung.com
References: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com> <1349188056-4886-20-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1349188056-4886-20-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210061422.27704.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue October 2 2012 16:27:30 Tomasz Stanislawski wrote:
> This patch adds extension to videobuf2-core. It allow to export a mmap buffer
> as a file descriptor.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/videobuf2-core.c |   82 ++++++++++++++++++++++++++++++++++
>  include/media/videobuf2-core.h       |    4 ++
>  2 files changed, 86 insertions(+)
> 
> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index 05da3b4..a97815b 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c

<snip>

> @@ -2455,6 +2528,15 @@ int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
>  }
>  EXPORT_SYMBOL_GPL(vb2_ioctl_streamoff);
>  
> +int vb2_ioctl_expbuf(struct file *file, void *priv, struct v4l2_exportbuffer *p)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +
> +	/* No need to call vb2_queue_is_busy(), anyone can export buffers. */

After thinking about this some more I'm not so sure we should allow this.
Exporting a buffer also means that the memory can't be freed as long as the
exported filehandle remains open.

That means that it is possible to make a malicious application that exports
the buffers and never frees them, which can cause havoc. I think that only
the filehandle that called REQBUFS/CREATE_BUFS should be allowed to export
buffers.

What do you think?

Regards,

	Hans

> +	return vb2_expbuf(vdev->queue, p);
> +}
> +EXPORT_SYMBOL_GPL(vb2_ioctl_expbuf);
> +
>  /* v4l2_file_operations helpers */
>  
>  int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
