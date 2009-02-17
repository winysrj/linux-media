Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:39794 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbZBQAWb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 19:22:31 -0500
Date: Mon, 16 Feb 2009 16:22:27 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Steven Toth <stoth@linuxtv.org>
cc: linux-media@vger.kernel.org, e9hack <e9hack@googlemail.com>,
	linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [BUG] changeset 9029 (http://linuxtv.org/hg/v4l-dvb/rev/aa3e5cc1d833)
In-Reply-To: <4999BADF.6070106@linuxtv.org>
Message-ID: <Pine.LNX.4.58.0902161611300.24268@shell2.speakeasy.net>
References: <4986507C.1050609@googlemail.com> <200902151336.17202@orion.escape-edv.de>
 <Pine.LNX.4.58.0902160811340.24268@shell2.speakeasy.net>
 <20090216153148.6f2aa408@pedra.chehab.org> <4999BADF.6070106@linuxtv.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Feb 2009, Steven Toth wrote:
> > Hartmut, Oliver and Trent: Thanks for helping with this issue. I've just
> > reverted the changeset. We still need a fix at dm1105, au0828-dvb and maybe
> > other drivers that call the filtering routines inside IRQ's.
>
> Fix the demux, add a worker thread and allow drivers to call it directly.
>
> I'm not a big fan of videobuf_dvb or having each driver do it's own thing as an
> alternative.
>
> Fixing the demux... Would this require and extra buffer copy? probably, but it's
> a trade-off between  the amount of spent during code management on a driver by
> driver basis vs wrestling with videobuf_dvb and all of problems highlighted on
> the ML over the last 2 years.

Have the driver copy the data into the demuxer from the interrupt handler
with irqs disabled?  That's still too much.

The right way to do it is to have a queue of DMA buffers.  In the interrupt
handler the driver takes the completed DMA buffer off the "to DMA" queue
and puts it in the "to process" queue.  The driver should not copy and
cetainly not demux the data from the interrupt handler.
