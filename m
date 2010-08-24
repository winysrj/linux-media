Return-path: <mchehab@pedra>
Received: from smtp8.mail.ru ([94.100.176.53]:47459 "EHLO smtp8.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695Ab0HXQoP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Aug 2010 12:44:15 -0400
Received: from [92.101.155.238] (port=2064 helo=localhost.localdomain)
	by smtp8.mail.ru with asmtp
	id 1Onwbd-00030w-00
	for linux-media@vger.kernel.org; Tue, 24 Aug 2010 20:44:13 +0400
Date: Tue, 24 Aug 2010 20:52:57 +0400
From: Goga777 <goga777@bk.ru>
Cc: linux-media@vger.kernel.org
Subject: Re: SkyStar S2 on an embedded Linux
Message-ID: <20100824205257.47407821@bk.ru>
In-Reply-To: <AANLkTimvTUsqDtsyKytktwcAp49xcez71eROKh5BsAt8@mail.gmail.com>
References: <AANLkTi=OTqzA41=H-=M7Vmrq=uY=Av-bjVNDHpQ=LRv1@mail.gmail.com>
	<20100817211027.1ffee6ea@list.ru>
	<AANLkTi=T0dCRCHfr9tsQe-fVBwo+x1SehaZKA-VPmPAj@mail.gmail.com>
	<20100818185354.177c4c07@bk.ru>
	<AANLkTi=TXpy8da2KF_1-+B3Wjx4OQK7eH0KkG-+if9mQ@mail.gmail.com>
	<AANLkTimvTUsqDtsyKytktwcAp49xcez71eROKh5BsAt8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

> Sorry, my bad!
> You were right. The channels on FEC 3/4 and 8PSK modulation can't be
> locked. Is there any solution to this problem?
> I noticed you've quoted my email on a forum:
> http://linuxdvb.org.ru/wbb/index.php?page=Thread&postID=16173#post16173

yes,  we discussed such issue, but solution still doesn't exist 
Custler is very busy to fix it :(


> 
> On Wed, Aug 18, 2010 at 11:21 PM, Nima Mohammadi <nima.irt@gmail.com> wrote:
> > On Wed, Aug 18, 2010 at 7:23 PM, Goga777 <goga777@bk.ru> wrote:
> >>
> >> would you re-check please again - have you luck with 8PSK-FEC 3/4 dvb-s2 channels ?
> >>
> >> Goga
> >
> > Yes, except MTVNHD and Suisse HD (which use QPSK modulation), almost
> > all other HD channels on Hotbird are on 8PSK and I can watch them
> > without any problem.
> >
> > Actually, I managed to solve my problem. I was using a lightweight
> > implementation of udev called mdev. Today I tried installing udev on
> > my embedded system. And although it works fine now, I prefer to use
> > mdev and I'd be more than happy if anyone could point out what the
> > problem with mdev is. As the documentation of busybox states, mdev can
> > load firmwares from the /lib/firmware/ directory.
> >
