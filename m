Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:36134 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab1JFBmA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 21:42:00 -0400
Message-ID: <4E8D075E.40702@infradead.org>
Date: Wed, 05 Oct 2011 22:41:50 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Javier Martinez Canillas <martinez.javier@gmail.com>,
	linux-media@vger.kernel.org,
	laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>
Subject: Re: [PATCH 3/3] [media] tvp5150: Migrate to media-controller framework
 and add video format detection
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com> <CAAwP0s1ozMVi5TgWUGmu5Pxd2cTEHd1rTD72HU9R+Fth3Rb9-A@mail.gmail.com> <4E891B22.1020204@infradead.org> <201110030830.25364.hverkuil@xs4all.nl> <4E8A04C2.5000508@infradead.org> <20111003190109.GN6180@valkosipuli.localdomain> <4E8A0ECC.3030006@infradead.org> <20111005234140.GE8614@valkosipuli.localdomain>
In-Reply-To: <20111005234140.GE8614@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 05-10-2011 20:41, Sakari Ailus escreveu:
> On Mon, Oct 03, 2011 at 04:36:44PM -0300, Mauro Carvalho Chehab wrote:
>> Em 03-10-2011 16:01, Sakari Ailus escreveu:
>>> On Mon, Oct 03, 2011 at 03:53:54PM -0300, Mauro Carvalho Chehab wrote:
>>>> Yes, you're right. I should not try to answer emails when I'm lazy enough to not
>>>> look in to the code ;)
>>>>
>>>> Anyway, the thing is that V4L2 API has enough support for auto-detection. There's
>>>> no need to duplicate stuff with MC API.
>>>
>>> It's not MC API but V4L2 subdev API. No-one has proposed to add video
>>> standard awareness to the Media controller API. There's no reason to export
>>> a video node in video decoder drivers... but I guess you didn't mean that.
>>>
>>> Would implementing ENUM/G/S_STD make sense for the camera ISP driver, that
>>> has nothing to do with any video standard?
>>
>> This is an old discussion, and we never agreed on that. Some webcam drivers
>> implement those ioctls. Others don't. Both cases are compliant with the
>> current specs. In the past, several userspace applications used to abort if those
>> ioctl's weren't implemented, but I think that this were fixed already there.
>>
>> As I said, we should define a per-device type profile in order to enforce that
>> all devices of the same type will do the same. We'll need man power to fix the
>> ones that aren't compliant, and solve the userspace issues. Volunteers needed.
>>
>> There's one point to bold on it: devices that can have either an analog input
>> or a digital input will likely need to implement ENUM/G/S_STD for both, as
>> userspace applications may fail, if the ioctl's are disabled depending on the
>> type of input. We had to implement them on several drivers, due to that.
>
> My disguised question behind this was actually that would a driver need to
> implement an ioctl that has no relevance to the driver itself at all but
> only to support another driver, yet the first driver might not have enough
> information to properly implement it?

This is done a lot at the V4L2 drivers: basically, the code at the bridge
driver just forwards the request to the sub-devices, when it doesn't know
what to do, and return the information back to the userspace, acting like
a bridge between the userspace and the sub-devices.

For example, this is what the usbvision[1] driver does for all control ioctl's:

[1] usbvision is not an example of a modern driver. It is for some old
generations of USB 1.1 media devices. I'm just using it here as it contains
one of the simplest implementations among the drivers we have, as most of
the work is done by the saa7115 driver.

static int vidioc_s_ctrl(struct file *file, void *priv,
				struct v4l2_control *ctrl)
{
	struct usb_usbvision *usbvision = video_drvdata(file);

	call_all(usbvision, core, s_ctrl, ctrl);
	return 0;
}

In other words, it just forwards the call to the tv decoder or to the sensor
(the same driver is used with both webcams and tv decoders).

The implementation for S_STD is a little more complex, as it also sets the
input at the video muxer. Even so, it is trivial:

static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *id)
{
	struct usb_usbvision *usbvision = video_drvdata(file);

	usbvision->tvnorm_id = *id;

	call_all(usbvision, core, s_std, usbvision->tvnorm_id);
	/* propagate the change to the decoder */
	usbvision_muxsel(usbvision, usbvision->ctl_input);

	return 0;
}

> It may be sometimes necessary but I would like to avoid that if possible
> since it complicates even more drivers which already are very complex.

As you can see from the two above examples, a code that will just bridge
the call to the subdevs is trivial to implement, and won't affect much
the drivers complexity.

On the other hand, Implementing the same at userspace can be much more complex, as userspace
will need to know some details about the device. For example, userspace
would need to know what nodes are affected by a command like S_STD, and
what are the requirements for each pad, to avoid putting the device into
an unsupported configuration.

>>> If you have two video decoders
>>> connected to your system, then which one should the ioctls be redirected to?
>>> What if there's a sensor and a video decoder? And how could the user know
>>> about this?
>>
>> When an input is selected (either via the V4L2 way - S_INPUT or via the MC/subdev
>> way, there's just one video decoder or sensor associated to the corresponding
>> V4L2 node).
>>
>>> It's the same old issues again... let's discuss this in the Multimedia
>>> summit.
>>
>> We can discuss more at the summit, but we should start discussing it here, as
>> otherwise we may not be able to go into a consensus there, due to the limited
>> amount of time we would have for each topic.
>
> Sounds good to me, but sometimes face-to-face discussion just is not
> replaceable.
>

We've scheduled some time for discussing it there, and we may schedule more discussions
a about that if needed during the rest of the week.

Regards,
Mauro
