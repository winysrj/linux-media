Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:44510 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750711AbeEKRfg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 13:35:36 -0400
Received: by mail-pf0-f179.google.com with SMTP id q22-v6so3039166pff.11
        for <linux-media@vger.kernel.org>; Fri, 11 May 2018 10:35:35 -0700 (PDT)
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
To: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
Cc: linux-media@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tim Harvey <tharvey@gateworks.com>
References: <m37eobudmo.fsf@t19.piap.pl>
 <b6e7ba76-09a4-2b6a-3c73-0e3ef92ca8bf@gmail.com> <m3tvresqfw.fsf@t19.piap.pl>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <08726c4a-fb60-c37a-75d3-9a0ca164280d@gmail.com>
Date: Fri, 11 May 2018 10:35:28 -0700
MIME-Version: 1.0
In-Reply-To: <m3tvresqfw.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/10/2018 10:37 PM, Krzysztof Hałasa wrote:
> Steve Longerbeam <slongerbeam@gmail.com> writes:
>
>>> Second, the image format information I'm getting out of "ipu2_csi1
>>> capture" device is:
>>>
>>> open("/dev/video6")
>>> ioctl(VIDIOC_S_FMT, {V4L2_BUF_TYPE_VIDEO_CAPTURE,
>>> 	fmt.pix={704x576, pixelformat=NV12, V4L2_FIELD_INTERLACED} =>
>>> 	fmt.pix={720x576, pixelformat=NV12, V4L2_FIELD_INTERLACED,
>>>           bytesperline=720, sizeimage=622080,
>>> 	colorspace=V4L2_COLORSPACE_SMPTE170M}})
>>>
>>> Now, the resulting image obtained via QBUF/DQBUF doesn't seem to be
>>> a single interlaced frame (like it was with older drivers). Actually,
>>> I'm getting the two fields, encoded with NV12 and concatenated
>>> together (I think it's V4L2_FIELD_SEQ_TB or V4L2_FIELD_SEQ_BT).
>>>
>>> What's wrong?
>> Set field type at /dev/video6 to NONE. That will enable IDMAC
>> interweaving of the top and bottom fields.
> Such as this?
> "adv7180 2-0020":0
>                  [fmt:UYVY2X8/720x576 field:interlaced]
> "ipu2_csi1_mux":1
>                  [fmt:UYVY2X8/720x576 field:interlaced]
> "ipu2_csi1_mux":2
>                  [fmt:UYVY2X8/720x576 field:interlaced]
> "ipu2_csi1":0
>                  [fmt:UYVY2X8/720x576 field:interlaced
>                   crop.bounds:(0,0)/720x576
>                   crop:(0,0)/720x576
>                   compose.bounds:(0,0)/720x576
>                   compose:(0,0)/720x576]
> "ipu2_csi1":2
>                  [fmt:AYUV32/720x576 field:none]


Yes, that looks fine.

> There is something wrong - the resulting image is out of (vertical)
> sync,

Yes, the CSI on i.MX6 does not deal well with unstable bt.656 sync codes,
which results in vertical sync issues (scrolling or split images). The 
ADV7180
will often shift the sync codes around in various situations (initial 
power on,
see below, also when there is an interruption of the input analog CVBS
signal).

There is a frame interval monitor in the imx-media driver that can catch 
these
unstable sync code events and send an v4l2 event to userspace, userspace can
then issue stream off->on which usually corrects the vertical sync.

See https://linuxtv.org/downloads/v4l-dvb-apis/v4l-drivers/imx.html, section
15.9 for more info on the vertical sync issues in i.MX6 CSI and how to setup
the FIM to correct them.

One other thing I've noticed is that the ADV7180 can send unstable bt.656
sync codes after initial power on. Try adding a ~10 frame time delay in
adv7180_set_power(), so that the imx CSI won't see these frames and
get tripped up at stream on.


>   it seems the time it takes to receive a frame is a bit longer than
> the normal 40 ms. I can also set field to NONE on "ipu2_csi1_mux":[12]
> but it doesn't sync, either. Only with everything set to INTERLACED, the
> frame is synchronized (actually, it starts unsynchronized, but slowly
> scrolls down the screen and eventually "catches sync").
> With the old drivers nothing like this happens: the image is "instantly"
> synchronized and it's a single interlaced frame, not the two halves
> concatenated.

The old driver, IIRC, would also catch the unstable sync codes via
a FIM, but would internally restart IPU capture hardware without
the involvement of userspace, effectively this was an internal
stream on/off. In imx-media, this must be done via userspace when
it catches the V4L2_EVENT_IMX_FRAME_INTERVAL_ERROR event.

Steve
