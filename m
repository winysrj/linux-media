Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:58164 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbZCQUXo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2009 16:23:44 -0400
Date: Tue, 17 Mar 2009 13:23:42 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: bttv, tvaudio and ir-kbd-i2c probing conflict
In-Reply-To: <20090317103142.51fe0c46@hyperion.delvare>
Message-ID: <Pine.LNX.4.58.0903171314350.28292@shell2.speakeasy.net>
References: <200903151344.01730.hverkuil@xs4all.nl> <20090315181207.36d951ac@hyperion.delvare>
 <Pine.LNX.4.58.0903151038210.28292@shell2.speakeasy.net>
 <20090315185313.4c15702c@hyperion.delvare> <20090316063402.1b0da1f3@gaivota.chehab.org>
 <20090316121801.1c03d747@hyperion.delvare> <20090316095237.21775418@gaivota.chehab.org>
 <20090316152802.7492dd20@hyperion.delvare> <Pine.LNX.4.58.0903161202330.28292@shell2.speakeasy.net>
 <20090316224040.7672176a@hyperion.delvare> <Pine.LNX.4.58.0903161533090.28292@shell2.speakeasy.net>
 <20090317103142.51fe0c46@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 17 Mar 2009, Jean Delvare wrote:
> On Mon, 16 Mar 2009 15:47:17 -0700 (PDT), Trent Piepho wrote:
> > On Mon, 16 Mar 2009, Jean Delvare wrote:
> > > You are unfair. The pull request came with a short log of all the
> > > changes.
> >
> > "short" log.  His entire series was decribed with fewer words than I would
> > use on a single patch that changes ten lines.
>
> In general I tend to like detailed patch logs as much as you do. But in
> this case Hans is doing almost all the work by himself and it is very
> needed, and the faster completed, the better. So I am really to trade
> log details for a faster conversion.

I guess that I don't consider documentation to be optional.

> > > (...)
> > > I am not familiar enough with this part of the code to say. But I guess
> > > it doesn't really matter, as it wasn't my point anyway.
> >
> > It seems like your point was that conversions to v4l2_subdev allow drivers
> > to be more efficient remove lots of code.  The numbers I see just don't
> > support that claim.
>
> No, sorry if I didn't make it clear, but that wasn't my point. My point
> was only about the change in i2c binding model. This change clearly
> results in a net shrink as far as lines of code are concerned.

Does it?  When we can use the model as it's designed, then I think it's
clearly much better.  But when one is emulating the detection behaviour,
like it appears the bttv patches do, I don't see what's better.
