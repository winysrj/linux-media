Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:42746 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750948AbeBQBCr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Feb 2018 20:02:47 -0500
Received: by mail-pg0-f67.google.com with SMTP id y8so3721253pgr.9
        for <linux-media@vger.kernel.org>; Fri, 16 Feb 2018 17:02:47 -0800 (PST)
Subject: Re: i.MX53 using imx-media to capture analog video through ADV7180
To: Fabio Estevam <festevam@gmail.com>,
        Matthew Starr <mstarr@hedonline.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
References: <3C8219BAE02B894A9C69304A12E8AA0656AAF9AE@HED-Exchange.hed.local>
 <CAOMZO5AyPnAfzbAOB247N9mwEp0n7-kUFxdAhm9RK0SEWP=1iA@mail.gmail.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <6cf6f988-86c0-2aef-6a6d-b873eb40ead1@gmail.com>
Date: Fri, 16 Feb 2018 17:02:42 -0800
MIME-Version: 1.0
In-Reply-To: <CAOMZO5AyPnAfzbAOB247N9mwEp0n7-kUFxdAhm9RK0SEWP=1iA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mathew,


On 02/14/2018 07:44 AM, Fabio Estevam wrote:
> [Adding Steve and Philipp in case they could provide some suggestions]
>
> On Wed, Feb 14, 2018 at 1:21 PM, Matthew Starr <mstarr@hedonline.com> wrote:
>> I have successfully modified device tree files in the mainline 4.15.1 kernel to get a display product using the i.MX53 processor to initialize the imx-media drivers.  I think up to this point they have only been tested on i.MX6 processors.

Yes that's correct. I have not tested imx-media driver on any i.MX5 targets.
There are likely issues with i.MX5 support.

>>    I am using two ADV7180 analog capture chips, one per CSI port, on this display product.
>>
>> I have everything initialize successfully at boot, but I am unable to get the media-ctl command to link the ADV7180 devices to the CSI ports.  I used the following website as guidance of how to setup the links between media devices:
>> https://linuxtv.org/downloads/v4l-dvb-apis/v4l-drivers/imx.html
>>
>> When trying to link the ADV7180 chip to a CSI port, I use the following command and get the result below:
>>
>>          media-ctl -v -l "'adv7180 1-0021':0->'ipu1_csi0':0[1]"
>>
>>          No link between "adv7180 1-0021":0 and "ipu1_csi0":0
>>          media_parse_setup_link: Unable to parse link
>>          Unable to parse link: Invalid argument (22)
>>
>> How do I get the ADV7180 and CSI port on the i.MX53 processor to link?
>>
>> The difference for the i.MX53 compared to the i.MX6 processor is that there is only one IPU and no mipi support, so my device tree does not use any video-mux or mux devices.  Could this have something to do with why I can't link the ADV7180 to the CSI port?

It probably does. Clearly there was no media link defined from
the adv7180 to any of the CSI ports, which can also be seen from
the media topology you printed below.

As long as the OF graph is correct, I don't see why this would have
happened. Please send two things:

1. Your patches to DT files
2. dmesg output.

There could be more issues with i.MX5 support in imx-media, but
it should be figured out why the media links from adv7180 to the CSI
ports were not established first.


Steve

