Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37030 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756530AbdAJLcY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jan 2017 06:32:24 -0500
Received: by mail-wm0-f42.google.com with SMTP id c206so68936672wme.0
        for <linux-media@vger.kernel.org>; Tue, 10 Jan 2017 03:32:23 -0800 (PST)
Subject: Re: [PATCH 08/10] media: camss: Add files which handle the video
 device nodes
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <1480085841-28276-1-git-send-email-todor.tomov@linaro.org>
 <16480551.5NNPjmTzBo@avalon> <90199b5b-f71a-fadf-29ec-ccd032dce4ca@xs4all.nl>
 <1774027.HEDcIz8E3N@avalon>
Cc: mchehab@kernel.org, laurent.pinchart+renesas@ideasonboard.com,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, bjorn.andersson@linaro.org,
        srinivas.kandagatla@linaro.org
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <5874C645.8000102@linaro.org>
Date: Tue, 10 Jan 2017 13:32:21 +0200
MIME-Version: 1.0
In-Reply-To: <1774027.HEDcIz8E3N@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent, Hans,

On 12/05/2016 05:25 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday 05 Dec 2016 16:02:55 Hans Verkuil wrote:
>> On 12/05/2016 03:45 PM, Laurent Pinchart wrote:
>>> On Monday 05 Dec 2016 14:44:55 Hans Verkuil wrote:
>>>> On 11/25/2016 03:57 PM, Todor Tomov wrote:
>>>>> These files handle the video device nodes of the camss driver.
>>>>>
>>>>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>>>>> ---
>>>>>
>>>>>  drivers/media/platform/qcom/camss-8x16/video.c | 597 +++++++++++++++++
>>>>>  drivers/media/platform/qcom/camss-8x16/video.h |  67 +++
>>>>>  2 files changed, 664 insertions(+)
>>>>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/video.c
>>>>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/video.h
>>>
>>> [snip]
>>>
>>>>> +int msm_video_register(struct camss_video *video, struct v4l2_device
>>>>> *v4l2_dev,
>>>>> +                    const char *name)
>>>>> +{
>>>>> +     struct media_pad *pad = &video->pad;
>>>>> +     struct video_device *vdev;
>>>>> +     struct vb2_queue *q;
>>>>> +     int ret;
>>>>> +
>>>>> +     vdev = video_device_alloc();
>>>>> +     if (vdev == NULL) {
>>>>> +             dev_err(v4l2_dev->dev, "Failed to allocate video
>>>>> device\n");
>>>>> +             return -ENOMEM;
>>>>> +     }
>>>>> +
>>>>> +     video->vdev = vdev;
>>>>> +
>>>>> +     q = &video->vb2_q;
>>>>> +     q->drv_priv = video;
>>>>> +     q->mem_ops = &vb2_dma_contig_memops;
>>>>> +     q->ops = &msm_video_vb2_q_ops;
>>>>> +     q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>>>>> +     q->io_modes = VB2_MMAP;
>>>>
>>>> Add modes VB2_DMABUF and VB2_READ. These are for free, so why not?
>>>> Especially DMABUF is of course very desirable to have.
>>>
>>> I certainly agree with VB2_DMABUF, but I wouldn't expose VB2_READ. read()
>>> for this kind of device is inefficient and we should encourage userspace
>>> application to move away from it (and certainly make it very clear that
>>> new applications should not use read() with this device).
>>
>> VB2_READ is very nice when debugging (no need to program a stream I/O
>> application first)
> 
> There's at least v4l2-ctl and yavta that can (and should) be used for 
> debugging ;-)
> 
>> and useful when you want to pipe the video.
> 
> Except that you lose frame boundaries. It's really a poor man's solution that 
> should never be used in any "real" application. I'd rather add an option to 
> v4l2-ctl to output the video stream to stdout (and/or stderr).
> 
>> Nobody uses read() in 'regular' applications since it is obviously
>> inefficient, but I don't see that as a reason not to offer VB2_READ.
>>
>> I don't think this is something anyone will ever abuse,
> 
> Famous last words ;-)
> 
>> and it is a nice feature to have (and for free as well).
> 

Thank you for the discussion over this. Both of you have reasonable arguments
about the read i/o.
I'd say that you cannot always save a person from himself. I'll add VB2_READ.

-- 
Best regards,
Todor Tomov
