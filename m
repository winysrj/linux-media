Return-path: <linux-media-owner@vger.kernel.org>
Received: from a-painless.mh.aa.net.uk ([81.187.30.51]:60368 "EHLO
        a-painless.mh.aa.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932745AbcLMQGZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 11:06:25 -0500
Subject: Re: Sony imx219 driver?
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
References: <09ab897e-79a9-ae44-4caa-93d8d1fa1c51@synopsys.com>
Cc: linux-media@vger.kernel.org
From: Dave Stevenson <linux-media@destevenson.freeserve.co.uk>
Message-ID: <dcf92a8f-1e3c-4c9f-3694-95cff9998456@destevenson.freeserve.co.uk>
Date: Tue, 13 Dec 2016 16:06:11 +0000
MIME-Version: 1.0
In-Reply-To: <09ab897e-79a9-ae44-4caa-93d8d1fa1c51@synopsys.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramiro

On 13/12/16 13:47, Ramiro Oliveira wrote:
> Hi Dave
>
> On 07/21/2016 08:19 PM, Dave Stevenson wrote:
>> Just a quick query to avoid duplicating effort. Has anyone worked on a
>> Sony IMX219 (or other Sony sensor) subdevice driver as yet?
>>
>> With the new Raspberry Pi camera being IMX219, and as Broadcom have
>> released an soc_camera based driver for the sensor already
>> (https://android.googlesource.com/kernel/bcm/+/android-bcm-tetra-3.10-lollipop-wear-release/drivers/media/video/imx219.c)
>> I was going to investigate converting that to a subdevice. I just wanted
>> to check this wasn't already in someone else's work queue.
>>
>> A further Google shows that there's also an soc_camera IMX219 driver in
>> ChromiumOS, copyright Andrew Chew @ Nvidia, but author Guennadi
>> Liakhovetski who I know posts on here.
>> https://chromium.googlesource.com/chromiumos/third_party/kernel/+/factory-ryu-6486.14.B-chromeos-3.14/drivers/media/i2c/soc_camera/imx219.c.
>> The Broadcom one supports 8MPix and 1080P, the Chromium one only 8MP.
>> Perhaps a hybrid of the feature set? Throw in
>> https://github.com/ZenfoneArea/android_kernel_asus_zenfone5/blob/master/linux/modules/camera/drivers/media/i2c/imx219/imx219.h
>> as well, and we have register sets for numerous readout modes, plus
>> there are the ones in the Pi firmware which can be extracted if necessary.
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
> Do you still plan on submitting this driver? If so, do you plan on submitting it
> soon?
>
> If you're not planning on submitting it any time soon, do you mind if submit it
> myself? I'm planning on having something ready for kernel submission by January.

I've got bogged down in other things and not got anywhere as yet, so go 
for it.
When I've got the CSI2 receiver subdevice working (hopefully soon) then 
I'll happily test your driver with it. For the time being I've been 
working against the TC358743 driver.

   Dave

> Thanks,
> Ramiro Oliveira
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
