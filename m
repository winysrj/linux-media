Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0219.hostedemail.com ([216.40.44.219]:54167 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751513AbdFHFd4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Jun 2017 01:33:56 -0400
Message-ID: <1496900032.1929.9.camel@perches.com>
Subject: Re: [PATCH v2] [media] vb2: core: Lower the log level of debug
 outputs
From: Joe Perches <joe@perches.com>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Hirokazu Honda <hiroh@chromium.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 07 Jun 2017 22:33:52 -0700
In-Reply-To: <CAAFQd5A2i+23F1piYbe1zk5Uy0+p+=wN9vyKJX=7JmaXF3Q9BQ@mail.gmail.com>
References: <20170530094901.1807-1-hiroh@chromium.org>
         <1496139572.2618.19.camel@perches.com>
         <CAO5uPHO7GwxCTk2OqQA5NfrL0-Jyt5SB-jVpeUA_eCrqR7u5xA@mail.gmail.com>
         <1496196991.2618.47.camel@perches.com>
         <CAO5uPHPWGABuKf3FuAky2BRx+9E=n-QhZ94RPQ7wEuHAwC1qGg@mail.gmail.com>
         <1496203602.2618.54.camel@perches.com>
         <0eb529d9-a710-4305-f0e2-e2fcd5d5433a@xs4all.nl>
         <CAO5uPHOX=++z_YGFoCapH9fvhPwXpC5xr=gCCimAK=ZJ5pp7Hw@mail.gmail.com>
         <CAAFQd5AnpjwgWkNL1RvOY1C2WR8gqVuCrPQmaRVCwjSvAM2u8Q@mail.gmail.com>
         <1496898982.1929.7.camel@perches.com>
         <CAAFQd5A2i+23F1piYbe1zk5Uy0+p+=wN9vyKJX=7JmaXF3Q9BQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-06-08 at 14:24 +0900, Tomasz Figa wrote:
> On Thu, Jun 8, 2017 at 2:16 PM, Joe Perches <joe@perches.com> wrote:
[]
> > If there automated systems that rely on specific levels, then
> > changing the levels of individual messages could also cause
> > those automated systems to fail.
> 
> Well, that might be true for some of them indeed. I was thinking about
> our use case, which relies on particular numbers to get expected
> verbosity levels not caring about particular messages. I guess the
> break all or none rule is going to apply here, so we should do the
> bitmap conversion indeed. :)
> 
> On the other hand, I think it would be still preferable to do the
> conversion in a separate patch.

Right.  No worries.
