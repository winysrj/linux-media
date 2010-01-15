Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758112Ab0AOTr1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 14:47:27 -0500
Message-ID: <4B50C639.7070402@redhat.com>
Date: Fri, 15 Jan 2010 17:47:05 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: Fix for breakage caused by kfifo backport
References: <1263556855.3059.10.camel@palomino.walls.org>
In-Reply-To: <1263556855.3059.10.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> Mauro,
> 
> At 
> 
> http://linuxtv.org/hg/~awalls/cx23885-ir2
> 
> I have a change checked in to fix the v4l-dvb compilation breakage for
> kernels less than 2.6.33 cause by the kfifo API change.  I have fixed
> both the cx23885 and meye driver so they compile again for older
> kernels.

As patches that do backports aren't applied upstream, they can't change any
line at the upstream code. However, your patch is changing two comments:

+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 33)
+		kfifo_reset(state->rx_kfifo);
+#else
 		unsigned long flags;
 
 		spin_lock_irqsave(&state->rx_kfifo_lock, flags);
 		kfifo_reset(&state->rx_kfifo);
-		/* reset tx_fifo too if there is one... */
 		spin_unlock_irqrestore(&state->rx_kfifo_lock, flags);
+#endif

@@ -977,6 +1000,7 @@
 	o->interrupt_enable = p->interrupt_enable;
 	o->enable = p->enable;
 	if (p->enable) {
+		/* reset tx_fifo here */
 		if (p->interrupt_enable)
 			irqenable_tx(dev, IRQEN_TSE);
 		control_tx_enable(dev, p->enable);
@@ -1256,8 +1280,15 @@


This means that upstream and your -hg will be different. Please, don't do that.
If you want to touch on comments or at the upstream code, please send a separate
patch.

> 
> All the changes in this repo are OK to PULL as is, even though I haven't
> finished all the changes for the TeVii S470 IR  (I was planning on a
> PULL request late this evening EST).  You can also just cherry pick the
> one that fixes the kfifo problem if you want.

Yet, the series contains that issue I've already pointed:
+struct cx23885_ir_input {
...
+       char                    name[48];
+       char                    phys[48];

> 
> [I was unaware of the timing of the backport, but since it was stopping
> me from working, I fixed it as I thought appropriate.  Please feel free
> to contact me on any backport changes that have my fingerprints all over
> it, with which you would like help.  I'd like to help minimize the
> impact to users, testers, and developers, who may not have the bleeding
> edge kernel - or at least the impact to me ;) ]

I do the backports when I'm about to prepare patches to submit upstream, generally
after doing a large patch merge.

That's said, maintainng both upstream and the backports are consuming a lot
of my time. I'll probably pass the task of keeping the -hg tree with the
backports to somebody else receiving and applying patches directly on my
-git tree.

Douglas already offered to do it, so I'll likely pass him the task to maintain
the -hg tree soon. Then, all patches there will be simply a backport of what
we'll have on -git.

Cheers,
Mauro.
