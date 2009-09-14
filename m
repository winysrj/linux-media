Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59340 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbZINVN0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 17:13:26 -0400
Date: Mon, 14 Sep 2009 18:12:49 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [ANOUNCE] Staging trees at V4L/DVB trees
Message-ID: <20090914181249.4c8c50ff@pedra.chehab.org>
In-Reply-To: <19F8576C6E063C45BE387C64729E73940436BA557C@dbde02.ent.ti.com>
References: <20090913210841.6a4db925@caramujo.chehab.org>
	<19F8576C6E063C45BE387C64729E73940436BA556F@dbde02.ent.ti.com>
	<20090914151216.5a29a171@pedra.chehab.org>
	<19F8576C6E063C45BE387C64729E73940436BA557C@dbde02.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 14 Sep 2009 23:58:33 +0530
"Hiremath, Vaibhav" <hvaibhav@ti.com> escreveu:

> > -----Original Message-----
> > From: Mauro Carvalho Chehab [mailto:mchehab@infradead.org]
> > Sent: Monday, September 14, 2009 11:42 PM
> > To: Hiremath, Vaibhav
> > Cc: linux-media@vger.kernel.org
> > Subject: Re: [ANOUNCE] Staging trees at V4L/DVB trees
> > 
> > Em Mon, 14 Sep 2009 22:51:44 +0530
> > "Hiremath, Vaibhav" <hvaibhav@ti.com> escreveu:
> > 
> > > > -----Original Message-----
> > > > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > > > owner@vger.kernel.org] On Behalf Of Mauro Carvalho Chehab
> > > > Sent: Monday, September 14, 2009 5:39 AM
> > > > To: linux-media@vger.kernel.org
> > > > Subject: [ANOUNCE] Staging trees at V4L/DVB trees
> > > >
> > > > Probably some of you already noticed that we're creating some
> > > > staging trees at
> > > > V4L/DVB trees.
> > > >
> > > > There are currently 2 staging trees:
> > > >
> > > > 1) /linux/drivers/staging - With drivers that aren't ready yet
> > for
> > > > merge, needing
> > > > help for being finished.
> > > >
> > > [Hiremath, Vaibhav] Hi Mauro,
> > >
> > > As you know I am also working on OMAP3 V4L2 display driver and
> > posted initial patches (Posted by myself and Hardik Shah) to the
> > community which went through couple of review cycles. Since it was
> > having dependency on DSS2 library being developed by and at Nokia
> > (Tomi) we decided to wait for it to be accepted.
> > >
> > > Now DSS2 has already being submitted to the community and will
> > make his way to mainline soon.
> > >
> > > Do you want me to submit the OMAP3 DSS driver for staging tree,
> > this would be really good candidate for this. I will make sure that
> > it stays updated and tested till DSS2 gets accepted.
> > >
> > > Please let me know your inputs, if you feel it should be done then
> > I will submit patch tomorrow as soon as I get into office.
> > 
> > Hmm... if it has dependency with another tree, this may be a problem
> > since my
> > intention is to merge the three drivers we have currently at kernel
> > drivers/staging (in fact two of them, since go7007 is already
> > there), but, if
> > they compile fine, even without DSS2 library (is it a kernel
> > library?), then,
> > that's fine for staging.
> > 
> > 
> [Hiremath, Vaibhav] Yes, this is kernel level library which sits underneath driver, V4L2 and Fbdev and provides seamless DSS hardware access to above drivers. They won't compile without it. 
> 
>       V4L2                             Fbdev
>        |                                 |
>         ----------------------------------
>              |                         |
>             DSS2                     VRFB
>              |                         |
>          OMAP3 DSS HW             VRFB HW engine
> 
> But should it be ok if I put dependency in Kconfig itself? The file won't get compiled. I understand we won't gain anything with this, this is just another tree to hold, and this is one of the main reason I stopped pushing this patch. 
> The patch is submit worthy and cater most of the requirements, but due to some dependencies it has blocked till now.

Well, what would be the gain on having it there upstream without being capable
of compiling? I would prefer if you add it at some -hg tree and ask me to pull
after having the DSS2 library at upstream or at linux-next.

Cheers,
Mauro
