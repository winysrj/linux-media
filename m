Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:58304 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751100AbcLEPEY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Dec 2016 10:04:24 -0500
Subject: Re: [PATCH 08/10] media: camss: Add files which handle the video
 device nodes
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1480085841-28276-1-git-send-email-todor.tomov@linaro.org>
 <1480085841-28276-7-git-send-email-todor.tomov@linaro.org>
 <9b1cffbc-62a9-c699-5813-189d5f160343@xs4all.nl> <16480551.5NNPjmTzBo@avalon>
Cc: Todor Tomov <todor.tomov@linaro.org>, mchehab@kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        javier@osg.samsung.com, s.nawrocki@samsung.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        bjorn.andersson@linaro.org, srinivas.kandagatla@linaro.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <90199b5b-f71a-fadf-29ec-ccd032dce4ca@xs4all.nl>
Date: Mon, 5 Dec 2016 16:02:55 +0100
MIME-Version: 1.0
In-Reply-To: <16480551.5NNPjmTzBo@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/05/2016 03:45 PM, Laurent Pinchart wrote:
> Hello,
> 
> On Monday 05 Dec 2016 14:44:55 Hans Verkuil wrote:
>> On 11/25/2016 03:57 PM, Todor Tomov wrote:
>>> These files handle the video device nodes of the camss driver.
>>>
>>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>>> ---
>>>
>>>  drivers/media/platform/qcom/camss-8x16/video.c | 597 ++++++++++++++++++++
>>>  drivers/media/platform/qcom/camss-8x16/video.h |  67 +++
>>>  2 files changed, 664 insertions(+)
>>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/video.c
>>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/video.h
> 
> [snip]
> 
>>> +int msm_video_register(struct camss_video *video, struct v4l2_device
>>> *v4l2_dev,
>>> +                    const char *name)
>>> +{
>>> +     struct media_pad *pad = &video->pad;
>>> +     struct video_device *vdev;
>>> +     struct vb2_queue *q;
>>> +     int ret;
>>> +
>>> +     vdev = video_device_alloc();
>>> +     if (vdev == NULL) {
>>> +             dev_err(v4l2_dev->dev, "Failed to allocate video device\n");
>>> +             return -ENOMEM;
>>> +     }
>>> +
>>> +     video->vdev = vdev;
>>> +
>>> +     q = &video->vb2_q;
>>> +     q->drv_priv = video;
>>> +     q->mem_ops = &vb2_dma_contig_memops;
>>> +     q->ops = &msm_video_vb2_q_ops;
>>> +     q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>>> +     q->io_modes = VB2_MMAP;
>>
>> Add modes VB2_DMABUF and VB2_READ. These are for free, so why not?
>> Especially DMABUF is of course very desirable to have.
> 
> I certainly agree with VB2_DMABUF, but I wouldn't expose VB2_READ. read() for 
> this kind of device is inefficient and we should encourage userspace 
> application to move away from it (and certainly make it very clear that new 
> applications should not use read() with this device).

VB2_READ is very nice when debugging (no need to program a stream I/O application first)
and useful when you want to pipe the video.

Nobody uses read() in 'regular' applications since it is obviously inefficient, but
I don't see that as a reason not to offer VB2_READ.

I don't think this is something anyone will ever abuse, and it is a nice feature
to have (and for free as well).

Regards,

	Hans