>>
>> Here is the output of the "media-ctl -p -v" command:
>>
>> Opening media device /dev/media0
>> Enumerating entities
>> looking up device: 81:10
>> looking up device: 81:11
>> looking up device: 81:12
>> looking up device: 81:4
>> looking up device: 81:13
>> looking up device: 81:5
>> looking up device: 81:14
>> looking up device: 81:15
>> looking up device: 81:16
>> looking up device: 81:17
>> looking up device: 81:6
>> looking up device: 81:18
>> looking up device: 81:7
>> looking up device: 81:19
>> looking up device: 81:20
>> looking up device: 81:8
>> looking up device: 81:21
>> looking up device: 81:9
>> Found 18 entities
>> Enumerating pads and links
>> Media controller API version 4.15.1
>>
>> Media device information
>> ------------------------
>> driver          imx-media
>> model           imx-media
>> serial
>> bus info
>> hw revision     0x0
>> driver version  4.15.1
>>
>> Device topology
>> - entity 1: adv7180 1-0021 (1 pad, 0 link)
>>              type V4L2 subdev subtype Unknown flags 20004
>>              device node name /dev/v4l-subdev0
>>          pad0: Source
>>                  [fmt:UYVY8_2X8/720x480 field:interlaced]
>>
>> - entity 3: adv7180 1-0020 (1 pad, 0 link)
>>              type V4L2 subdev subtype Unknown flags 20004
>>              device node name /dev/v4l-subdev1
>>          pad0: Source
>>                  [fmt:UYVY8_2X8/720x480 field:interlaced]
>>
>> - entity 5: ipu1_csi1 (3 pads, 3 links)
>>              type V4L2 subdev subtype Unknown flags 0
>>              device node name /dev/v4l-subdev2
>>          pad0: Sink
>>                  [fmt:UYVY8_2X8/640x480 field:none
>>                   crop.bounds:(0,0)/640x480
>>                   crop:(0,0)/640x480
>>                   compose.bounds:(0,0)/640x480
>>                   compose:(0,0)/640x480]
>>          pad1: Source
>>                  [fmt:AYUV8_1X32/640x480 field:none]
>>                  -> "ipu1_ic_prp":0 []
>>                  -> "ipu1_vdic":0 []
>>          pad2: Source
>>                  [fmt:AYUV8_1X32/640x480 field:none]
>>                  -> "ipu1_csi1 capture":0 []
>>
>> - entity 9: ipu1_csi1 capture (1 pad, 1 link)
>>              type Node subtype V4L flags 0
>>              device node name /dev/video4
>>          pad0: Sink
>>                  <- "ipu1_csi1":2 []
>>
>> - entity 15: ipu1_csi0 (3 pads, 3 links)
>>               type V4L2 subdev subtype Unknown flags 0
>>               device node name /dev/v4l-subdev3
>>          pad0: Sink
>>                  [fmt:UYVY8_2X8/640x480 field:none
>>                   crop.bounds:(0,0)/640x480
>>                   crop:(0,0)/640x480
>>                   compose.bounds:(0,0)/640x480
>>                   compose:(0,0)/640x480]
>>          pad1: Source
>>                  [fmt:AYUV8_1X32/640x480 field:none]
>>                  -> "ipu1_ic_prp":0 []
>>                  -> "ipu1_vdic":0 [ENABLED]
>>          pad2: Source
>>                  [fmt:AYUV8_1X32/640x480 field:none]
>>                  -> "ipu1_csi0 capture":0 []
>>
>> - entity 19: ipu1_csi0 capture (1 pad, 1 link)
>>               type Node subtype V4L flags 0
>>               device node name /dev/video5
>>          pad0: Sink
>>                  <- "ipu1_csi0":2 []
>>
>> - entity 25: ipu1_ic_prp (3 pads, 5 links)
>>               type V4L2 subdev subtype Unknown flags 0
>>               device node name /dev/v4l-subdev4
>>          pad0: Sink
>>                  [fmt:AYUV8_1X32/640x480 field:none]
>>                  <- "ipu1_csi1":1 []
>>                  <- "ipu1_csi0":1 []
>>                  <- "ipu1_vdic":2 [ENABLED]
>>          pad1: Source
>>                  [fmt:AYUV8_1X32/640x480 field:none]
>>                  -> "ipu1_ic_prpenc":0 []
>>          pad2: Source
>>                  [fmt:AYUV8_1X32/640x480 field:none]
>>                  -> "ipu1_ic_prpvf":0 [ENABLED]
>>
>> - entity 29: ipu1_vdic (3 pads, 3 links)
>>               type V4L2 subdev subtype Unknown flags 0
>>               device node name /dev/v4l-subdev5
>>          pad0: Sink
>>                  [fmt:AYUV8_1X32/640x480 field:none]
>>                  <- "ipu1_csi1":1 []
>>                  <- "ipu1_csi0":1 [ENABLED]
>>          pad1: Sink
>>                  [fmt:UYVY8_2X8/640x480 field:none]
>>          pad2: Source
>>                  [fmt:AYUV8_1X32/640x480 field:none]
>>                  -> "ipu1_ic_prp":0 [ENABLED]
>>
>> - entity 33: ipu2_vdic (3 pads, 1 link)
>>               type V4L2 subdev subtype Unknown flags 0
>>               device node name /dev/v4l-subdev6
>>          pad0: Sink
>>                  [fmt:AYUV8_1X32/640x480 field:none]
>>          pad1: Sink
>>                  [fmt:UYVY8_2X8/640x480 field:none]
>>          pad2: Source
>>                  [fmt:AYUV8_1X32/640x480 field:none]
>>                  -> "ipu2_ic_prp":0 []
>>
>> - entity 37: ipu1_ic_prpenc (2 pads, 2 links)
>>               type V4L2 subdev subtype Unknown flags 0
>>               device node name /dev/v4l-subdev7
>>          pad0: Sink
>>                  [fmt:AYUV8_1X32/640x480 field:none]
>>                  <- "ipu1_ic_prp":1 []
>>          pad1: Source
>>                  [fmt:AYUV8_1X32/640x480 field:none]
>>                  -> "ipu1_ic_prpenc capture":0 []
>>
>> - entity 40: ipu1_ic_prpenc capture (1 pad, 1 link)
>>               type Node subtype V4L flags 0
>>               device node name /dev/video6
>>          pad0: Sink
>>                  <- "ipu1_ic_prpenc":1 []
>>
>> - entity 46: ipu1_ic_prpvf (2 pads, 2 links)
>>               type V4L2 subdev subtype Unknown flags 0
>>               device node name /dev/v4l-subdev8
>>          pad0: Sink
>>                  [fmt:AYUV8_1X32/640x480 field:none]
>>                  <- "ipu1_ic_prp":2 [ENABLED]
>>          pad1: Source
>>                  [fmt:AYUV8_1X32/640x480 field:none]
>>                  -> "ipu1_ic_prpvf capture":0 [ENABLED]
>>
>> - entity 49: ipu1_ic_prpvf capture (1 pad, 1 link)
>>               type Node subtype V4L flags 0
>>               device node name /dev/video7
>>          pad0: Sink
>>                  <- "ipu1_ic_prpvf":1 [ENABLED]
>>
>> - entity 55: ipu2_ic_prp (3 pads, 3 links)
>>               type V4L2 subdev subtype Unknown flags 0
>>               device node name /dev/v4l-subdev9
>>          pad0: Sink
>>                  [fmt:AYUV8_1X32/640x480 field:none]
>>                  <- "ipu2_vdic":2 []
>>          pad1: Source
>>                  [fmt:AYUV8_1X32/640x480 field:none]
>>                  -> "ipu2_ic_prpenc":0 []
>>          pad2: Source
>>                  [fmt:AYUV8_1X32/640x480 field:none]
>>                  -> "ipu2_ic_prpvf":0 []
>>
>> - entity 59: ipu2_ic_prpenc (2 pads, 2 links)
>>               type V4L2 subdev subtype Unknown flags 0
>>               device node name /dev/v4l-subdev10
>>          pad0: Sink
>>                  [fmt:AYUV8_1X32/640x480 field:none]
>>                  <- "ipu2_ic_prp":1 []
>>          pad1: Source
>>                  [fmt:AYUV8_1X32/640x480 field:none]
>>                  -> "ipu2_ic_prpenc capture":0 []
>>
>> - entity 62: ipu2_ic_prpenc capture (1 pad, 1 link)
>>               type Node subtype V4L flags 0
>>               device node name /dev/video8
>>          pad0: Sink
>>                  <- "ipu2_ic_prpenc":1 []
>>
>> - entity 68: ipu2_ic_prpvf (2 pads, 2 links)
>>               type V4L2 subdev subtype Unknown flags 0
>>               device node name /dev/v4l-subdev11
>>          pad0: Sink
>>                  [fmt:AYUV8_1X32/640x480 field:none]
>>                  <- "ipu2_ic_prp":2 []
>>          pad1: Source
>>                  [fmt:AYUV8_1X32/640x480 field:none]
>>                  -> "ipu2_ic_prpvf capture":0 []
>>
>> - entity 71: ipu2_ic_prpvf capture (1 pad, 1 link)
>>               type Node subtype V4L flags 0
>>               device node name /dev/video9
>>          pad0: Sink
>>                  <- "ipu2_ic_prpvf":1 []
>>
>>
>> Best regards,
>>
>> Matthew Starr
