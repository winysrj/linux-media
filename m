Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:56604 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbZFVWmd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 18:42:33 -0400
Subject: Re: lsmod path hardcoded in v4l/Makefile
From: Andy Walls <awalls@radix.net>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200906221636.25006.zzam@gentoo.org>
References: <200906221636.25006.zzam@gentoo.org>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 18:42:11 -0400
Message-Id: <1245710531.3190.7.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-06-22 at 16:36 +0200, Matthias Schwarzott wrote:
> Hi list!
> 
> It seems the path to lsmod tool is hardcoded in the Makefile for out-of-tree 
> building of v4l-dvb.
> Now at least gentoo has moved lsmod from /sbin to /bin.
> Additionally it is bad style (or at least I am told so), to not rely on $PATH 
> but hardcode pathes for tools that should be in $PATH.

It's a potential security hole to rely on $PATH instead of absolute
paths when running a command as root.

Since many of the commnads in the Makefile rely on $PATH, including
executions of 'install' which usually would be run as root, I suppose
secuirty concerns don't matter.

-Andy

> So the attached patch removes the hardcoded /sbin from the lsmod call.
> 
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> 
> Regards
> Matthias

