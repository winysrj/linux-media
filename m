Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:51087 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751463AbbEDIEO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 May 2015 04:04:14 -0400
Message-ID: <554727F3.4000103@xs4all.nl>
Date: Mon, 04 May 2015 10:04:03 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 1/3] v4l2-subdev: add VIDIOC_SUBDEV_QUERYCAP ioctl
References: <1430480030-29136-1-git-send-email-hverkuil@xs4all.nl> <1430480030-29136-2-git-send-email-hverkuil@xs4all.nl> <2593943.bedsoOsVyV@avalon>
In-Reply-To: <2593943.bedsoOsVyV@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/04/2015 12:20 AM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Friday 01 May 2015 13:33:48 Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> While normal video/radio/vbi/swradio nodes have a proper QUERYCAP ioctl
>> that apps can call to determine that it is indeed a V4L2 device, there
>> is currently no equivalent for v4l-subdev nodes. Adding this ioctl will
>> solve that, and it will allow utilities like v4l2-compliance to be used
>> with these devices as well.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/v4l2-core/v4l2-subdev.c | 19 +++++++++++++++++++
>>  include/uapi/linux/v4l2-subdev.h      | 12 ++++++++++++
>>  2 files changed, 31 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c
>> b/drivers/media/v4l2-core/v4l2-subdev.c index 6359606..2ab1f7d 100644
>> --- a/drivers/media/v4l2-core/v4l2-subdev.c
>> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
>> @@ -25,6 +25,7 @@
>>  #include <linux/types.h>
>>  #include <linux/videodev2.h>
>>  #include <linux/export.h>
>> +#include <linux/version.h>
> 
> Nitpicking, I'd insert version.h between types.h and videodev2.h to keep 
> entries alphabetically sorted (I know that export.h is misplaced, but that's 
> the only one.).
> 
>>  #include <media/v4l2-ctrls.h>
>>  #include <media/v4l2-device.h>
>> @@ -187,6 +188,24 @@ static long subdev_do_ioctl(struct file *file, unsigned
>> int cmd, void *arg) #endif
>>
>>  	switch (cmd) {
>> +	case VIDIOC_SUBDEV_QUERYCAP: {
>> +		struct v4l2_subdev_capability *cap = arg;
>> +
>> +		cap->version = LINUX_VERSION_CODE;
>> +		cap->device_caps = 0;
>> +		cap->pads = 0;
>> +		cap->entity_id = 0;
>> +#if defined(CONFIG_MEDIA_CONTROLLER)
>> +		if (sd->entity.parent) {
>> +			cap->device_caps = V4L2_SUBDEV_CAP_ENTITY;
>> +			cap->pads = sd->entity.num_pads;
>> +			cap->entity_id = sd->entity.id;
>> +		}
>> +#endif
>> +		memset(cap->reserved, 0, sizeof(cap->reserved));
>> +		break;
>> +	}
>> +
>>  	case VIDIOC_QUERYCTRL:
>>  		return v4l2_queryctrl(vfh->ctrl_handler, arg);
>>
>> diff --git a/include/uapi/linux/v4l2-subdev.h
>> b/include/uapi/linux/v4l2-subdev.h index dbce2b5..e48b9fd 100644
>> --- a/include/uapi/linux/v4l2-subdev.h
>> +++ b/include/uapi/linux/v4l2-subdev.h
>> @@ -154,9 +154,21 @@ struct v4l2_subdev_selection {
>>  	__u32 reserved[8];
>>  };
>>
>> +struct v4l2_subdev_capability {
>> +	__u32 version;
>> +	__u32 device_caps;
>> +	__u32 pads;
> 
> If we restrict pad number reporting to subdevs that are also entities, should 
> we report the number of pads at all here ? Applications could find it out 
> through the MC API using the entity ID. I don't have a too strong opinion on 
> this for now, but we should consider whether reporting the same information 
> through two different means wouldn't cause issues.

My problem is that that would require e.g. v4l2-compliance to hunt for the
media device when all it needs is the number of pads. I don't mind dropping
this, but then we need a good way to find the associated media device (and
sysfs is not a good way).

The goal is to be able to write v4l2-compliance tests, so I need this info
one way or another.

Regards,

	Hans

> 
>> +	__u32 entity_id;
>> +	__u32 reserved[48];
>> +};
>> +
>> +/* This v4l2_subdev is also a media entity and the entity_id field is valid
>> */ +#define V4L2_SUBDEV_CAP_ENTITY		(1 << 0)
>> +
>>  /* Backwards compatibility define --- to be removed */
>>  #define v4l2_subdev_edid v4l2_edid
>>
>> +#define VIDIOC_SUBDEV_QUERYCAP			 _IOR('V',  0, struct
>> v4l2_subdev_capability) #define VIDIOC_SUBDEV_G_FMT			_IOWR('V',  4, 
> struct
>> v4l2_subdev_format) #define VIDIOC_SUBDEV_S_FMT			_IOWR('V',  5, 
> struct
>> v4l2_subdev_format) #define VIDIOC_SUBDEV_G_FRAME_INTERVAL		_IOWR('V', 
> 21,
>> struct v4l2_subdev_frame_interval)
> 

