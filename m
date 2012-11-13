Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:48723 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab2KMWyS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 17:54:18 -0500
Message-ID: <50A2CF95.4000202@gmail.com>
Date: Tue, 13 Nov 2012 23:54:13 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Andrey Gusakov <dron0gus@gmail.com>
CC: Tomasz Figa <tomasz.figa@gmail.com>,
	In-Bae Jeong <kukyakya@gmail.com>,
	=?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: S3C244X/S3C64XX SoC camera host interface driver questions
References: <CAA11ShCpH7Z8eLok=MEh4bcSb6XjtVFfLQEYh2icUtYc-j5hEQ@mail.gmail.com> <5096C561.5000108@gmail.com> <CAA11ShCKFfdmd_ydxxCYo9Sv0VhgZW9kCk_F7LAQDg3mr5prrw@mail.gmail.com> <5096E8D7.4070304@gmail.com> <CAA11ShDinm7oU4azQYPMrNDsqWPqw+vJNFPpBDNzV=dTeUdZzw@mail.gmail.com> <50979998.8090809@gmail.com> <CAA11ShD6Qug_=t8vGE5LwSpfXW2FsceTonxnF8aO6i2b=inibw@mail.gmail.com> <50983CFD.2030104@gmail.com> <CAA11ShDAscm8snYzjnC3Fe1MaVXc-FJqhWM677iJwgbgu2_J1Q@mail.gmail.com> <509AD957.5070301@gmail.com> <CAA11ShCn3S_nxXg5_pAsgcMsPFpER7XrHsvg71DrznAmONu7Lg@mail.gmail.com> <509CBB61.40206@gmail.com> <CAA11ShB1s6wSEEoVQ2_z4_BaGdM8f_F7ec_UrZzhcBgzoABAtQ@mail.gmail.com>
In-Reply-To: <CAA11ShB1s6wSEEoVQ2_z4_BaGdM8f_F7ec_UrZzhcBgzoABAtQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrey,

On 11/11/2012 02:26 PM, Andrey Gusakov wrote:
> Hi.
>
> Patch v2 attached. Comments taken into account.

Thanks, I had to rework the S3C-CAMIF subdev controls handling to avoid
races when the control's value is modified in the control framwework and
accessed from interrupt context in the driver.

I've pushed all patches to branch s3c-camif-for-v3.8 at
git://linuxtv.org/snawrocki/media.git

I'd like to squash all the s3c-camif patches before sending upstream,
if you don't mind. And to add your Signed-off at the final patch.
Please let me know if you'd rather keep your patch separate.

I might have introduced bugs in the image effects handling, hopefully
there is none. I couldn't test it though. Could you test that on your
side with s3c64xx ?

I'm planning to send a pull request for the CAMIF driver this week.

>>> I often get "VIDIOC_QUERYCAP: failed: Inappropriate ioctl for device"
>> This is an issue in the v4l2-ctl, it is going to be fixed by adding
>> VIDIOC_SUBDEV_QUERYCAP ioctl for subdevs. It has been just discussed today.
>> I guess you get it when running v4l2-ctl on /dev/v4l-subdev* ?
> Yes.
>>> or "system error: Inappropriate ioctl for device"
>> I think this one is caused by unimplemented VIDIOC_G/S_PARM ioctls
>> at the s3c-camif driver.
>>> Is it because of not implemented set/get framerate func? How this
>> Yes, I think so. ioctls as above.
> Ok. I'll implement this ioctls and see what happens.

They are not supposed to be implemented in the s3c-camif driver.
Instead they should be emulated by a user-space library, based on
the sensor subdev operations.

>>> should work? I mean framerate heavy depend of sensor's settings. So
>>> set/get framerate call to fimc should get/set framerate from sensor.
>>> What is mechanism of such things?
>>
>>
>> With user space subdev API one should control frame interval directly
>> on the sensor subdev device node [1]. For Gstreamer to work with
>> VIDIOC_G/S_PARM ioctls we need a dedicated v4l2 library (possibly with
>> a plugin for s3c-camif, but that shouldn't be needed since it is very
>> simple driver) that will translate those video node ioctls into the
>> subdev node ioctls [2]. Unfortunately such library is still not available.
>>
>>
>>> And same question about synchronizing format of sensor and FIMC pads.
>>> I make ov2640 work, but if did not call media-ctl for sensor, format
>>> of FIMC sink pad and format of sensor source pad different. I think I
>>> missed something, but reading other sources did not help.
>>
>>
>> As I explained previously, s3c-fimc is supposed to synchronize format
>> with the sensor subdev. Have you got pad level get_fmt callback
>> implemented in the ov2640 driver ?
> Yes.
>> Could you post your 'media-ctl -p' output, run right after the system boot ?
>
> Looks like I messed up, after starting formats are the same:
>
> Opening media device /dev/media0ov2640: ov2640_open:1381
>
> Enumerating entities
> Found 4 entities
> Enumerating pads and links
> Media controller API version 0.0.0
>
> Media device information
> ------------------------
> driver          s3c-camif
> model           SAMSUNG S3C6410 CAMIF
> serial
> bus info        platform:%s

I've removed this stray "%s" already.

> hw revision     0x32
> driver version  0.0.0
>
> Device topology
> - entity 1: ov2640 (1 pad, 1 link)
>              type V4L2 subdev subtype Sensor
>              device node name /dev/v4l-subdev0
>          pad0: Source [YUYV2X8 176x144]
>                  ->  "S3C-CAMIF":0 [ENABLED,IMMUTABLE]
>
> - entity 2: S3C-CAMIF (3 pads, 3 links)
>              type V4L2 subdev subtype Unknown
>              device node name /dev/v4l-subdev1
>          pad0: Sink [YUYV2X8 176x144 (0,0)/176x144]
>                  <- "ov2640":0 [ENABLED,IMMUTABLE]
>          pad1: Source [YUYV2X8 176x144]
>                  ->  "camif-codec":0 [ENABLED,IMMUTABLE]
>          pad2: Source [YUYV2X8 176x144]
>                  ->  "camif-preview":0 [ENABLED,IMMUTABLE]
>
> - entity 3: camif-codec (1 pad, 1 link)
>              type Node subtype V4L
>              device node name /dev/video0
>          pad0: Sink
>                  <- "S3C-CAMIF":1 [ENABLED,IMMUTABLE]
>
> - entity 4: camif-preview (1 pad, 1 link)
>              type Node subtype V4L
>              device node name /dev/video1
>          pad0: Sink
>                  <- "S3C-CAMIF":2 [ENABLED,IMMUTABLE]

Looks fine, thanks.

