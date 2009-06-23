Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:41410 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138AbZFWT3H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 15:29:07 -0400
Date: Tue, 23 Jun 2009 12:29:09 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Matthias Schwarzott <zzam@gentoo.org>
cc: linux-media@vger.kernel.org, Andy Walls <awalls@radix.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: lsmod path hardcoded in v4l/Makefile
In-Reply-To: <200906230950.26287.zzam@gentoo.org>
Message-ID: <Pine.LNX.4.58.0906231214360.6411@shell2.speakeasy.net>
References: <200906221636.25006.zzam@gentoo.org> <1245710531.3190.7.camel@palomino.walls.org>
 <200906230950.26287.zzam@gentoo.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 23 Jun 2009, Matthias Schwarzott wrote:
> > On Mon, 2009-06-22 at 16:36 +0200, Matthias Schwarzott wrote:
> > > It seems the path to lsmod tool is hardcoded in the Makefile for
> > > out-of-tree building of v4l-dvb.
> >
> Shouldn't $PATH of root be considered safe? Else the distro or the system

I believe make will set the variable whenever the makefile is used, even
when building as non-root.

It turns out that it was just lsmod with no path originally, but Michael
Krufky changed it back in 2005 (commit b0e7b40744ef) to have a hardcoded
path.  Then later in commit c91e7f84a1d6 the only use of 'v4l_modules' was
deleted, so we can just delete this line and not worry about sbin and
paths.

Mauro,

Please pull from http://linuxtv.org/hg/~tap/fix

for the following changeset:

build: Remove module list cruft
http://linuxtv.org/hg/~tap/fix?cmd=changeset;node=fb228bb1ad9f
