Return-path: <linux-media-owner@vger.kernel.org>
Received: from b.painless.aa.net.uk ([81.187.30.52]:46649 "EHLO
	b.painless.aa.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbcGVVe5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 17:34:57 -0400
Subject: Re: Sony imx219 driver?
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <57911245.1010500@destevenson.freeserve.co.uk>
 <5c425f34-d044-f228-65a4-f67430d55941@xs4all.nl>
From: Dave Stevenson <linux-media@destevenson.freeserve.co.uk>
Message-ID: <57928260.3080503@destevenson.freeserve.co.uk>
Date: Fri, 22 Jul 2016 21:30:24 +0100
MIME-Version: 1.0
In-Reply-To: <5c425f34-d044-f228-65a4-f67430d55941@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans.

On 22/07/16 10:46, Hans Verkuil wrote:
>
>
> On 07/21/2016 08:19 PM, Dave Stevenson wrote:
>> Hi All.
>>
>> Just a quick query to avoid duplicating effort. Has anyone worked on a
>> Sony IMX219 (or other Sony sensor) subdevice driver as yet?
>
> Not that I am aware of.

OK, glad to hear I won't be duplicating effort.

>> With the new Raspberry Pi camera being IMX219, and as Broadcom have
>> released an soc_camera based driver for the sensor already
>> (https://android.googlesource.com/kernel/bcm/+/android-bcm-tetra-3.10-lollipop-wear-release/drivers/media/video/imx219.c)
>
> #@!@$! Why do they never ever ask us what would be a good example driver to use. The
> soc-camera framework is deprecated and will likely be gone by the end of the year.

Yes, a touch grim.
I'm aware of the project it was done for from my time at Broadcom but 
wasn't directly involved. Partly in their defence:
(a) It was almost 3 years ago.
(b) It's on top of a 3.10 kernel, so lots of the nicer features that are 
now present just weren't there.
(c) However they did bastardise even soc_camera to extract extra info 
from the sensor driver for some of their upper layers. Not so nice.

>> I was going to investigate converting that to a subdevice. I just wanted
>> to check this wasn't already in someone else's work queue.
>>
>> A further Google shows that there's also an soc_camera IMX219 driver in
>> ChromiumOS, copyright Andrew Chew @ Nvidia, but author Guennadi
>> Liakhovetski who I know posts on here.
>> https://chromium.googlesource.com/chromiumos/third_party/kernel/+/factory-ryu-6486.14.B-chromeos-3.14/drivers/media/i2c/soc_camera/imx219.c.
>
> At least for the tegra there is a proper non-soc-camera driver in the works.

non-soc-camera driver for imx219, or for the tegra hardware blocks? I'm 
assuming the latter based on you saying you're not aware of an imx219 
driver being in progress.

As I have mentioned before, the other half of my playing is a subdevice 
driver for the CSI2 receiver on Pi. That bcm android kernel tree also 
released all the info needed for that block into the public domain, so 
I'm not even breaching NDAs in doing so :-) I hope to test my imx219 
driver against that.

>> The Broadcom one supports 8MPix and 1080P, the Chromium one only 8MP.
>> Perhaps a hybrid of the feature set?
>
> They usually only implement what they need, so I'd say for chromium they only needed 8MP support.
>
>> Throw in
>> https://github.com/ZenfoneArea/android_kernel_asus_zenfone5/blob/master/linux/modules/camera/drivers/media/i2c/imx219/imx219.h
>> as well, and we have register sets for numerous readout modes, plus
>> there are the ones in the Pi firmware which can be extracted if necessary.
>
> With all that code it shouldn't be hard to write a proper subdev driver.

Indeed.
I'll try to put something together and submit it to the list. I don't 
know what my timescales will end up being on it though.

>>
>> On a related note, if putting together a system with IMX219 or similar
>> producing Bayer raw 10, the data on the CSI2 bus is one of the
>> V4L2_PIX_FMT_SRGGB10P formats. What's the correct way to reflect that
>> from the sensor subdevice in an MEDIA_BUS_FMT_ enum?
>> The closest is MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE (or LE), but the data
>> isn't padded (the Pi CSI2 receiver can do the unpacking and padding, but
>> that just takes up more memory).|||| Or is it MEDIA_BUS_FMT_SBGGR10_1X10
>> to describe the data on the bus correctly as 10bpp Bayer, and the odd
>> packing is ignored. Or do we need new enums?
>
> Just add new enums to media-bus-format.h. It should be clear from comments and/or
> the naming of the enum what the exact format it, so you'll need to think about
> that carefully. Otherwise it's no big deal to add new formats there.

OK, will do.
I wasn't clear from reading the docs how accurately MEDIA_BUS_FMT_ was 
describing the pixel layout as it mentions NOT having a 1:1 mapping with 
V4L2_PIX_FMT_ enums. Having the clarification is great.

Thanks for the advice.
   Dave
