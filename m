Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52607 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbcGMJjO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 05:39:14 -0400
Date: Wed, 13 Jul 2016 11:38:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Tejun Heo <tj@kernel.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH 2/9] async: Introduce kfence, a N:M completion mechanism
Message-ID: <20160713093852.GZ30921@twins.programming.kicks-ass.net>
References: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
 <1466759333-4703-3-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1466759333-4703-3-git-send-email-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 24, 2016 at 10:08:46AM +0100, Chris Wilson wrote:
> diff --git a/kernel/async.c b/kernel/async.c
> index d2edd6efec56..d0bcb7cc4884 100644
> --- a/kernel/async.c
> +++ b/kernel/async.c
> @@ -50,6 +50,7 @@ asynchronous and synchronous parts of the kernel.
>  
>  #include <linux/async.h>
>  #include <linux/atomic.h>
> +#include <linux/kfence.h>
>  #include <linux/ktime.h>
>  #include <linux/export.h>
>  #include <linux/wait.h>

So why does this live in async.c? It got its own header, why not also
give it its own .c file?

Also, I'm not a particular fan of the k* naming, but I see 'fence' is
already taken.

> +/**
> + * DOC: kfence overview
> + *
> + * kfences provide synchronisation barriers between multiple processes.
> + * They are very similar to completions, or a pthread_barrier. Where
> + * kfence differs from completions is their ability to track multiple
> + * event sources rather than being a singular "completion event". Similar
> + * to completions, multiple processes or other kfences can listen or wait
> + * upon a kfence to signal its completion.
> + *
> + * The kfence is a one-shot flag, signaling that work has progressed passed
> + * a certain point (as measured by completion of all events the kfence is
> + * listening for) and the waiters upon kfence may proceed.
> + *
> + * kfences provide both signaling and waiting routines:
> + *
> + *	kfence_pending()
> + *
> + * indicates that the kfence should itself wait for another signal. A
> + * kfence created by kfence_create() starts in the pending state.

I would much prefer:

 *  - kfence_pending(): indicates that the kfence should itself wait for
 *    another signal. A kfence created by kfence_create() starts in the
 *    pending state.

Which is much clearer in what text belongs where.

Also, what !? I don't get what this function does.

> + *
> + *	kfence_signal()
> + *
> + * undoes the earlier pending notification and allows the fence to complete
> + * if all pending events have then been signaled.

So I know _signal() is the posix thing, but seeing how we already
completions, how about being consistent with those and use _complete()
for this?

> + *
> + *	kfence_wait()
> + *
> + * allows the caller to sleep (uninterruptibly) until the fence is complete.

whitespace to separate the description of kfence_wait() from whatever
else follows.

> + * Meanwhile,
> + *
> + * 	kfence_complete()
> + *
> + * reports whether or not the kfence has been passed.

kfence_done(), again to match completions.

> + *
> + * This interface is very similar to completions, with the exception of
> + * allowing multiple pending / signals to be sent before the kfence is
> + * complete.
> + *
> + *	kfence_add() / kfence_add_completion()
> + *
> + * sets the kfence to wait upon another fence, or completion respectively.
> + *
> + * Unlike completions, kfences are expected to live inside more complex graphs
> + * and form the basis for parallel execution of interdependent and so are
> + * reference counted. A kfence may be created using,
> + *
> + * 	kfence_create()
> + *
> + * The fence starts off pending a single signal. Once you have finished
> + * setting up the fence, use kfence_signal() to allow it to wait upon
> + * its event sources.
> + *
> + * Use
> + *
> + *	kfence_get() / kfence_put
> + *
> + * to acquire or release a reference on kfence respectively.
> + */
