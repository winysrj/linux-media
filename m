Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:20734 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753329Ab1AOVqs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 16:46:48 -0500
Subject: Re: [PATCH] hdpvr: enable IR part
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Jean Delvare <khali@linux-fr.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janne Grunau <j@jannau.net>, Jarod Wilson <jarod@redhat.com>
In-Reply-To: <0EADA025-77B0-4E8B-A649-F3BE6F2E437B@wilsonet.com>
References: <20110114195448.GA9849@redhat.com>
	 <1295041480.2459.9.camel@localhost> <20110114220759.GG9849@redhat.com>
	 <661A728F-3CF1-47F3-A650-D17429AF7DF1@wilsonet.com>
	 <1295066141.2459.34.camel@localhost>
	 <0EADA025-77B0-4E8B-A649-F3BE6F2E437B@wilsonet.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 Jan 2011 16:46:18 -0500
Message-ID: <1295127978.7147.4.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2011-01-15 at 00:37 -0500, Jarod Wilson wrote:
> On Jan 14, 2011, at 11:35 PM, Andy Walls wrote:

> Receive with lirc_zilog does actually work slightly better, though its still
> not perfect. Each key press (using irw to watch) always results in at least
> two lines of output, both with sequence number 00 (i.e., two distinct events),
> and holding a button down results in a stream of 00 events. So repeat is
> obviously busted. But I don't see the wackiness that is happening w/ir-kbd-i2c.
> 
> Oh, and transmit works too. So this patch and the buffer alloc patch have now
> been formally tested. Unless we go the custom get_key() route inside the hdpvr
> driver, I think the rest of the legwork to make the hdpvr's IR part behave is
> within lirc_zilog and ir-kbd-i2c (both of which I need to spend some more
> time reading over).
> 
> 
> > BTW, a checkpatch and compiler tested lirc_zilog.c is here:
> > 
> > http://git.linuxtv.org/awalls/media_tree.git?a=shortlog;h=refs/heads/z8
> > 
> > It should fix all the binding and allocation problems related to
> > ir_probe()/ir_remove().  Except I suspect it may leak the Rx poll
> > kthread.  That's possibly another bug to add to the list.
> > 
> > Anyway, $DIETY knows if the lirc_zilog module actually still works after
> > all my hacks.  Give it a test if you are adventurous.  I won't be able
> > to test until tomorrow evening.
> 
> I'll try to grab those and give them a test tomorrow, and hey, I've even got
> a baseline to test against now.

I have now confirmed that with all the above patches to lirc_zilog, both
Tx and Rx using an HVR-1600 work.

Time to start cleaning up the less important things I noticed...

Regards,
Andy


