Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43601 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbcGMKdU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 06:33:20 -0400
Date: Wed, 13 Jul 2016 12:32:51 +0200
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
Subject: Re: [PATCH 5/9] async: Wrap hrtimer to provide a time source for a
 kfence
Message-ID: <20160713103251.GC30921@twins.programming.kicks-ass.net>
References: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
 <1466759333-4703-6-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1466759333-4703-6-git-send-email-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 24, 2016 at 10:08:49AM +0100, Chris Wilson wrote:
> kfence_add_delay() is a convenience wrapper around
> hrtimer_start_range_ns() to provide a time source for a kfence graph.

Changelog could be greatly improved by telling us why we'd want this.
