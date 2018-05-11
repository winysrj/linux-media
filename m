Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:42932 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751462AbeEKFhl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 01:37:41 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tim Harvey <tharvey@gateworks.com>
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
References: <m37eobudmo.fsf@t19.piap.pl>
        <b6e7ba76-09a4-2b6a-3c73-0e3ef92ca8bf@gmail.com>
Date: Fri, 11 May 2018 07:37:39 +0200
In-Reply-To: <b6e7ba76-09a4-2b6a-3c73-0e3ef92ca8bf@gmail.com> (Steve
        Longerbeam's message of "Thu, 10 May 2018 09:32:51 -0700")
Message-ID: <m3tvresqfw.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve Longerbeam <slongerbeam@gmail.com> writes:

>> Second, the image format information I'm getting out of "ipu2_csi1
>> capture" device is:
>>
>> open("/dev/video6")
>> ioctl(VIDIOC_S_FMT, {V4L2_BUF_TYPE_VIDEO_CAPTURE,
>> 	fmt.pix={704x576, pixelformat=NV12, V4L2_FIELD_INTERLACED} =>
>> 	fmt.pix={720x576, pixelformat=NV12, V4L2_FIELD_INTERLACED,
>>          bytesperline=720, sizeimage=622080,
>> 	colorspace=V4L2_COLORSPACE_SMPTE170M}})
>>
>> Now, the resulting image obtained via QBUF/DQBUF doesn't seem to be
>> a single interlaced frame (like it was with older drivers). Actually,
>> I'm getting the two fields, encoded with NV12 and concatenated
>> together (I think it's V4L2_FIELD_SEQ_TB or V4L2_FIELD_SEQ_BT).
>>
>> What's wrong?
>
> Set field type at /dev/video6 to NONE. That will enable IDMAC
> interweaving of the top and bottom fields.

Such as this?
"adv7180 2-0020":0
                [fmt:UYVY2X8/720x576 field:interlaced]
"ipu2_csi1_mux":1
                [fmt:UYVY2X8/720x576 field:interlaced]
"ipu2_csi1_mux":2
                [fmt:UYVY2X8/720x576 field:interlaced]
"ipu2_csi1":0
                [fmt:UYVY2X8/720x576 field:interlaced
                 crop.bounds:(0,0)/720x576
                 crop:(0,0)/720x576
                 compose.bounds:(0,0)/720x576
                 compose:(0,0)/720x576]
"ipu2_csi1":2
                [fmt:AYUV32/720x576 field:none]

There is something wrong - the resulting image is out of (vertical)
sync, it seems the time it takes to receive a frame is a bit longer than
the normal 40 ms. I can also set field to NONE on "ipu2_csi1_mux":[12]
but it doesn't sync, either. Only with everything set to INTERLACED, the
frame is synchronized (actually, it starts unsynchronized, but slowly
scrolls down the screen and eventually "catches sync").
With the old drivers nothing like this happens: the image is "instantly"
synchronized and it's a single interlaced frame, not the two halves
concatenated.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
