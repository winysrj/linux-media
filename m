Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42757 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbeGNTRo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Jul 2018 15:17:44 -0400
Received: by mail-ed1-f66.google.com with SMTP id g12-v6so26990901edi.9
        for <linux-media@vger.kernel.org>; Sat, 14 Jul 2018 11:57:45 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] media: i2c: ov5640: Re-work MIPI startup sequence
To: jacopo mondi <jacopo@jmondi.org>
Cc: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        maxime.ripard@bootlin.com, sam@elite-embedded.com,
        jagan@amarulasolutions.com, festevam@gmail.com, pza@pengutronix.de,
        hugues.fruchet@st.com, loic.poulain@linaro.org, daniel@zonque.org,
        linux-media@vger.kernel.org
References: <1531247768-15362-1-git-send-email-jacopo@jmondi.org>
 <e9057214-2e1a-df78-8983-c63c80448cb1@mentor.com>
 <20180711072148.GH8180@w540>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <bc50c3d7-d6ba-e73f-6156-341e1ce3099a@gmail.com>
Date: Sat, 14 Jul 2018 11:57:37 -0700
MIME-Version: 1.0
In-Reply-To: <20180711072148.GH8180@w540>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Pardon the late reply, see below.

On 07/11/2018 12:21 AM, jacopo mondi wrote:
> Hi Steve,
>
> On Tue, Jul 10, 2018 at 02:10:54PM -0700, Steve Longerbeam wrote:
>> Hi Jacopo,
>>
>> Sorry to report my testing on SabreSD has same result
>> as last time. This series fixes the LP-11 timeout at stream
>> on but captured images are still blank. I tried the 640x480
>> mode with UYVY2X8. Here is the pad config:
> This saddens me :(
>
> I'm capturing with the same format and sizes... this shouldn't be the
> issue
>
> Could you confirm this matches what you have in your tree?
> 5dc2c80 media: ov5640: Fix timings setup code
> b35e757 media: i2c: ov5640: Re-work MIPI startup sequence
> 3c4a737 media: ov5640: fix frame interval enumeration
> 41cb1c7 media: ov5640: adjust xclk_max
> c3f3ba3 media: ov5640: add support of module orientation
> ce85705 media: ov5640: add HFLIP/VFLIP controls support
> 8663341 media: ov5640: Program the visible resolution
> 476dec0 media: ov5640: Add horizontal and vertical totals
> dba13a0 media: ov5640: Change horizontal and vertical resolutions name
> 8f57c2f media: ov5640: Init properly the SCLK dividers

Yes, I have that commit sequence.

FWIW, I can verify what Jagan Teki reported earlier, that the driver still
works on the SabreSD platform at:

dba13a0 media: ov5640: Change horizontal and vertical resolutions name

and is broken at:

476dec0 media: ov5640: Add horizontal and vertical totals

with LP-11 timeout at the mipi csi-2 receiver:

[   80.763189] imx6-mipi-csi2: LP-11 timeout, phy_state = 0x00000230
[   80.769599] ipu1_csi1: pipeline start failed with -110


Steve

>
>
>
>> # media-ctl --get-v4l2 "'ov5640 1-003c':0"
>>          [fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:srgb xfer:srgb
>> ycbcr:601 quantization:full-range]
>>
>> Steve
>>
>> On 07/10/2018 11:36 AM, Jacopo Mondi wrote:
>>> Hello,
>>>     this series fixes capture operations on i.MX6Q platforms (and possible other
>>> platforms reported not working) using MIPI CSI-2 interface.
>>>
>>> This iteration expands the v1 version with an additional fix, initially
>>> submitted by Maxime in his series:
>>> [PATCH v3 00/12] media: ov5640: Misc cleanup and improvements
>>> https://www.spinics.net/lists/linux-media/msg134436.html
>>>
>>> The original patch has been reported not fully fixing the issues by Daniel Mack
>>> in his comment here below (on a Qualcomm platform if I'm not wrong):
>>> https://www.spinics.net/lists/linux-media/msg134524.html
>>> On my i.MX6Q testing platform that patch alone does not fix MIPI capture
>>> neither.
>>>
>>> The version I'm sending here re-introduces some of the timings parameters in the
>>> initial configuration blob (not in the single mode ones), which apparently has
>>> to be at least initially programmed to allow the driver to later program them
>>> singularly in the 'set_timings()' function. Unfortunately I do not have a real
>>> rationale behind this which explains why it has to be done this way :(
>>>
>>> For the MIPI startup sequence re-work patch, no changes compared to v1.
>>> Steve reported he has verified the LP-11 timout issue is solved on his testing
>>> platform too. For more details, please refer to the v1 cover letter:
>>> https://www.mail-archive.com/linux-media@vger.kernel.org/msg133352.html
>>>
>>> Thanks
>>>     j
>>>
>>> Jacopo Mondi (1):
>>>    media: i2c: ov5640: Re-work MIPI startup sequence
>>>
>>> Samuel Bobrowicz (1):
>>>    media: ov5640: Fix timings setup code
>>>
>>>   drivers/media/i2c/ov5640.c | 107 ++++++++++++++++++++++++++++++++++-----------
>>>   1 file changed, 82 insertions(+), 25 deletions(-)
>>>
>>> --
>>> 2.7.4
>>>
