Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:55448 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbZFVXBo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 19:01:44 -0400
Date: Mon, 22 Jun 2009 16:01:45 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Andy Walls <awalls@radix.net>
cc: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org
Subject: Re: lsmod path hardcoded in v4l/Makefile
In-Reply-To: <1245710531.3190.7.camel@palomino.walls.org>
Message-ID: <Pine.LNX.4.58.0906221558510.6411@shell2.speakeasy.net>
References: <200906221636.25006.zzam@gentoo.org> <1245710531.3190.7.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 22 Jun 2009, Andy Walls wrote:
> On Mon, 2009-06-22 at 16:36 +0200, Matthias Schwarzott wrote:
> > Hi list!
> >
> > It seems the path to lsmod tool is hardcoded in the Makefile for out-of-tree
> > building of v4l-dvb.
> > Now at least gentoo has moved lsmod from /sbin to /bin.

Won't your patch cause breakage for everyone who hasn't moved lsmod from
/sbin and doesn't have sbin in the path?  Which was, and perhaps still is,
the most common situation?  It would be better to do something that does
not break things that used to work.

> > Additionally it is bad style (or at least I am told so), to not rely on $PATH
> > but hardcode pathes for tools that should be in $PATH.
>
> It's a potential security hole to rely on $PATH instead of absolute
> paths when running a command as root.
>
> Since many of the commnads in the Makefile rely on $PATH, including
> executions of 'install' which usually would be run as root, I suppose
> secuirty concerns don't matter.
>
> -Andy
>
> > So the attached patch removes the hardcoded /sbin from the lsmod call.
> >
> > Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> >
> > Regards
> > Matthias
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
