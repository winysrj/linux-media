Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:43597 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbZFWHu3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 03:50:29 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Subject: Re: lsmod path hardcoded in v4l/Makefile
Date: Tue, 23 Jun 2009 09:50:26 +0200
Cc: Andy Walls <awalls@radix.net>
References: <200906221636.25006.zzam@gentoo.org> <1245710531.3190.7.camel@palomino.walls.org>
In-Reply-To: <1245710531.3190.7.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906230950.26287.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Dienstag, 23. Juni 2009, Andy Walls wrote:
> On Mon, 2009-06-22 at 16:36 +0200, Matthias Schwarzott wrote:
> > Hi list!
> >
> > It seems the path to lsmod tool is hardcoded in the Makefile for
> > out-of-tree building of v4l-dvb.
> > Now at least gentoo has moved lsmod from /sbin to /bin.
> > Additionally it is bad style (or at least I am told so), to not rely on
> > $PATH but hardcode pathes for tools that should be in $PATH.
>
> It's a potential security hole to rely on $PATH instead of absolute
> paths when running a command as root.

Shouldn't $PATH of root be considered safe? Else the distro or the system 
setup is doing something worse, and can't be improved by using fixed pathes 
in some scripts and Makefiles.

Regards
Matthias
