Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:52893 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751067AbdKUP6Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Nov 2017 10:58:24 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: christian.koenig@amd.com,
        =?utf-8?q?Christian_K=C3=B6nig?= <ckoenig.leichtzumerken@gmail.com>,
        "Rob Clark" <robdclark@gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <83c7c887-0d40-69b5-2ad2-67d0af6eda71@gmail.com>
Cc: "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <20171121140850.23401-1-robdclark@gmail.com>
 <151127508188.436.3320065005004428970@mail.alporthouse.com>
 <CAF6AEGuo=e8rOnLHX3rL9qGTenSRDO2D=S7GQs9rq+=5SVqS0g@mail.gmail.com>
 <83c7c887-0d40-69b5-2ad2-67d0af6eda71@gmail.com>
Message-ID: <151127989753.436.17300151969206767494@mail.alporthouse.com>
Subject: Re: [PATCH] reservation: don't wait when timeout=0
Date: Tue, 21 Nov 2017 15:58:17 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Christian König (2017-11-21 15:49:55)
> Am 21.11.2017 um 15:59 schrieb Rob Clark:
> > On Tue, Nov 21, 2017 at 9:38 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> >> Quoting Rob Clark (2017-11-21 14:08:46)
> >>> If we are testing if a reservation object's fences have been
> >>> signaled with timeout=0 (non-blocking), we need to pass 0 for
> >>> timeout to dma_fence_wait_timeout().
> >>>
> >>> Plus bonus spelling correction.
> >>>
> >>> Signed-off-by: Rob Clark <robdclark@gmail.com>
> >>> ---
> >>>   drivers/dma-buf/reservation.c | 11 +++++++++--
> >>>   1 file changed, 9 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
> >>> index dec3a815455d..71f51140a9ad 100644
> >>> --- a/drivers/dma-buf/reservation.c
> >>> +++ b/drivers/dma-buf/reservation.c
> >>> @@ -420,7 +420,7 @@ EXPORT_SYMBOL_GPL(reservation_object_get_fences_rcu);
> >>>    *
> >>>    * RETURNS
> >>>    * Returns -ERESTARTSYS if interrupted, 0 if the wait timed out, or
> >>> - * greater than zer on success.
> >>> + * greater than zero on success.
> >>>    */
> >>>   long reservation_object_wait_timeout_rcu(struct reservation_object *obj,
> >>>                                           bool wait_all, bool intr,
> >>> @@ -483,7 +483,14 @@ long reservation_object_wait_timeout_rcu(struct reservation_object *obj,
> >>>                          goto retry;
> >>>                  }
> >>>
> >>> -               ret = dma_fence_wait_timeout(fence, intr, ret);
> >>> +               /*
> >>> +                * Note that dma_fence_wait_timeout() will return 1 if
> >>> +                * the fence is already signaled, so in the wait_all
> >>> +                * case when we go through the retry loop again, ret
> >>> +                * will be greater than 0 and we don't want this to
> >>> +                * cause _wait_timeout() to block
> >>> +                */
> >>> +               ret = dma_fence_wait_timeout(fence, intr, timeout ? ret : 0);
> >> One should ask if we should just fix the interface to stop returning
> >> incorrect results (stop "correcting" a completion with 0 jiffies remaining
> >> as 1). A timeout can be distinguished by -ETIME (or your pick of errno).
> > perhaps -EBUSY, if we go that route (although maybe it should be a
> > follow-on patch, this one is suitable for backport to stable/lts if
> > one should so choose..)
> >
> > I think current approach was chosen to match schedule_timeout() and
> > other such functions that take a timeout in jiffies.  Not making a
> > judgement on whether that is a good or bad reason..
> 
> We intentionally switched away from that to be in sync with the 
> wait_event_* interface.
> 
> Returning 1 when a function with a zero timeout succeeds is actually 
> quite common in the kernel.

We actually had this conversation last time, and outside of that it
isn't. Looking at all the convolution to first return 1, then undo the
damage in the caller, it looks pretty silly.
-Chris
