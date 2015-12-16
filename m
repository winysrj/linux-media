Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35380 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965466AbbLPPgJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 10:36:09 -0500
Received: by mail-wm0-f42.google.com with SMTP id l126so43968650wml.0
        for <linux-media@vger.kernel.org>; Wed, 16 Dec 2015 07:36:08 -0800 (PST)
Date: Wed, 16 Dec 2015 16:36:06 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: Gustavo Padovan <gustavo@padovan.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Andrew Bresticker <abrestic@chromium.org>,
	Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
	dri-devel@lists.freedesktop.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Riley Andrews <riandrews@android.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] android: fix warning when releasing active sync point
Message-ID: <20151216153606.GR30437@phenom.ffwll.local>
References: <20151215012955.GA28277@dtor-ws>
 <20151215092601.GI3189@phenom.ffwll.local>
 <20151215190008.GE883@joana>
 <CAE_wzQ87y-Py8miGoyVwRz7qL4xgDse5U5dLEj58D_QeHHkprg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE_wzQ87y-Py8miGoyVwRz7qL4xgDse5U5dLEj58D_QeHHkprg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 15, 2015 at 11:08:01AM -0800, Dmitry Torokhov wrote:
> On Tue, Dec 15, 2015 at 11:00 AM, Gustavo Padovan <gustavo@padovan.org> wrote:
> > 2015-12-15 Daniel Vetter <daniel@ffwll.ch>:
> >
> >> On Mon, Dec 14, 2015 at 05:29:55PM -0800, Dmitry Torokhov wrote:
> >> > Userspace can close the sync device while there are still active fence
> >> > points, in which case kernel produces the following warning:
> >> >
> >> > [   43.853176] ------------[ cut here ]------------
> >> > [   43.857834] WARNING: CPU: 0 PID: 892 at /mnt/host/source/src/third_party/kernel/v3.18/drivers/staging/android/sync.c:439 android_fence_release+0x88/0x104()
> >> > [   43.871741] CPU: 0 PID: 892 Comm: Binder_5 Tainted: G     U 3.18.0-07661-g0550ce9 #1
> >> > [   43.880176] Hardware name: Google Tegra210 Smaug Rev 1+ (DT)
> >> > [   43.885834] Call trace:
> >> > [   43.888294] [<ffffffc000207464>] dump_backtrace+0x0/0x10c
> >> > [   43.893697] [<ffffffc000207580>] show_stack+0x10/0x1c
> >> > [   43.898756] [<ffffffc000ab1258>] dump_stack+0x74/0xb8
> >> > [   43.903814] [<ffffffc00021d414>] warn_slowpath_common+0x84/0xb0
> >> > [   43.909736] [<ffffffc00021d530>] warn_slowpath_null+0x14/0x20
> >> > [   43.915482] [<ffffffc00088aefc>] android_fence_release+0x84/0x104
> >> > [   43.921582] [<ffffffc000671cc4>] fence_release+0x104/0x134
> >> > [   43.927066] [<ffffffc00088b0cc>] sync_fence_free+0x74/0x9c
> >> > [   43.932552] [<ffffffc00088b128>] sync_fence_release+0x34/0x48
> >> > [   43.938304] [<ffffffc000317bbc>] __fput+0x100/0x1b8
> >> > [   43.943185] [<ffffffc000317cc8>] ____fput+0x8/0x14
> >> > [   43.947982] [<ffffffc000237f38>] task_work_run+0xb0/0xe4
> >> > [   43.953297] [<ffffffc000207074>] do_notify_resume+0x44/0x5c
> >> > [   43.958867] ---[ end trace 5a2aa4027cc5d171 ]---
> >> >
> >> > Let's fix it by introducing a new optional callback (disable_signaling)
> >> > to fence operations so that drivers can do proper clean ups when we
> >> > remove last callback for given fence.
> >> >
> >> > Reviewed-by: Andrew Bresticker <abrestic@chromium.org>
> >> > Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
> >> > ---
> >> >  drivers/dma-buf/fence.c        | 6 +++++-
> >> >  drivers/staging/android/sync.c | 8 ++++++++
> >> >  include/linux/fence.h          | 2 ++
> >> >  3 files changed, 15 insertions(+), 1 deletion(-)
> >> >
> >> > diff --git a/drivers/dma-buf/fence.c b/drivers/dma-buf/fence.c
> >> > index 7b05dbe..0ed73ad 100644
> >> > --- a/drivers/dma-buf/fence.c
> >> > +++ b/drivers/dma-buf/fence.c
> >> > @@ -304,8 +304,12 @@ fence_remove_callback(struct fence *fence, struct fence_cb *cb)
> >> >     spin_lock_irqsave(fence->lock, flags);
> >> >
> >> >     ret = !list_empty(&cb->node);
> >> > -   if (ret)
> >> > +   if (ret) {
> >> >             list_del_init(&cb->node);
> >> > +           if (list_empty(&fence->cb_list))
> >> > +                   if (fence->ops->disable_signaling)
> >> > +                           fence->ops->disable_signaling(fence);
> >>
> >> What exactly is the bug here? A fence with no callbacks registered any
> >> more shouldn't have any problem. Why exactly does this blow up?
> >
> > The WARN_ON is probably this one:
> > https://android.googlesource.com/kernel/common/+/android-3.18/drivers/staging/android/sync.c#433
> >
> > I've been wondering in the last few days if this warning is really
> > necessary. If the user is closing a sync_timeline that has unsignalled
> > fences it should probably be aware of that already. Then I think it is
> > okay to remove the the sync_pt from the active_list at the release-time.
> > In fact I've already prepared a patch doing that. Thoughts?
> >
> 
> Maybe, but you need to make sure that you only affecting your fences.
> 
> My main objection is that still leaves fence_remove_callback() being
> not mirror image of fence_add_callback().

That's 100% intentional. I looked at the sync.c code a bit more and it
duplicates a bunch of the fence stuff still. We need to either merge that
code into the mainline struct fence logic, or remove it. There shouldn't
really be any need for the userspace ABI layer to keep track of active
fences at all. Worse, it means that you must use the sync_pt struct to be
able to export it to userspace, and can't just export any normal struct
fence object. That breaks the abstraction we're aiming for.

Imo just remove that WARN_ON for now.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
