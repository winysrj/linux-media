Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:42540 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751111AbdHXGr7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Aug 2017 02:47:59 -0400
Subject: Re: [PATCH] [media_build] rc: Fix ktime erros in rc_ir_raw.c
To: "Jasmin J." <jasmin@anw.at>, linux-media@vger.kernel.org
Cc: d.scheller@gmx.net, Sean Young <sean@mess.org>
References: <1503531988-15429-1-git-send-email-jasmin@anw.at>
 <9b070969-9422-b809-3611-648d8da0e121@anw.at>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <93053a66-18f2-9c4f-1987-49687d8f3069@xs4all.nl>
Date: Thu, 24 Aug 2017 08:47:54 +0200
MIME-Version: 1.0
In-Reply-To: <9b070969-9422-b809-3611-648d8da0e121@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/24/2017 02:07 AM, Jasmin J. wrote:
> Hi!
> 
> Just some notes on that patch.
> 
> I have *not* tested it due to the lack of an ir remote control. So someone
> needs to test this on an <= 4.9 Kernel, if the ir core is still working as
> expected.
> 
> Even if I fixed that in media_build, it may be better to apply this code change
> in media_tree. This because the involved variables are all of type ktime_t and
> there are accessor and converter functions available for that type, which
> should have been used by the original author of 86fe1ac0d and 48b2de197 in my
> opinion.

Sean,

I agree with Jasmin here. I noticed the same errors in the daily build and it
is really caused by not using the correct functions. I just didn't have the
time to follow up on it.

Can you take a look at Jasmin's patch and, if OK, make a pull request for
it?

Regards,

	Hans
