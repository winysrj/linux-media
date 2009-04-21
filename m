Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4273 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbZDULrF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 07:47:05 -0400
Message-ID: <39337.62.70.2.252.1240314423.squirrel@webmail.xs4all.nl>
Date: Tue, 21 Apr 2009 13:47:03 +0200 (CEST)
Subject: Re: Applying SoC camera framework on multi-functional camera
     interface
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Ailus Sakari" <sakari.ailus@nokia.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	=?iso-8859-1?Q?=B1=E8=C7=FC=C1=D8?= <riverful.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Tue, 21 Apr 2009, Dongsoo, Nathaniel Kim wrote:
>
>> Hello,
>>
>> One of my recent work is making S3C64XX camera interface driver with
>> SoC camera framework. Thanks to Guennadi, SoC camera framework is so
>> clear and easy to follow. Actually I didn't need to worry about my
>> whole driver structure, the framework almost has everything that I
>> need.
>>
>> But here is a problem that I couldn't make up my mind while
>> implementing some of the features of S3C64XX camera IP.
>> As you know, S3C64XX camera IP has scaler and rotator capability on
>> it's own which can be used standalone even memory to memory scaling
>> and rotating jobs.
>> If you want to know in detail please take a look at the user manual
>> (just remind if you have already seen this)  :
>> http://www.ebv.com/fileadmin/products/Products/Samsung/S3C6400/S3C6400X_UserManual_rev1-0_2008-02_661558um.pdf
>>
>> Telling you about the driver concept that I wanted to make is like
>> following:
>>
>> (I want to select inputs like external camera and MSDMA using
>> S_INPUT'/G_INPUT but we don't have them in SoC camera framework.
>> So this should be the version of design with current SoC camera
>> framework.)
>>
>> 1. S3C64XX has preview and codec path
>> 2. Each preview and codec path can have external camera and MSDMA for
>> input
>> 3. make external camera and MSDMA device nodes for each preview and
>> codec.
>>   => Let's assume that we have camera A and B, then it should go like
>> this
>>   /dev/video0 (camera A on preview device)
>>   /dev/video1 (camera B on preview device)
>>   /dev/video2 (MSDMA on preview device)
>>   /dev/video3 (camera A on codec device)
>>   /dev/video4 (camera B on codec device)
>>   /dev/video5 (MSDMA on codec device)
>
> My proposal was a bit different. You don't need two different output
> devices per camera - video3 and video4. I suggested to make preview a pure
> output device, without the ability to select the input. So, if you
> activate (open) video1, video3 will get data from the first camera. If you
> activate video2, video3 will preview camera 2.
>
> Also, you can have a look at arch/sh/boards/mach-migor/setup.c for an
> example of handling two cameras on one interface. The only difference to
> what I have proposed is that they block on open(video1) if video0 is in
> use and the other way round. Whereas I suggested to return -EBUSY. You can
> choose.
>
>> 4. Those device nodes are "device" in SoC camera framework (and S3C
>> camera interface should be "host" device)
>>  => External camera devices can be made in SoC camera device. Fair
>> enough.
>>
>>   But MSMDA? what should I do If I want to make it as a "device"
>> driver in SoC camera framework?
>>   Any reference that I could have? because I can't find any "device"
>> drivers besides camera sensor,isp drivers.
>>   Please let me know if there is any.
>
> Actually, last time we talked about it I didn't realise, that you can
> configure the preview path to read data from memory while your codec path
> processes data from the camera, is this really the case? I didn't study
> the datasheet in enough detail.
>
> Well, you might look at drivers/media/video/soc_camera_platform.c for an
> example of a simple "pseudo" camera driver. Of course, with your two
> additional devices you don't want to add extra platform devices and extra
> probing. In fact, you can do this with the "old" (currently in the
> mainline) soc-camera model, where client drivers actively report
> themselves to the soc-camera core using soc_camera_device_register() /
> soc_camera_device_unregister() and the core doesn't care about the nature
> of those drivers. This is not going to be the case with the new platform /
> v4l2-subdev infrastructure, which is pretty tightly bound to i2c... So,
> we'll have to extend it too.

Not true. v4l2-device and v4l2-subdev are bus-independent. Only the
v4l2-i2c-* helper functions in v4l2-common.c are i2c dependent. For
example, ivtv uses v4l2_subdev to control devices connected via gpio,
while cx18 uses it for a logical video decoder block on the main asic.

Other than initialization and possibly cleanup there should be NO
bus-dependencies.

Regards,

         Hans

> I would suggest you reserve slots for those two from-memory video devices
> in your design, base your design on latest patches on this list (see the
> patches I just submitted) and concentrate on camera-devices for now. Then
> we shall see how to add non-i2c video data-sources to the framework.

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

