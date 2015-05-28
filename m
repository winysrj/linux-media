Return-path: <linux-media-owner@vger.kernel.org>
Received: from benson.vm.bytemark.co.uk ([212.110.190.137]:46553 "EHLO
	benson.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbbE1Hlu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 03:41:50 -0400
Message-ID: <1432798906.5748.183.camel@hellion.org.uk>
Subject: Re: DVB-T2 PCIe vs DVB-S2
From: Ian Campbell <ijc@hellion.org.uk>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: Jemma Denson <jdenson@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Date: Thu, 28 May 2015 08:41:46 +0100
In-Reply-To: <CAAZRmGzcU0sGjzvim+ap2HXDp=ZxTkn8h+ZbNEA8DQn3P0jVag@mail.gmail.com>
References: <1432626810.5748.173.camel@hellion.org.uk>
	 <556494F9.1020406@gmail.com>
	 <CAAZRmGzcU0sGjzvim+ap2HXDp=ZxTkn8h+ZbNEA8DQn3P0jVag@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks guys, it hadn't occurred to me that I'd need to check the mythtv
side as well! (It's obvious though now it's been pointed out...)

Since one of my two Nova-T-500 died recently I may just replace it with
an HD capable DVB-T2 card but only use it for DVD-T for now while the
PVR side catches up.

Thanks for the advice and the pointers to the available h/w!

Ian.

On Tue, 2015-05-26 at 21:10 +0200, Olli Salonen wrote:
> There are indeed a few DVB-T2 PCIe cards that are supported (DVBSky
> T9580, T980C, T982C, TechnoTrend CT2-4500 CI, Hauppauge HVR-2205,
> Hauppauge HVR-5525 at least come to my mind). PCTV 290e is a USB
> device, not PCIe. In the wiki there's currently some issue with the
> filtering when it comes to the tables - that's why every PCIe device
> is printed instead of just the DVB-T2 supporting ones.
> 
> As Jemma points out, the application should be clever enough to tell
> the driver that DVB-T2 delivery system is wanted. For the cxd2820r
> driver (PCTV 290e) Antti made the "fudge", but has decided not to
> implement it in the Si2168 driver (reasoning, to which I
> wholeheartedly agree, is here:
> http://blog.palosaari.fi/2014/09/linux-dvb-t2-tuning-problems.html ).
> 
> When it comes to PVR backends, at least tvheadend supports DVBv5 fully
> - I don't have a clear picture of other backends.
> 
> Cheers,
> -olli
> 
> On 26 May 2015 at 17:44, Jemma Denson <jdenson@gmail.com> wrote:
> > On 26/05/15 08:53, Ian Campbell wrote:
> >>
> >> Hello,
> >>
> >> I'm looking to get a DVB-T2 tuner card to add UK Freeview HD to my
> >> mythtv box.
> >>
> >> Looking at http://linuxtv.org/wiki/index.php/DVB-T2_PCIe_Cards is seems
> >> that many (the majority even) of the cards there are actually DVB-S2.
> >>
> >> Is this a mistake or is there something I don't know (like maybe S2 is
> >> compatible with T2)?
> >>
> >> Thanks,
> >> Ian.
> >
> >
> > That's a mistake - I don't recall that table looking like that when I was
> > looking for one, and S2 is quite definitely not compatible with T2!
> >
> > I can confirm that the 290e works out of the box with myth with very few
> > problems, however it's well out of production now and you might not be after
> > a USB device. I'm not sure anything else would work without some hacking
> > because last I heard myth doesn't do T2 the proper way using DVBv5 yet, and
> > afaik only the 290e driver has a fudge to allow T2 on v3.
> > (http://lists.mythtv.org/pipermail/mythtv-users/2014-November/374441.html
> > and https://code.mythtv.org/trac/ticket/12342)
> >
> >
> > Jemma.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


