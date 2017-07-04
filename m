Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:38193 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752051AbdGDMeD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Jul 2017 08:34:03 -0400
Subject: Re: [PATCH v5 2/4] [media] platform: Add Synopsys Designware HDMI RX
 Controller Driver
To: Hans Verkuil <hansverk@cisco.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <cover.1498732993.git.joabreu@synopsys.com>
 <52933416f17b8a3408ab94784fa8db56453ff196.1498732993.git.joabreu@synopsys.com>
 <30787ca1-f488-ef29-8997-0a74c70d552f@xs4all.nl>
 <57902dce-e665-8027-1d88-7c447753a5b2@synopsys.com>
 <3a666f71-fb91-5c76-853d-df9de5a9af10@xs4all.nl>
 <749c9b9e-e42b-76ef-36a7-2ea3cbf0ce84@synopsys.com>
 <e79b8482-342d-3300-21b7-073bbad6df36@cisco.com>
CC: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Sylwester Nawrocki" <snawrocki@kernel.org>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <93a7aa80-52c5-86c4-c264-37849b467dd3@synopsys.com>
Date: Tue, 4 Jul 2017 13:33:50 +0100
MIME-Version: 1.0
In-Reply-To: <e79b8482-342d-3300-21b7-073bbad6df36@cisco.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 04-07-2017 10:39, Hans Verkuil wrote:
>
>>>>>> +static const struct v4l2_subdev_video_ops
>>>>>> dw_hdmi_sd_video_ops = {
>>>>>> +    .s_routing = dw_hdmi_s_routing,
>>>>>> +    .g_input_status = dw_hdmi_g_input_status,
>>>>>> +    .g_parm = dw_hdmi_g_parm,
>>>>>> +    .g_dv_timings = dw_hdmi_g_dv_timings,
>>>>>> +    .query_dv_timings = dw_hdmi_query_dv_timings,
>>>>> No s_dv_timings???
>>>> Hmm, yeah, I didn't implement it because the callchain and the
>>>> player I use just use {get/set}_fmt. s_dv_timings can just
>>>> populate the fields and replace them with the detected dv_timings
>>>> ? Just like set_fmt does? Because the controller has no scaler.
>>> No, s_dv_timings is the function that actually sets
>>> dw_dev->timings.
>>> After you check that it is valid of course (call
>>> v4l2_valid_dv_timings).
>>>
>>> set_fmt calls get_fmt which returns the information from
>>> dw_dev->timings.
>>>
>>> But it is s_dv_timings that has to set dw_dev->timings.
>>>
>>> With the current code you can only capture 640x480 (the default
>>> timings).
>>> Have you ever tested this with any other timings? I don't quite
>>> understand
>>> how you test.
>> I use mpv to test with a wrapper driver that just calls the
>> subdev ops and sets up a video dma.
>>
>> Ah, I see now. I failed to port the correct callbacks and in the
>> upstream version I'm using I only tested with 640x480 ...
>>
>> But apart from that this is a capture device without scaling so I
>> can not set timings, I can only return them so that applications
>> know which format I'm receiving, right? So my s_dv_timings will
>> return the same as query_dv_timings ...
> Well, to be precise: s_dv_timings just accepts what the application
> gives it (as long as it is within the dv_timings capabilities). But
> those timings come in practice from a query_dv_timings call from the
> application.
>
> The core rule is that receivers cannot randomly change timings since
> timings are related to buffer sizes. You do not want the application
> to allocate buffers for 640x480 and when the source changes to 1920x1080
> have those buffers suddenly overflow.
>
> Instead the app queries the timings, allocates the buffers, start
> streaming and when the timings change it will get an event so it can
> stop streaming, reallocate buffers, and start the process again.
>
> In other words, the application is in control here.
>

... But this is not true for mpv/mplayer. They first try to set a
default format (by using s_fmt) and then query the format again
(by using g_fmt) ... So dv_timings are never used. Are these apps
broken? Im only using them because of performance, do you
recommend others?

Best regards,
Jose Miguel Abreu
