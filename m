Return-path: <linux-media-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51148 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755393Ab2IQUgU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 16:36:20 -0400
Date: Mon, 17 Sep 2012 13:28:50 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: Colin Cross <ccross@google.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
	Andy Walls <awalls@md.metrocast.net>,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
	Grant Likely <grant.likely@secretlab.ca>,
	spi-devel-general@lists.sourceforge.net,
	Linus Torvalds <torvalds@linux-foundation.org>,
	stable@vger.kernel.org
Subject: Re: [PATCHSET] kthread_worker: reimplement flush_kthread_work() to
 allow freeing during execution
Message-ID: <20120917202850.GA18910@kroah.com>
References: <20120719211510.GA32763@google.com>
 <CAMbhsRQs+2MCXq0M-eTeezwPR=KMnBKtJny1rjiUJL-wNYctMQ@mail.gmail.com>
 <20120917194016.GI18677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917194016.GI18677@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 17, 2012 at 12:40:16PM -0700, Tejun Heo wrote:
> On Fri, Sep 14, 2012 at 03:50:40PM -0700, Colin Cross wrote:
> > This patch set fixes a reproducible crash I'm seeing on a 3.4.10
> > kernel.  flush_kthread_worker (which is different from
> > flush_kthread_work) is initializing a kthread_work and a completion on
> > the stack, then queuing it and calling wait_for_completion.  Once the
> > completion is signaled, flush_kthread_worker exits and the stack
> > region used by the kthread_work may be immediately reused by another
> > object on the stack, but kthread_worker_fn continues accessing its
> > work pointer:
> >                 work->func(work);         <- calls complete,
> > effectively frees work
> >                 smp_wmb();      /* wmb worker-b0 paired with flush-b1 */
> >                 work->done_seq = work->queue_seq;   <- overwrites a
> > new stack object
> >                 smp_mb();       /* mb worker-b1 paired with flush-b0 */
> >                 if (atomic_read(&work->flushing))
> >                         wake_up_all(&work->done);  <- or crashes here
> > 
> > These patches fix the problem by not accessing work after work->func
> > is called, and should be backported to stable.  They apply cleanly to
> > 3.4.10.  Upstream commits are 9a2e03d8ed518a61154f18d83d6466628e519f94
> > and 46f3d976213452350f9d10b0c2780c2681f7075b.
> 
> Yeah, you're right.  I wonder why this didn't come up before.  Greg,
> can you please pick up these two commits?

Ok, will do, thanks for letting me know.

greg k-h
