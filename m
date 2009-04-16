Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:11620 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbZDPKAe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 06:00:34 -0400
Received: by rv-out-0506.google.com with SMTP id f9so338690rvb.1
        for <linux-media@vger.kernel.org>; Thu, 16 Apr 2009 03:00:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0904161032050.4947@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
	 <Pine.LNX.4.64.0904151403500.4729@axis700.grange>
	 <5e9665e10904151919p50c695e2s35140402d2c7345c@mail.gmail.com>
	 <Pine.LNX.4.64.0904161032050.4947@axis700.grange>
Date: Thu, 16 Apr 2009 19:00:32 +0900
Message-ID: <5e9665e10904160300k7e581910r73710d8ffe5230a8@mail.gmail.com>
Subject: Re: [PATCH 5/5] soc-camera: Convert to a platform driver
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Guennadi,

On Thu, Apr 16, 2009 at 5:58 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Thu, 16 Apr 2009, Dongsoo, Nathaniel Kim wrote:
>
>> Hello Guennadi,
>>
>>
>> Reviewing your patch, I've got curious about a thing.
>> I think your soc camera subsystem is covering multiple camera
>> devices(sensors) in one target board, but if that is true I'm afraid
>> I'm confused how to handle them properly.
>> Because according to your patch, video_dev_create() takes camera
>> device as parameter and it seems to be creating device node for each
>> camera devices.
>
> This patch is a preparatory step for the v4l2-(sub)dev conversion. With it
> yes (I think) a video device will be created for every registered on the
> platform level camera, but only the one(s) that probed successfully will
> actually work, others will return -ENODEV on open().
>
>> It means, if I have one camera host and several camera devices, there
>> should be several device nodes for camera devices but cannot be used
>> at the same time. Because typical camera host(camera interface) can
>> handle only one camera device at a time. But multiple device nodes
>> mean "we can open and handle them at the same time".
>>
>> How about registering camera host device as v4l2 device and make
>> camera device a input device which could be handled using
>> VIDIOC_S_INPUT/G_INPUT api?
>
> There are also cases, when you have several cameras simultaneously (think
> for example about stereo vision), even though we don't have any such cases
> just yet.

I think, there are some specific camera interfaces for stereo camera.
Like stereo camera controller chip from Epson.

But in case of camera interface which can handle only one single
camera at a time, I'm strongly believing that we should use only one
device node for camera.
I mean device node should be the camera interface not the sensor
device. If you are using stereo camera controller chip, you can make
that with a couple of device nodes, like /dev/video0 and /dev/video1.


>
>> Actually, I'm working on S3C64xx camera interface driver with soc
>> camera subsystem,
>
> Looking forward to it!:-)
>
>> and I'm facing that issue right now because I've got
>> dual camera on my target board.
>
> Good, I think, there also has been a similar design based on a pxa270 SoC.
> How are cameras switched in your case? You probably have some additional
> hardware logic to switch between them, right? So, you need some code to
> control that. I think, you should even be able to do this automatically in
> your platform code using power hooks from the struct soc_camera_link. You
> could fail to power on a camera if another camera is currently active. In
> fact, I have to add a return code test to the call to icl->power(icl, 1)
> in soc_camera_open(), I'll do this for the final v4l2-dev version. Would
> this work for you or do you have another requirements? In which case, can
> you describe your use-case in more detail - should both cameras be open by
> applications simultaneously (looks like not), do you need a more explicit
> switching control, than just "first open switches," which shouldn't be the
> case, since you can even create a separate task, that does nothing but
> just keeps the required camera device open.
>

Yes exactly right. My H/W is designed to share data pins and mclk,
pclk pins between both of cameras.
And they have to work mutually exclusive.
For now I'm working on s3c64xx with soc camera subsystem, so no way to
make dual camera control with VIDIOC_S_INPUT, VIDIOC_G_INPUT. But the
prior version of my driver was made to control dual camera with those
S_INPUT/G_INPUT api.
Actually with single device node and switching camera with S_INPUT and
G_INPUT, there is no way to mis-control dual camera.
Because both of cameras work mutually exclusive.

To make it easier, you can take a look at my presentation file which I
gave a talk at CELF ELC2009 in San Francisco.
Here it is the presentation file

http://tree.celinuxforum.org/CelfPubWiki/ELC2009Presentations?action=AttachFile&do=get&target=Framework_for_digital_camera_in_linux-in_detail.ppt

I think it is more decent way to control dual camera. No need to check
whether the sensor is available or not using this way. Just use
G_INPUT to check current active sensor and do S_INPUT to switch into
another one.
Cheers,

Nate


>> I hope you to consider this concept, and also want to know your opinion.
>
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
