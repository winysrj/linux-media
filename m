Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay4.synopsys.com ([198.182.47.9]:54347 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755402AbdC2N0v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 09:26:51 -0400
Subject: Re: [PATCH 0/3] Handling of reduced FPS in V4L2
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Hans Verkuil <hansverk@cisco.com>,
        <linux-media@vger.kernel.org>
References: <cover.1490095965.git.joabreu@synopsys.com>
 <1939bd77-a74d-3ad6-06db-2b1eaa205aca@synopsys.com>
 <3a7b5c81-834c-8d1e-2181-6d8f57d20f7b@cisco.com>
 <ccea984f-c68a-b188-49fb-29f04b7a3382@synopsys.com>
 <c0f50bfc-cf2e-2d49-1ea3-22686d078b5d@cisco.com>
 <a124edf2-06c8-1c91-bf6f-145d4624a6c9@synopsys.com>
 <94c98e4e-3823-1387-c18f-09c347916f4e@cisco.com>
 <a537bfef-581b-cd55-6a5b-5965518d50fb@synopsys.com>
 <4f4aa3ea-f2d3-52c2-d4a2-3e79b8ffabd2@xs4all.nl>
CC: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        <linux-kernel@vger.kernel.org>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <e1604a3b-751a-9360-d56b-5d78163d3ce1@synopsys.com>
Date: Wed, 29 Mar 2017 14:26:45 +0100
MIME-Version: 1.0
In-Reply-To: <4f4aa3ea-f2d3-52c2-d4a2-3e79b8ffabd2@xs4all.nl>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


On 28-03-2017 11:07, Hans Verkuil wrote:
> On 27/03/17 13:58, Jose Abreu wrote:
>> Hi Hans,
>>
>>
>> On 24-03-2017 12:28, Hans Verkuil wrote:
>>> On 03/24/17 13:21, Jose Abreu wrote:
>>>> Hi Hans,
>>>>
>>>>
>>>> On 24-03-2017 12:12, Hans Verkuil wrote:
>>>>> On 03/24/17 12:52, Jose Abreu wrote:
>>>>>> Hi Hans,
>>>>>>
>>>>>>
>>>>>>>> Can you please review this series, when possible? And if you
>>>>>>>> could test it on cobalt it would be great :)
>>>>>>> Hopefully next week. 
>>>>>> Thanks :)
>>>>>>
>>>>>>> Did you have some real-world numbers w.r.t. measured
>>>>>>> pixelclock frequencies and 60 vs 59.94 Hz and 24 vs 23.976 Hz?
>>>>>> I did make some measurements but I'm afraid I didn't yet test
>>>>>> with many sources (I mostly tested with signal generators which
>>>>>> should have a higher precision clock than real sources). I have a
>>>>>> bunch of players here, I will test them as soon as I can.
>>>>>> Regarding precision: for our controller is theoretically and
>>>>>> effectively enough: The worst case is for 640x480, and even in
>>>>>> that case the difference between 60Hz and 59.94Hz is > 1 unit of
>>>>>> the measuring register. This still doesn't solve the problem of
>>>>>> having a bad source with a bad clock, but I don't know if we can
>>>>>> do much more about that.
>>>>> I would really like to see a table with different sources sending
>>>>> these different framerates and the value that your HW detects.
>>>>>
>>>>> If there is an obvious and clear difference, then this feature makes
>>>>> sense. If it is all over the place, then I need to think about this
>>>>> some more.
>>>>>
>>>>> To be honest, I expect that you will see 'an obvious and clear'
>>>>> difference, but that is no more than a gut feeling at the moment and
>>>>> I would like to see some proper test results.
>>>> Ok, I will make a table. The test procedure will be like this:
>>>>     - Measure pixel clock value using certified HDMI analyzer
>>>>     - Measure pixel clock using our controller
>>>>     - Compare the values obtained from analyzer, controller and
>>>> the values that the source is telling to send (the value
>>>> displayed in source menu for example [though, some of them may
>>>> not discriminate the exact frame rate, thats why analyzer should
>>>> be used also]).
>>>>
>>>> Seems ok? I will need some time, something like a week because my
>>>> setup was "borrowed".
>>> That sounds good. Sorry for adding to your workload, but there is no
>>> point to have a flag that in practice is meaningless.
>>>
>>> I'm actually very curious about the results!
>> I managed to do the tests but unfortunately I can't publish the
>> full results (at least until I get approval).
>>
>> I can say that the results look good. As you expected we have
>> some sources with a bad clock but this is correctly detected by
>> the controller (and also by the HDMI analyzer).
>>
>> Using the v4l2_calc_framerate function I managed to get this:
>>
>> | Source       | Resolution                  | v4l2_calc_framerate()
>> ------------------------------------------------------------------------------
>> | Analyzer 1 | 640x480@59.94         | 59.92
>> | Analyzer 1 | 640x480@60              | 60
>> | Analyzer 1 | 1920x1080@60          | 60
>> | Player 1     | 1920x1080@59.94     | 59.94
>> | Player 2     | 1920x1080@59.94     | 59.93
>> | Player 3     | 3840x2160@59.94     | 59.94
>> | Player 4     | 1920x1080@59.94     | 59.94
>> | Player 5     | 1920x1080@59.94     | 59.93
>> | Player 6     | 1280x720@50            | 50
>> | Player 7     | 1920x1080@59.94     | 59.93
>> | Player 8     | 1920x1080@60          | 60
>> | Analyzer 2 | 720x480@59.94         | 59.94
>> | Analyzer 2 | 720x480@60              | 60
>> | Analyzer 2 | 1920x1080@59.94     | 59.93
>> | Analyzer 2 | 1920x180@60            | 60
>> | Analyzer 2 | 3840x2160@23.98     | 23.97
>> | Analyzer 2 | 3840x2160@24          | 24
>> | Analyzer 2 | 3840x2160@29.97     | 29.96
>> | Analyzer 2 | 3840x2160@30          | 30
>> | Analyzer 2 | 3840x2160@59.94     | 59.93
>> | Analyzer 2 | 3840x2160@60          | 60
> Nice!
>
> Are the sources with a bad clock included in these results? I only see deviations
> of 0.02 at most, so I don't think so.

The results include all the sources I have to test (Player x
indicates a real player available in the market while Analyzer x
indicates HDMI protocol analyzer). From the data I've collected
the players are the ones with the less precise clock, thats what
I was referring as a bad clock. But even with that deviations the
algorithm computes the value ok. I think I don't have any player
else to test here. Maybe, if you could, test the patch series
with cobalt + adv with a player and check the precision? ( I
think cobalt uses an adv as subdev, right? )

>
>> ------------------------------------------------------------------------------
>>
>> What do you think? Shall we continue integrating this new patch
>> or drop it?
> Yes, we can continue. This is what I wanted to know :-)
> Thank you for testing this, much appreciated.

No problem :) Please review the patch series (when you can) so
that I can submit a next version.

Best regards,
Jose Miguel Abreu

>
> Regards,
>
> 	Hans
