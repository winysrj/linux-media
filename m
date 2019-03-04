Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A664EC43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 12:54:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7833520449
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 12:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfCDMyK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 07:54:10 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:47132 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726101AbfCDMyK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Mar 2019 07:54:10 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id 0n6ZhHDWRI8AW0n6dh0dA9; Mon, 04 Mar 2019 13:54:07 +0100
Subject: Re: [PATCH] media: uvcvideo: Read support
To:     Hugues Fruchet <hugues.fruchet@st.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1551702925-7739-1-git-send-email-hugues.fruchet@st.com>
 <1551702925-7739-2-git-send-email-hugues.fruchet@st.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6e1739dd-861f-98a6-9e31-5b1cc1c91493@xs4all.nl>
Date:   Mon, 4 Mar 2019 13:54:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1551702925-7739-2-git-send-email-hugues.fruchet@st.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfJyzuvc0is7L1BUldMbTjMxBoH98AX4iuf+2bklV+kE69HG85TnyF1M0e3azUf2cZpO7t4LUYXv2bStjjswaOTaS99EfUA5W+boNgmGglRsaoBUZxLql
 semCG0VMeNCUVnpuxCAr9ieL5iTujkHLT4oav5sI31Bgt1cy/mRtZ+vGZTN1RU46PlKMZJo1w7XGdZH+YJeYKXil/vOA+uNA+FPJMuKIkbPKUU6Oify7GG/u
 zFusRr0UpTb4/uZ5bLPToIpQQmZxEKi/zrBTzGvSBhsO+NwCypl/TTKO6vtn7mn/mKe/R0hqngUnHC5Y6xcVbV+5EgYNuNpurrruVle1iPk=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/4/19 1:35 PM, Hugues Fruchet wrote:
> Add support of read() call from userspace by implementing
> uvc_v4l2_read() with vb2_read() helper.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  drivers/media/usb/uvc/uvc_queue.c | 15 ++++++++++++++-
>  drivers/media/usb/uvc/uvc_v4l2.c  | 11 ++++++++---
>  drivers/media/usb/uvc/uvcvideo.h  |  2 ++
>  3 files changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
> index 682698e..0c8a0a8 100644
> --- a/drivers/media/usb/uvc/uvc_queue.c
> +++ b/drivers/media/usb/uvc/uvc_queue.c
> @@ -227,7 +227,7 @@ int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
>  	int ret;
>  
>  	queue->queue.type = type;
> -	queue->queue.io_modes = VB2_MMAP | VB2_USERPTR;
> +	queue->queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
>  	queue->queue.drv_priv = queue;
>  	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
>  	queue->queue.mem_ops = &vb2_vmalloc_memops;
> @@ -361,6 +361,19 @@ int uvc_queue_streamoff(struct uvc_video_queue *queue, enum v4l2_buf_type type)
>  	return ret;
>  }
>  
> +ssize_t uvc_queue_read(struct uvc_video_queue *queue, struct file *file,
> +		       char __user *buf, size_t count, loff_t *ppos)
> +{
> +	ssize_t ret;
> +
> +	mutex_lock(&queue->mutex);
> +	ret = vb2_read(&queue->queue, buf, count, ppos,
> +		       file->f_flags & O_NONBLOCK);
> +	mutex_unlock(&queue->mutex);
> +
> +	return ret;
> +}
> +
>  int uvc_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma)
>  {
>  	return vb2_mmap(&queue->queue, vma);
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
> index 84be596..3866832 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -594,7 +594,8 @@ static int uvc_ioctl_querycap(struct file *file, void *fh,
>  	strscpy(cap->driver, "uvcvideo", sizeof(cap->driver));
>  	strscpy(cap->card, vdev->name, sizeof(cap->card));
>  	usb_make_path(stream->dev->udev, cap->bus_info, sizeof(cap->bus_info));
> -	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
> +	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING |
> +			    V4L2_CAP_READWRITE
>  			  | chain->caps;

device_caps for VIDEO_CAPTURE should also get V4L2_CAP_READWRITE. See uvc_register_video_device().

Regards,

	Hans

>  
>  	return 0;
> @@ -1434,8 +1435,12 @@ static long uvc_v4l2_compat_ioctl32(struct file *file,
>  static ssize_t uvc_v4l2_read(struct file *file, char __user *data,
>  		    size_t count, loff_t *ppos)
>  {
> -	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_read: not implemented.\n");
> -	return -EINVAL;
> +	struct uvc_fh *handle = file->private_data;
> +	struct uvc_streaming *stream = handle->stream;
> +
> +	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_read\n");
> +
> +	return uvc_queue_read(&stream->queue, file, data, count, ppos);
>  }
>  
>  static int uvc_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
> diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
> index c7c1baa..5d0515c 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -766,6 +766,8 @@ struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
>  					 struct uvc_buffer *buf);
>  struct uvc_buffer *uvc_queue_get_current_buffer(struct uvc_video_queue *queue);
>  void uvc_queue_buffer_release(struct uvc_buffer *buf);
> +ssize_t uvc_queue_read(struct uvc_video_queue *queue, struct file *file,
> +		       char __user *buf, size_t count, loff_t *ppos);
>  int uvc_queue_mmap(struct uvc_video_queue *queue,
>  		   struct vm_area_struct *vma);
>  __poll_t uvc_queue_poll(struct uvc_video_queue *queue, struct file *file,
> 

