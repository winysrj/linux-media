Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0073.hostedemail.com ([216.40.44.73]:42643 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752391AbdFHFQc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Jun 2017 01:16:32 -0400
Message-ID: <1496898982.1929.7.camel@perches.com>
Subject: Re: [PATCH v2] [media] vb2: core: Lower the log level of debug
 outputs
From: Joe Perches <joe@perches.com>
To: Tomasz Figa <tfiga@google.com>,
        Hirokazu Honda <hiroh@chromium.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 07 Jun 2017 22:16:22 -0700
In-Reply-To: <CAAFQd5AnpjwgWkNL1RvOY1C2WR8gqVuCrPQmaRVCwjSvAM2u8Q@mail.gmail.com>
References: <20170530094901.1807-1-hiroh@chromium.org>
         <1496139572.2618.19.camel@perches.com>
         <CAO5uPHO7GwxCTk2OqQA5NfrL0-Jyt5SB-jVpeUA_eCrqR7u5xA@mail.gmail.com>
         <1496196991.2618.47.camel@perches.com>
         <CAO5uPHPWGABuKf3FuAky2BRx+9E=n-QhZ94RPQ7wEuHAwC1qGg@mail.gmail.com>
         <1496203602.2618.54.camel@perches.com>
         <0eb529d9-a710-4305-f0e2-e2fcd5d5433a@xs4all.nl>
         <CAO5uPHOX=++z_YGFoCapH9fvhPwXpC5xr=gCCimAK=ZJ5pp7Hw@mail.gmail.com>
         <CAAFQd5AnpjwgWkNL1RvOY1C2WR8gqVuCrPQmaRVCwjSvAM2u8Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-06-08 at 13:39 +0900, Tomasz Figa wrote:
> On Thu, Jun 8, 2017 at 12:24 PM, Hirokazu Honda <hiroh@chromium.org> wrote:
> > Hi,
> > 
> > I completely understand bitmask method now.
> > I agree to the idea, but it is necessary to change the specification of
> > a debug parameter.
> >  (We probably need to change a document about that?)
> > For example, there is maybe a user who set a debug parameter 3.
> > The user assume that logs whose levels are less than 4 are shown.
> > However, after the bitmask method is adopted, someday the logs whose
> > level is 1 or 2 are only shown, not 3 level logs are not shown.
> > This will be confusing to users.
> 
> I think I have to agree with Hirokazu here. Even though it's only
> about debugging, there might be some automatic testing systems that
> actually rely on certain values here.

I think it's a non-argument.

If there automated systems that rely on specific levels, then
changing the levels of individual messages could also cause
those automated systems to fail.
