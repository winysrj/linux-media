Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:56015 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751574AbdF1QAo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Jun 2017 12:00:44 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sean Paul <seanpaul@chromium.org>, dri-devel@lists.freedesktop.org
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20170628155117.3558-1-seanpaul@chromium.org>
Cc: marcheu@chromium.org, linux-media@vger.kernel.org
References: <20170628155117.3558-1-seanpaul@chromium.org>
Message-ID: <149866562059.23475.15965626912972737879@mail.alporthouse.com>
Subject: Re: [PATCH] dma-buf/sw_sync: Fix timeline/pt overflow cases
Date: Wed, 28 Jun 2017 17:00:20 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Sean Paul (2017-06-28 16:51:11)
> Protect against long-running processes from overflowing the timeline
> and creating fences that go back in time. While we're at it, avoid
> overflowing while we're incrementing the timeline.
> 
> Signed-off-by: Sean Paul <seanpaul@chromium.org>
> ---
>  drivers/dma-buf/sw_sync.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
> index 69c5ff36e2f9..40934619ed88 100644
> --- a/drivers/dma-buf/sw_sync.c
> +++ b/drivers/dma-buf/sw_sync.c
> @@ -142,7 +142,7 @@ static void sync_timeline_signal(struct sync_timeline *obj, unsigned int inc)
>  
>         spin_lock_irqsave(&obj->child_list_lock, flags);
>  
> -       obj->value += inc;
> +       obj->value += min(inc, ~0x0U - obj->value);

The timeline uses u32 seqno, so just obj->value += min(inc, INT_MAX);

Better of course would be to report the error,

diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
index 69c5ff36e2f9..2503cf884018 100644
--- a/drivers/dma-buf/sw_sync.c
+++ b/drivers/dma-buf/sw_sync.c
@@ -345,6 +345,9 @@ static long sw_sync_ioctl_inc(struct sync_timeline *obj, unsigned long arg)
        if (copy_from_user(&value, (void __user *)arg, sizeof(value)))
                return -EFAULT;
 
+       if (value > INT_MAX)
+               return -EINVAL;
+
        sync_timeline_signal(obj, value);

>  
>         list_for_each_entry_safe(pt, next, &obj->active_list_head,
>                                  active_list) {
> @@ -178,6 +178,11 @@ static struct sync_pt *sync_pt_create(struct sync_timeline *obj, int size,
>                 return NULL;
>  
>         spin_lock_irqsave(&obj->child_list_lock, flags);
> +       if (value < obj->value) {
> +               spin_unlock_irqrestore(&obj->child_list_lock, flags);
> +               return NULL;
> +       }

Needs a u32 check. if ((int)(value - obj->value) < 0) return some_error;
-Chris
