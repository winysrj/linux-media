Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaATRgc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 12:36:32 -0500
Date: Mon, 20 Jan 2014 12:36:26 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Sean Young <sean@mess.org>
Cc: Martin Kittel <linux@martin-kittel.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: Patch mceusb: fix invalid urb interval
Message-ID: <20140120173625.GA18257@redhat.com>
References: <loom.20131110T113621-661@post.gmane.org>
 <20131211131751.GA434@pequod.mess.org>
 <l8ai94$cbr$1@ger.gmane.org>
 <20140115134917.1450f87c@samsung.com>
 <20140115165245.GA23620@pequod.mess.org>
 <20140115155923.0b8978da.m.chehab@samsung.com>
 <52DC3E0B.6010202@martin-kittel.de>
 <20140119215648.GA15388@pequod.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140119215648.GA15388@pequod.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 19, 2014 at 09:56:48PM +0000, Sean Young wrote:
> On Sun, Jan 19, 2014 at 10:05:15PM +0100, Martin Kittel wrote:
> > Hi Mauro, hi Sean,
...
> > >From a71676dad29adef9cafb08598e693ec308ba2e95 Mon Sep 17 00:00:00 2001
> > From: Martin Kittel <linux@martin-kittel.de>
> > Date: Sun, 19 Jan 2014 21:24:55 +0100
> > Subject: [PATCH] mceusb: use endpoint xfer mode as advertised
> > 
> > mceusb always sets endpoints to interrupt transfer mode no matter
> > what the device itself is advertising. This causes trouble on xhci
> > hubs. This patch changes the behavior to honor the device endpoint
> > settings.
> 
> This patch is wrong. I get:
> 
> [   60.962727] ------------[ cut here ]------------
> [   60.962729] WARNING: CPU: 0 PID: 0 at drivers/usb/core/urb.c:452 usb_submit_u
> rb+0x1fd/0x5b0()
> [   60.962730] usb 3-2: BOGUS urb xfer, pipe 1 != type 3
> 
> This is because the patch no longer sets the endpoints to interrupt
> endpoints, but still uses the interrupt functions like
> usb_fill_int_urb().

Crap, I sent a working patch to everyone a few days ago, but from a new
host that didn't have relay stuff set up yet, so I don't think anyone got
the message. Oops... I'll try to dig it back up. Its a quick fix, but its
tested as fully functional on multiple devices here, including a mix of
ones that claim bulk and interrupt, ones with no bInterval, ones with
different non-0 bIntervals, etc.

-- 
Jarod Wilson
jarod@redhat.com

