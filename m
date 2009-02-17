Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50645 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbZBQLV5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 06:21:57 -0500
Date: Tue, 17 Feb 2009 12:21:53 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: =?ISO-8859-15?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Trivial Patch Monkey <trivial@kernel.org>
Subject: Re: [PATCH] DAB: fix typo
In-Reply-To: <20090217081917.568af731@pedra.chehab.org>
Message-ID: <alpine.LNX.1.10.0902171220370.18110@jikos.suse.cz>
References: <498622DA.9080106@freemail.hu> <alpine.LNX.1.10.0902111400540.31014@jikos.suse.cz> <20090217081917.568af731@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="336216065-165693548-1234869713=:18110"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--336216065-165693548-1234869713=:18110
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 17 Feb 2009, Mauro Carvalho Chehab wrote:

> > > From: Márton Németh <nm127@freemail.hu>
> > > 
> > > Fix typo in "DAB adapters" section in Kconfig.
> > > 
> > > Signed-off-by: Márton Németh <nm127@freemail.hu>
> > > ---
> > > --- linux-2.6.29-rc3/drivers/media/Kconfig.orig	2008-12-25 00:26:37.000000000 +0100
> > > +++ linux-2.6.29-rc3/drivers/media/Kconfig	2009-02-01 13:30:54.000000000 +0100
> > > @@ -117,7 +117,7 @@ source "drivers/media/dvb/Kconfig"
> > >  config DAB
> > >  	boolean "DAB adapters"
> > >  	---help---
> > > -	  Allow selecting support for for Digital Audio Broadcasting (DAB)
> > > +	  Allow selecting support for Digital Audio Broadcasting (DAB)
> > >  	  Receiver adapters.
> > 
> > Didn't find this in today's linux-next, so I have applied it to trivial 
> > tree.
> I was just applying it on my tree right now. Anyway, it is OK for me if you
> apply it at trivial.

No problem, if you take it through your tree I am fine with that, it will 
be easier that way to avoid conflicts in -next.

I am dropping the patch from trivial tree.

Thanks,

-- 
Jiri Kosina
SUSE Labs
--336216065-165693548-1234869713=:18110--
