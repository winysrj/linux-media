Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60981 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbZA2JTE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 04:19:04 -0500
Date: Thu, 29 Jan 2009 07:18:29 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Roel Kluin <roel.kluin@gmail.com>, linux-media@vger.kernel.org,
	Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: [PATCH] Bttv: move check on unsigned
Message-ID: <20090129071829.78e87158@caramujo.chehab.org>
In-Reply-To: <Pine.LNX.4.58.0901241718090.17971@shell2.speakeasy.net>
References: <497250C7.6030502@gmail.com>
	<Pine.LNX.4.58.0901191020460.11165@shell2.speakeasy.net>
	<Pine.LNX.4.58.0901241718090.17971@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 24 Jan 2009 17:27:09 -0800 (PST)
Trent Piepho <xyzzy@speakeasy.org> wrote:

> On Mon, 19 Jan 2009, Trent Piepho wrote:
> > On Sat, 17 Jan 2009, Roel Kluin wrote:
> > > Please review, this patch was not tested.
> > >
> > > The static function set_tvnorm is called in
> > > drivers/media/video/bt8xx/bttv-driver.c:
> > >
> > > 1355:   set_tvnorm(btv, norm);
> > > 1868:   set_tvnorm(btv, i);
> > > 3273:   set_tvnorm(btv,btv->tvnorm);
> > >
> > > in the first two with an unsigned, but bttv->tvnorm is signed.
> >
> > Probably better to just change bttv->tvnorm is unsigned if we can.
> 
> Here is an improved patch that does a full tvnorm fix for the driver.  The
> tvnorm value is an index into an array and is never allowed to be negative
> or otherwise invalid.  Most places it was passed around were unsigned, but
> a few structs and functions had signed values.
> 
> I got rid of the "< 0" checks and changed some ">= BTTV_TVNORMS" checks
> to BUG_ON().
> 
> Any problems with this patch Roel?
> 
> Mauro, don't apply as is, I'll send a pull request for a real patch later.

Ok.

Cheers,
Mauro
