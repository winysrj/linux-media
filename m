Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59976 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487AbbCRCzT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2015 22:55:19 -0400
Date: Tue, 17 Mar 2015 23:55:08 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Kozlov Sergey <serjk@netup.ru>, linux-media@vger.kernel.org,
	aospan1@gmail.com,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 1/5] [media] horus3a: Sony Horus3A DVB-S/S2 tuner driver
Message-ID: <20150317235508.21abc274@recife.lan>
In-Reply-To: <5508C2C8.4090407@iki.fi>
References: <20150202092806.7B4D81BC32CD@debian>
	<20150305055414.1b02a0c1@recife.lan>
	<5508C2C8.4090407@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 18 Mar 2015 02:11:52 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 03/05/2015 10:54 AM, Mauro Carvalho Chehab wrote:
> > Em Mon, 02 Feb 2015 12:22:32 +0300
> > Kozlov Sergey <serjk@netup.ru> escreveu:
> 
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index ddb9ac8..a3a1767 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -4365,6 +4365,15 @@ W:	http://linuxtv.org
> >>   S:	Odd Fixes
> >>   F:	drivers/media/usb/hdpvr/
> >>
> >> +HORUS3A MEDIA DRIVER
> >
> > Not a big issue, but could you please rename it to:
> > 	MEDIA DRIVERS FOR HORUS3A
> >
> > We're trying to better organize the media entries at MAINTAINERS, at
> > least for the new drivers.
> 
> What the *ell is that new rule? MAINTAINERS file clearly says entries 
> should be alphabetical order,

Yes, whatever name is given, the MAINTAINERS entries should be in 
alphabetical order.

> but on the other-hand there seems to be 
> PCI and ARM specific stuff already grouped. Is that some new way?

Yeah, there is a tendency to try to group the entries on a similar
way on other subsystems.

So, Laurent proposed to do that for new drivers.

That's said, it makes no sense to rename the existing entries, as such
patch would likely make lots of people unhappy by causing a great number
of merge conflicts, but, as grouping the new entries seem to help
some people that manually looks at MAINTAINERS, it sounds a good
idea to do it for new drivers.

One advantage of grouping the entries for new drivers is that this
reduces the merge conflicts at MAINTAINERS, as it reduces the risk of
two subsystems to touch at the same part of the file.

Regards,
Mauro
