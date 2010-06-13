Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:42583 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754228Ab0FMRyL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jun 2010 13:54:11 -0400
Subject: Re: [PATCH] Fix av7110 driver name
From: hermann pitton <hermann-pitton@arcor.de>
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
Cc: VDR User <user.vdr@gmail.com>,
	"mailing list: linux-media" <linux-media@vger.kernel.org>,
	Oliver Endriss <o.endriss@gmx.de>
In-Reply-To: <alpine.DEB.2.01.1006131200580.17071@localhost.localdomain>
References: <AANLkTilYElPyhhej6XYF15D9wwBtkiMWrmkTvsviCI3W@mail.gmail.com>
	 <alpine.DEB.2.01.1006131200580.17071@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 13 Jun 2010 19:48:04 +0200
Message-Id: <1276451284.3128.18.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Barry,

Am Sonntag, den 13.06.2010, 12:07 +0200 schrieb BOUWSMA Barry:
> On Sat (Saturday) 12.Jun (June) 2010, 05:10,  VDR User wrote:
> 
> > This patch simply changes the name of the av7110 driver to "AV7110"
> > instead of the generic "dvb" it's set to currently.  Although it's
> > somewhat trivial, it still seems appropriate to fix the name to be
> > descriptive of the driver.
> 
> Thanks Derek; I'll just note that as submitted, the trivial patch
> is a ``reversed'' patch, but I'd hope that any tools written for
> auto-patch-handing should be able to detect this and correct this
> issue.
> 
> The other patch is in ``proper'' order, so no worries.
> 
> 
> 
> > --- v4l-dvb/linux/drivers/media/dvb/ttpci/av7110.c      2010-06-11
> > 13:24:29.000000000 -0700
> > +++ v4l-dvb.orig/linux/drivers/media/dvb/ttpci/av7110.c 2010-06-11
> > 12:49:50.000000000 -0700
> 
> 
> > -       .name           = "AV7110",
> > +       .name           = "dvb",
> 
> 
> thanks,
> barry bouwsma

the whole situation, dealing with such sort of patches, also given the
noise for nothing previously, is of course somewhat unpleasant.

But out of such, we had best support from people not obviously related
to linux many times and that counts.

So, for my experience, it is always worth to have some rumble.

Cheers,
Hermann






