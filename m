Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:44255 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752810AbcL0LRd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Dec 2016 06:17:33 -0500
Date: Tue, 27 Dec 2016 11:17:30 +0000
From: Sean Young <sean@mess.org>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] media: rc: refactor raw handler kthread
Message-ID: <20161227111729.GA3374@gofer.mess.org>
References: <f1b01f8c-934a-3bfe-ca1f-880b9c1ad233@gmail.com>
 <727717c2-8529-691f-282a-cb57c997c922@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <727717c2-8529-691f-282a-cb57c997c922@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 26, 2016 at 02:01:31PM +0100, Heiner Kallweit wrote:
> Am 02.08.2016 um 07:44 schrieb Heiner Kallweit:
> > I think we can get rid of the spinlock protecting the kthread from being
> > interrupted by a wakeup in certain parts.
> > Even with the current implementation of the kthread the only lost wakeup
> > scenario could happen if the wakeup occurs between the kfifo_len check
> > and setting the state to TASK_INTERRUPTIBLE.
> > 
> > In the changed version we could lose a wakeup if it occurs between
> > processing the fifo content and setting the state to TASK_INTERRUPTIBLE.
> > This scenario is covered by an additional check for available events in
> > the fifo and setting the state to TASK_RUNNING in this case.
> > 
> > In addition the changed version flushes the kfifo before ending
> > when the kthread is stopped.
> > 
> > With this patch we gain:
> > - Get rid of the spinlock
> > - Simplify code
> > - Don't grep / release the mutex for each individual event but just once
> >   for the complete fifo content. This reduces overhead if a driver e.g.
> >   triggers processing after writing the content of a hw fifo to the kfifo.
> > 
> > Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> Sean added a review comment and his "Tested-by" a month ago.
> Anything else missing before it can be applied?

I have it applied here:

https://git.linuxtv.org/syoung/media_tree.git/log/?h=for-v4.11a

I'll ask Mauro to pull that tree soon, now that 4.10-rc1 has been
merged. I need to do some testing.


Sean
