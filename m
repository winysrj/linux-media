Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:33519 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750752AbdFHFZG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 01:25:06 -0400
Received: by mail-yw0-f172.google.com with SMTP id 63so9766984ywr.0
        for <linux-media@vger.kernel.org>; Wed, 07 Jun 2017 22:25:06 -0700 (PDT)
Received: from mail-yb0-f172.google.com (mail-yb0-f172.google.com. [209.85.213.172])
        by smtp.gmail.com with ESMTPSA id s199sm1606547ywg.11.2017.06.07.22.25.04
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Jun 2017 22:25:04 -0700 (PDT)
Received: by mail-yb0-f172.google.com with SMTP id 202so7311143ybd.0
        for <linux-media@vger.kernel.org>; Wed, 07 Jun 2017 22:25:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1496898982.1929.7.camel@perches.com>
References: <20170530094901.1807-1-hiroh@chromium.org> <1496139572.2618.19.camel@perches.com>
 <CAO5uPHO7GwxCTk2OqQA5NfrL0-Jyt5SB-jVpeUA_eCrqR7u5xA@mail.gmail.com>
 <1496196991.2618.47.camel@perches.com> <CAO5uPHPWGABuKf3FuAky2BRx+9E=n-QhZ94RPQ7wEuHAwC1qGg@mail.gmail.com>
 <1496203602.2618.54.camel@perches.com> <0eb529d9-a710-4305-f0e2-e2fcd5d5433a@xs4all.nl>
 <CAO5uPHOX=++z_YGFoCapH9fvhPwXpC5xr=gCCimAK=ZJ5pp7Hw@mail.gmail.com>
 <CAAFQd5AnpjwgWkNL1RvOY1C2WR8gqVuCrPQmaRVCwjSvAM2u8Q@mail.gmail.com> <1496898982.1929.7.camel@perches.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 8 Jun 2017 14:24:43 +0900
Message-ID: <CAAFQd5A2i+23F1piYbe1zk5Uy0+p+=wN9vyKJX=7JmaXF3Q9BQ@mail.gmail.com>
Subject: Re: [PATCH v2] [media] vb2: core: Lower the log level of debug outputs
To: Joe Perches <joe@perches.com>
Cc: Hirokazu Honda <hiroh@chromium.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 8, 2017 at 2:16 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2017-06-08 at 13:39 +0900, Tomasz Figa wrote:
>> On Thu, Jun 8, 2017 at 12:24 PM, Hirokazu Honda <hiroh@chromium.org> wrote:
>> > Hi,
>> >
>> > I completely understand bitmask method now.
>> > I agree to the idea, but it is necessary to change the specification of
>> > a debug parameter.
>> >  (We probably need to change a document about that?)
>> > For example, there is maybe a user who set a debug parameter 3.
>> > The user assume that logs whose levels are less than 4 are shown.
>> > However, after the bitmask method is adopted, someday the logs whose
>> > level is 1 or 2 are only shown, not 3 level logs are not shown.
>> > This will be confusing to users.
>>
>> I think I have to agree with Hirokazu here. Even though it's only
>> about debugging, there might be some automatic testing systems that
>> actually rely on certain values here.
>
> I think it's a non-argument.
>
> If there automated systems that rely on specific levels, then
> changing the levels of individual messages could also cause
> those automated systems to fail.

Well, that might be true for some of them indeed. I was thinking about
our use case, which relies on particular numbers to get expected
verbosity levels not caring about particular messages. I guess the
break all or none rule is going to apply here, so we should do the
bitmap conversion indeed. :)

On the other hand, I think it would be still preferable to do the
conversion in a separate patch.

Best regards,
Tomasz
