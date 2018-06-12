Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:54341 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933469AbeFLR1z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 13:27:55 -0400
Received: by mail-wm0-f68.google.com with SMTP id o13-v6so372201wmf.4
        for <linux-media@vger.kernel.org>; Tue, 12 Jun 2018 10:27:54 -0700 (PDT)
From: Javier Martinez Canillas <javierm@redhat.com>
Subject: Re: [PATCH] gpu: ipu-v3: Allow negative offsets for interlaced
 scanning
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org
Cc: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>,
        kernel@pengutronix.de
References: <20180601131316.18728-1-p.zabel@pengutronix.de>
 <ebada35f-23c1-6ca4-5228-d3d91bad48bc@gmail.com>
 <1528708771.3818.7.camel@pengutronix.de>
 <6780e24e-891d-3583-6e38-d1abd69c8a0d@gmail.com>
Message-ID: <2aff8f80-aa79-6718-6183-6e49088ae498@redhat.com>
Date: Tue, 12 Jun 2018 19:27:51 +0200
MIME-Version: 1.0
In-Reply-To: <6780e24e-891d-3583-6e38-d1abd69c8a0d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On 06/11/2018 11:06 PM, Steve Longerbeam wrote:

[snip]

>>
>> I've been made aware [1] that recently V4L2_FIELD_ALTERNATE has been
>> clarified [2] to specify that v4l2_mbus_fmt.height should contain the
>> number of lines per field, not per frame:
> 
> Yep! That was nagging at me as well. I noticed at least one other
> platform (omap3isp) that doubles the source pad frame height

Coincidentally I noticed this problem when testing on a board with an
omap3isp. This is the pipeline setup I've been using for a long time: 

$ media-ctl -l '"tvp5150 1-005c":1->"OMAP3 ISP CCDC":0[1]'
$ media-ctl -l '"OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
$ media-ctl -V '"OMAP3 ISP CCDC":0 [UYVY2X8 720x240 field:alternate]'
$ media-ctl -V '"OMAP3 ISP CCDC":1 [UYVY 720x480 field:interlaced-tb]'

> when the sensor reports ALTERNATE field mode, to capture a
> whole frame. Makes sense. I think the crop height will need to

As you said, the ISP doubles the source pad height, and so the sink
pad is meant to have half of the frame height and this should match
the camera sensor height. But since the tvp5150 had the full frame
height (720x480) in its source pad, this didn't match the CCDC sink
pads height which lead to .link_validate callback to return -EPIPE:

ioctl(3, VIDIOC_STREAMON, 0xbeabea18)   = -1 EPIPE (Broken pipe)

After the revert, link validation / STREAMON works correctly and the
following is what the relevant media entities look like in the graph:

- entity 15: OMAP3 ISP CCDC (3 pads, 9 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev2
        pad0: Sink
                [fmt:UYVY2X8/720x240 field:alternate]
                <- "OMAP3 ISP CCP2":1 []
                <- "OMAP3 ISP CSI2a":1 []
                <- "tvp5150 1-005c":1 [ENABLED]
        pad1: Source
                [fmt:UYVY/720x480 field:interlaced-tb
                 crop.bounds:(0,0)/720x240
                 crop:(0,0)/720x240]
                -> "OMAP3 ISP CCDC output":0 [ENABLED]
                -> "OMAP3 ISP resizer":0 []

- entity 81: tvp5150 1-005c (4 pads, 1 link)
             type V4L2 subdev subtype Decoder flags 0
             device node name /dev/v4l-subdev8
        pad0: Sink
        pad1: Source
                [fmt:UYVY2X8/720x240 field:alternate
                 crop.bounds:(0,0)/720x480
                 crop:(0,0)/720x480]
                -> "OMAP3 ISP CCDC":0 [ENABLED]

Best regards,
-- 
Javier Martinez Canillas
Software Engineer - Desktop Hardware Enablement
Red Hat
