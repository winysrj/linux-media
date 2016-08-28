Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:62845 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751610AbcH1Uu7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 Aug 2016 16:50:59 -0400
Date: Sun, 28 Aug 2016 21:50:49 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: intel-gfx@lists.freedesktop.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH] dma-buf: Do a fast lockless check for poll with timeout=0
Message-ID: <20160828205049.GC23758@nuc-i3427.alporthouse.com>
References: <20160828163747.32751-1-chris@chris-wilson.co.uk>
 <20160828203354.GB23758@nuc-i3427.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160828203354.GB23758@nuc-i3427.alporthouse.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 28, 2016 at 09:33:54PM +0100, Chris Wilson wrote:
> On Sun, Aug 28, 2016 at 05:37:47PM +0100, Chris Wilson wrote:
> > Currently we install a callback for performing poll on a dma-buf,
> > irrespective of the timeout. This involves taking a spinlock, as well as
> > unnecessary work, and greatly reduces scaling of poll(.timeout=0) across
> > multiple threads.
> > 
> > We can query whether the poll will block prior to installing the
> > callback to make the busy-query fast.
> > 
> > Single thread: 60% faster
> > 8 threads on 4 (+4 HT) cores: 600% faster
> 
> Hmm, this only really applies to the idle case.
> reservation_object_test_signaled_rcu() is still a major bottleneck when
> busy, due to the dance inside reservation_object_test_signaled_single()

The fix is not difficult, just requires extending the seqlock to catch
the RCU race (i.e. earlier patches). I'll resend that series in the
morning.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
