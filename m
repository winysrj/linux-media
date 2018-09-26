Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39992 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbeI0CJs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 22:09:48 -0400
Date: Wed, 26 Sep 2018 16:54:49 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANN] Draft Agenda for the media summit on Thursday Oct 25th in
 Edinburgh
Message-ID: <20180926165449.139fdc40@coco.lan>
In-Reply-To: <12eb26b5-a701-68d9-b81b-576812ff7169@xs4all.nl>
References: <9ee40db8-244b-c019-be7d-39925e87bf6f@xs4all.nl>
        <20180924141228.10227b1d@coco.lan>
        <12eb26b5-a701-68d9-b81b-576812ff7169@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 24 Sep 2018 19:41:13 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 09/24/2018 07:12 PM, Mauro Carvalho Chehab wrote:
> > Em Mon, 24 Sep 2018 16:42:13 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >> Hi all,
> >>
> >> We are organizing a media mini-summit on Thursday October 25th in
> >> Edinburgh, Edinburgh International Conference Centre.
> >>
> >> If you plan to attend, please let Mauro know. It is open for all, but
> >> we have a limited number of seats.  
> > 
> > No need to let me explicitly know in advance, but be sure to register for
> > it at the ELCE/OSS register site. I'll use their tracking system to
> > know who will be there. We have a limited number of seats there, and
> > I'm relying on their system to control the number of attendees for
> > us.  
> 
> How many registrations do we have now?

At the moment, there are 75 people subscribed to it! From them, on
a quick glance, I was able to recognize ~18 names from people that are
already contributors to media.

Yet, running:

	$ IFS=$'\n'; for i in $(cat ~/Documentos/attendees_list.csv|cut -d\; -f1-2|sed 's,;, ,'); do echo -n "$i;";git log --oneline --author "$i" |wc -l; done

I noticed 32 people[1] that submitted at least one Kernel patch (either to
media or to other subsystems), where 30 of them submitted more than 7
patches.

So, I guess we'll have full house this time.

Thanks,
Mauro

[1] I'm seeking for names, not e-mails. So, this is just a hint,
as it may have more than one people with the same name.
