Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:33425 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbZH0EEc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 00:04:32 -0400
Date: Wed, 26 Aug 2009 21:04:33 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Andy Walls <awalls@radix.net>
cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Can ir polling be turned off in cx88 module for
 Leadtek 1000DTV card?
In-Reply-To: <1251329402.5232.6.camel@palomino.walls.org>
Message-ID: <Pine.LNX.4.58.0908262102280.11911@shell2.speakeasy.net>
References: <357341.28380.qm@web112510.mail.gq1.yahoo.com>
 <1251329402.5232.6.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 26 Aug 2009, Andy Walls wrote:
> On Wed, 2009-08-26 at 07:33 -0700, Dalton Harvie wrote:
> >   If there isn't, would it be a good idea?
>
> Maybe.
>
> > Thanks for any help.
>
>
> Try this.  It adds a module option "noir" that accepts an array of
> int's.  For a 0, that card's IR is set up as normal; for a 1, that
> card's IR is not initialized.
>
> 	# modprobe cx88 noir=1,1

I think this is a good idea.  I was going to do someting similar
to stop the excessive irqs from my cx88 cards, which don't
even have remote receivers.

I haven't tried, but maybe it is possible to only turn on polling when the
event device is opened.
