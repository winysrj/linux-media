Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:40814 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751170AbdCXMMI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 08:12:08 -0400
Subject: Re: [PATCH 0/3] Handling of reduced FPS in V4L2
To: Jose Abreu <Jose.Abreu@synopsys.com>, linux-media@vger.kernel.org
References: <cover.1490095965.git.joabreu@synopsys.com>
 <1939bd77-a74d-3ad6-06db-2b1eaa205aca@synopsys.com>
 <3a7b5c81-834c-8d1e-2181-6d8f57d20f7b@cisco.com>
 <ccea984f-c68a-b188-49fb-29f04b7a3382@synopsys.com>
Cc: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-kernel@vger.kernel.org
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <c0f50bfc-cf2e-2d49-1ea3-22686d078b5d@cisco.com>
Date: Fri, 24 Mar 2017 13:12:05 +0100
MIME-Version: 1.0
In-Reply-To: <ccea984f-c68a-b188-49fb-29f04b7a3382@synopsys.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/24/17 12:52, Jose Abreu wrote:
> Hi Hans,
> 
> 
>>> Can you please review this series, when possible? And if you
>>> could test it on cobalt it would be great :)
>> Hopefully next week. 
> 
> Thanks :)
> 
>> Did you have some real-world numbers w.r.t. measured
>> pixelclock frequencies and 60 vs 59.94 Hz and 24 vs 23.976 Hz?
> 
> I did make some measurements but I'm afraid I didn't yet test
> with many sources (I mostly tested with signal generators which
> should have a higher precision clock than real sources). I have a
> bunch of players here, I will test them as soon as I can.
> Regarding precision: for our controller is theoretically and
> effectively enough: The worst case is for 640x480, and even in
> that case the difference between 60Hz and 59.94Hz is > 1 unit of
> the measuring register. This still doesn't solve the problem of
> having a bad source with a bad clock, but I don't know if we can
> do much more about that.

I would really like to see a table with different sources sending
these different framerates and the value that your HW detects.

If there is an obvious and clear difference, then this feature makes
sense. If it is all over the place, then I need to think about this
some more.

To be honest, I expect that you will see 'an obvious and clear'
difference, but that is no more than a gut feeling at the moment and
I would like to see some proper test results.

> 
>>
>> I do want to see that, since this patch series only makes sense if you can
>> actually make use of it to reliably detect the difference.
>>
>> I will try to test that myself with cobalt, but almost certainly I won't
>> be able to tell the difference; if memory serves it can't detect the freq
>> with high enough precision.
> 
> Ok, thanks, this would be great because I didn't test the series
> exactly "as is" because I'm using 4.10. I did look at vivid
> driver but it already handles reduced frame rate, so it kind of
> does what it is proposed in this series. If this helper is
> integrated in the v4l2 core then I can send the patch to vivid.

That would be nice to have in vivid.

Regards,

	Hans
