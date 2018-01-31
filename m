Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:46139 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752009AbeAaEvJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 23:51:09 -0500
Received: by mail-wr0-f182.google.com with SMTP id g21so13542278wrb.13
        for <linux-media@vger.kernel.org>; Tue, 30 Jan 2018 20:51:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <517f8b12-e10e-1e8d-6d98-26f5fefe62b8@xs4all.nl>
References: <1514491789-8697-1-git-send-email-tharvey@gateworks.com>
 <1514491789-8697-5-git-send-email-tharvey@gateworks.com> <1e65ee61-f282-4b53-dd03-68a89a91da8e@xs4all.nl>
 <CAJ+vNU1ysHuzqOnL4sf3hFZrU5kyGnQ0dFkRObVjCa=NyLsJug@mail.gmail.com> <517f8b12-e10e-1e8d-6d98-26f5fefe62b8@xs4all.nl>
From: Tim Harvey <tharvey@gateworks.com>
Date: Tue, 30 Jan 2018 20:51:07 -0800
Message-ID: <CAJ+vNU1xnnmNZW5zmT8+0HfT3Xfg6zfdrbC8vFNH4wuah5AVTA@mail.gmail.com>
Subject: Re: [PATCH v6 4/6] media: i2c: Add TDA1997x HDMI receiver driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 29, 2018 at 4:00 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 01/25/2018 05:15 PM, Tim Harvey wrote:
<snip>
>>>
>>> Hmm. This receiver supports multiple output formats, but you advertise only one.
>>> That looks wrong. If nothing else, you should be able to switch between RGB and
>>> YUV 4:4:4 since they use the same port config.
>>>
>>> It's a common use-case that you want to switch between RGB and YUV depending on
>>> the source material (i.e. if you receive a desktop/graphics then RGB is best, if
>>> you receive video then YUV 4:2:2 or 4:2:0 is best).
>>>
>>> Hardcoding just one format won't do.
>>>
>>
>> I've been thinking about this a bit. I had hard-coded a single format
>> for now because I haven't had any good ideas on how to deal with the
>> fact that the port mappings would need to differ if you change from
>> the RGB888/YUV444 (I think these are referred to as 'planar' formats?)
>> to YUV422 (semi-planar) and BT656 formats. It is true though that the
>> 36bit (TDA19973) RGB888/YUV444 and 24bit (TDA19971/2) formats can both
>> be supported with the same port mappings / pinout.
>
> Regarding terminology:
>
> RGB and YUV are typically interleaved, i.e. the color components are
> (for two pixels) either RGBRGB for RGB888, YUVYUV for YUV444 or YUYV
> for YUV422.
>
> Planar formats are in practice only seen for YUV and will first output
> all Y samples, and then the UV samples. This requires that the hardware
> buffers the frame and that's not normally done by HDMI receivers.
>
> The DMA engine, however, is often able to split up the interleaved YUV
> samples that it receives and DMA them to separate buffers, thus turning
> an interleaved media bus format to a planar memory format.
>
> BT656 doesn't refer to how the samples are transferred, instead it
> refers to how the hsync and vsync are reported. The enum v4l2_mbus_type
> has various options, one of them being BT656.
>
> Which mbus type is used is board specific (and should come from the
> device tree). Whether to transmit RGB888, YUV444 or YUV422 (or possibly
> even YUV420) is dynamic and is up to userspace since it is use-case
> dependent.
>
> So you'll never switch between BT656 and CSI, but you can switch between
> BT656+RGB and BT656+YUV, or between CSI+RGB and CSI+YUV.
>
>>
>> For example the GW5400 has a TDA19971 mapped to IMX6 CSI_DATA[19:4]
>> (16bit) for YUV422. However if you want to use BT656 you have to shift
>> the TDA19971 port mappings to get the YCbCr pins mapped to
>> CSI_DATA[19:x] and those pin groups are at the bottom of the bus for
>> the RGB888/YUV444 format.
>
> As mentioned above, you wouldn't switch between mbus types.
>
>>
>> I suppose however that perhaps for the example above if I have a 16bit
>> width required to support YUV422 there would never be a useful case
>> for supporting 8-bit/10-bit/12-bit BT656 on the same board?
>
> You wouldn't switch between mbus types, but if the device tree configures
> BT.656 with a bus width of 24 bits, then the application might very well
> want to dynamically switch between 8, 10 and 12 bits per color component.
>

Hans,

I just submitted a v7 with multiple format support. Your point about
bus_type being specified by dt is exactly what I needed to help make
sense of the formats.

That said, I'm unsure how to properly test the enum_mbus_code() pad op
function. How do you obtain a list of valid formats on a subdev?

I tried the following:
root@ventana:~# media-ctl -e 'tda19971 2-0048'
/dev/v4l-subdev1
root@ventana:~# media-ctl --get-v4l2 '"tda19971 2-0048":0'
                [fmt:UYVY8_2X8/1280x720 field:none colorspace:srgb]
^^^^ calls get_format and returns the 1 and only format available for
my tda19971 with 16bit parallel bus
root@ventana:~# v4l2-ctl -d /dev/v4l-subdev1 --get-fmt-video-out
VIDIOC_G_FMT: failed: Inappropriate ioctl for device
root@ventana:~# v4l2-ctl -d /dev/v4l-subdev1 --list-formats-out
ioctl: VIDIOC_ENUM_FMT

I'm thinking perhaps enumerating the list of possible formats is a
missing feature in media-ctl?

Regards,

Tim
