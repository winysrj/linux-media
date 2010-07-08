Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757599Ab0GHNvd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Jul 2010 09:51:33 -0400
Message-ID: <4C35D7E5.60407@redhat.com>
Date: Thu, 08 Jul 2010 10:51:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [RFC/PATCH 2/6] v4l: subdev: Add device node support
References: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com> <201007072144.46481.laurent.pinchart@ideasonboard.com> <4C34E954.5090907@redhat.com> <201007081408.50289.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201007081408.50289.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 08-07-2010 09:08, Laurent Pinchart escreveu:
> Hi Mauro,
> 
> On Wednesday 07 July 2010 22:53:40 Mauro Carvalho Chehab wrote:
>> Em 07-07-2010 16:44, Laurent Pinchart escreveu:
>>> On Wednesday 07 July 2010 16:58:01 Mauro Carvalho Chehab wrote:
>>>> Em 07-07-2010 08:53, Laurent Pinchart escreveu:
>>>>> Create a device node named subdevX for every registered subdev.
>>>>> As the device node is registered before the subdev core::s_config
>>>>> function is called, return -EGAIN on open until initialization
>>>>> completes.
>>>
>>> [snip]
>>>
>>>>> +static int subdev_open(struct file *file)
>>>>> +{
>>>>> +	struct video_device *vdev = video_devdata(file);
>>>>> +	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
>>>>> +
>>>>> +	if (!sd->initialized)
>>>>> +		return -EAGAIN;
>>>>
>>>> Those internal interfaces should not be used on normal
>>>> devices/applications, as none of the existing drivers are tested or
>>>> supposed to properly work if an external program is touching on its
>>>>
>>>> internal interfaces. So, please add:
>>>> 	if (!capable(CAP_SYS_ADMIN))
>>>> 	
>>>> 		return -EPERM;
>>>
>>> As Hans pointed out, subdev device nodes should only be created if the
>>> subdev request it explicitly. I'll fix the patch accordingly. Existing
>>> subdevs will not have a device node by default anymore, so the
>>> CAP_SYS_ADMIN capability won't be required (new subdevs that explicitly
>>> ask for a device node are supposed to handle the calls properly,
>>> otherwise it's a bit pointless :-)).
>>
>> It should be not requested by the subdev, but by the bridge driver (or
>> maybe by both).
>>
>> On several drivers, the bridge is connected to more than one subdev, and
>> some changes need to go to both subdevs, in order to work. As the glue
>> logic is at the bridge driver, creating subdev interfaces will not make
>> sense on those devices.
> 
> Agreed. I've added a flag that subdev drivers can set to request creation of a 
> device node explicitly, and an argument to to v4l2_i2c_new_subdev_board and 
> v4l2_spi_new_subdev to overwrite the flag. A device node will only be created 
> if the flag is set by the subdev (meaning "I can support device nodes") and 
> the flag is not forced to 0 by the bridge driver (meaning "I allow userspace 
> to access the subdev directly).

OK.

> [snip]
> 
>>>>> +static long subdev_ioctl(struct file *file, unsigned int cmd,
>>>>> +	unsigned long arg)
>>>>> +{
>>>>> +	return video_usercopy(file, cmd, arg, subdev_do_ioctl);
>>>>
>>>> This is a legacy call. Please, don't use it.
>>>
>>> What should I use instead then ? I need the functionality of
>>> video_usercopy. I could copy it to v4l2-subdev.c verbatim. As
>>> video_ioctl2 shares lots of code with video_usercopy I think
>>> video_usercopy should stay, and video_ioctl2 should use it.
>>
>> The bad thing of video_usercopy() is that it has a "compat" code, to fix
>> broken definitions of some iotls (see video_fix_command()), and that a few
>> drivers still use it, instead of video_ioctl2.
> 
> video_ioctl2 has the same compat code.

Yes, in order to avoid breaking binary compatibility with files compiled against
the old videodev2.h header that used to declare some ioctls as:

#define VIDIOC_OVERLAY     	_IOWR('V', 14, int)
#define VIDIOC_S_PARM      	 _IOW('V', 22, struct v4l2_streamparm)
#define VIDIOC_S_CTRL      	 _IOW('V', 28, struct v4l2_control)
#define VIDIOC_G_AUDIO     	_IOWR('V', 33, struct v4l2_audio)
#define VIDIOC_G_AUDOUT    	_IOWR('V', 49, struct v4l2_audioout)
#define VIDIOC_CROPCAP     	 _IOR('V', 58, struct v4l2_cropcap)

instead of:

#define VIDIOC_OVERLAY		 _IOW('V', 14, int)
#define VIDIOC_S_PARM		_IOWR('V', 22, struct v4l2_streamparm)
#define VIDIOC_S_CTRL		_IOWR('V', 28, struct v4l2_control)
#define VIDIOC_G_AUDIO		 _IOR('V', 33, struct v4l2_audio)
#define VIDIOC_G_AUDOUT		 _IOR('V', 49, struct v4l2_audioout)
#define VIDIOC_CROPCAP		_IOWR('V', 58, struct v4l2_cropcap)

(basically, the old ioctl's were using the wrong _IO macros, preventing a generic
copy_from_user/copy_to_user code to work)

This doesn't make sense for subdev, as old binary-only applications will never
use the legacy ioctl definitions.

Probably, we can mark this legacy support for removal at 
Documentation/feature-removal-schedule.txt, and remove
it on a latter version of the kernel. It seems that the old ioctl definitions are
before 2005 (before 2.6.12):

^1da177e (Linus Torvalds        2005-04-16 15:20:36 -0700 1461) #define VIDIOC_OVERLAY_OLD      _IOWR ('V', 14, int)
^1da177e (Linus Torvalds        2005-04-16 15:20:36 -0700 1462) #define VIDIOC_S_PARM_OLD       _IOW  ('V', 22, struct v4l2_streamparm)
^1da177e (Linus Torvalds        2005-04-16 15:20:36 -0700 1463) #define VIDIOC_S_CTRL_OLD       _IOW  ('V', 28, struct v4l2_control)
^1da177e (Linus Torvalds        2005-04-16 15:20:36 -0700 1464) #define VIDIOC_G_AUDIO_OLD      _IOWR ('V', 33, struct v4l2_audio)
^1da177e (Linus Torvalds        2005-04-16 15:20:36 -0700 1465) #define VIDIOC_G_AUDOUT_OLD     _IOWR ('V', 49, struct v4l2_audioout)
^1da177e (Linus Torvalds        2005-04-16 15:20:36 -0700 1466) #define VIDIOC_CROPCAP_OLD      _IOR  ('V', 58, struct v4l2_cropcap)

>> For sure, we don't need the "compat" code for subdev interface. Also, as
>> time goes by, we'll eventually have different needs at the subdev interface,
>> as some types of ioctl's may be specific to subdevs and may require
>> different copy logic.
> 
> We can change the logic then :-)
> 
>> IMO, the better is to use the same logic inside the subdev stuff, of course
>> removing that "old ioctl" fix logic:
>>
>> #ifdef __OLD_VIDIOC_
>> 	cmd = video_fix_command(cmd);
>> #endif
>>
>> And replacing the call to:
>> 	err = func(file, cmd, parg);
>>
>> By the proper subdev handling.
> 
> What about renaming video_usercopy to __video_usercopy, adding an argument to 
> enable/disable the compat code, create a new video_usercopy that calls 
> __video_usercopy with compat code enabled, have video_ioctl2 call 
> __video_usercopy with compat code enabled, and having subdev_ioctl call 
> __video_usercopy with compat code disabled ?

Seems good, but maybe the better is to put the call to video_fix_command() outside
the common function.

We may add also a printk for the video_usercopy wrapper printing that the
driver is using a legacy API call, and that this will be removed on a next kernel version.
Maybe this way, people will finally submit patches porting the last remaining drivers to
video_ioctl2.

I suspect, however, that we'll end by needing a subdev-specific version of __video_usercopy,
as we add new ioctls to subdev.

Cheers,
Mauro.
