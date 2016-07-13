Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43579 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbcGMKcZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 06:32:25 -0400
Date: Wed, 13 Jul 2016 12:31:37 +0200
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
Subject: Re: [PATCH 3/9] async: Extend kfence to allow struct embedding
Message-ID: <20160713103137.GB30921@twins.programming.kicks-ass.net>
References: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
 <1466759333-4703-4-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1466759333-4703-4-git-send-email-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 24, 2016 at 10:08:47AM +0100, Chris Wilson wrote:
> @@ -151,7 +161,11 @@ static void kfence_free(struct kref *kref)
>  
>  	WARN_ON(atomic_read(&fence->pending) > 0);
>  
> -	kfree(fence);
> +	if (fence->flags) {
> +		kfence_notify_t fn = (kfence_notify_t)fence->flags;

Maybe provide an inline helper for that conversion and also mask out the
low bits, just to be careful. You're assuming they're not set here,
which seems like a dangerous thing.

> +		fn(fence);
> +	} else
> +		kfree(fence);

Also Codingstyle wants braces on both branches if its on one.

