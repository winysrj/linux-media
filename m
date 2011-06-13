Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:3986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab1FMLpU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2011 07:45:20 -0400
Message-ID: <4DF5F84A.7070508@redhat.com>
Date: Mon, 13 Jun 2011 08:45:14 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv4 PATCH 1/8] tuner-core: rename check_mode to supported_mode
References: <1307876389-30347-1-git-send-email-hverkuil@xs4all.nl> <201106122009.10116.hverkuil@xs4all.nl> <4DF5385B.3020603@redhat.com> <201106131223.48550.hverkuil@xs4all.nl>
In-Reply-To: <201106131223.48550.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 13-06-2011 07:23, Hans Verkuil escreveu:
> On Monday, June 13, 2011 00:06:19 Mauro Carvalho Chehab wrote:
>> Em 12-06-2011 15:09, Hans Verkuil escreveu:
>>> On Sunday, June 12, 2011 19:27:21 Mauro Carvalho Chehab wrote:
>>>> Em 12-06-2011 13:07, Hans Verkuil escreveu:
>>>>> On Sunday, June 12, 2011 16:37:55 Mauro Carvalho Chehab wrote:
>>>>>> Em 12-06-2011 07:59, Hans Verkuil escreveu:
>>>>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>>>>
>>>>>>> The check_mode function checks whether a mode is supported. So calling it
>>>>>>> supported_mode is more appropriate. In addition it returned either 0 or
>>>>>>> -EINVAL which suggests that the -EINVAL error should be passed on. However,
>>>>>>> that's not the case so change the return type to bool.
>>>>>>
>>>>>> I prefer to keep returning -EINVAL. This is the proper thing to do, and
>>>>>> to return the result to the caller. A fixme should be added though, so,
>>>>>> after someone add a subdev call that would properly handle the -EINVAL
>>>>>> code for multiple tuners, the functions should return the error code
>>>>>> instead of 0.
>>>>>
>>>>> No, you can't return -EINVAL here. It is the responsibility of the bridge
>>>>> driver to determine whether there is e.g. a radio tuner. So if one of these
>>>>> tuner subdevs is called with mode radio while it is a tv tuner, then that
>>>>> is not an error, but instead it is a request that can safely be ignored
>>>>> as not relevant for that tuner. It is up to the bridge driver to ensure
>>>>> that a tuner is loaded that is actually valid for the radio mode.
>>>>>
>>>>> Subdev ops should only return errors when there is a real problem (e.g. i2c
>>>>> errors) and should just return 0 if a request is not for them.
>>>>>
>>>>> That's why I posted these first two patches: these functions suggest that you
>>>>> can return an error if the mode doesn't match when you really cannot.
>>>>>
>>>>> If I call v4l2_device_call_until_err() for e.g. s_frequency, then the error
>>>>> that is returned should match a real error (e.g. an i2c error), not that one
>>>>> of the tv tuners refused the radio mode. I know there is a radio tuner somewhere,
>>>>> otherwise there wouldn't be a /dev/radio node.
>>>>>
>>>>> I firmly believe that the RFCv4 series is correct and just needs an additional
>>>>> patch adding some documentation.
>>>>>
>>>>> That said, it would make sense to move the first three patches to the end
>>>>> instead if you prefer. Since these are cleanups, not bug fixes like the others.
>>>>
>>>>
>>>> The errors at tuner should be propagated. If there's just one tuner, the error
>>>> code should just be returned by the ioctl. But, if there are two tuners, if the bridge 
>>>> driver calls G_TUNER (or any other tuner subdev call) and both tuners return -EINVAL, 
>>>> then it needs to return -EINVAL to userspace. If just one returns -EINVAL, and the 
>>>> other tuner returns 0, then it should return 0. So, it is about the opposite behaviour 
>>>> implemented at v4l2_device_call_until_err().
>>>
>>> Sorry, but no, that's not true. You are trying to use the error codes from tuner
>>> subdevs to determine whether none of the tuner subdevs support a certain tuner mode.
>>
>> Not only that. There are some cases where the tuner driver may not bind for some reason.
>> So, even if the bridge driver does support a certain mode, a call to G_TUNER may fail
>> (for example, if tea5767 probe failed). Only with a proper return code, the bridge driver
>> can detect if the driver found some issue.
> 
> Surely, that's an error reported by tuner_probe, isn't it? That's supposed to ensure
> that the tuner driver was loaded and initialized correctly. I'm not sure if it does,
> but that's definitely where any errors of that kind should be reported.
> 
> Looking at it some more, it seems to me that s_type_addr should also return an
> error if there are problems. Ditto for tuner_s_config.
> 
> An alternative solution is to keep a 'initialized' boolean that is set to true
> once the tuner is fully configured. If g_tuner et al are called when the tuner
> is not fully configured, then you can return -ENODEV or -EIO or something like that.

NACK. This would be just an ugly workaround. 

