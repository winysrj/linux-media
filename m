Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:8061 "EHLO
        aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751645AbdGDOEG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Jul 2017 10:04:06 -0400
Subject: Re: [PATCH v5 2/4] [media] platform: Add Synopsys Designware HDMI RX
 Controller Driver
To: Jose Abreu <Jose.Abreu@synopsys.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1498732993.git.joabreu@synopsys.com>
 <52933416f17b8a3408ab94784fa8db56453ff196.1498732993.git.joabreu@synopsys.com>
 <30787ca1-f488-ef29-8997-0a74c70d552f@xs4all.nl>
 <57902dce-e665-8027-1d88-7c447753a5b2@synopsys.com>
 <3a666f71-fb91-5c76-853d-df9de5a9af10@xs4all.nl>
 <749c9b9e-e42b-76ef-36a7-2ea3cbf0ce84@synopsys.com>
 <e79b8482-342d-3300-21b7-073bbad6df36@cisco.com>
 <93a7aa80-52c5-86c4-c264-37849b467dd3@synopsys.com>
 <ccb46d54-df40-91ef-b5fc-05b9b1f08da7@cisco.com>
 <72310298-42c9-db7a-da1c-60a2881e9c3f@synopsys.com>
Cc: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <736aa7f9-101f-f59a-4feb-07bde179a478@cisco.com>
Date: Tue, 4 Jul 2017 16:04:03 +0200
MIME-Version: 1.0
In-Reply-To: <72310298-42c9-db7a-da1c-60a2881e9c3f@synopsys.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/04/17 15:50, Jose Abreu wrote:
> 
> 
> On 04-07-2017 14:02, Hans Verkuil wrote:
>> On 07/04/17 14:33, Jose Abreu wrote:
>>>
>>> On 04-07-2017 10:39, Hans Verkuil wrote:
>>>>>>>>> +static const struct v4l2_subdev_video_ops
>>>>>>>>> dw_hdmi_sd_video_ops = {
>>>>>>>>> +    .s_routing = dw_hdmi_s_routing,
>>>>>>>>> +    .g_input_status = dw_hdmi_g_input_status,
>>>>>>>>> +    .g_parm = dw_hdmi_g_parm,
>>>>>>>>> +    .g_dv_timings = dw_hdmi_g_dv_timings,
>>>>>>>>> +    .query_dv_timings = dw_hdmi_query_dv_timings,
>>>>>>>> No s_dv_timings???
>>>>>>> Hmm, yeah, I didn't implement it because the callchain and the
>>>>>>> player I use just use {get/set}_fmt. s_dv_timings can just
>>>>>>> populate the fields and replace them with the detected dv_timings
>>>>>>> ? Just like set_fmt does? Because the controller has no scaler.
>>>>>> No, s_dv_timings is the function that actually sets
>>>>>> dw_dev->timings.
>>>>>> After you check that it is valid of course (call
>>>>>> v4l2_valid_dv_timings).
>>>>>>
>>>>>> set_fmt calls get_fmt which returns the information from
>>>>>> dw_dev->timings.
>>>>>>
>>>>>> But it is s_dv_timings that has to set dw_dev->timings.
>>>>>>
>>>>>> With the current code you can only capture 640x480 (the default
>>>>>> timings).
>>>>>> Have you ever tested this with any other timings? I don't quite
>>>>>> understand
>>>>>> how you test.
>>>>> I use mpv to test with a wrapper driver that just calls the
>>>>> subdev ops and sets up a video dma.
>>>>>
>>>>> Ah, I see now. I failed to port the correct callbacks and in the
>>>>> upstream version I'm using I only tested with 640x480 ...
>>>>>
>>>>> But apart from that this is a capture device without scaling so I
>>>>> can not set timings, I can only return them so that applications
>>>>> know which format I'm receiving, right? So my s_dv_timings will
>>>>> return the same as query_dv_timings ...
>>>> Well, to be precise: s_dv_timings just accepts what the application
>>>> gives it (as long as it is within the dv_timings capabilities). But
>>>> those timings come in practice from a query_dv_timings call from the
>>>> application.
>>>>
>>>> The core rule is that receivers cannot randomly change timings since
>>>> timings are related to buffer sizes. You do not want the application
>>>> to allocate buffers for 640x480 and when the source changes to 1920x1080
>>>> have those buffers suddenly overflow.
>>>>
>>>> Instead the app queries the timings, allocates the buffers, start
>>>> streaming and when the timings change it will get an event so it can
>>>> stop streaming, reallocate buffers, and start the process again.
>>>>
>>>> In other words, the application is in control here.
>>>>
>>> ... But this is not true for mpv/mplayer. They first try to set a
>>> default format (by using s_fmt) and then query the format again
>>> (by using g_fmt) ... So dv_timings are never used. Are these apps
>>> broken? Im only using them because of performance, do you
>>> recommend others?
>> I don't believe those have ever been adapted to the DV_TIMINGS API. Only
>> SDTV (G/S/QUERYSTD). I believe gstreamer can handle this, though. But I
>> don't have any experience with gstreamer.
>>
>> qv4l2 works fine, though. If you can build that on your system, then that's
>> by far the easiest utility to use.
> 
> I will give it a try in my PCIe setup. But for my embedded setup
> (the one I'm using for testing this controller) it won't do. To
> handle this I modified my wrapper driver to "simulate" the
> dv_timings calls.
> 
>>
>> The reason why so few applications have been adapted to the DV_TIMINGS API
>> is that it is so hard to get hardware with working HDMI input. There are
>> PCIe cards, but since the datasheets for the used HDMI receivers are closed
>> we can't make a driver. And there are no cheap SoC devkits that have HDMI input.
>> Output, yes. Input, no.
>>
>> So there is no easy way to add support for this to applications.
>>
>> Regards,
>>
>> 	Hans
> 
> Yeah, and even for SDTV the support is limited in mpv/mplayer :/
> I was told that v4l2 code in these apps is more or less unmaintained.

For the average PC user video capture is simply not all that interesting
or relevant anymore. Video capture moved to embedded systems (phones,
tablets, but of course also video conferencing equipment) and professional
video processing.

> BTW, do you have any pending comments for the other patches in
> this series? Because I've addressed all your comments regarding
> this patch and I'm ready to send a new version.

No, I didn't have any comments for the other patches.

Regards,

	Hans
