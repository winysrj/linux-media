Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:55579 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbZBOOHo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2009 09:07:44 -0500
Subject: Re: [linux-dvb] [BUG] changeset 9029
 (http://linuxtv.org/hg/v4l-dvb/rev/aa3e5cc1d833)
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <200902151336.17202@orion.escape-edv.de>
References: <4986507C.1050609@googlemail.com>
	 <200902151336.17202@orion.escape-edv.de>
Content-Type: text/plain
Date: Sun, 15 Feb 2009 09:07:42 -0500
Message-Id: <1234706862.3181.7.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-02-15 at 13:36 +0100, Oliver Endriss wrote:
> e9hack wrote:
> > Hi,
> > 
> > this change set is wrong. The affected functions cannot be called from an interrupt
> > context, because they may process large buffers. In this case, interrupts are disabled for
> > a long time. Functions, like dvb_dmx_swfilter_packets(), could be called only from a
> > tasklet. This change set does hide some strong design bugs in dm1105.c and au0828-dvb.c.
> > 
> > Please revert this change set and do fix the bugs in dm1105.c and au0828-dvb.c (and other
> > files).

Does anyone have a complete list of the drivers that are the bad actors?
It would be nice to have some sense of the scope of the work to fix
them, and to know who might have hardware for testing.

Hartmut mentioned 2 current problem drivers.  I know cx18 was a problem,
but I fixed it months ago.  I can agree in every driver that does things
wrong, it is a design error.  Fixing design errors will not be a quick
fix for most drivers

Regards,
Andy

> @Mauro:
> 
> This changeset _must_ be reverted! It breaks all kernels since 2.6.27
> for applications which use DVB and require a low interrupt latency.
> 
> It is a very bad idea to call the demuxer to process data buffers with
> interrupts disabled!
> 
> FYI, a LIRC problem was reported here:
>   http://vdrportal.de/board/thread.php?postid=786366#post786366
> 
> and it has been verified that changeset
>   http://linuxtv.org/hg/v4l-dvb/rev/aa3e5cc1d833
> causes the problem:
>   http://vdrportal.de/board/thread.php?postid=791813#post791813
> 
> Please revert this changeset immediately and submit a fix to the stable
> kernels >= 2.6.27.
> 
> CU
> Oliver
> 

