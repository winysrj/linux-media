Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:43568 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762939AbZCQJcI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2009 05:32:08 -0400
Date: Tue, 17 Mar 2009 10:31:42 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: bttv, tvaudio and ir-kbd-i2c probing conflict
Message-ID: <20090317103142.51fe0c46@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.58.0903161533090.28292@shell2.speakeasy.net>
References: <200903151344.01730.hverkuil@xs4all.nl>
	<20090315181207.36d951ac@hyperion.delvare>
	<Pine.LNX.4.58.0903151038210.28292@shell2.speakeasy.net>
	<20090315185313.4c15702c@hyperion.delvare>
	<20090316063402.1b0da1f3@gaivota.chehab.org>
	<20090316121801.1c03d747@hyperion.delvare>
	<20090316095237.21775418@gaivota.chehab.org>
	<20090316152802.7492dd20@hyperion.delvare>
	<Pine.LNX.4.58.0903161202330.28292@shell2.speakeasy.net>
	<20090316224040.7672176a@hyperion.delvare>
	<Pine.LNX.4.58.0903161533090.28292@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Trent,

On Mon, 16 Mar 2009 15:47:17 -0700 (PDT), Trent Piepho wrote:
> On Mon, 16 Mar 2009, Jean Delvare wrote:
> > You are unfair. The pull request came with a short log of all the
> > changes.
> 
> "short" log.  His entire series was decribed with fewer words than I would
> use on a single patch that changes ten lines.

In general I tend to like detailed patch logs as much as you do. But in
this case Hans is doing almost all the work by himself and it is very
needed, and the faster completed, the better. So I am really to trade
log details for a faster conversion.

> > (...)
> > I am not familiar enough with this part of the code to say. But I guess
> > it doesn't really matter, as it wasn't my point anyway.
> 
> It seems like your point was that conversions to v4l2_subdev allow drivers
> to be more efficient remove lots of code.  The numbers I see just don't
> support that claim.

No, sorry if I didn't make it clear, but that wasn't my point. My point
was only about the change in i2c binding model. This change clearly
results in a net shrink as far as lines of code are concerned.

This doesn't have much to do with the v4l2_subdev conversion Hans is
doing in parallel (other than the fact that the former may make the
later easier, but I'm not even sure.)

-- 
Jean Delvare
