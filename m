Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:60277 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752375AbdC0MHe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 08:07:34 -0400
Subject: Re: [PATCH 0/3] Handling of reduced FPS in V4L2
To: Hans Verkuil <hansverk@cisco.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        <linux-media@vger.kernel.org>
References: <cover.1490095965.git.joabreu@synopsys.com>
 <1939bd77-a74d-3ad6-06db-2b1eaa205aca@synopsys.com>
 <3a7b5c81-834c-8d1e-2181-6d8f57d20f7b@cisco.com>
 <ccea984f-c68a-b188-49fb-29f04b7a3382@synopsys.com>
 <c0f50bfc-cf2e-2d49-1ea3-22686d078b5d@cisco.com>
 <a124edf2-06c8-1c91-bf6f-145d4624a6c9@synopsys.com>
 <94c98e4e-3823-1387-c18f-09c347916f4e@cisco.com>
CC: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        <linux-kernel@vger.kernel.org>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <a537bfef-581b-cd55-6a5b-5965518d50fb@synopsys.com>
Date: Mon, 27 Mar 2017 12:58:39 +0100
MIME-Version: 1.0
In-Reply-To: <94c98e4e-3823-1387-c18f-09c347916f4e@cisco.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


On 24-03-2017 12:28, Hans Verkuil wrote:
> On 03/24/17 13:21, Jose Abreu wrote:
>> Hi Hans,
>>
>>
>> On 24-03-2017 12:12, Hans Verkuil wrote:
>>> On 03/24/17 12:52, Jose Abreu wrote:
>>>> Hi Hans,
>>>>
>>>>
>>>>>> Can you please review this series, when possible? And if you
>>>>>> could test it on cobalt it would be great :)
>>>>> Hopefully next week. 
>>>> Thanks :)
>>>>
>>>>> Did you have some real-world numbers w.r.t. measured
>>>>> pixelclock frequencies and 60 vs 59.94 Hz and 24 vs 23.976 Hz?
>>>> I did make some measurements but I'm afraid I didn't yet test
>>>> with many sources (I mostly tested with signal generators which
>>>> should have a higher precision clock than real sources). I have a
>>>> bunch of players here, I will test them as soon as I can.
>>>> Regarding precision: for our controller is theoretically and
>>>> effectively enough: The worst case is for 640x480, and even in
>>>> that case the difference between 60Hz and 59.94Hz is > 1 unit of
>>>> the measuring register. This still doesn't solve the problem of
>>>> having a bad source with a bad clock, but I don't know if we can
>>>> do much more about that.
>>> I would really like to see a table with different sources sending
>>> these different framerates and the value that your HW detects.
>>>
>>> If there is an obvious and clear difference, then this feature makes
>>> sense. If it is all over the place, then I need to think about this
>>> some more.
>>>
>>> To be honest, I expect that you will see 'an obvious and clear'
>>> difference, but that is no more than a gut feeling at the moment and
>>> I would like to see some proper test results.
>> Ok, I will make a table. The test procedure will be like this:
>>     - Measure pixel clock value using certified HDMI analyzer
>>     - Measure pixel clock using our controller
>>     - Compare the values obtained from analyzer, controller and
>> the values that the source is telling to send (the value
>> displayed in source menu for example [though, some of them may
>> not discriminate the exact frame rate, thats why analyzer should
>> be used also]).
>>
>> Seems ok? I will need some time, something like a week because my
>> setup was "borrowed".
> That sounds good. Sorry for adding to your workload, but there is no
> point to have a flag that in practice is meaningless.
>
> I'm actually very curious about the results!

I managed to do the tests but unfortunately I can't publish the
full results (at least until I get approval).

I can say that the results look good. As you expected we have
some sources with a bad clock but this is correctly detected by
the controller (and also by the HDMI analyzer).

Using the v4l2_calc_framerate function I managed to get this:

| Source       | Resolution                  | v4l2_calc_framerate()
------------------------------------------------------------------------------
| Analyzer 1 | 640x480@59.94         | 59.92
| Analyzer 1 | 640x480@60              | 60
| Analyzer 1 | 1920x1080@60          | 60
| Player 1     | 1920x1080@59.94     | 59.94
| Player 2     | 1920x1080@59.94     | 59.93
| Player 3     | 3840x2160@59.94     | 59.94
| Player 4     | 1920x1080@59.94     | 59.94
| Player 5     | 1920x1080@59.94     | 59.93
| Player 6     | 1280x720@50            | 50
| Player 7     | 1920x1080@59.94     | 59.93
| Player 8     | 1920x1080@60          | 60
| Analyzer 2 | 720x480@59.94         | 59.94
| Analyzer 2 | 720x480@60              | 60
| Analyzer 2 | 1920x1080@59.94     | 59.93
| Analyzer 2 | 1920x180@60            | 60
| Analyzer 2 | 3840x2160@23.98     | 23.97
| Analyzer 2 | 3840x2160@24          | 24
| Analyzer 2 | 3840x2160@29.97     | 29.96
| Analyzer 2 | 3840x2160@30          | 30
| Analyzer 2 | 3840x2160@59.94     | 59.93
| Analyzer 2 | 3840x2160@60          | 60
------------------------------------------------------------------------------

What do you think? Shall we continue integrating this new patch
or drop it?

Best regards,
Jose Miguel Abreu

>
> Regards,
>
> 	Hans
>
>> Best regards,
>> Jose Miguel Abreu
>>
>>>>> I do want to see that, since this patch series only makes sense if you can
>>>>> actually make use of it to reliably detect the difference.
>>>>>
>>>>> I will try to test that myself with cobalt, but almost certainly I won't
>>>>> be able to tell the difference; if memory serves it can't detect the freq
>>>>> with high enough precision.
>>>> Ok, thanks, this would be great because I didn't test the series
>>>> exactly "as is" because I'm using 4.10. I did look at vivid
>>>> driver but it already handles reduced frame rate, so it kind of
>>>> does what it is proposed in this series. If this helper is
>>>> integrated in the v4l2 core then I can send the patch to vivid.
>>> That would be nice to have in vivid.
>>>
>>> Regards,
>>>
>>> 	Hans
>>>
