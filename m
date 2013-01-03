Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:53569 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3ACFBM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 00:01:12 -0500
Received: by mail-we0-f180.google.com with SMTP id t57so6929922wey.11
        for <linux-media@vger.kernel.org>; Wed, 02 Jan 2013 21:01:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1301021100130.7829@axis700.grange>
References: <CA+V-a8uK38_HrYa2ic5soLE=Ge0aK3=PObNCs_xMf=PAzcwBcg@mail.gmail.com>
 <Pine.LNX.4.64.1301021100130.7829@axis700.grange>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 3 Jan 2013 10:30:50 +0530
Message-ID: <CA+V-a8uz-5GW6OidDdQ9CNBgJy51pCZAdGjRNDJ6P9wPxrC5zg@mail.gmail.com>
Subject: Re: DT bindings for subdevices
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for your response!

On Wed, Jan 2, 2013 at 3:49 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi Prabhakar
>
> On Wed, 2 Jan 2013, Prabhakar Lad wrote:
>
>> Hi,
>>
>> This is my first step towards DT support for media, Question might be
>> bit amateur :)
>
> No worries, we're all doing our first steps in this direction right at the
> moment. These two recent threads should give you an idea as to where we
> stand atm:
>
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/58646
>
> and (optionally, to a lesser extent)
>
> http://www.spinics.net/lists/linux-media/index.html#57836
>
Thanks for the links.

>> In the video pipeline there will be external devices (decoders/camera)
>> connected via
>> i2c, spi, csi. This sub-devices take platform data. So question is
>> moving ahead and
>> adding DT support for this subdevices how should this platform data be
>> passed through.
>> Should it be different properties for different devices.
>
> Mostly, yes.
>
Ok

>> For example the mt9t001 sensor takes following platform data:
>> struct mt9t001_platform_data {
>>       unsigned int clk_pol:1;
>
> This would presumably be the standard "pclk-sample" property from the
> first of the above two quoted threads
>
>>       unsigned int ext_clk;
>
> Is this the frequency? This should be replaced by a phandle, linking to a
Yes its the external clock frequency.

> clock device-tree node, assuming, your platform is implementing the
> generic clock API. If it isn't yet, not a problem either:-) In either case
> your sensor driver shall be using the v4l2_clk API to retrieve the clock
> rate and your camera host driver should be providing a matching v4l2_clk
> instance and implementing its methods, including retrieving the frequency.
>
Ok.

>> };
>> similarly mt9p031 takes following platform data:
>>
>> struct mt9p031_platform_data {
>>       int (*set_xclk)(struct v4l2_subdev *subdev, int hz);
>
> Not sure what the xclk is, but, presumable, this should be ported to
> v4l2_clk too.
>
>>       int reset;
>
> This is a GPIO number, used to reset the chip. You should use a property,
> probably, calling it "reset-gpios", specifying the desired GPIO.
>
>>       int ext_freq;
>>       int target_freq;
>
> Presumably, ext_freq should be retrieved, using v4l2_clk_get_rate() and
> target_freq could be a proprietary property of your device.
>
Ok.

Regards,
--Prabhakar

> Thanks
> Guennadi
>
>> };
>>
>> should this all be individual properties ?
>>
>> Regards,
>> --Prabhakar
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
