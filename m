Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:43092 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbZBBDif (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Feb 2009 22:38:35 -0500
Subject: Re: [BUG] changeset 9029
 (http://linuxtv.org/hg/v4l-dvb/rev/aa3e5cc1d833)
From: Andy Walls <awalls@radix.net>
To: e9hack <e9hack@googlemail.com>
Cc: linux-media@vger.kernel.org, obi@linuxtv.org, mchehab@redhat.com
In-Reply-To: <4986507C.1050609@googlemail.com>
References: <4986507C.1050609@googlemail.com>
Content-Type: text/plain
Date: Sun, 01 Feb 2009 22:38:05 -0500
Message-Id: <1233545885.3091.77.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-02-02 at 02:46 +0100, e9hack wrote:
> Hi,
> 
> this change set is wrong. The affected functions cannot be called from an interrupt
> context, because they may process large buffers. In this case, interrupts are disabled for
> a long time. Functions, like dvb_dmx_swfilter_packets(), could be called only from a
> tasklet. 

I agree with Hartmut that these functions should not be called from an
interrupt context.

Although for deferrable work, I thought tasklets were deprecated and
that work handlers were the preferred mechanism:
http://lwn.net/Articles/23634/


> This change set does hide some strong design bugs in dm1105.c and au0828-dvb.c.
> 
> Please revert this change set and do fix the bugs in dm1105.c and au0828-dvb.c (and other
> files).

BTW dm1105.c does use a tasklet for IR keypresses.  However, since it is
only imlemented with one "struct infrared", and hence only one
"ir_command", per device and not a queue, it is possible to lose button
presses that happen very close together.  That probably doesn't matter
practically for IR button presses, but the same strategy cannot be used
for TS packets.

Regards,
Andy


> Regards,
> Hartmut

