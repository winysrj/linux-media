Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:36858 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdH1HLA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 03:11:00 -0400
Received: by mail-wr0-f175.google.com with SMTP id p14so15779594wrg.3
        for <linux-media@vger.kernel.org>; Mon, 28 Aug 2017 00:11:00 -0700 (PDT)
Subject: Re: [PATCH v4 04/21] doc: media/v4l-drivers: Add Qualcomm Camera
 Subsystem driver document
To: Daniel Mack <daniel@zonque.org>
References: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
 <1502199018-28250-5-git-send-email-todor.tomov@linaro.org>
 <de3c02a1-5c04-977d-fd51-186a5d39c32a@zonque.org>
From: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, s.nawrocki@samsung.com,
        sakari.ailus@iki.fi, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Message-ID: <7483f716-4240-899f-f9c5-23c6408f39ff@linaro.org>
Date: Mon, 28 Aug 2017 10:10:56 +0300
MIME-Version: 1.0
In-Reply-To: <de3c02a1-5c04-977d-fd51-186a5d39c32a@zonque.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

On 25.08.2017 17:10, Daniel Mack wrote:
> Hi Todor,
> 
> Thanks a lot for working on the upstream support for this!
> 
> On 08/08/2017 03:30 PM, Todor Tomov wrote:
>> +The Camera Subsystem hardware found on 8x16 processors and supported by the
>> +driver consists of:
>> +
>> +- 2 CSIPHY modules. They handle the Physical layer of the CSI2 receivers.
>> +  A separate camera sensor can be connected to each of the CSIPHY module;
>> +- 2 CSID (CSI Decoder) modules. They handle the Protocol and Application layer
>> +  of the CSI2 receivers. A CSID can decode data stream from any of the CSIPHY.
>> +  Each CSID also contains a TG (Test Generator) block which can generate
>> +  artificial input data for test purposes;
>> +- ISPIF (ISP Interface) module. Handles the routing of the data streams from
>> +  the CSIDs to the inputs of the VFE;
>> +- VFE (Video Front End) module. Contains a pipeline of image processing hardware
>> +  blocks. The VFE has different input interfaces. The PIX input interface feeds
>> +  the input data to the image processing pipeline. Three RDI input interfaces
>> +  bypass the image processing pipeline. The VFE also contains the AXI bus
>> +  interface which writes the output data to memory.
> 
> [I'm based on the 4.9 Linaro downstream version of this code right now,
> but at a glance the driver version there looks very much identical to
> this one.]
> 
> Could you explain how ISPIF, CSID and CSIPHY are related?
> 
> I have a userspace test setup that works fine for USB webcams, but when
> operating on any of the video devices exposed by this driver, the
> lowlevel functions such as .s_power of the ISPIF, CSID, CSIPHY and the
> sensor driver layers aren't called into.

Have you activated the media controller links? The s_power is called
when the subdev is part of a pipeline in which the video device node
is opened. You can see example configurations for the Qualcomm CAMSS
driver on:
https://github.com/96boards/documentation/blob/master/ConsumerEdition/DragonBoard-410c/Guides/CameraModule.md
This will probably answer most of your questions.

> 
> The general setup seems to work fine though. The sensor is probed,
> camss_subdev_notifier_complete() is called, and the v4l2 subdevices
> exist. But the stream start is not propagated to the other layers, and
> I'm trying to understand why.
> 
> My DTS looks something like this right now, and the hardware is an
> APQ8016 board (Variscite DART SD410).
> 
> &i2c {
> 	cam0: ov5640@3c {
> 		compatible = "ovti,ov5640";
> 		reg = <0x3c>;
> 
> 		// clocks, regulators, gpios etc are omitted
> 
> 		port {
> 			cam0_ep: endpoint {
> 				clock-lanes = <1>;
> 				data-lanes = <0 2>;
> 				remote-endpoint = <&csiphy0_ep>;
> 			};
> 		};
> 	};
> };
> 
> &camss {
> 	ports {
> 		port@0 {
> 			reg = <0>;
> 			csiphy0_ep: endpoint {
> 				clock-lanes = <1>;
> 				data-lanes = <0 1 2 3>;

As far as I know the OV5640 has a two data lane CSI2 interface so
this will probably look like:
data-lanes = <0 2>;

> 				qcom,settle-cnt = <0xe>;
> 				remote-endpoint = <&cam0_ep>;
> 			};
> 		};
> 	};
> };
> 
> Also, which video device should be opened when accessing the cameras on
> each of the hardware ports? And what are the other two devices doing?
> 
> I'm sure I'm missing something trivial, but at least I can't find this
> information in the documentation.
> 
> 
> Thanks,
> Daniel
> 

-- 
Best regards,
Todor Tomov
