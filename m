Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:15238 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaKCQtv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Nov 2014 11:49:51 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NEH00MHW2R1DT60@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 03 Nov 2014 11:49:49 -0500 (EST)
Date: Mon, 03 Nov 2014 14:49:45 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: Sean Young <sean@mess.org>, Martin Kittel <linux@martin-kittel.de>,
	linux-media@vger.kernel.org
Subject: Re: Patch mceusb: fix invalid urb interval
Message-id: <20141103144945.00288499.m.chehab@samsung.com>
In-reply-to: <20140120173625.GA18257@redhat.com>
References: <loom.20131110T113621-661@post.gmane.org>
 <20131211131751.GA434@pequod.mess.org> <l8ai94$cbr$1@ger.gmane.org>
 <20140115134917.1450f87c@samsung.com> <20140115165245.GA23620@pequod.mess.org>
 <20140115155923.0b8978da.m.chehab@samsung.com>
 <52DC3E0B.6010202@martin-kittel.de> <20140119215648.GA15388@pequod.mess.org>
 <20140120173625.GA18257@redhat.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 20 Jan 2014 12:36:26 -0500
Jarod Wilson <jarod@redhat.com> escreveu:

> On Sun, Jan 19, 2014 at 09:56:48PM +0000, Sean Young wrote:
> > On Sun, Jan 19, 2014 at 10:05:15PM +0100, Martin Kittel wrote:
> > > Hi Mauro, hi Sean,
> ...
> > > >From a71676dad29adef9cafb08598e693ec308ba2e95 Mon Sep 17 00:00:00 2001
> > > From: Martin Kittel <linux@martin-kittel.de>
> > > Date: Sun, 19 Jan 2014 21:24:55 +0100
> > > Subject: [PATCH] mceusb: use endpoint xfer mode as advertised
> > > 
> > > mceusb always sets endpoints to interrupt transfer mode no matter
> > > what the device itself is advertising. This causes trouble on xhci
> > > hubs. This patch changes the behavior to honor the device endpoint
> > > settings.
> > 
> > This patch is wrong. I get:
> > 
> > [   60.962727] ------------[ cut here ]------------
> > [   60.962729] WARNING: CPU: 0 PID: 0 at drivers/usb/core/urb.c:452 usb_submit_u
> > rb+0x1fd/0x5b0()
> > [   60.962730] usb 3-2: BOGUS urb xfer, pipe 1 != type 3
> > 
> > This is because the patch no longer sets the endpoints to interrupt
> > endpoints, but still uses the interrupt functions like
> > usb_fill_int_urb().
> 
> Crap, I sent a working patch to everyone a few days ago, but from a new
> host that didn't have relay stuff set up yet, so I don't think anyone got
> the message. Oops... I'll try to dig it back up. Its a quick fix, but its
> tested as fully functional on multiple devices here, including a mix of
> ones that claim bulk and interrupt, ones with no bInterval, ones with
> different non-0 bIntervals, etc.

Hi All,

This is still pending on my queue. Any news?

Regards,
Mauro
