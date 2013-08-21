Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57822 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3HUNRV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 09:17:21 -0400
MIME-Version: 1.0
In-Reply-To: <1377081215-5948-3-git-send-email-inki.dae@samsung.com>
References: <1377081215-5948-1-git-send-email-inki.dae@samsung.com>
	<1377081215-5948-3-git-send-email-inki.dae@samsung.com>
Date: Wed, 21 Aug 2013 15:17:20 +0200
Message-ID: <CANq1E4R1so8VEwtWmb_c-FLGD_zBpU2s-iQ7x-naefEkAxDm3Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] dma-buf: Add user interfaces for dmabuf sync support
From: David Herrmann <dh.herrmann@gmail.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linaro-kernel@lists.linaro.org,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	kyungmin.park@samsung.com, myungjoo.ham@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Wed, Aug 21, 2013 at 12:33 PM, Inki Dae <inki.dae@samsung.com> wrote:
> This patch adds lock and poll callbacks to dma buf file operations,
> and these callbacks will be called by fcntl and select system calls.
>
> fcntl and select system calls can be used to wait for the completion
> of DMA or CPU access to a shared dmabuf. The difference of them is
> fcntl system call takes a lock after the completion but select system
> call doesn't. So in case of fcntl system call, it's useful when a task
> wants to access a shared dmabuf without any broken. On the other hand,
> it's useful when a task wants to just wait for the completion.

1)
So how is that supposed to work in user-space? I don't want to block
on a buffer, but get notified once I can lock it. So I do:
  select(..dmabuf..)
Once it is finished, I want to use it:
  flock(..dmabuf..)
However, how can I guarantee the flock will not block? Some other
process might have locked it in between. So I do a non-blocking
flock() and if it fails I wait again? Looks ugly and un-predictable.

2)
What do I do if some user-space program holds a lock and dead-locks?

3)
How do we do modesetting in atomic-context in the kernel? There is no
way to lock the object. But this is required for panic-handlers and
more importantly the kdb debugging hooks.
Ok, I can live with that being racy, but would still be nice to be considered.

4)
Why do we need locks? Aren't fences enough? That is, in which
situation is a lock really needed?
If we assume we have two writers A and B (DMA, CPU, GPU, whatever) and
they have no synchronization on their own. What do we win by
synchronizing their writes? Ok, yeah, we end up with either A or B and
not a mixture of both. But if we cannot predict whether we get A or B,
I don't know why we care at all? It's random, so a mixture would be
fine, too, wouldn't it?

So if user-space doesn't have any synchronization on its own, I don't
see why we need an implicit sync on a dma-buf. Could you describe a
more elaborate use-case?

I think the problems we need to fix are read/write syncs. So we have a
write that issues the DMA+write plus a fence and passes the buf plus
fence to the reader. The reader waits for the fence and then issues
the read plus fence. It passes the fence back to the writer. The
writer waits for the fence again and then issues the next write if
required.

This has the following advantages:
 - fences are _guaranteed_ to finish in a given time period. Locks, on
the other hand, might never be freed (of the holder dead-locks, for
instance)
 - you avoid any stalls. That is, if a writer releases a buffer and
immediately locks it again, the reader side might stall if it didn't
lock it in exactly the given window. You have no control to guarantee
the reader ever gets access. You would need a synchronization in
user-space between the writer and reader to guarantee that. This makes
the whole lock useles, doesn't it?

Cheers
David

> Changelog v2:
> - Add select system call support.
>   . The purpose of this feature is to wait for the completion of DMA or
>     CPU access to a dmabuf without that caller locks the dmabuf again
>     after the completion.
>     That is useful when caller wants to be aware of the completion of
>     DMA access to the dmabuf, and the caller doesn't use intefaces for
>     the DMA device driver.
>
> Signed-off-by: Inki Dae <inki.dae@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/base/dma-buf.c |   81 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 81 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
> index 4aca57a..f16a396 100644
> --- a/drivers/base/dma-buf.c
> +++ b/drivers/base/dma-buf.c
> @@ -29,6 +29,7 @@
>  #include <linux/export.h>
>  #include <linux/debugfs.h>
>  #include <linux/seq_file.h>
> +#include <linux/poll.h>
>  #include <linux/dmabuf-sync.h>
>
>  static inline int is_dma_buf_file(struct file *);
> @@ -80,9 +81,89 @@ static int dma_buf_mmap_internal(struct file *file, struct vm_area_struct *vma)
>         return dmabuf->ops->mmap(dmabuf, vma);
>  }
>
> +static unsigned int dma_buf_poll(struct file *filp,
> +                                       struct poll_table_struct *poll)
> +{
> +       struct dma_buf *dmabuf;
> +       struct dmabuf_sync_reservation *robj;
> +       int ret = 0;
> +
> +       if (!is_dma_buf_file(filp))
> +               return POLLERR;
> +
> +       dmabuf = filp->private_data;
> +       if (!dmabuf || !dmabuf->sync)
> +               return POLLERR;
> +
> +       robj = dmabuf->sync;
> +
> +       mutex_lock(&robj->lock);
> +
> +       robj->polled = true;
> +
> +       /*
> +        * CPU or DMA access to this buffer has been completed, and
> +        * the blocked task has been waked up. Return poll event
> +        * so that the task can get out of select().
> +        */
> +       if (robj->poll_event) {
> +               robj->poll_event = false;
> +               mutex_unlock(&robj->lock);
> +               return POLLIN | POLLOUT;
> +       }
> +
> +       /*
> +        * There is no anyone accessing this buffer so just return.
> +        */
> +       if (!robj->locked) {
> +               mutex_unlock(&robj->lock);
> +               return POLLIN | POLLOUT;
> +       }
> +
> +       poll_wait(filp, &robj->poll_wait, poll);
> +
> +       mutex_unlock(&robj->lock);
> +
> +       return ret;
> +}
> +
> +static int dma_buf_lock(struct file *file, int cmd, struct file_lock *fl)
> +{
> +       struct dma_buf *dmabuf;
> +       unsigned int type;
> +       bool wait = false;
> +
> +       if (!is_dma_buf_file(file))
> +               return -EINVAL;
> +
> +       dmabuf = file->private_data;
> +
> +       if ((fl->fl_type & F_UNLCK) == F_UNLCK) {
> +               dmabuf_sync_single_unlock(dmabuf);
> +               return 0;
> +       }
> +
> +       /* convert flock type to dmabuf sync type. */
> +       if ((fl->fl_type & F_WRLCK) == F_WRLCK)
> +               type = DMA_BUF_ACCESS_W;
> +       else if ((fl->fl_type & F_RDLCK) == F_RDLCK)
> +               type = DMA_BUF_ACCESS_R;
> +       else
> +               return -EINVAL;
> +
> +       if (fl->fl_flags & FL_SLEEP)
> +               wait = true;
> +
> +       /* TODO. the locking to certain region should also be considered. */
> +
> +       return dmabuf_sync_single_lock(dmabuf, type, wait);
> +}
> +
>  static const struct file_operations dma_buf_fops = {
>         .release        = dma_buf_release,
>         .mmap           = dma_buf_mmap_internal,
> +       .poll           = dma_buf_poll,
> +       .lock           = dma_buf_lock,
>  };
>
>  /*
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
