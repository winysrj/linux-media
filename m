Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35244 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbcGMLDH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 07:03:07 -0400
Received: by mail-wm0-f68.google.com with SMTP id i5so5469371wmg.2
        for <linux-media@vger.kernel.org>; Wed, 13 Jul 2016 04:03:01 -0700 (PDT)
Date: Wed, 13 Jul 2016 13:02:41 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-kernel@vger.kernel.org,
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
Message-ID: <20160713110241.GE23520@phenom.ffwll.local>
References: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
 <1466759333-4703-3-git-send-email-chris@chris-wilson.co.uk>
 <20160713093852.GZ30921@twins.programming.kicks-ass.net>
 <20160713102014.GC6157@nuc-i3427.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160713102014.GC6157@nuc-i3427.alporthouse.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 13, 2016 at 11:20:14AM +0100, Chris Wilson wrote:
> On Wed, Jul 13, 2016 at 11:38:52AM +0200, Peter Zijlstra wrote:
> > Also, I'm not a particular fan of the k* naming, but I see 'fence' is
> > already taken.
> 
> Agreed, I really want to rename the dma-buf fence to struct dma_fence -
> we would need to do that whilst it dma-buf fencing is still in its infancy.

+1 on dma_fence, seems to make more sense than plain struct fence.
Probably best to do after the recent pile of work from Gustavo to de-stage
sync_file has landed.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
