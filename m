Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:52902 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753688AbbDTIiX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2015 04:38:23 -0400
Message-ID: <5534BAE7.4040509@xs4all.nl>
Date: Mon, 20 Apr 2015 10:37:59 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC] Querycap for subdevs, finding MC from device nodes
References: <550D2EB9.5090806@xs4all.nl> <1768917.5uFxr7arIJ@avalon>
In-Reply-To: <1768917.5uFxr7arIJ@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 04/17/2015 05:07 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Saturday 21 March 2015 09:41:29 Hans Verkuil wrote:
>> I've been thinking about extending v4l2-compliance with v4l-subdev tests.
>>
>> However, there are a few missing pieces that are needed before this can be
>> done.
>>
>> First of all is that there is no subdev equivalent to VIDIOC_QUERYCAP, i.e.
>> an ioctl that is guaranteed to always be available.
>>
>> So I propose the following ioctl:
>>
>> VIDIOC_SUBDEV_QUERYCAP(struct v4l2_subdev_capability);
>>
>> struct v4l2_subdev_capability {
>> 	char name[V4L2_SUBDEV_NAME_SIZE];
>> 	__u32 version;			// same as KERNEL_VERSION like QUERYCAP does
>> 	__u32 device_caps;
>> 	__u32 pads;
>> 	__u32 entity_id;
>> 	__u32 reserved[40];
>> };
>>
>> /* This v4l2_subdev is also a media entity and the entity_id field is valid
>> */ #define V4L2_SUBDEV_CAP_ENTITY		(1 << 0)
>>
>> This will allow v4l2-compliance to discover that this is a bona fide v4l2
>> subdevice. All the information in the struct above can be filled in by
>> v4l2-subdev.c, no need to change drivers.
> 
> This looks quite good to me. There's a prerequisite though, we need to 
> formally define the naming scheme for subdevs, otherwise we'll expose yet 
> another ill-defined name that will cause issues later.

If memory serves I proposed in San Jose when we discussed this to leave the
'name' field out for this initial version. From the point of view of
v4l2-compliance all it really needs is 'pads' and a single guaranteed-to-
exist ioctl.

>> The reason I included 'pads' as well is that subdev drivers can have a
>> devnode without being an entity, but still support ioctls like
>> VIDIOC_SUBDEV_ENUM_MBUS_CODE. In that case v4l2-compliance needs to know
>> the number of pads in order to properly test. If it is an entity, then the
>> entity information can be obtained from the MC, see below how to find the
>> MC.
> 
> Shouldn't we make it mandatory for subdevs to be entities if they want to 
> expose a subdev node ? Otherwise applications won't be able to find out how 
> the subdev relates to other subdevs and v4l2 devices, making the API quite 
> shaky in my opinion.

I am inclined to agree with you. I just need time (hah!) to sit down and look
carefully through the API and if this would cause any problems. My gut says it
doesn't and that it would actually simplify things.

>> Note: I think it makes sense to extend VIDIOC_QUERYCAP as well with a
>> CAP_ENTITY and an entity_id.
>>
>> The next step is to be able to associate a media device with a v4l2-subdev.
>>
>> Originally I though of adding the major and minor numbers of the media
>> device to the capability struct, but I'd like to do that for
>> VIDIOC_QUERYCAP as well, and there are only 3 reserved fields (2 after
>> taking one for the entity_id).
>>
>> Instead I think we can just implement the MEDIA_IOC_DEVICE_INFO ioctl: this
>> returns all info about the media_device, and it can easily be extended to
>> include the major and minor number of that device.
> 
> Hmmm... I'm not too found of that approach. Can't userspace find the 
> corresponding media device through sysfs ? I'd like to point that the common 
> use case is to start from the media device and find the entities. Finding the 
> media device from a subdev is useful mostly for test tools, but it's not the 
> main use case.

I've never been happy with the idea of applications having to hunt through
sysfs trying to find a device node. And in general I think it is good to be
able to be able to go in both directions. However, this isn't the most urgent
task for now, so I'll drop it for the first version. Right now I just want to
start working on tests for v4l-subdev nodes.

Regards,

	Hans

>> Again, supporting this is easily done in the core, both for regular video
>> nodes and for subdev nodes, so drivers do not need to be changed.
>>
>> This way you can easily find whether a V4L2 device node is an entity and
>> what the associated media controller is. All the information is available,
>> we just need to expose it.
>>
>> Comments?
> 
> Please see above :-)
> 

