Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56604 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbZBQLTs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 06:19:48 -0500
Date: Tue, 17 Feb 2009 08:19:17 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: =?ISO-8859-1?B?TultZXRoIE3hcnRvbg==?= <nm127@freemail.hu>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Trivial Patch Monkey <trivial@kernel.org>
Subject: Re: [PATCH] DAB: fix typo
Message-ID: <20090217081917.568af731@pedra.chehab.org>
In-Reply-To: <alpine.LNX.1.10.0902111400540.31014@jikos.suse.cz>
References: <498622DA.9080106@freemail.hu>
	<alpine.LNX.1.10.0902111400540.31014@jikos.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 11 Feb 2009 14:01:15 +0100 (CET)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Sun, 1 Feb 2009, Németh Márton wrote:
> 
> > From: Márton Németh <nm127@freemail.hu>
> > 
> > Fix typo in "DAB adapters" section in Kconfig.
> > 
> > Signed-off-by: Márton Németh <nm127@freemail.hu>
> > ---
> > --- linux-2.6.29-rc3/drivers/media/Kconfig.orig	2008-12-25 00:26:37.000000000 +0100
> > +++ linux-2.6.29-rc3/drivers/media/Kconfig	2009-02-01 13:30:54.000000000 +0100
> > @@ -117,7 +117,7 @@ source "drivers/media/dvb/Kconfig"
> >  config DAB
> >  	boolean "DAB adapters"
> >  	---help---
> > -	  Allow selecting support for for Digital Audio Broadcasting (DAB)
> > +	  Allow selecting support for Digital Audio Broadcasting (DAB)
> >  	  Receiver adapters.
> 
> Didn't find this in today's linux-next, so I have applied it to trivial 
> tree.
I was just applying it on my tree right now. Anyway, it is OK for me if you
apply it at trivial.

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Cheers,
Mauro
