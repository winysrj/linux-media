Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48167 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933293AbZHWRtp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2009 13:49:45 -0400
Date: Sun, 23 Aug 2009 10:34:35 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: James Peters <james.peters.ml@googlemail.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Miguel <mcm@moviquity.com>, linux-media@vger.kernel.org
Subject: Re: USB Wintv HVR-900 Hauppauge
Message-ID: <20090823103435.13f907a1@pedra.chehab.org>
In-Reply-To: <82d79e70908210927w2df8c403w3764bb131f24f87d@mail.gmail.com>
References: <1250679685.14727.14.camel@McM>
	<829197380908190642sfabee2ahe599dda1df39678c@mail.gmail.com>
	<1250701340.14727.28.camel@McM>
	<829197380908191016n8d7f21eq88ebe3a45816275b@mail.gmail.com>
	<20090821030749.372093bd@pedra.chehab.org>
	<829197380908210912u51df8809i617c6a3be65e886b@mail.gmail.com>
	<82d79e70908210927w2df8c403w3764bb131f24f87d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 21 Aug 2009 18:27:30 +0200
James Peters <james.peters.ml@googlemail.com> escreveu:

> On Fri, Aug 21, 2009 at 6:12 PM, Devin
> Heitmueller<dheitmueller@kernellabs.com> wrote:
> > On Fri, Aug 21, 2009 at 2:07 AM, Mauro Carvalho
> > Chehab<mchehab@infradead.org> wrote:
> >> In brief, while I want to fix the driver issues, I recommend to avoid
> >> buying any devices with tm5600/tm6000/tm6010 (and DRX demod) chips. There are
> >> other offers at the market with drivers that work properly, including some
> >> nice HVR devices that are fully supported.
> >
> > The more I think about it, the more I think we should setup something
> > along the lines of a "Wall of Shame" on the LinuxTV wiki, so that
> > people will be better informed exactly which products they should not
> > buy because of the chipset vendor's behavior.
> 
> I doubt that this will help, it will moreover scare them off and also
> put a bad light on Linux we already have a list of supported devices
> on linuxtv.org if people buy the wrong devices it's their fault in the
> end.
> 
> Better support the available devices properly so that everyone can
> easily use them... "everyone" is the highest burden at this time...

I sort of agree with you both. From one side, IMO, it is very badly documented,
currently, what are the manufacturers that helps the project, and on what
level, and what are the ones that refuses to help.

On the other hand, just blaming the manufacturer won't solve. There are even
some cases where the rights for certain parts of their hardware belongs to a
third party, so, even if they want to help, maybe they can't on some cases.
Unfortunately, I've seen some cases where the hardware and binary distribution
rights were transferred from one company to the other, but, apparently, the
source code and/or development datasheet rights were not transferred.

Maybe we could create a search engine at linuxtv with the info we have about
each board, that could report some specific troubles we're having with some
board/vendor info, reporting also if the vendor helped with some driver.



Cheers,
Mauro
