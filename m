Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:35422 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZGUHOp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 03:14:45 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: lsmod path hardcoded in v4l/Makefile
Date: Tue, 21 Jul 2009 09:14:36 +0200
Cc: linux-media@vger.kernel.org, Trent Piepho <xyzzy@speakeasy.org>,
	Andy Walls <awalls@radix.net>
References: <200906221636.25006.zzam@gentoo.org> <200906230950.26287.zzam@gentoo.org> <Pine.LNX.4.58.0906231214360.6411@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0906231214360.6411@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907210914.37819.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Dienstag, 23. Juni 2009, Trent Piepho wrote:
> On Tue, 23 Jun 2009, Matthias Schwarzott wrote:
> > > On Mon, 2009-06-22 at 16:36 +0200, Matthias Schwarzott wrote:
> > > > It seems the path to lsmod tool is hardcoded in the Makefile for
> > > > out-of-tree building of v4l-dvb.
> >
> > Shouldn't $PATH of root be considered safe? Else the distro or the system
>
> I believe make will set the variable whenever the makefile is used, even
> when building as non-root.
>
> It turns out that it was just lsmod with no path originally, but Michael
> Krufky changed it back in 2005 (commit b0e7b40744ef) to have a hardcoded
> path.  Then later in commit c91e7f84a1d6 the only use of 'v4l_modules' was
> deleted, so we can just delete this line and not worry about sbin and
> paths.
>
> Mauro,
>
> Please pull from http://linuxtv.org/hg/~tap/fix
>
> for the following changeset:
>
> build: Remove module list cruft
> http://linuxtv.org/hg/~tap/fix?cmd=changeset;node=fb228bb1ad9f

Hi Mauro!

is there any reason to not pull this besides time?

Regards
Matthias
