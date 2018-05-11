Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:50977 "EHLO
        homiemail-a121.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750798AbeEKVsa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 17:48:30 -0400
Subject: Re: [PATCH 7/7] Add config-compat.h override config-mycompat.h
To: "Jasmin J." <jasmin@anw.at>, Brad Love <brad@nextdimension.cc>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
 <1524763162-4865-8-git-send-email-brad@nextdimension.cc>
 <c20ac1dd-153c-5d43-f0fd-ade27c548f86@xs4all.nl>
 <777ec77a-1a1c-138b-b5ca-33201649acc7@nextdimension.cc>
 <3a039830-6ae8-406b-ede6-77553d7f45dd@anw.at>
 <412dd3a2-b48e-3068-4181-37c66d664891@nextdimension.cc>
 <2e78051f-d025-6a50-e745-20baf20325b6@anw.at>
From: Brad Love <brad@nextdimension.cc>
Message-ID: <9a9ca72a-420a-85fc-1fa5-fbd49f06069c@nextdimension.cc>
Date: Fri, 11 May 2018 16:48:27 -0500
MIME-Version: 1.0
In-Reply-To: <2e78051f-d025-6a50-e745-20baf20325b6@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jasmin,


On 2018-05-11 16:43, Jasmin J. wrote:
> Hello Brad!
>
> THX for this clarification!
>
> So you tried already to fix the config_compat script and I agree with you that
> it is difficult for you because of the various Kernels and distributions you
> have to maintain.
>
> Then your workaround is indeed a possibility to use media-build to build your
> modules out of tree for all the combinations you have. Maybe in the future
> other people may use this also.
>
> BR,
>    Jasmin

Please do check out my v2. Hans also had questions and concerns over the
intended usage, so I did my best to explain it thoroughly in the v2 commit
message along with inside of compat.h. I hope it is clear enough now to
understand for anyone who might need the feature in the future.

Cheers,

Brad
