Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab1KPPgx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 10:36:53 -0500
Message-ID: <4EC3D891.9090009@redhat.com>
Date: Wed, 16 Nov 2011 13:36:49 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sylwester Nawrocki <snjw23@gmail.com>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 1/3] V4L2: Add per-device-node capabilities
References: <1320662246-8531-1-git-send-email-hverkuil@xs4all.nl> <43f3b62f1a17a91a02b5a66026b8af02ad31fa2f.1320661643.git.hans.verkuil@cisco.com> <4EC2C904.2010308@gmail.com> <201111161541.41796.hverkuil@xs4all.nl>
In-Reply-To: <201111161541.41796.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 16-11-2011 12:41, Hans Verkuil escreveu:
> On Tuesday 15 November 2011 21:18:12 Sylwester Nawrocki wrote:
>> Hello Hans,
>>
>> On 11/07/2011 11:37 AM, Hans Verkuil wrote:
>>> From: Hans Verkuil<hans.verkuil@cisco.com>
>>>
>>> If V4L2_CAP_DEVICE_CAPS is set, then the new device_caps field is filled
>>> with the capabilities of the opened device node.
>>>
>>> The capabilities field traditionally contains the capabilities of the
>>> whole device. E.g., if you open video0, then if it contains VBI caps
>>> then that means that there is a corresponding vbi node as well. And the
>>> capabilities field of both the video and vbi node should contain
>>> identical caps.
>>>
>>> However, it would be very useful to also have a capabilities field that
>>> contains just the caps for the currently open device, hence the new CAP
>>> bit and field.
>>>
>>> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
>>> ---
>>>
>>>   include/linux/videodev2.h |    7 +++++--
>>>   1 files changed, 5 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>>> index 4b752d5..2b6338b 100644
>>> --- a/include/linux/videodev2.h
>>> +++ b/include/linux/videodev2.h
>>> @@ -243,8 +243,9 @@ struct v4l2_capability {
>>>
>>>   	__u8	card[32];	/* i.e. "Hauppauge WinTV" */
>>>   	__u8	bus_info[32];	/* "PCI:" + pci_name(pci_dev) */
>>>   	__u32   version;        /* should use KERNEL_VERSION() */
>>>
>>> -	__u32	capabilities;	/* Device capabilities */
>>> -	__u32	reserved[4];
>>> +	__u32	capabilities;	/* Global device capabilities */
>>> +	__u32	device_caps;	/* Device node capabilities */
>>
>> How about changing this to
>>
>> 	__u32	devnode_caps;	/* Device node capabilities */
>>
>>> +	__u32	reserved[3];
>>>
>>>   };
>>>   
>>>   /* Values for 'capabilities' field */
>>>
>>> @@ -274,6 +275,8 @@ struct v4l2_capability {
>>>
>>>   #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
>>>   #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O
>>>   ioctls */
>>>
>>> +#define V4L2_CAP_DEVICE_CAPS            0x80000000  /* sets device
>>> capabilities field */
>>
>> ..and
>>
>> #define V4L2_CAP_DEVNODE_CAPS            0x80000000  /* sets device node
>> capabilities field */
>>
>> ?
>>
>> 'device' might suggest a whole physical device/system at first sight.
>> Maybe devnode_caps is not be the best name but it seems more explicit and
>> less confusing :)

On kernel, "device" doesn't represent a physical device/system.
See, for example:
	Documentation/devices.txt

It is clear there that a device is directly associated with a devnode.

The thing is that the kernel struct that represents a device is "struct device".
And the userspace view for "struct device" is a device node.

As I told several times, what we call "subdevice" is, in fact a device, as it is
(on most cases) exported via devnodes to userspace. For example, all I2C subdevices
are devices, as they can be seen via devnodes at the I2C bus support (if i2c-dev
module is loaded). Worse than that, if MC/subdev API is used, the same sub-device
will be, in fact, 2 devices (one I2C device, and one V4L2 subdev device), each
device with its own device node.

A "physical device" can have more than one device. For example, serial devices, in
general, have two devices for each physical one (cua0-191 and TTYS0-191). This is
there since the beginning of Linux.

So, calling/interpreting the term "device" as the physical device is _wrong_.
It might be used as-is only if there's only one device is associated to the physical
device. I don't think there's any such case currently at V4L2 (as, at least, one
bus device and one V4L2 device will be created at the simplest case).

>> It's just my personal opinion though.
> 
> I also have a preference for devnode, but it is my understanding that Mauro 
> prefers 'device' over 'devnode'. Is that correct, Mauro?

This is a recurrent discussion. Do a "git grep devnode|wc" and compare it with
a "git grep device|wc".

So, calling anything as "devnode" is confusing, as there's no obvious way to
distinguish it from "device".

>>> +	__u32	capabilities;	/* Global device capabilities */
>>> +	__u32	device_caps;	/* Device node capabilities */

I would change the comments to:

	__u32	capabilities;	/* capabilities present at the physical device as a hole */
	__u32	device_caps;	/* capabilities accessed via this particular device (node) */

Btw, the better would be to use the standard way to comment it:

/**
 * struct v4l2_capability - Describes V4L2 device caps on VIDIOC_QUERYCAP
...
 @capabilities: capabilities present at the physical device as a hole
 @device_caps:	capabilities accessed via this particular device
...
 */


> I am OK with either.
> 
> Regards,
> 
> 	Hans
> 
>>
>> --
>> Regards,
>> Sylwester
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

