Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14929 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbZIXLVQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Sep 2009 07:21:16 -0400
From: "Yu, Jinlu" <jinlu.yu@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 24 Sep 2009 19:21:40 +0800
Subject: Re: [PATCH 0/5] V4L2 patches for Intel Moorestown Camera Imaging
Message-ID: <037F493892196B458CD3E193E8EBAD4F01ED6EEE10@pdsmsx502.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Hans/Guennadi

I am modifying these drivers to comply with v4l2 framework. I have finished replacing our buffer managing code with utility function from videobuf-core.c and videobuf-dma-contig.c. Now I am working on the subdev. One thing I am sure is that each sensor should be registered as a v4l2_subdev and ISP (Image Signal Processor) is registered as a v4l2_device acting as the bridge device. 

But we have two ways to deal with the relationship of sensor and ISP, and we don't know which one is better. Could you help me on this?

No.1. Register the ISP as a video_device (/dev/video0) and treat each of the sensor (SOC and RAW) as an input of the ISP. If I want to change the sensor, use the VIDIOC_S_INPUT to change input from sensor A to sensor B. But I have a concern about this ioctl. Since I didn't find any code related HW pipeline status checking and HW register setting in the implement of this ioctl (e.g. vino_s_input in /drivers/media/video/vino.c). So don't I have to stream-off the HW pipeline and change the HW register setting for the new input? Or is it application's responsibility to stream-off the pipeline and renegotiate the parameters for the new input?

No.2. Combine the SOC sensor together with the ISP as Channel One and register it as /dev/video0, and combine the RAW sensor together with the ISP as Channel Two and register it as /dev/video1. Surely, only one channel works at a certain time due to HW restriction. When I want to change the sensor (e.g. from SOC sensor to RAW sensor), just close /dev/video0 and open /dev/video1.

Best Regards
Jinlu Yu
Intel China Research Center

>-----Original Message-----
>From: linux-media-owner@vger.kernel.org
>[mailto:linux-media-owner@vger.kernel.org] On Behalf Of Hans Verkuil
>Sent: Saturday, May 02, 2009 11:43 PM
>To: Guennadi Liakhovetski
>Cc: Zhang, Xiaolin; linux-media@vger.kernel.org; Johnson, Charles F; Zhu, Daniel
>Subject: Re: [PATCH 0/5] V4L2 patches for Intel Moorestown Camera Imaging
>Drivers
>
>On Friday 01 May 2009 23:26:02 Guennadi Liakhovetski wrote:
>> On Thu, 30 Apr 2009, Zhang, Xiaolin wrote:
>> > Hi All,
>> >
>> > Here is the a set of V4L2 camera sensors and ISP drivers to support the
>> > Intel Moorestown camera imaging subsystem. The Camera Imaging interface
>> > in Moorestown is responsible for capturing both still and video frames.
>> > The CI handles demosaicing, color synthesis, filtering, image
>> > enhancement functions and JPEG encode. Intel Moorestown platform can
>> > support either a single camera or two cameras. A platform with two
>> > cameras will have on the same side as this display and the second on
>> > the opposite side the display. The camera on the display side will be
>> > used for video conferencing (with low resolution SoC cameras) and the
>> > other camera is used to still image capture or video recode (with high
>> > resolution RAW cameras).
>> >
>> > In this set of driver patches, I will submit the 5 patches to enable
>> > the ISP HW and 3 cameras module (two SoCs: 1.3MP - Omnivision 9665, 2MP
>> > - Omnivison 2650 and one RAW: 5MP - Omnivision 5630).
>> > 1. Intel Moorestown ISP driver.
>> > 2. Intel Moorestown camera sensor pseudo driver. This is to uniform the
>> > interfaces for ISP due to supporting dual cameras.
>> > 3. Intel Moorestown 2MP camera sensor driver.
>> > 4. Intel Moorestown 5MP camera sensor driver.
>> > 5. Intel Moorestown 1.3MP camera sensor driver.
>> >
>> > I will post the above 5 patches in near feature.
>>
>> I think this is a perfect candidate for the use of the v4l2-(sub)dev API,
>> and should be converted to use it, am I right?
>
>Absolutely. The sensor drivers must use v4l2_subdev, otherwise they will not
>be reusable by other drivers.
>
>There is a lot of work that needs to be done before these sensor drivers can
>be merged. These sensor drivers are tightly coupled to the platform driver,
>thus preventing any reuse of these i2c devices. That's bad and something
>that needs to be fixed first.
>
>Xiaolin, please take a look at Documentation/video4linux/v4l2-framework.txt
>for information on the new v4l2 framework. All v4l2 i2c drivers should use
>v4l2_subdev to enable reuse of these i2c devices in other platform drivers
>and webcams.
>
>Regards,
>
>	Hans
>
>>
>> Thanks
>> Guennadi
>> ---
>> Guennadi Liakhovetski, Ph.D.
>> Freelance Open-Source Software Developer
>> http://www.open-technology.de/
>
>
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
