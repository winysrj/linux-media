Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:33801 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbdF1QrZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Jun 2017 12:47:25 -0400
Received: by mail-io0-f174.google.com with SMTP id r36so39102067ioi.1
        for <linux-media@vger.kernel.org>; Wed, 28 Jun 2017 09:47:25 -0700 (PDT)
Date: Wed, 28 Jun 2017 12:47:24 -0400
From: Sean Paul <seanpaul@chromium.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Sean Paul <seanpaul@chromium.org>, dri-devel@lists.freedesktop.org,
        marcheu@chromium.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] dma-buf/sw_sync: Fix timeline/pt overflow cases
Message-ID: <20170628164724.oa7pg2xqthv5y3hk@art_vandelay>
References: <20170628155117.3558-1-seanpaul@chromium.org>
 <149866562059.23475.15965626912972737879@mail.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149866562059.23475.15965626912972737879@mail.alporthouse.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 28, 2017 at 05:00:20PM +0100, Chris Wilson wrote:
> Quoting Sean Paul (2017-06-28 16:51:11)
> > Protect against long-running processes from overflowing the timeline
> > and creating fences that go back in time. While we're at it, avoid
> > overflowing while we're incrementing the timeline.
> > 
> > Signed-off-by: Sean Paul <seanpaul@chromium.org>
> > ---
> >  drivers/dma-buf/sw_sync.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
> > index 69c5ff36e2f9..40934619ed88 100644
> > --- a/drivers/dma-buf/sw_sync.c
> > +++ b/drivers/dma-buf/sw_sync.c
> > @@ -142,7 +142,7 @@ static void sync_timeline_signal(struct sync_timeline *obj, unsigned int inc)
> >  
> >         spin_lock_irqsave(&obj->child_list_lock, flags);
> >  
> > -       obj->value += inc;
> > +       obj->value += min(inc, ~0x0U - obj->value);
> 
> The timeline uses u32 seqno, so just obj->value += min(inc, INT_MAX);
> 
Hi Chris,
Thanks for the review.

I don't think that solves the same problem I was trying to solve. The issue is
that android userspace increments value by 0x7fffffff twice in order to ensure
all fences have signaled. This is causing value to overflow and is_signaled will
never be true. With your snippet, the possibility of overflow still exists.

> Better of course would be to report the error,

AFAIK, it's not an error to jump the timeline, perhaps just bad taste. Capping
value at UINT_MAX will ensure all fences are signaled, and the check below ensures
that fences can't be created beyond that (returning an error at that point in
time).

Sean

> 
> diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
> index 69c5ff36e2f9..2503cf884018 100644
> --- a/drivers/dma-buf/sw_sync.c
> +++ b/drivers/dma-buf/sw_sync.c
> @@ -345,6 +345,9 @@ static long sw_sync_ioctl_inc(struct sync_timeline *obj, unsigned long arg)
>         if (copy_from_user(&value, (void __user *)arg, sizeof(value)))
>                 return -EFAULT;
>  
> +       if (value > INT_MAX)
> +               return -EINVAL;
> +
>         sync_timeline_signal(obj, value);
> 
> >  
> >         list_for_each_entry_safe(pt, next, &obj->active_list_head,
> >                                  active_list) {
> > @@ -178,6 +178,11 @@ static struct sync_pt *sync_pt_create(struct sync_timeline *obj, int size,
> >                 return NULL;
> >  
> >         spin_lock_irqsave(&obj->child_list_lock, flags);
> > +       if (value < obj->value) {
> > +               spin_unlock_irqrestore(&obj->child_list_lock, flags);
> > +               return NULL;
> > +       }
> 
> Needs a u32 check. if ((int)(value - obj->value) < 0) return some_error;
> -Chris

-- 
Sean Paul, Software Engineer, Google / Chromium OS
