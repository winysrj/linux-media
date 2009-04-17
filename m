Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:41013 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444AbZDQGqs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 02:46:48 -0400
Received: by wf-out-1314.google.com with SMTP id 29so777694wff.4
        for <linux-media@vger.kernel.org>; Thu, 16 Apr 2009 23:46:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0904162147370.4947@axis700.grange>
References: <5e9665e10904151712o5fa3076dr85ad12fc7f04914d@mail.gmail.com>
	 <Pine.LNX.4.64.0904162147370.4947@axis700.grange>
Date: Fri, 17 Apr 2009 15:46:47 +0900
Message-ID: <5e9665e10904162346g37a29778ub0fd4c9f5c11f1df@mail.gmail.com>
Subject: Re: [RFC] Making Samsung S3C64XX camera interface driver in SoC
	camera subsystem
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	kernel@pengutronix.de,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	dongsoo45.kim@samsung.com, Hans Verkuil <hverkuil@xs4all.nl>,
	"Ailus Sakari (Nokia-D/Helsinki)" <Sakari.Ailus@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,


On Fri, Apr 17, 2009 at 4:58 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Thu, 16 Apr 2009, Dongsoo, Nathaniel Kim wrote:
>
>> Hello,
>>
>> I'm planing to make a new camera interface driver for S3C64XX from Samsung.
>> Even if it already has a driver, it seems to be re-designed for some
>> reasons. If you are interested in, take a look at following repository
>> (http://git.kernel.org/?p=linux/kernel/git/eyryu_ap/samsung-ap-2.6.24.git;a=summary)
>> drivers/media/video/s3c_* files
>>
>> Before beginning to implement a new driver for that, I need to clarify
>> some of features about how to implement in driver.
>>
>> Please take a look at the diagram on page 610 of following user manual
>> of s3c6400.
>> http://www.ebv.com/fileadmin/products/Products/Samsung/S3C6400/S3C6400X_UserManual_rev1-0_2008-02_661558um.pdf
>>
>> It seems to have a couple of path for camera data named codec and
>> preview, and they could be used at the same time.
>> It means that it has no problem making those two paths into
>> independent device nodes like /dev/video0 and /dev/video1
>>
>> But there is a limit of size using both of paths at the same time. I
>> mean, If you are using preview path and camera sensor is running with
>> 1280*720 resolution (which seems to be the max resolution could be
>> handled by preview path), codec path can't use resolution bigger than
>> 1280*720 at the same time because camera sensor can't produce
>> different resolution at a time.
>>
>> And also we should face a big problem when we are making dual camera
>> system with s3c64xx. Dual camera with single camera interface has some
>> restriction using clock and data path, because they have to be shared
>> between both of cameras.
>> I suppose to handle them with VIDIOC_S_INPUT and G_INPUT. And with
>> those, we can handle dual camera with single camera interface in a
>> decent way.
>>
>> But the thing is that there should be a problem using dual camera with
>> preview and codec path of s3c64xx. Even if we have each preview, and
>> codec device node and can't open them concurrently when user is
>> attempting to open each camera sensor like "camera A with preview node
>> and camera B with codec node". Because both of those camera sensors
>> are sharing same data path and clock source, and s3c64xx camera
>> interface only can handle one camera at a time.
>>
>> So, what I am concerned is how to make it a elegant driver which has
>> two device nodes handling multiple sensors as input devices.
>> Sounds complicated but I'm asking you to help me with any opinion
>> about designing this driver. Any opinion about these issues will be
>> greatly helpful to me.
>
> Ok, now I understand your comments to my soc-camera thread better. Now,
> what about making one (or more) video devices with V4L2_CAP_VIDEO_CAPTURE
> type and one with V4L2_CAP_VIDEO_OUTPUT? Then you can use your capture
> type devices to switch between cameras and to configure input, and your
> output device to configure preview? Then you can use soc-camera to control
> your capture devices (if you want to of course) and implement an output
> device directly. It should be a much simpler device, because it will not
> be communicating with the cameras and only modify various preview
> parameters.
>

It's a cool idea! Adding my understanding to your comment,

1. make preview device a video output
=> it makes sense. but codec path also has dedicated DMA to frame buffer.
What should we do with that? I have no idea by now.

2. preview device can have two inputs
   a) input from camera device : ok it's an ordinary way
   b) input from MSDMA : we can give RGB data upto 720P to preview
device with rotating and resizing supported

Does it sound ok?
BTW, OMAP3 has similar feature with this. omap vout something?
And by now I'm gonna make my driver with soc camera subsystem without
VIDIOC_S_INPUT/G_INPUT, but I'm still desperate for that.
Thank you for your opinion. I deeply appreciate that.
Cheers,

Nate


> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
>



-- 
========================================================
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
========================================================
