Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:35038 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbZDEQiI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2009 12:38:08 -0400
Date: Sun, 5 Apr 2009 18:37:43 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Janne Grunau <j@jannau.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Mike Isely <isely@pobox.com>,
	isely@isely.net, LMML <linux-media@vger.kernel.org>,
	Andy Walls <awalls@radix.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
  model
Message-ID: <20090405183743.5a239008@hyperion.delvare>
In-Reply-To: <20090405143748.GC10556@aniel>
References: <20090404142427.6e81f316@hyperion.delvare>
	<Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
	<20090405010539.187e6268@hyperion.delvare>
	<200904050746.47451.hverkuil@xs4all.nl>
	<20090405143748.GC10556@aniel>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Janne,

On Sun, 5 Apr 2009 16:37:49 +0200, Janne Grunau wrote:
> On Sun, Apr 05, 2009 at 07:46:47AM +0200, Hans Verkuil wrote:
> >
> > Let's keep it simple: add a 'load_ir_kbd_i2c' module option for those 
> > drivers that did not autoload this module. The driver author can refine 
> > things later (I'll definitely will do that for ivtv).
> > 
> > It will be interesting if someone can find out whether lirc will work at all 
> > once autoprobing is removed from i2c. If it isn't, then perhaps that will 
> > wake them up to the realization that they really need to move to the 
> > kernel.
> 
> I would guess that it won't work. There is an effort to merge lirc. It's
> currently stalled though. A git tree is available at
> 
> git://git.wilsonet.com/linux-2.6-lirc.git

I tried to clone this but it failed:

git.wilsonet.com[0: 72.93.233.4]: errno=Connection timed out
fatal: unable to connect a socket (Connection timed out)

> Jared Wilson and I were working on it (mainly last september). Since the
> IR on the HD PVR is also driven by the same zilog chip as on other
> hauppauge devices I'll take of lirc_zilog. Help converting the i2c
> drivers to the new i2c model is welcome. General cleanup of lirc to make
> it ready for mainline is of course wellcome too.

I will happily help you with the i2c side of things. Without an access
to your git tree however, I don't know the latest state of your code.
And I can't see any lirc_zilog module in the CVS repository of lirc
either. But if you show me the i2c code you're worried about, I'll let
you know what I think about it.

-- 
Jean Delvare
