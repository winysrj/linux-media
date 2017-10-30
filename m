Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:51737
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932173AbdJ3JrO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Oct 2017 05:47:14 -0400
Date: Mon, 30 Oct 2017 17:47:01 +0800 (CST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Muralidharan Karicheri <mkaricheri@gmail.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: Adjustments for a lot of function implementations
In-Reply-To: <14619198-bebe-d215-5324-a14fbc2103fb@users.sourceforge.net>
Message-ID: <alpine.DEB.2.20.1710301745530.2160@hadrien>
References: <f9dc652b-4fca-37aa-0b72-8c9e6a828da9@users.sourceforge.net> <356f75b2-d303-7f10-b76c-95e2f686bd3c@xs4all.nl> <14619198-bebe-d215-5324-a14fbc2103fb@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 30 Oct 2017, SF Markus Elfring wrote:

> > While we do not mind cleanup patches, the way you post them (one fix per file)
>
> I find it safer in this way  while I was browsing through the landscape of Linux
> software components.
>
>
> > is really annoying and takes us too much time to review.
>
> It is just the case that there are so many remaining open issues.
>
>
> > I'll take the "Fix a possible null pointer" patch since it is an actual bug fix,
>
> Thanks for a bit of change acceptance.
>
>
> > but will reject the others, not just this driver but all of them that are currently
> > pending in our patchwork (https://patchwork.linuxtv.org).
>
> Will any chances evolve to integrate 146 patches in any other combination?
>
>
> > Feel free to repost, but only if you organize the patch as either fixing the same type of
> > issue for a whole subdirectory (media/usb, media/pci, etc)

Just for the record, while this may work for media, it won't work for all
subsystems.  One will quickly get a complaint that the big patch needs to
go into multiple trees.

julia

>
> Can we achieve an agreement on the shown change patterns?
>
> Is a consensus possible for involved update candidates?
>
>
> > or fixing all issues for a single driver.
>
> I find that I did this already.
>
>
> > Actual bug fixes (like the null pointer patch in this series) can still be posted as
> > separate patches, but cleanups shouldn't.
>
> I got an other software development opinion.
>
>
> > Just so you know, I'll reject any future patch series that do not follow these rules.
> > Just use common sense when posting these things in the future.
>
> Do we need to try any additional communication tools out?
>
>
> > I would also suggest that your time might be spent more productively if you would
> > work on some more useful projects.
>
> I hope that various change possibilities (from my selection) will become useful
> for more Linux users.
> How will the clarification evolve further?
>
>
> Regards,
> Markus
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
