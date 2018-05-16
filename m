Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:54634 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbeEPJm2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 05:42:28 -0400
Received: by mail-wm0-f66.google.com with SMTP id f6-v6so118385wmc.4
        for <linux-media@vger.kernel.org>; Wed, 16 May 2018 02:42:28 -0700 (PDT)
Date: Wed, 16 May 2018 11:42:24 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ezequiel Garcia <ezequiel@collabora.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>, kernel@collabora.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] dma-fence: Make dma_fence_add_callback() fail if
 signaled with error
Message-ID: <20180516094224.GD3438@phenom.ffwll.local>
References: <20180509201449.27452-1-ezequiel@collabora.com>
 <152602366168.22269.11696001916463464983@mail.alporthouse.com>
 <20180514164823.GH28661@phenom.ffwll.local>
 <e75424afd7fafad7b584a9cf905684de661996cb.camel@collabora.com>
 <152638659036.18532.13662508480413451560@mail.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152638659036.18532.13662508480413451560@mail.alporthouse.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 15, 2018 at 01:16:30PM +0100, Chris Wilson wrote:
> Quoting Ezequiel Garcia (2018-05-14 22:28:31)
> > On Mon, 2018-05-14 at 18:48 +0200, Daniel Vetter wrote:
> > > On Fri, May 11, 2018 at 08:27:41AM +0100, Chris Wilson wrote:
> > > > Quoting Ezequiel Garcia (2018-05-09 21:14:49)
> > > > > Change how dma_fence_add_callback() behaves, when the fence
> > > > > has error-signaled by the time it is being add. After this commit,
> > > > > dma_fence_add_callback() returns the fence error, if it
> > > > > has error-signaled before dma_fence_add_callback() is called.
> > > > 
> > > > Why? What problem are you trying to solve? fence->error does not imply
> > > > that the fence has yet been signaled, and the caller wants a callback
> > > > when it is signaled.
> > > 
> > > On top this is incosistent, e.g. we don't do the same for any of the other
> > > dma_fence interfaces. Plus there's the issue that you might alias errno
> > > values with fence errno values.
> > > 
> > 
> > Right.
> > 
> > > I think keeping the error codes from the functions you're calling distinct
> > > from the error code of the fence itself makes a lot of sense. The first
> > > tells you whether your request worked out (or why not), the second tells
> > > you whether the asynchronous dma operation (gpu rendering, page flip,
> > > whatever) that the dma_fence represents worked out (or why not). That's 2
> > > distinct things imo.
> > > 
> > > Might be good to show us the driver code that needs this behaviour so we
> > > can discuss how to best handle your use-case.
> > > 
> > 
> > This change arose while discussing the in-fences support for video4linux.
> > Here's the patch that calls dma_fence_add_callback https://lkml.org/lkml/2018/5/4/766.
> > 
> > The code snippet currently looks something like this:
> > 
> >         if (vb->in_fence) {
> >                 ret = dma_fence_add_callback(vb->in_fence, &vb->fence_cb,
> >                                 
> >              vb2_qbuf_fence_cb);
> >                 /* is the fence signaled? */
> >                 if (ret == -ENOENT) {
> >         
> >                 dma_fence_put(vb->in_fence);
> >                         vb->in_fence = NULL;
> >                 } else if (ret)
> > {
> >                         goto unlock;
> >                 }
> >         }
> > 
> > In this use case, if the callback is added successfully,
> > the video4linux core defers the activation of the buffer
> > until the fence signals.
> > 
> > If the fence is signaled (currently disregarding of errors)
> > then the buffer is assumed to be ready to be activated,
> > and so it gets queued for hardware usage.
> > 
> > Giving some more thought to this, I'm not so sure what is
> > the right action if a fence signaled with error. In this case,
> > it appears to me that we shouldn't be using this buffer
> > if its in-fence is in error, but perhaps I'm missing
> > something.
> 
> What I have in mind for async errors is to skip the operation and
> propagate the error onto the next fence. Mostly because those async
> errors may include fatal errors such as unable to pin the backing
> storage for the operation, but even "trivial" errors such as an early
> operation failing means that this request is then subject to garbage-in,
> garbage-out. However, for trivial errors I would just propagate the
> error status (so the caller knows something went wrong if they care, but
> in all likelihood no one will notice) and continue on with the glitchy
> operation.

In general, there's not really any hard rule about propagating fence
errors across devices. It's mostly just used by drivers internally to keep
track of failed stuff (gpu hangs or anything else async like Chris
describes here).

For v4l I'm not sure you want to care much about this, since right now the
main use of fence errors is gpu hang recovery (whether it's the driver or
hw that's hung doesn't matter here).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