> But that's a separate status check and has nothing to do with mode checking.
> 
>>> E.g., you want to change something for a radio tuner and there are no radio tuner
>>> subdevs. But that's the job of the bridge driver to check. That has the overview,
>>> the lowly subdevs do not. The subdevs just filter the ops and check the mode to see
>>> if they should handle it and ignore it otherwise.
>>>
>>> Only if they have to handle it will they return a possible error. The big problem
>>> with trying to use subdev errors codes for this is that you don't see the difference
>>> between a real error of a subdev (e.g. -EIO when an i2c access fails) and a subdev
>>> that returns -EINVAL just because it didn't understand the tuner mode.
>>>
>>> So the bridge may return -EINVAL to the application instead of the real error, which
>>> is -EIO.
>>
>> An -EIO would also be discarded, as errors at v4l2_device_call_all() calls don't return
>> anything. So, currently, the bridge has to assume that no errors happened and return 0.
> 
> Obviously, v4l2_device_call_all calls should be replaced with v4l2_device_call_until_err.
> I've no problem with that.

See bellow.

>>
>>> That's the whole principle behind the sub-device model: sub-devices do not know
>>> about 'the world outside'. So if you pass RADIO mode to S_FREQUENCY and there is no
>>> radio tuner, then the bridge driver is the one that should detect that and return
>>> -EINVAL.
>>>
>>> Actually, as mentioned before, it can also be done in video_ioctl2.c by checking
>>> the tuner mode against the device node it's called on. But that requires tightening
>>> of the V4L2 spec first.
>>
>> Yes, video_ioctl2 (or, currently, the bridge driver) shouldn't allow an invalid operation.
>> But if the call returns an error, this error should be propagated. 
>>
>> Also, as I've explained before, even adding the invalid mode check inside video_ioctl,
>> you may still have errors if the registered tuners don't support the mode, because one 
>> of the tuners didn't registered properly.
> 
> And that's something that tuner_probe/s_type_addr/s_config should have detected.

I'm almost sure that they don't do it, currently: s_type_addr/s_config also calls
v4l2_device_call_all(). No errors are returned back. The tuner_probe call also can't
do much, as it doesn't know in advance if the device has one or two tuners.

> Or, should that be impossible (I would have to spend more time to analyze that)
> we might have to add a 'validate_tuner' op that can be called to verify all tuners
> are configured correctly.

You're wanting to create a very complex patchset just to justify that replacing
from -EINVAL to a bool is the right thing to do. It isn't. The point is that:
if, for any reason, an ioctl fails, it should return an _error_, and _not_ a boolean.

After fixing v4l2_device_call_all() to allow it to return errors, the next step
is to review all calls to it, and add a proper handler for the errors. s_type_addr,
s_config, g_tuner, s_tuner, etc should be handling errors.

In other words, the original v4l2_device_call_all() that were just replicating the
previous I2C behaviour is a mistake, as it doesn't provide any feedback about errors.
This needs to be replaced by something that it is aware of the errors. If you take
a look at v4l2-subdev, there's just one operation that doesn't return an error
(v4l2_subdev_internal_ops.unregistered, never called from drivers). All the others 
returns an error. However, the default usage is to simply discard errors. This is wrong.
Errors should be propagated.

AFAIK, there are only a two types error propagation that are currently needed:

1) Call all subdevices. If one returns 0, assumes that the operation succeeded. This is
   used when there are multiple subdevs, but they're mutually exclusive: only one of them 
   will handle such call. It is needed by tuners and by controls, on devices that have 
   several subdevs providing different sets of controls.

2) Call all subdevices until an error. Used when the same operation needs to be set
   on multiple subdevices. The subdevices that don't implement such operation should 
   return -ENOIOCTLCMD.

Btw, v4l2_device_call_subdevs_until_err() has currently a bug: if all sub-devices return
-ENOIOCTLCMD, it returns 0. It should, instead, return -ENOIOCTLCMD, in order to allow
the bridge drivers to return an error code to the userspace, to indicate that the
IOCTL was not handled.

Eventually, we may just use (2) for everything, if we patch all subdev drivers to return
-ENOIOCTLCMD if they are discarding a subdev call, but, in this case, the bridge drivers 
will need to replace the -ENOIOCTLCMD to an error code defined at the V4L2 spec (or we
can have a macro for that).

A side note: the only error codes defined at the media API DocBook are: -EACCES, -EAGAIN,
-EBADF, -EBUSY, -EFAULT, -EIO, -EINTR, -EINVAL, -ENFILE, -ENOMEM, -ENOSPC, -ENOTTY, -ENXIO,
-EMFILE, -EPERM, -ERANGE and EPIPE. On most places, the error codes are defined per ioctl.
We need to review the DocBook and the drivers to be sure that they match the API specs, 
in terms of returned codes. It probably makes sense to create a section with the valid error
codes, remove most of error codes comments from each ioctl, and add a link to the global
error code section.

Ah, -ENODEV is not currently defined, but -ENXIO is defined on a few places. -ENXIO means 
"No such device or address". So, it may make sense to replace all -ENODEV to -ENXIO at 
the drivers.

Cheers,
Mauro

