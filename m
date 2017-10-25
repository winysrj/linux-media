Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:45027 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751289AbdJYMH7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Oct 2017 08:07:59 -0400
Received: by mail-wr0-f196.google.com with SMTP id z55so17714662wrz.1
        for <linux-media@vger.kernel.org>; Wed, 25 Oct 2017 05:07:58 -0700 (PDT)
Subject: Re: [PATCH v4 04/21] doc: media/v4l-drivers: Add Qualcomm Camera
 Subsystem driver document
To: Daniel Mack <daniel@zonque.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, s.nawrocki@samsung.com,
        sakari.ailus@iki.fi, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
 <1502199018-28250-5-git-send-email-todor.tomov@linaro.org>
 <de3c02a1-5c04-977d-fd51-186a5d39c32a@zonque.org>
 <7483f716-4240-899f-f9c5-23c6408f39ff@linaro.org>
 <bfd290f4-4fb7-40b0-2d58-8b2a04a9aeca@zonque.org>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <3c042974-4118-957b-c9e8-411b30ed5909@linaro.org>
Date: Wed, 25 Oct 2017 15:07:53 +0300
MIME-Version: 1.0
In-Reply-To: <bfd290f4-4fb7-40b0-2d58-8b2a04a9aeca@zonque.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

On 16.10.2017 18:01, Daniel Mack wrote:
> Hi,
> 
> On 28.08.2017 09:10, Todor Tomov wrote:
>> On 25.08.2017 17:10, Daniel Mack wrote:
>>> Could you explain how ISPIF, CSID and CSIPHY are related?
>>>
>>> I have a userspace test setup that works fine for USB webcams, but when
>>> operating on any of the video devices exposed by this driver, the
>>> lowlevel functions such as .s_power of the ISPIF, CSID, CSIPHY and the
>>> sensor driver layers aren't called into.
>>
>> Have you activated the media controller links? The s_power is called
>> when the subdev is part of a pipeline in which the video device node
>> is opened. You can see example configurations for the Qualcomm CAMSS
>> driver on:
>> https://github.com/96boards/documentation/blob/master/ConsumerEdition/DragonBoard-410c/Guides/CameraModule.md
>> This will probably answer most of your questions.
> 
> It did in fact, yes. Thanks again for the pointer.
> 
> I am however struggling getting a 4-lane OV13855 camera to work with
> this camss driver, and I'd be happy to hear about similar setups that work.
> 
> In short, here's what my setup looks like:
> 
> 1. I wrote a driver for the OV13855 sensor, based on the one for OV13858
> but with updated register values. It announces
> MEDIA_BUS_FMT_SBGGR10_1X10 as bus format which is what the sensor should
> be sending, if I understand the specs correctly.
> 
> 
> 2. The DTS snippet for the endpoint connection look like this:
> 
> &blsp_i2c6 {
> 	cam0: ov13855@16 {
> 		/* ... */
> 		port {
> 			cam0_ep: endpoint {
> 				clock-lanes = <1>;
> 				data-lanes = <0 2 3 4>;
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
> 				data-lanes = <0 2 3 4>;
> 				remote-endpoint = <&cam0_ep>;
> 			};
> 		};
> 	};
> };
> 
> There are also no lane swaps or any intermediate components in hardware.
> We've checked the electrical bits many times, and that end seems alright.
> 
> 
> 3. The pads and links are set up like this:
> 
> # media-ctl -d /dev/media0 -l
> '"msm_csiphy0":1->"msm_csid0":0[1],"msm_csid0":1->"msm_ispif0":0[1],"msm_ispif0":1->"msm_vfe0_rdi0":0[1]'
> 
> # media-ctl -d /dev/media0 -V '"ov13855
> 1-0010":0[fmt:SBGGR10_1X10/4224x3136
> field:none],"msm_csiphy0":0[fmt:SBGGR10_1X10/4224x3136
> field:none],"msm_csid0":0[fmt:SBGGR10_1X10/4224x3136
> field:none],"msm_ispif0":0[fmt:SBGGR10_1X10/4224x3136
> field:none],"msm_vfe0_rdi0":0[fmt:SBGGR10_1X10/4224x3136 field:none]'
> 
> Both commands succeed.
> 
> 
> 4. When streaming is started, the power consumption of the device goes
> up, all necessary external clocks and voltages are provided and are
> stable, and I can see a continuous stream of data on all 4 MIPI lanes
> using an oscilloscope.
> 
> 
> 5. Capturing frames with the following yavta command doesn't work
> though. The task is mostly stuck in the buffer dequeing ioctl:
> 
> # yavta -B capture-mplane -c10 -I -n 5 -f SBGGR10P -s 4224x3136 /dev/video0
> 
> vfe_isr() does fire sometimes with VFE_0_IRQ_STATUS_1_RDIn_SOF(0) set,
> but very occasionally only, and the frames do not contain data.
> 
> FWIW, an ov6540 is connected to port 1 of the camss, and this sensor
> works fine.
> 
> I'd be grateful for any pointer about what I could investigate on.
>

Everything that you have described seems correct.

As you say that frames do not contain any data, do
VFE_0_IRQ_STATUS_0_IMAGE_MASTER_n_PING_PONG
fire at all or not?

Do you see any interrupts on the ISPIF? Which?

Could you please share what hardware setup you have - mezzanine and camera module.


-- 
Best regards,
Todor Tomov
