Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 068CEC43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 12:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C19C020842
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 12:41:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="VFrZTI1s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbfCEMlx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 07:41:53 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:33304 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbfCEMlw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 07:41:52 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id DA75A24A;
        Tue,  5 Mar 2019 13:41:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1551789710;
        bh=Z31+AfwVSPGT7wCcqe92FZgfK2nO8xnTWoi0PIbqGjM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VFrZTI1sGn8Jx2lIbLLiCHQJ7hgNAiWpsm3giVa7hQJVcPIkY36eX/9T0xivPfozu
         YX9Kr6q2mXzDt+tgQRlilSy8yo1WtIH867qtkZppseHOwXt128uafhlJyZuLgO+eZC
         3j1lWWLVnmTOMCEPgua8rtCVPwcAcD8LmIRvkabI=
Date:   Tue, 5 Mar 2019 14:41:43 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hugues FRUCHET <hugues.fruchet@st.com>
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: uvcvideo: Read support
Message-ID: <20190305124143.GA4949@pendragon.ideasonboard.com>
References: <1551702925-7739-1-git-send-email-hugues.fruchet@st.com>
 <1551702925-7739-2-git-send-email-hugues.fruchet@st.com>
 <8ec96fe6-96af-c101-ff20-ab59d953ad6a@ideasonboard.com>
 <20190304154458.GO6325@pendragon.ideasonboard.com>
 <eb707933-4309-bb65-ad73-d933278a3c5d@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <eb707933-4309-bb65-ad73-d933278a3c5d@st.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hugues,

On Tue, Mar 05, 2019 at 10:24:15AM +0000, Hugues FRUCHET wrote:
> On 3/4/19 4:44 PM, Laurent Pinchart wrote:
> > On Mon, Mar 04, 2019 at 03:36:32PM +0000, Kieran Bingham wrote:
> >> On 04/03/2019 12:35, Hugues Fruchet wrote:
> >>> Add support of read() call from userspace by implementing
> >>> uvc_v4l2_read() with vb2_read() helper.
> >>
> >> Just thinking out loud,
> >>
> >> This opens up UVC devices to read raw full frame images through this
> >> interface as well.
> >>
> >> Due to the UVC protocol, there is /already/ a full memcpy to get these
> >> images out of the URB packets, so using a read() interface would be
> >> another full frame copy.
> >>
> >> I can perhaps see the usecase for reading compressed data through this
> >> interface - but full frames don't seem appropriate. (not impossible of
> >> course, just is it reasonable?)
> >>
> >> If this is to be enabled, should it be enabled for compressed formats
> >> only? or would that complicate matters?
> > 
> > I've repeatedly refused read() support in uvcvideo for this reason, and
> > also because read() doesn't carry framing information very well. It's
> > just not a good API for capturing video frames from a webcam, and so far
> > I haven't heard a compeling reason why it should be enabled. I thus
> > haven't changed my mind :-)
> 
> For sure read() is not optimal, but is very common and pretty simple to 
> use from userspace as explained in the cover letter with some examples.
> 
> Moreover, read() is enabled by many (all ?) camera interfaces:
> 
> drivers/media/platform/pxa_camera.c:	.read		= vb2_fop_read,
> drivers/media/platform/atmel/atmel-isi.c:	.read	= vb2_fop_read,
> drivers/media/platform/rcar-vin/rcar-v4l2.c:	.read	= vb2_fop_read,
> drivers/media/platform/stm32/stm32-dcmi.c:	.read	= vb2_fop_read,
> drivers/media/platform/vivid/vivid-core.c:	.read   = vb2_fop_read,
> drivers/media/platform/vimc/vimc-capture.c:	.read   = vb2_fop_read,
> drivers/media/platform/marvell-ccic/mcam-core.c:.read   = vb2_fop_read,
> drivers/media/platform/qcom/camss/camss-video.c:.read	= vb2_fop_read,

Cargo-cult doesn't mean we have to repear the same mistakes everywhere
:-)

> on my setup, this leads to have /dev/video0 (mapped on DCMI camera 
> interface) supporting JPEG streaming through read() while /dev/video1 
> (mapped on Hercule USB camera) fails with "invalid argument" error...

Let's not encourage applications to use inefficient interfaces, when
using streaming I/O wouldn't be that more difficult. I'd argue that
supporting read() in the above drivers is part of the problem, not of
the solution.

