Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:45029 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750861AbdCNTOK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 15:14:10 -0400
Subject: Re: [PATCH] [media] v4l2-dv-timings: Introduce v4l2_calc_fps()
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        <linux-media@vger.kernel.org>
References: <94397052765d1f6d84dc7edac65f906b09890871.1488905139.git.joabreu@synopsys.com>
 <4f598aba-3002-eeb5-1cad-d4dff4553644@xs4all.nl>
 <8bc4a61a-5b5d-2233-741a-bbf44fc5f009@synopsys.com>
 <908807fd-5b1c-4fb1-d24a-a8d7bd06a3b9@xs4all.nl>
 <437c31d5-64cf-08d2-a3bb-b4fba7db30a9@synopsys.com>
 <bb580666-e137-0940-ea48-f0901b0926e9@xs4all.nl>
CC: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>,
        <linux-kernel@vger.kernel.org>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <ea1118e7-4bcb-29fc-29dc-341db5d0974e@synopsys.com>
Date: Tue, 14 Mar 2017 19:14:04 +0000
MIME-Version: 1.0
In-Reply-To: <bb580666-e137-0940-ea48-f0901b0926e9@xs4all.nl>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


On 14-03-2017 07:24, Hans Verkuil wrote:
>> Right, I was forgetting about this ...
>>
>> So:
>> 1) Most of HDMI receivers do not have the expected precision in
>> measuring pixel clock value;
> s/Most/Some/
>
> Newer HDMI receivers tend to have better precision.
>
> However, the 1000/1001 factor is within the error of margin that the HDMI
> spec has for the pixelclock, so even if it is 59.94 you still (theoretically)
> do not know if that is because it really has that fps or if the source just has
> a bad clock.

Hmm. But if source has a bad clock then it won't send at the
expected frame rate, so if we are able to measure pixel clock
value we will get the approximated frame rate for that source,
right? Unless the source also doesn't have standard h/v timings,
but as long as receiver detects this correctly then we can calculate.

>
> It's a bit theoretical, in practice you can assume the source really is sending
> at 59.94 AFAIK.
>
>> 2) Most (I would guess all of them?) have access to AVI infoframe
>> contents;
> All will have that.
>
>> 3) The FPS value is generally used by applications to calculate
>> expected frame rate and number of frames dropped (right?);
> Not really. Most HDMI drivers do not implement g_parm, instead they fill in
> the detected pixelclock in QUERY_DV_TIMINGS, leaving it up to the application
> to calculate the fps from that.
>
>> 4) The factor in FPS value can be adjusted by 1000/1001;
>>
>> From these points I would propose in just using the vic and drop
>> the resolution in fps a little bit, do you agree?
> The reality is that how to detect the 1000/1001 reduced fps is fuzzy. Part of
> the reason for that is that most of the HDMI receivers we have in the kernel
> were developed by Cisco/Tandberg (i.e. mostly me) for our video conferencing
> systems, and those all run at 60 Hz. So we never had the need to detect 59.94 vs
> 60 Hz. In addition, some of the older Analog Devices devices didn't have the
> resolution to detect the difference.
>
> So I always held off a bit with defining exactly how to do this since I had
> no experience with it.
>
> My question to you is: can you reliably detect the difference between 60 and 59.94
> Hz and between 24 and 23.976 Hz by just the measured pixelclock?
>
> You need to test this with different sources, not just signal generators. You
> probably get a range of pixelclock values for the same framerate for different
> sources, since each source has their own clock.

I will have to conduct more tests to confirm but the expected
resolution is more than enough to detect 1000/1001 changes.

>
> My preference would be to extend query_dv_timings a bit for this:
>
> <brainstorm mode on>
> Add a flag V4L2_DV_FL_CAN_DETECT_REDUCED_FPS. If set, then the hw can detect the
> difference between regular fps and 1000/1001 fps. Note: this is only valid for
> timings of VIC codes with the V4L2_DV_FL_CAN_REDUCE_FPS flag set.

Where should we set the flag? In v4l2_dv_timings_cap?

>
> Allow V4L2_DV_FL_REDUCED_FPS to be used for receivers if V4L2_DV_FL_CAN_DETECT_REDUCED_FPS
> is set.
>
> For standard VIC codes the pixelclock returned by query_dv_timings is that of the
> corresponding VIC timing, not what is measured. This will ensure fixed fps values
>
> g_parm should calculate the fps based on the v4l2_bt_timings struct, looking at the
> REDUCES_FPS flags.
>
> For those receivers that cannot detect the difference, the fps will be 24/30/60 Hz,
> for those that can detect the difference g_parm can check if both V4L2_DV_FL_CAN_DETECT_REDUCED_FPS
> and V4L2_DV_FL_REDUCED_FPS are set and reduce the fps by 1000/1001.
> <brainstorm mode off>
>
> If your hw can reliably detect the difference, then now is a good time to close
> this gap in the DV_TIMINGS API.

Sounds nice :) Let me conduct more tests first and I will try to
make the patch.

Best regards,
Jose Miguel Abreu

>
> Regards,
>
> 	Hans
