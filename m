Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:45439 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751181AbdEHNIc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 09:08:32 -0400
Subject: Re: [PATCH 3/3] [media] intel-ipu3: cio2: Add new MIPI-CSI2 driver
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, jian.xu.zheng@intel.com,
        rajmohan.mani@intel.com, hyungwoo.yang@intel.com
References: <cover.1493479141.git.yong.zhi@intel.com>
 <9cf19d01f6f85ac0e5969a2b2fcd5ad5ef8c1e22.1493479141.git.yong.zhi@intel.com>
 <a33ac20c-5a72-3e6e-c55c-78bdb46449a5@xs4all.nl>
 <20170508121003.GJ7456@valkosipuli.retiisi.org.uk>
 <8dbaa458-6476-ac3b-daf3-785b0f591a69@xs4all.nl>
 <20170508125620.GK7456@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1b0cde5d-37a9-2274-43a2-c242e2b944f5@xs4all.nl>
Date: Mon, 8 May 2017 15:08:26 +0200
MIME-Version: 1.0
In-Reply-To: <20170508125620.GK7456@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/08/2017 02:56 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Mon, May 08, 2017 at 02:32:22PM +0200, Hans Verkuil wrote:
>> On 05/08/2017 02:10 PM, Sakari Ailus wrote:
> 
> ...
> 
>>>>> +/* .complete() is called after all subdevices have been located */
>>>>> +static int cio2_notifier_complete(struct v4l2_async_notifier *notifier)
>>>>> +{
>>>>> +	struct cio2_device *cio2 = container_of(notifier, struct cio2_device,
>>>>> +						notifier);
>>>>> +	struct sensor_async_subdev *s_asd;
>>>>> +	struct fwnode_handle *fwn_remote, *fwn_endpt, *fwn_remote_endpt;
>>>>> +	struct cio2_queue *q;
>>>>> +	struct fwnode_endpoint remote_endpt;
>>>>> +	int i, ret;
>>>>> +
>>>>> +	for (i = 0; i < notifier->num_subdevs; i++) {
>>>>> +		s_asd = container_of(cio2->notifier.subdevs[i],
>>>>> +					struct sensor_async_subdev,
>>>>> +					asd);
>>>>> +
>>>>> +		fwn_remote = s_asd->asd.match.fwnode.fwn;
>>>>> +		fwn_endpt = (struct fwnode_handle *)
>>>>> +					s_asd->vfwn_endpt.base.local_fwnode;
>>>>> +		fwn_remote_endpt = fwnode_graph_get_remote_endpoint(fwn_endpt);
>>>>> +		if (!fwn_remote_endpt) {
>>>>> +			dev_err(&cio2->pci_dev->dev,
>>>>> +					"failed to get remote endpt %d\n", ret);
>>>>> +			return ret;
>>>>> +		}
>>>>> +
>>>>> +		ret = fwnode_graph_parse_endpoint(fwn_remote_endpt,
>>>>> +							&remote_endpt);
>>>>> +		if (ret) {
>>>>> +			dev_err(&cio2->pci_dev->dev,
>>>>> +				"failed to parse remote endpt %d\n", ret);
>>>>> +			return ret;
>>>>> +		}
>>>>> +
>>>>> +		q = cio2_find_queue_by_sensor_node(cio2->queue, fwn_remote);
>>>>> +		if (!q) {
>>>>> +			dev_err(&cio2->pci_dev->dev,
>>>>> +					"failed to find cio2 queue %d\n", ret);
>>>>> +			return ret;
>>>>> +		}
>>>>> +
>>>>> +		ret = media_create_pad_link(
>>>>> +				&q->sensor->entity, remote_endpt.id,
>>>>> +				&q->subdev.entity, s_asd->vfwn_endpt.base.id,
>>>>> +				0);
>>>>> +		if (ret) {
>>>>> +			dev_err(&cio2->pci_dev->dev,
>>>>> +					"failed to create link for %s\n",
>>>>> +					cio2->queue[i].sensor->name);
>>>>> +			return ret;
>>>>> +		}
>>>>> +	}
>>>>> +
>>>>> +	return v4l2_device_register_subdev_nodes(&cio2->v4l2_dev);
>>>>> +}
>>>>
>>>> The current code only supports sensor subdevs, right? Not non-sensor subdevs such as
>>>> for focus etc. control (e.g. voice coil).
>>>
>>> The CIO2 driver only supports sensors (I presume you could attach e.g. a TV
>>> tuner, too) but then again I don't think it's its job to support voice coils
>>> either: they're related to the sensors instead and the CIO2 driver wouldn't
>>> have enough information on them to associate them to a particular sensor.
>>>
>>> There are DT binding patches for such devices + async sub-device notifier
>>> patches floating around to support these.
>>
>> Can you give me a pointer to those?
> 
> Certainly. Lens etc. DT bindings:
> 
> <URL:http://www.spinics.net/lists/linux-media/msg115272.html>
> 
> And async sub-device notifier support:
> 
> <URL:http://www.spinics.net/lists/linux-media/msg114915.html>
> 
> ...
> 
>>>>> +
>>>>> +	q->pixelformat = V4L2_PIX_FMT_IPU3_SRGGB10;
>>>>> +
>>>>> +	/* Initialize fbpt */
>>>>> +	r = cio2_fbpt_init(cio2, q);
>>>>> +	if (r)
>>>>> +		goto fail_fbpt;
>>>>> +
>>>>> +	/* Initialize media entities */
>>>>> +	r = media_entity_pads_init(&subdev->entity, CIO2_PADS, q->subdev_pads);
>>>>> +	if (r) {
>>>>> +		dev_err(&cio2->pci_dev->dev,
>>>>> +			"failed initialize subdev media entity (%d)\n", r);
>>>>> +		goto fail_subdev_media_entity;
>>>>> +	}
>>>>> +	q->subdev_pads[CIO2_PAD_SINK].flags = MEDIA_PAD_FL_SINK |
>>>>> +		MEDIA_PAD_FL_MUST_CONNECT;
>>>>> +	q->subdev_pads[CIO2_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
>>>>> +	subdev->entity.ops = &cio2_media_ops;
>>>>> +	r = media_entity_pads_init(&vdev->entity, 1, &q->vdev_pad);
>>>>> +	if (r) {
>>>>> +		dev_err(&cio2->pci_dev->dev,
>>>>> +			"failed initialize videodev media entity (%d)\n", r);
>>>>> +		goto fail_vdev_media_entity;
>>>>> +	}
>>>>> +	q->vdev_pad.flags = MEDIA_PAD_FL_SINK | MEDIA_PAD_FL_MUST_CONNECT;
>>>>> +	vdev->entity.ops = &cio2_media_ops;
>>>>> +
>>>>> +	/* Initialize subdev */
>>>>> +	v4l2_subdev_init(subdev, &cio2_subdev_ops);
>>>>> +	subdev->flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
>>>>> +	subdev->owner = THIS_MODULE;
>>>>> +	snprintf(subdev->name, sizeof(subdev->name),
>>>>> +		 CIO2_ENTITY_NAME ":%li", q - cio2->queue);
>>>>> +	v4l2_set_subdevdata(subdev, cio2);
>>>>> +	r = v4l2_device_register_subdev(&cio2->v4l2_dev, subdev);
>>>>> +	if (r) {
>>>>> +		dev_err(&cio2->pci_dev->dev,
>>>>> +			"failed initialize subdev (%d)\n", r);
>>>>> +		goto fail_subdev;
>>>>> +	}
>>>>> +
>>>>> +	/* Initialize vbq */
>>>>> +	vbq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>>>>> +	vbq->io_modes = VB2_USERPTR | VB2_MMAP;
>>>>
>>>> No DMABUF?!
>>>
>>> I don't think it should require really code from the driver but I wonder if
>>> something could go wrong if you don't test it.
>>
>> Not to my knowledge. All new drivers should really support VB2_DMABUF. In fact, this
>> driver supports vidioc_expbuf, which makes no sense unless VB2_DMABUF is set.
> 
> Ack.
> 
>>
>> The USERPTR mode is more dubious. Has this been tested? Can the DMA handle partially
>> filled pages? (I.e. there must be no requirements such as that the DMA has to start
>> at a page boundary, since that's not the case with USERPTR).
> 
> I rememeber this has been discussed before. :-)
> 
> Most hardware has some limitations on the granularity of the buffer start
> address, and the drivers still support USERPTR memory. In practice the C
> library allocated memory is always page aligned if the size is large enough,
> which is in practice the case for video buffers.

That was not true the last time I checked. I can't remember what the exact
alignment was, although I do remember that it was different for 32 and 64 bit.

I am also pretty sure it was less than 64 bytes. It's been 2 years ago since
I last looked at this, though.

> There's no guarantee of
> this though. Unless I'm mistaken, the start address granularity for this
> hardware is 64 bytes.
> 
> It's always possible to allocate memory using:
> 
> 	memalign(sysconf(_SC_PAGESIZE), size)
> 
> Some cache architectures have real trouble of properly supporting USERPTR
> such as VIVT AFAIR.
> 
> I guess the bottom line is that USERPTR is always dubious. :-) One should
> rather user MMAP instead, and then map the buffer to user space. Application
> developers still often appear to resort to the user of USERPTR because it's
> convenient.

A lot of older drivers can handle this fine since the DMA can handle memory that
starts at weird boundaries. But if there are restrictions on what the DMA can do
and that is not compatible with what malloc() gives you, then I would advise against
it.

Most if not all apps use MMAP, because that is universally supported. And DMABUF
is taking over from USERPTR.

Regards,

	Hans
