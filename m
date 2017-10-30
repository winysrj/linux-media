Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:46218 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932189AbdJ3J5M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Oct 2017 05:57:12 -0400
Subject: Re: Adjustments for a lot of function implementations
To: Julia Lawall <julia.lawall@lip6.fr>,
        SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Muralidharan Karicheri <mkaricheri@gmail.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <f9dc652b-4fca-37aa-0b72-8c9e6a828da9@users.sourceforge.net>
 <356f75b2-d303-7f10-b76c-95e2f686bd3c@xs4all.nl>
 <14619198-bebe-d215-5324-a14fbc2103fb@users.sourceforge.net>
 <alpine.DEB.2.20.1710301745530.2160@hadrien>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ebf37d57-38c6-b3de-5a66-dbb1c13fd63a@xs4all.nl>
Date: Mon, 30 Oct 2017 10:57:06 +0100
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1710301745530.2160@hadrien>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/30/2017 10:47 AM, Julia Lawall wrote:
> 
> 
> On Mon, 30 Oct 2017, SF Markus Elfring wrote:
> 
>>> While we do not mind cleanup patches, the way you post them (one fix per file)
>>
>> I find it safer in this way  while I was browsing through the landscape of Linux
>> software components.
>>
>>
>>> is really annoying and takes us too much time to review.
>>
>> It is just the case that there are so many remaining open issues.
>>
>>
>>> I'll take the "Fix a possible null pointer" patch since it is an actual bug fix,
>>
>> Thanks for a bit of change acceptance.
>>
>>
>>> but will reject the others, not just this driver but all of them that are currently
>>> pending in our patchwork (https://patchwork.linuxtv.org).
>>
>> Will any chances evolve to integrate 146 patches in any other combination?
>>
>>
>>> Feel free to repost, but only if you organize the patch as either fixing the same type of
>>> issue for a whole subdirectory (media/usb, media/pci, etc)
> 
> Just for the record, while this may work for media, it won't work for all
> subsystems.  One will quickly get a complaint that the big patch needs to
> go into multiple trees.

For the record: this only applies to drivers/media. We discussed what do to with series
like this during our media summit last Friday and this was the conclusion of that.
Obviously I can't talk about other subsystems.

Regards,

	Hans

> 
> julia
> 
>>
>> Can we achieve an agreement on the shown change patterns?
>>
>> Is a consensus possible for involved update candidates?
>>
>>
>>> or fixing all issues for a single driver.
>>
>> I find that I did this already.
>>
>>
>>> Actual bug fixes (like the null pointer patch in this series) can still be posted as
>>> separate patches, but cleanups shouldn't.
>>
>> I got an other software development opinion.
>>
>>
>>> Just so you know, I'll reject any future patch series that do not follow these rules.
>>> Just use common sense when posting these things in the future.
>>
>> Do we need to try any additional communication tools out?
>>
>>
>>> I would also suggest that your time might be spent more productively if you would
>>> work on some more useful projects.
>>
>> I hope that various change possibilities (from my selection) will become useful
>> for more Linux users.
>> How will the clarification evolve further?
>>
>>
>> Regards,
>> Markus
>> --
>> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