> >>> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> >>> ---
> >>>   drivers/media/usb/uvc/uvc_queue.c | 15 ++++++++++++++-
> >>>   drivers/media/usb/uvc/uvc_v4l2.c  | 11 ++++++++---
> >>>   drivers/media/usb/uvc/uvcvideo.h  |  2 ++
> >>>   3 files changed, 24 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
> >>> index 682698e..0c8a0a8 100644
> >>> --- a/drivers/media/usb/uvc/uvc_queue.c
> >>> +++ b/drivers/media/usb/uvc/uvc_queue.c
> >>> @@ -227,7 +227,7 @@ int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
> >>>   	int ret;
> >>>   
> >>>   	queue->queue.type = type;
> >>> -	queue->queue.io_modes = VB2_MMAP | VB2_USERPTR;
> >>> +	queue->queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
> >>>   	queue->queue.drv_priv = queue;
> >>>   	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
> >>>   	queue->queue.mem_ops = &vb2_vmalloc_memops;
> >>> @@ -361,6 +361,19 @@ int uvc_queue_streamoff(struct uvc_video_queue *queue, enum v4l2_buf_type type)
> >>>   	return ret;
> >>>   }
> >>>   
> >>> +ssize_t uvc_queue_read(struct uvc_video_queue *queue, struct file *file,
> >>> +		       char __user *buf, size_t count, loff_t *ppos)
> >>> +{
> >>> +	ssize_t ret;
> >>> +
> >>> +	mutex_lock(&queue->mutex);
> >>> +	ret = vb2_read(&queue->queue, buf, count, ppos,
> >>> +		       file->f_flags & O_NONBLOCK);
> >>> +	mutex_unlock(&queue->mutex);
> >>> +
> >>> +	return ret;
> >>> +}
> >>> +
> >>>   int uvc_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma)
> >>>   {
> >>>   	return vb2_mmap(&queue->queue, vma);
> >>> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
> >>> index 84be596..3866832 100644
> >>> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> >>> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> >>> @@ -594,7 +594,8 @@ static int uvc_ioctl_querycap(struct file *file, void *fh,
> >>>   	strscpy(cap->driver, "uvcvideo", sizeof(cap->driver));
> >>>   	strscpy(cap->card, vdev->name, sizeof(cap->card));
> >>>   	usb_make_path(stream->dev->udev, cap->bus_info, sizeof(cap->bus_info));
> >>> -	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
> >>> +	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING |
> >>> +			    V4L2_CAP_READWRITE
> >>>   			  | chain->caps;
> >>>   
> >>>   	return 0;
> >>> @@ -1434,8 +1435,12 @@ static long uvc_v4l2_compat_ioctl32(struct file *file,
> >>>   static ssize_t uvc_v4l2_read(struct file *file, char __user *data,
> >>>   		    size_t count, loff_t *ppos)
> >>>   {
> >>> -	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_read: not implemented.\n");
> >>> -	return -EINVAL;
> >>> +	struct uvc_fh *handle = file->private_data;
> >>> +	struct uvc_streaming *stream = handle->stream;
> >>> +
> >>> +	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_read\n");
> >>> +
> >>> +	return uvc_queue_read(&stream->queue, file, data, count, ppos);
> >>>   }
> >>>   
> >>>   static int uvc_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
> >>> diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
> >>> index c7c1baa..5d0515c 100644
> >>> --- a/drivers/media/usb/uvc/uvcvideo.h
> >>> +++ b/drivers/media/usb/uvc/uvcvideo.h
> >>> @@ -766,6 +766,8 @@ struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
> >>>   					 struct uvc_buffer *buf);
> >>>   struct uvc_buffer *uvc_queue_get_current_buffer(struct uvc_video_queue *queue);
> >>>   void uvc_queue_buffer_release(struct uvc_buffer *buf);
> >>> +ssize_t uvc_queue_read(struct uvc_video_queue *queue, struct file *file,
> >>> +		       char __user *buf, size_t count, loff_t *ppos);
> >>>   int uvc_queue_mmap(struct uvc_video_queue *queue,
> >>>   		   struct vm_area_struct *vma);
> >>>   __poll_t uvc_queue_poll(struct uvc_video_queue *queue, struct file *file,

-- 
Regards,

Laurent Pinchart
