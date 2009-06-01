Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41162 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917AbZFAS66 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2009 14:58:58 -0400
Date: Mon, 1 Jun 2009 15:58:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Paulraj, Sandeep" <s-paulraj@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Grosen, Mark" <mgrosen@ti.com>
Subject: Re: New Driver for DaVinci DM355/DM365/DM6446
Message-ID: <20090601155854.38350ab5@pedra.chehab.org>
In-Reply-To: <C9D59C82B94F474B872F2092A87F2614817980B0@dlee07.ent.ti.com>
References: <C9D59C82B94F474B872F2092A87F261481797D4B@dlee07.ent.ti.com>
	<20090601133436.06a4a4a0@pedra.chehab.org>
	<C9D59C82B94F474B872F2092A87F261481797F62@dlee07.ent.ti.com>
	<20090601145714.36158fe8@pedra.chehab.org>
	<C9D59C82B94F474B872F2092A87F2614817980B0@dlee07.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 1 Jun 2009 13:39:17 -0500
"Paulraj, Sandeep" <s-paulraj@ti.com> escreveu:

> > > [Sandeep] WE don't propose any API changes. This module for which we  
> > want to submit patches is a TI proprietary IP. We currently implement this
> > as a character device and have a few IOCTL's.  
> > > We do not follow the V4L2 framework and do not use any V4L2 IOCTLs.
> > >
> > > Can we continue to use it as a character driver?  
> > 
> > In this case, I don't see why you want it to be upstream.  
> [Sandeep] TI customers and TI itself want to see this driver part of open source trees. Considering this we would like to submit our patches to the linux-media mailing list.
> IS this OK?

If you're just providing a character API with some protocol protected by IP,
you're not providing the source code of the driver, but something else. 

It is not ok to provide such driver. 

Also, even if you disclosure your protocol, it makes no sense to create another
API for userspace communication, for features that already exists or can easily
expand to accommodate your needs. 

So, you should really use the V4L2 API for the driver, expanding it where
required, if you want it to be considered for upstream addition.



Cheers,
Mauro
