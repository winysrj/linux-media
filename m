Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60970 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751327AbcLEOqb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2016 09:46:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Todor Tomov <todor.tomov@linaro.org>, mchehab@kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        javier@osg.samsung.com, s.nawrocki@samsung.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        bjorn.andersson@linaro.org, srinivas.kandagatla@linaro.org
Subject: Re: [PATCH 08/10] media: camss: Add files which handle the video device nodes
Date: Mon, 05 Dec 2016 16:45:26 +0200
Message-ID: <16480551.5NNPjmTzBo@avalon>
In-Reply-To: <9b1cffbc-62a9-c699-5813-189d5f160343@xs4all.nl>
References: <1480085841-28276-1-git-send-email-todor.tomov@linaro.org> <1480085841-28276-7-git-send-email-todor.tomov@linaro.org> <9b1cffbc-62a9-c699-5813-189d5f160343@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Monday 05 Dec 2016 14:44:55 Hans Verkuil wrote:
> On 11/25/2016 03:57 PM, Todor Tomov wrote:
> > These files handle the video device nodes of the camss driver.
> >
> > Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> > ---
> >
> >  drivers/media/platform/qcom/camss-8x16/video.c | 597 ++++++++++++++++++++
> >  drivers/media/platform/qcom/camss-8x16/video.h |  67 +++
> >  2 files changed, 664 insertions(+)
> >  create mode 100644 drivers/media/platform/qcom/camss-8x16/video.c
> >  create mode 100644 drivers/media/platform/qcom/camss-8x16/video.h

[snip]

> > +int msm_video_register(struct camss_video *video, struct v4l2_device
> > *v4l2_dev,
> > +                    const char *name)
> > +{
> > +     struct media_pad *pad = &video->pad;
> > +     struct video_device *vdev;
> > +     struct vb2_queue *q;
> > +     int ret;
> > +
> > +     vdev = video_device_alloc();
> > +     if (vdev == NULL) {
> > +             dev_err(v4l2_dev->dev, "Failed to allocate video device\n");
> > +             return -ENOMEM;
> > +     }
> > +
> > +     video->vdev = vdev;
> > +
> > +     q = &video->vb2_q;
> > +     q->drv_priv = video;
> > +     q->mem_ops = &vb2_dma_contig_memops;
> > +     q->ops = &msm_video_vb2_q_ops;
> > +     q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> > +     q->io_modes = VB2_MMAP;
> 
> Add modes VB2_DMABUF and VB2_READ. These are for free, so why not?
> Especially DMABUF is of course very desirable to have.

I certainly agree with VB2_DMABUF, but I wouldn't expose VB2_READ. read() for 
this kind of device is inefficient and we should encourage userspace 
application to move away from it (and certainly make it very clear that new 
applications should not use read() with this device).

> > +     q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> > +     q->buf_struct_size = sizeof(struct camss_buffer);
> > +     q->dev = video->camss->dev;
> > +     ret = vb2_queue_init(q);
> > +     if (ret < 0) {
> > +             dev_err(v4l2_dev->dev, "Failed to init vb2 queue\n");
> > +             return ret;
> > +     }
> > +
> > +     pad->flags = MEDIA_PAD_FL_SINK;
> > +     ret = media_entity_pads_init(&vdev->entity, 1, pad);
> > +     if (ret < 0) {
> > +             dev_err(v4l2_dev->dev, "Failed to init video entity\n");
> > +             goto error_media_init;
> > +     }
> > +
> > +     vdev->fops = &msm_vid_fops;
> > +     vdev->ioctl_ops = &msm_vid_ioctl_ops;
> > +     vdev->release = video_device_release;
> > +     vdev->v4l2_dev = v4l2_dev;
> > +     vdev->vfl_dir = VFL_DIR_RX;
> > +     vdev->queue = &video->vb2_q;
> 
> As mentioned in querycap: set vdev->device_caps here.
> 
> > +     strlcpy(vdev->name, name, sizeof(vdev->name));
> > +
> > +     ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> > +     if (ret < 0) {
> > +             dev_err(v4l2_dev->dev, "Failed to register video device\n");
> > +             goto error_video_register;
> > +     }
> > +
> > +     video_set_drvdata(vdev, video);
> > +
> > +     return 0;
> > +
> > +error_video_register:
> > +     media_entity_cleanup(&vdev->entity);
> > +error_media_init:
> > +     vb2_queue_release(&video->vb2_q);
> > +
> > +     return ret;
> > +}

-- 
Regards,

Laurent Pinchart

