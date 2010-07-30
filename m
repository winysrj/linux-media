Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:41240 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758288Ab0G3CDM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 22:03:12 -0400
Subject: Re: [PATCH 0/9 v2] IR: few fixes, additions and ENE driver
From: Andy Walls <awalls@md.metrocast.net>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: maximlevitsky@gmail.com, jarod@wilsonet.com,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, mchehab@redhat.com
In-Reply-To: <BTlN5mEJjFB@christoph>
References: <BTlN5mEJjFB@christoph>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 22:03:30 -0400
Message-ID: <1280455410.15737.58.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-07-29 at 19:15 +0200, Christoph Bartelmus wrote:
> on 29 Jul 10 at 19:26, Maxim Levitsky wrote:
> > On Thu, 2010-07-29 at 11:38 -0400, Andy Walls wrote:
> >> On Thu, 2010-07-29 at 17:41 +0300, Maxim Levitsky wrote:
> >>> On Thu, 2010-07-29 at 09:23 +0200, Christoph Bartelmus wrote:

Hi Christoph, Mauro, and Jarrod

> When timeout reports are enabled the sequence must be:
> <pulse> <timeout> <space> <pulse>
> where <timeout> is optional.

OK.  This is some of the detail I needed.

I'm looking at the master branch of Jarrod's wip git repo, but:


1. I don't see how a timeout report is going to make it through 

	drivers/media/IR/ir-lirc-codec.c:lir_lirc_decode()

I guess I'll have to add a "flags" field (or something) to 

	include/media/ir_core.h:struct ir_raw_event

to modify the events beyond just mark or space reports.

Mauro, do you have any preferences or comments here?



2. The in-kernel decoders normally need a the final space to close out
the decoding, so the above sequence will cause them to wait.  It would
only really be noticiable if no repeat came from the remote, but it
still would be annoying.

If I send a space for the timeout to get the in kernel decoders to close
out decoding, then I end up sending a double space out to LIRC, which I
just read will confuse LIRC.  

So...

If I'm going to add a timeout event flag to struct ir_raw_event, I
suppose we could either:

	a. have the current in kernel decoders interpret an
	   ir_raw_event with a timeout event as a cue to conclude
           decoding the current pulse train

	b. add a "finish decode" flag and have the in kernel decoders
	   respond to that.

I beleive this will also let the in-kernel decoders still respond to
final space as they currently do.

Objections? comments?


3.  When my hardware times out, it stops measuring anything, until it
sees a new edge.  For short timeout settings (smaller than the
intertransmission gap), I will have generate a space in software to
provide the length of the gap.

I'll have to store the time of reading the timeout flag of the hardware
Rx FIFO, compute an approximate gap length when the next mark
measurement comes in, and insert a the space.  The gaps space time will
only be approximate, as the Rx FIFO watermark is set to interrupt at 4
measurements in the FIFO.



If I can't do #1 & #2 above, I'm not sure how I can send any in band
signaling out to user space.

Regards,
Andy

> lircd will not work when you leave out the space. It must know the exact  
> time between the pulses. Some hardware generates timeout reports that are  
> too short to distinguish between spaces that are so short that the next  
> sequence can be interpreted as a repeat or longer spaces which indicate  
> that this is a new key press.
> 
> Christoph


