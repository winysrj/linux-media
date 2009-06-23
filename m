Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:46616 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbZFWHvt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 03:51:49 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Subject: Re: lsmod path hardcoded in v4l/Makefile
Date: Tue, 23 Jun 2009 09:51:48 +0200
Cc: Trent Piepho <xyzzy@speakeasy.org>, Andy Walls <awalls@radix.net>
References: <200906221636.25006.zzam@gentoo.org> <1245710531.3190.7.camel@palomino.walls.org> <Pine.LNX.4.58.0906221558510.6411@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0906221558510.6411@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906230951.48983.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Dienstag, 23. Juni 2009, Trent Piepho wrote:
> On Mon, 22 Jun 2009, Andy Walls wrote:
> > On Mon, 2009-06-22 at 16:36 +0200, Matthias Schwarzott wrote:
> > > Hi list!
> > >
> > > It seems the path to lsmod tool is hardcoded in the Makefile for
> > > out-of-tree building of v4l-dvb.
> > > Now at least gentoo has moved lsmod from /sbin to /bin.
>
> Won't your patch cause breakage for everyone who hasn't moved lsmod from
> /sbin and doesn't have sbin in the path?  Which was, and perhaps still is,
> the most common situation?  It would be better to do something that does
> not break things that used to work.

root without sbin in path is bad and broken, isn't it?
If you really think this is too common, we could add
PATH=/sbin:/bin:$PATH
at the start of the Makefile.

Regards
Matthias
