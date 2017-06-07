Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:58012 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751257AbdFGJBJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 05:01:09 -0400
Subject: Re: [PATCH v2] [media] vb2: core: Lower the log level of debug
 outputs
To: Joe Perches <joe@perches.com>, Hirokazu Honda <hiroh@chromium.org>
References: <20170530094901.1807-1-hiroh@chromium.org>
 <1496139572.2618.19.camel@perches.com>
 <CAO5uPHO7GwxCTk2OqQA5NfrL0-Jyt5SB-jVpeUA_eCrqR7u5xA@mail.gmail.com>
 <1496196991.2618.47.camel@perches.com>
 <CAO5uPHPWGABuKf3FuAky2BRx+9E=n-QhZ94RPQ7wEuHAwC1qGg@mail.gmail.com>
 <1496203602.2618.54.camel@perches.com>
Cc: Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0eb529d9-a710-4305-f0e2-e2fcd5d5433a@xs4all.nl>
Date: Wed, 7 Jun 2017 11:01:06 +0200
MIME-Version: 1.0
In-Reply-To: <1496203602.2618.54.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31/05/17 06:06, Joe Perches wrote:
> On Wed, 2017-05-31 at 12:28 +0900, Hirokazu Honda wrote:
>> If I understand a bitmap correctly, it is necessary to change the log level
>> for each message.
>> I didn't mean a bitmap will take a long CPU time.
>> I mean the work to change so takes a long time.
> 
> No, none of the messages or levels need change,
> only the >= test changes to & so that for instance,
> level 1 and level 3 messages could be emitted
> without also emitting level 2 messages.
> 
> The patch suggested is all that would be required.
> 

I prefer the solution that Joe proposed as well.

It's more useful, esp. with a complex beast like vb2.

Regards,

	Hans
