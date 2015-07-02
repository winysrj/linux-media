Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:56037 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbbGBNIR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jul 2015 09:08:17 -0400
Message-ID: <55953779.8030205@cisco.com>
Date: Thu, 02 Jul 2015 15:07:05 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 1/3] v4l2-subdev: add VIDIOC_SUBDEV_QUERYCAP ioctl
References: <1430480030-29136-1-git-send-email-hverkuil@xs4all.nl> <1430480030-29136-2-git-send-email-hverkuil@xs4all.nl> <20150702130100.GV5904@valkosipuli.retiisi.org.uk>
In-Reply-To: <20150702130100.GV5904@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 07/02/15 15:01, Sakari Ailus wrote:
> Hi Hans,
> 
> Thanks for the patch!
> 
> On Fri, May 01, 2015 at 01:33:48PM +0200, Hans Verkuil wrote:
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
>> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
>> index 6359606..2ab1f7d 100644
>> --- a/drivers/media/v4l2-core/v4l2-subdev.c
>> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
>> @@ -25,6 +25,7 @@
>>  #include <linux/types.h>
>>  #include <linux/videodev2.h>
>>  #include <linux/export.h>
>> +#include <linux/version.h>
>>  
>>  #include <media/v4l2-ctrls.h>
>>  #include <media/v4l2-device.h>
>> @@ -187,6 +188,24 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>>  #endif
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
>> diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
>> index dbce2b5..e48b9fd 100644
>> --- a/include/uapi/linux/v4l2-subdev.h
>> +++ b/include/uapi/linux/v4l2-subdev.h
>> @@ -154,9 +154,21 @@ struct v4l2_subdev_selection {
>>  	__u32 reserved[8];
>>  };
>>  
>> +struct v4l2_subdev_capability {
>> +	__u32 version;
>> +	__u32 device_caps;
> 
> This is called capabilities in struct v4l2_capability. I'd follow the same
> pattern.

No, it's called device_caps in struct v4l2_capability. The capabilities field
in that same structure contains the capabilities of the device as a whole: so
not just of the device node in question, but the union of the capabilities of
all device nodes created by the driver.

> 
>> +	__u32 pads;
>> +	__u32 entity_id;
> 
> What's the use case for the entity_id field btw.? Supposing that the user
> wouldn't be using the MC interface to obtain it, is the entity_id relevant
> in this context? Or is your intent first open the sub-device, and then find
> out more information on the entity?

Right, the latter. I want to be able to do v4l2-compliance -d /dev/v4l-subdev0
and it should be able to figure everything out from there.

> 
>> +	__u32 reserved[48];
> 
> Why 48?

Can't remember :-)

> 
> As memory is typically allocated in powers of two (or n^2 + (n-1)^2), how
> about aligning it accordingly? I don't think we lose anything by making this
> e.g. 60. Although 28 would probably suffice as well (or 29 with the pads
> field removed as discussed). Even that much sounds like a lot.

29 would work fine as well. In general I am more generous with reserved fields
these days since we've hit the limits of it too often.

Regards,

	Hans

> 
>> +};
>> +
>> +/* This v4l2_subdev is also a media entity and the entity_id field is valid */
>> +#define V4L2_SUBDEV_CAP_ENTITY		(1 << 0)
>> +
>>  /* Backwards compatibility define --- to be removed */
>>  #define v4l2_subdev_edid v4l2_edid
>>  
>> +#define VIDIOC_SUBDEV_QUERYCAP			 _IOR('V',  0, struct v4l2_subdev_capability)
>>  #define VIDIOC_SUBDEV_G_FMT			_IOWR('V',  4, struct v4l2_subdev_format)
>>  #define VIDIOC_SUBDEV_S_FMT			_IOWR('V',  5, struct v4l2_subdev_format)
>>  #define VIDIOC_SUBDEV_G_FRAME_INTERVAL		_IOWR('V', 21, struct v4l2_subdev_frame_interval)
> 
