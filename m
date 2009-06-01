Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:54600 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbZFASjn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2009 14:39:43 -0400
From: "Paulraj, Sandeep" <s-paulraj@ti.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Grosen, Mark" <mgrosen@ti.com>
Date: Mon, 1 Jun 2009 13:39:17 -0500
Subject: RE: New Driver for DaVinci DM355/DM365/DM6446
Message-ID: <C9D59C82B94F474B872F2092A87F2614817980B0@dlee07.ent.ti.com>
References: <C9D59C82B94F474B872F2092A87F261481797D4B@dlee07.ent.ti.com>
	<20090601133436.06a4a4a0@pedra.chehab.org>
	<C9D59C82B94F474B872F2092A87F261481797F62@dlee07.ent.ti.com>
 <20090601145714.36158fe8@pedra.chehab.org>
In-Reply-To: <20090601145714.36158fe8@pedra.chehab.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,
      Please see inline

> -----Original Message-----
> From: Mauro Carvalho Chehab [mailto:mchehab@infradead.org]
> Sent: Monday, June 01, 2009 1:57 PM
> To: Paulraj, Sandeep
> Cc: linux-media@vger.kernel.org; linux-kernel@vger.kernel.org; Grosen,
> Mark
> Subject: Re: New Driver for DaVinci DM355/DM365/DM6446
> 
> Em Mon, 1 Jun 2009 11:54:37 -0500
> "Paulraj, Sandeep" <s-paulraj@ti.com> escreveu:
> 
> >
> >
> > > -----Original Message-----
> > > From: Mauro Carvalho Chehab [mailto:mchehab@infradead.org]
> > > Sent: Monday, June 01, 2009 12:35 PM
> > > To: Paulraj, Sandeep
> > > Cc: linux-media@vger.kernel.org; linux-kernel@vger.kernel.org; Grosen,
> > > Mark
> > > Subject: Re: New Driver for DaVinci DM355/DM365/DM6446
> > >
> > > Em Mon, 1 Jun 2009 09:56:40 -0500
> > > "Paulraj, Sandeep" <s-paulraj@ti.com> escreveu:
> > >
> > > >
> > > > Hello,
> > > >
> > > > WE have a module(H3A) on Davinci DM6446,DM355 and DM365.
> > > >
> > > > Customers require a way to collect the data required to perform the
> Auto
> > > Exposure (AE), Auto Focus(AF), and Auto White balance (AWB) in
> hardware as
> > > opposed to software. This is primarily for performance reasons as
> there is
> > > not enough software processing MIPS (to do 3A statistics) available in
> > > > an imaging/video system.
> > > >
> > > > Including this block in hardware reduces the load on the processor
> and
> > > bandwidth to the memory as the data is collected on the fly from the
> > > imager.
> > > >
> > > > This modules collects statistics and we currently implement it as a
> > > character driver.
> > > >
> > > > Which mailing list would be the most appropriate mailing list to
> submit
> > > patches for review?
> > >
> > > You should send they to:
> > > 	LMML <linux-media@vger.kernel.org>
> > >
> > > If you are proposing API changes, please submit they first.
> > [Sandeep] WE don't propose any API changes. This module for which we
> want to submit patches is a TI proprietary IP. We currently implement this
> as a character device and have a few IOCTL's.
> > We do not follow the V4L2 framework and do not use any V4L2 IOCTLs.
> >
> > Can we continue to use it as a character driver?
> 
> In this case, I don't see why you want it to be upstream.
[Sandeep] TI customers and TI itself want to see this driver part of open source trees. Considering this we would like to submit our patches to the linux-media mailing list.
IS this OK?
> 
> 
> 
> Cheers,
> Mauro

