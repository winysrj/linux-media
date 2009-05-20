Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:36227 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbZETRNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2009 13:13:32 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 20 May 2009 12:13:10 -0500
Subject: RE: MT9T031 and other similar sub devices...
Message-ID: <A69FA2915331DC488A831521EAE36FE401353CD999@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE401353CD3D6@dlee06.ent.ti.com>
 <Pine.LNX.4.64.0905200909240.4423@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0905200909240.4423@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for your prompt reply. Where do I pick your latest mt9t031.c that has partial implementation of sub device model ? I can work on that and try to integrate the same. I will remove item 1) that I mentioned and also add support for interface parameter query for bridge driver usage. I am happy to work with you on this driver.

Regards,
Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Wednesday, May 20, 2009 3:21 AM
>To: Karicheri, Muralidharan
>Cc: linux-media@vger.kernel.org
>Subject: Re: MT9T031 and other similar sub devices...
>
>Hi Murali
>
>On Tue, 19 May 2009, Karicheri, Muralidharan wrote:
>
>> Hi, Guennadi Liakhovetski,
>>
>> Thanks for your effort to migrate the sensor drivers to sub device
>framework.
>>
>> We have interest in mt9t031 and other sensor drivers from Micron since
>> this peripheral is used in our DM355/DM6446 EVMs as well. I have
>> submitted a set of patches for our vpfe_capture driver to the media
>> mailing list for review. This driver runs on DM355/DM6446 EVMs and is
>> developed to use the sub device model to integrate with capture
>> peripheral like TVP5146, MT9T001, MT9T031 etc.
>
>You mean MT9M001, right?
>
No. MT9T031
>> If you have a version of
>> mt9t031 driver migrated to sub device, I would like to integrate that
>> with our vpfe_capture driver.
>
>Nice, that's what the whole sudev conversion is (largely) about, AFAICS.
>
>> I want to check following with you so as to be on the same page.
>>
>> 1) I see that the mt9t001.c still uses struct soc_camera_device and
>> calls soc_camera_video_start() to start the master. This introduces a
>> reverse dependency from the sub device to bridge driver (correct me if I
>> my understanding is wrong). I guess you plan to remove this dependency
>> in your future patch. With this in the driver, it can't work with our
>> driver since we don't have soc_camera_device.
>
>Correct.
>
>> 2) vpfe_capture driver support raw bayer interface as well as raw yuv
>> interface. Raw bayer interface can be 8-16 bits wide along with
>> HD/VD/field lines. So in order for the bridge driver to configure the
>> interface, it needs to know parameters like interface type (BT.656,
>> BT.1120, Raw image data (8-16) etc), polarity of HD, VD, PCLK, field
>> signals etc. Is there a infrastructure for handling this ? I mean, we
>> should have a way of defining this per platform, which some how can be
>> read by bridge driver to configure the interface to work with a specific
>> sub device.
>
>Right, this is one of the pieces still missing in the v4l2-(sub)dev
>framework, which we have in soc_camera, and which we'll have to think
>about bringing over to v4l2-subdev. That's one of the reasons why the
>conversion is not complete yet.
>
>The other (and main) reason is my time. I'm doing this at my free time,
>and I don't know when next time I'll come round to progressing this work.
>So, either you can provide patches to speed up the process, or you can
>wait for me, or someone might want to pay for this work to be done:-)
>
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/

