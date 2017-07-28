Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:42964 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751745AbdG1NNR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 09:13:17 -0400
Subject: Re: [PATCH v2] [media] vb2: core: Lower the log level of debug
 outputs
To: Hirokazu Honda <hiroh@chromium.org>, Joe Perches <joe@perches.com>
Cc: Tomasz Figa <tfiga@chromium.org>, Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
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
 <1496900032.1929.9.camel@perches.com>
 <CAO5uPHP7HSpzbO7EhqLjjEsZ+etnqS106Ec98Z7cDvGhKb6dDQ@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c12a57ae-6f0c-eee2-b487-594ee330d9be@xs4all.nl>
Date: Fri, 28 Jul 2017 15:13:11 +0200
MIME-Version: 1.0
In-Reply-To: <CAO5uPHP7HSpzbO7EhqLjjEsZ+etnqS106Ec98Z7cDvGhKb6dDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/28/2017 12:57 AM, Hirokazu Honda wrote:
> Hi,
> 
> According to patch work, this patch are not approved yet and its
> status are "Changes Requested."
> What changes are necessary actually?
> If there is no necessary change, can you approve this patch?

I was considering to have more fine grained control by changing
the debug parameter to a bitmask. But after thinking about it a
bit more I decided that this patch is OK after all.

I'll pick it up the next time I prepare a pull request.

Regards,

	Hans

> 
> Best,
> Hirokazu Honda
> 
> On Thu, Jun 8, 2017 at 2:33 PM, Joe Perches <joe@perches.com> wrote:
>> On Thu, 2017-06-08 at 14:24 +0900, Tomasz Figa wrote:
>>> On Thu, Jun 8, 2017 at 2:16 PM, Joe Perches <joe@perches.com> wrote:
>> []
>>>> If there automated systems that rely on specific levels, then
>>>> changing the levels of individual messages could also cause
>>>> those automated systems to fail.
>>>
>>> Well, that might be true for some of them indeed. I was thinking about
>>> our use case, which relies on particular numbers to get expected
>>> verbosity levels not caring about particular messages. I guess the
>>> break all or none rule is going to apply here, so we should do the
>>> bitmap conversion indeed. :)
>>>
>>> On the other hand, I think it would be still preferable to do the
>>> conversion in a separate patch.
>>
>> Right.  No worries.
>>
