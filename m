Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:49482 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbZFWIYQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 04:24:16 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Subject: Re: lsmod path hardcoded in v4l/Makefile
Date: Tue, 23 Jun 2009 10:24:13 +0200
Cc: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	Andy Walls <awalls@radix.net>
References: <200906221636.25006.zzam@gentoo.org> <1245710531.3190.7.camel@palomino.walls.org> <alpine.LNX.2.00.0906221833160.24027@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0906221833160.24027@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906231024.14033.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Dienstag, 23. Juni 2009, Theodore Kilgore wrote:
> On Mon, 22 Jun 2009, Andy Walls wrote:
> > On Mon, 2009-06-22 at 16:36 +0200, Matthias Schwarzott wrote:
> >> Hi list!
> >>
> >> It seems the path to lsmod tool is hardcoded in the Makefile for
> >> out-of-tree building of v4l-dvb.
> >> Now at least gentoo has moved lsmod from /sbin to /bin.
>
> Sorry, but is it considered impertinent to ask why that lsmod should be
> moved from /sbin (system binaries, and lsmod certainly is one of those)
> and stick it into /bin instead? Is there any cogent reason for doing a

/sbin are binaries that only root should use. But lsmod can be used by users, 
too.
Suse also has only /bin/lsmod I think.
I don't know too much about the reason for the move, but it was long ago - 
version 0.9.11 contained that move and was released around year 2003.
Gentoo ebuild added /sbin/lsmod as compat symlink for things still hardcoding 
the path, but that was removed 2009 - 6 years should be enough.

> thing like that, which may have escaped my attention? Unless one is making
> some very small distro for some very small hardware and (say) one of /bin
> and /sbin is symlinked to the other, I find a change like that to be
> extremely puzzling. So, really. Why?
For a real answer to "why", do ask module-init-tools maintainer.

Regards
Matthias
