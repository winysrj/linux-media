Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:37441 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbeGNUWo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Jul 2018 16:22:44 -0400
Received: by mail-pf0-f193.google.com with SMTP id a26-v6so2301725pfo.4
        for <linux-media@vger.kernel.org>; Sat, 14 Jul 2018 13:02:35 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] media: i2c: ov5640: Re-work MIPI startup sequence
From: Steve Longerbeam <slongerbeam@gmail.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        maxime.ripard@bootlin.com, sam@elite-embedded.com,
        jagan@amarulasolutions.com, festevam@gmail.com, pza@pengutronix.de,
        hugues.fruchet@st.com, loic.poulain@linaro.org, daniel@zonque.org,
        linux-media@vger.kernel.org
References: <1531247768-15362-1-git-send-email-jacopo@jmondi.org>
 <e9057214-2e1a-df78-8983-c63c80448cb1@mentor.com>
 <20180711072148.GH8180@w540> <bc50c3d7-d6ba-e73f-6156-341e1ce3099a@gmail.com>
 <b1369576-2193-bc57-0716-ca08098a2eca@gmail.com>
Message-ID: <71f4b589-2c82-7e87-22fe-8b6373947b13@gmail.com>
Date: Sat, 14 Jul 2018 13:02:32 -0700
MIME-Version: 1.0
In-Reply-To: <b1369576-2193-bc57-0716-ca08098a2eca@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/14/2018 12:41 PM, Steve Longerbeam wrote:
> Hi Jacopo,
>
>
> On 07/14/2018 11:57 AM, Steve Longerbeam wrote:
>> Hi Jacopo,
>>
>> Pardon the late reply, see below.
>>
>> On 07/11/2018 12:21 AM, jacopo mondi wrote:
>>> Hi Steve,
>>>
>>> On Tue, Jul 10, 2018 at 02:10:54PM -0700, Steve Longerbeam wrote:
>>>> Hi Jacopo,
>>>>
>>>> Sorry to report my testing on SabreSD has same result
>>>> as last time. This series fixes the LP-11 timeout at stream
>>>> on but captured images are still blank. I tried the 640x480
>>>> mode with UYVY2X8. Here is the pad config:
>>> This saddens me :(
>>>
>>> I'm capturing with the same format and sizes... this shouldn't be the
>>> issue
>>>
>>> Could you confirm this matches what you have in your tree?
>>> 5dc2c80 media: ov5640: Fix timings setup code
>>> b35e757 media: i2c: ov5640: Re-work MIPI startup sequence
>>> 3c4a737 media: ov5640: fix frame interval enumeration
>>> 41cb1c7 media: ov5640: adjust xclk_max
>>> c3f3ba3 media: ov5640: add support of module orientation
>>> ce85705 media: ov5640: add HFLIP/VFLIP controls support
>>> 8663341 media: ov5640: Program the visible resolution
>>> 476dec0 media: ov5640: Add horizontal and vertical totals
>>> dba13a0 media: ov5640: Change horizontal and vertical resolutions name
>>> 8f57c2f media: ov5640: Init properly the SCLK dividers
>>
>> Yes, I have that commit sequence.
>>
>> FWIW, I can verify what Jagan Teki reported earlier, that the driver 
>> still
>> works on the SabreSD platform at:
>>
>> dba13a0 media: ov5640: Change horizontal and vertical resolutions name
>>
>> and is broken at:
>>
>> 476dec0 media: ov5640: Add horizontal and vertical totals
>>
>> with LP-11 timeout at the mipi csi-2 receiver:
>>
>> [   80.763189] imx6-mipi-csi2: LP-11 timeout, phy_state = 0x00000230
>> [   80.769599] ipu1_csi1: pipeline start failed with -110
>
> And I discovered the bug in 476dec0 "media: ov5640: Add horizontal and
> vertical totals". The call to ov5640_set_timings() needs to be moved 
> before the
> calls to ov5640_get_vts() and ov5640_get_hts(). But I see you have 
> discovered
> that as well, and fixed in the second patch in your series.
>

But strangely, if I revert to 476dec0, and then move the call to 
ov5640_set_timings()
to just after ov5640_load_regs() in ov5640_set_mode_exposure_calc() and
ov5640_set_mode_direct(), the LP-11 timeouts are still present. So I can 
confirm
this strangeness which you already pointed out below [1].


>
>>
>>>
>>>>
>>>>>
>>>>> The version I'm sending here re-introduces some of the timings 
>>>>> parameters in the
>>>>> initial configuration blob (not in the single mode ones), which 
>>>>> apparently has
>>>>> to be at least initially programmed to allow the driver to later 
>>>>> program them
>>>>> singularly in the 'set_timings()' function. Unfortunately I do not 
>>>>> have a real
>>>>> rationale behind this which explains why it has to be done this 
>>>>> way :(
>>>>>

[1] here :)

Steve
