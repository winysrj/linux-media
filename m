Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:59579 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751045AbcHAICa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Aug 2016 04:02:30 -0400
Subject: Re: [PATCH RFC v2 2/2] media: platform: pxa_camera: make a standalone
 v4l2 device
To: Robert Jarzmik <robert.jarzmik@free.fr>
References: <1459607213-15774-1-git-send-email-robert.jarzmik@free.fr>
 <1459607213-15774-3-git-send-email-robert.jarzmik@free.fr>
 <0b6d669c-3b31-e165-da77-85af526b696b@xs4all.nl>
 <87wpk1yhmy.fsf@belgarion.home>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4bbccd41-f5af-5807-da17-f060b42b6c9b@xs4all.nl>
Date: Mon, 1 Aug 2016 10:02:23 +0200
MIME-Version: 1.0
In-Reply-To: <87wpk1yhmy.fsf@belgarion.home>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On 07/31/2016 05:03 PM, Robert Jarzmik wrote:
> Hi Hans,
> 
> 
> Hans Verkuil <hverkuil@xs4all.nl> writes:
>> On 04/02/2016 04:26 PM, Robert Jarzmik wrote:
>>> diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
>>> index b8dd878e98d6..30d266bbab55 100644
>>> --- a/drivers/media/platform/soc_camera/pxa_camera.c
>>> +++ b/drivers/media/platform/soc_camera/pxa_camera.c
>>
>> When you prepare the final patch series, please put the driver in
>> drivers/media/platform/pxa-camera and not in the soc-camera directory.
> Sure.
> Would you accept the final patch to make the move, so that I keep the
> bisectability, ie. that all patches are applied while still in ../soc_camera,
> and then the final one making just the move to .../platform ?

Sure, that's fine.

> 
>>> +	if (format->name)
>>> +		strlcpy(f->description, format->name, sizeof(f->description));
>>
>> You can drop this since the core fills in the description. That means the
>> 'name' field of struct soc_mbus_pixelfmt is not needed either.
> Ok, let's try this, for v3.
> 
>>> +static int pxac_vidioc_querycap(struct file *file, void *priv,
>>> +				struct v4l2_capability *cap)
>>> +{
>>> +	strlcpy(cap->bus_info, "platform:pxa-camera", sizeof(cap->bus_info));
>>> +	strlcpy(cap->driver, PXA_CAM_DRV_NAME, sizeof(cap->driver));
>>> +	strlcpy(cap->card, pxa_cam_driver_description, sizeof(cap->card));
>>> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
>>> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>>
>> Tiny fix: you can drop the capabilities assignment: the v4l2 core does that
>> for you these days.
> Well, above kernel v4.7, if I drop the assignement, v4l2-compliance -s finds 2
> new errors:
> 	Required ioctls:
> 			fail: v4l2-compliance.cpp(534): dcaps & ~caps
> 		test VIDIOC_QUERYCAP: FAIL
> 	
> 	Allow for multiple opens:
> 		test second video open: OK
> 			fail: v4l2-compliance.cpp(534): dcaps & ~caps
> 		test VIDIOC_QUERYCAP: FAIL
> 		test VIDIOC_G/S_PRIORITY: OK
> 
> So there is something fishy here if the core provides this data ...

Sorry, I forgot to say that you have to set the device_caps field of struct
video_device to V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING. You do that
where you set up the other fields of that structure.

The advantage is that the v4l2 core now knows the device capabilities and
it can use that information in the future.

> 
>>> +static int pxac_vidioc_enum_input(struct file *file, void *priv,
>>> +				  struct v4l2_input *i)
>>> +{
>>> +	if (i->index > 0)
>>> +		return -EINVAL;
>>> +
>>> +	memset(i, 0, sizeof(*i));
>>
>> The memset can be dropped, it's cleared for you.
> OK, for v3.
> 
>>> +static void pxac_vb2_queue(struct vb2_buffer *vb)
>>> +{
>>> +	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
>>> +	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
>>> +
>>> +	dev_dbg(pcdev_to_dev(pcdev),
>>> +		 "%s(vb=%p) nb_channels=%d size=%lu active=%p\n",
>>> +		__func__, vb, pcdev->channels, vb2_get_plane_payload(vb, 0),
>>> +		pcdev->active);
>>> +
>>> +	list_add_tail(&buf->queue, &pcdev->capture);
>>> +
>>> +	pxa_dma_add_tail_buf(pcdev, buf);
>>> +
>>> +	if (!pcdev->active)
>>> +		pxa_camera_start_capture(pcdev);
>>
>> This is normally done from start_streaming. Are you really sure this is the right
>> place? I strongly recommend moving this start_capture call.
> Well, it was at least with the previous framework.
> Previously this was done here to "hot-queue" a buffer :
>  - if a previous capture was still running, the buffer was queued by
>    pxa_dma_add_tail_buf(), and no restart of the DMA pump was necessary
>  - if the previous capture was finished, a new one was initiated
> 
> Now if the new framework takes care of that, I can move the
> pxa_camera_start_capture() into start_streaming(), no problem, let me try in the
> next patchset. That might take a bit of time because testing both the
> "hot-queue" and the "queue but hot-queuing missed" is a bit tricky.
> 
>> You may also want to use the struct vb2queue min_buffers_needed field to specify
>> the minimum number of buffers that should be queued up before start_streaming can
>> be called. Whether that's needed depends on your DMA engine.
> I have no minimum required by the pxa dmaengine driver, that's good.
> 
>>> +
>>> +	v4l2_disable_ioctl(vdev, VIDIOC_G_STD);
>>> +	v4l2_disable_ioctl(vdev, VIDIOC_S_STD);
>>> +	v4l2_disable_ioctl(vdev, VIDIOC_ENUMSTD);
>>
>> I don't think this is needed since the tvnorms field of struct video_device == 0,
>> signalling that there is no STD support.
> OK, for v3.
> 
> Cheers.
> 

Regards,

	Hans
