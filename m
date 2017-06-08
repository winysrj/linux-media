Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:35898 "EHLO
        mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750725AbdFHEjn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 00:39:43 -0400
Received: by mail-yw0-f171.google.com with SMTP id l75so9553293ywc.3
        for <linux-media@vger.kernel.org>; Wed, 07 Jun 2017 21:39:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAO5uPHOX=++z_YGFoCapH9fvhPwXpC5xr=gCCimAK=ZJ5pp7Hw@mail.gmail.com>
References: <20170530094901.1807-1-hiroh@chromium.org> <1496139572.2618.19.camel@perches.com>
 <CAO5uPHO7GwxCTk2OqQA5NfrL0-Jyt5SB-jVpeUA_eCrqR7u5xA@mail.gmail.com>
 <1496196991.2618.47.camel@perches.com> <CAO5uPHPWGABuKf3FuAky2BRx+9E=n-QhZ94RPQ7wEuHAwC1qGg@mail.gmail.com>
 <1496203602.2618.54.camel@perches.com> <0eb529d9-a710-4305-f0e2-e2fcd5d5433a@xs4all.nl>
 <CAO5uPHOX=++z_YGFoCapH9fvhPwXpC5xr=gCCimAK=ZJ5pp7Hw@mail.gmail.com>
From: Tomasz Figa <tfiga@google.com>
Date: Thu, 8 Jun 2017 13:39:22 +0900
Message-ID: <CAAFQd5AnpjwgWkNL1RvOY1C2WR8gqVuCrPQmaRVCwjSvAM2u8Q@mail.gmail.com>
Subject: Re: [PATCH v2] [media] vb2: core: Lower the log level of debug outputs
To: Hirokazu Honda <hiroh@chromium.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Joe Perches <joe@perches.com>
Cc: Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 8, 2017 at 12:24 PM, Hirokazu Honda <hiroh@chromium.org> wrote:
> Hi,
>
> I completely understand bitmask method now.
> I agree to the idea, but it is necessary to change the specification of
> a debug parameter.
>  (We probably need to change a document about that?)
> For example, there is maybe a user who set a debug parameter 3.
> The user assume that logs whose levels are less than 4 are shown.
> However, after the bitmask method is adopted, someday the logs whose
> level is 1 or 2 are only shown, not 3 level logs are not shown.
> This will be confusing to users.

I think I have to agree with Hirokazu here. Even though it's only
about debugging, there might be some automatic testing systems that
actually rely on certain values here. It probably shouldn't be
considered hard ABI, but that still could be a significant annoyance
for everyone.

However, one could add this in an incremental way, i.e. add a new
debug_mask parameter that would be used by dprinkt(), while making the
original debug parameter simply update the debug_mask whenever it's
changed.

I still think that it should be made with a separate patch, though, as
adjusting the levels and changing the filtering method are orthogonal.

Best regards,
Tomasz
