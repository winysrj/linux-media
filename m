Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36693 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933186AbbLOJ0F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2015 04:26:05 -0500
Received: by mail-wm0-f51.google.com with SMTP id n186so155546287wmn.1
        for <linux-media@vger.kernel.org>; Tue, 15 Dec 2015 01:26:04 -0800 (PST)
Date: Tue, 15 Dec 2015 10:26:01 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Andrew Bresticker <abrestic@chromium.org>,
	Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Riley Andrews <riandrews@android.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] android: fix warning when releasing active sync point
Message-ID: <20151215092601.GI3189@phenom.ffwll.local>
References: <20151215012955.GA28277@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151215012955.GA28277@dtor-ws>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 14, 2015 at 05:29:55PM -0800, Dmitry Torokhov wrote:
> Userspace can close the sync device while there are still active fence
> points, in which case kernel produces the following warning:
> 
> [   43.853176] ------------[ cut here ]------------
> [   43.857834] WARNING: CPU: 0 PID: 892 at /mnt/host/source/src/third_party/kernel/v3.18/drivers/staging/android/sync.c:439 android_fence_release+0x88/0x104()
> [   43.871741] CPU: 0 PID: 892 Comm: Binder_5 Tainted: G     U 3.18.0-07661-g0550ce9 #1
> [   43.880176] Hardware name: Google Tegra210 Smaug Rev 1+ (DT)
> [   43.885834] Call trace:
> [   43.888294] [<ffffffc000207464>] dump_backtrace+0x0/0x10c
> [   43.893697] [<ffffffc000207580>] show_stack+0x10/0x1c
> [   43.898756] [<ffffffc000ab1258>] dump_stack+0x74/0xb8
> [   43.903814] [<ffffffc00021d414>] warn_slowpath_common+0x84/0xb0
> [   43.909736] [<ffffffc00021d530>] warn_slowpath_null+0x14/0x20
> [   43.915482] [<ffffffc00088aefc>] android_fence_release+0x84/0x104
> [   43.921582] [<ffffffc000671cc4>] fence_release+0x104/0x134
> [   43.927066] [<ffffffc00088b0cc>] sync_fence_free+0x74/0x9c
> [   43.932552] [<ffffffc00088b128>] sync_fence_release+0x34/0x48
> [   43.938304] [<ffffffc000317bbc>] __fput+0x100/0x1b8
> [   43.943185] [<ffffffc000317cc8>] ____fput+0x8/0x14
> [   43.947982] [<ffffffc000237f38>] task_work_run+0xb0/0xe4
> [   43.953297] [<ffffffc000207074>] do_notify_resume+0x44/0x5c
> [   43.958867] ---[ end trace 5a2aa4027cc5d171 ]---
> 
> Let's fix it by introducing a new optional callback (disable_signaling)
> to fence operations so that drivers can do proper clean ups when we
> remove last callback for given fence.
> 
> Reviewed-by: Andrew Bresticker <abrestic@chromium.org>
> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
> ---
>  drivers/dma-buf/fence.c        | 6 +++++-
>  drivers/staging/android/sync.c | 8 ++++++++
>  include/linux/fence.h          | 2 ++
>  3 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma-buf/fence.c b/drivers/dma-buf/fence.c
> index 7b05dbe..0ed73ad 100644
> --- a/drivers/dma-buf/fence.c
> +++ b/drivers/dma-buf/fence.c
> @@ -304,8 +304,12 @@ fence_remove_callback(struct fence *fence, struct fence_cb *cb)
>  	spin_lock_irqsave(fence->lock, flags);
>  
>  	ret = !list_empty(&cb->node);
> -	if (ret)
> +	if (ret) {
>  		list_del_init(&cb->node);
> +		if (list_empty(&fence->cb_list))
> +			if (fence->ops->disable_signaling)
> +				fence->ops->disable_signaling(fence);

What exactly is the bug here? A fence with no callbacks registered any
more shouldn't have any problem. Why exactly does this blow up?

I guess I don't really understand the bug ... we do seem to remove the
callback already.

Thanks, Daniel


> +	}
>  
>  	spin_unlock_irqrestore(fence->lock, flags);
>  
> diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
> index e0c1acb..f8566c1 100644
> --- a/drivers/staging/android/sync.c
> +++ b/drivers/staging/android/sync.c
> @@ -465,6 +465,13 @@ static bool android_fence_enable_signaling(struct fence *fence)
>  	return true;
>  }
>  
> +static void android_fence_disable_signaling(struct fence *fence)
> +{
> +	struct sync_pt *pt = container_of(fence, struct sync_pt, base);
> +
> +	list_del_init(&pt->active_list);
> +}
> +
>  static int android_fence_fill_driver_data(struct fence *fence,
>  					  void *data, int size)
>  {
> @@ -508,6 +515,7 @@ static const struct fence_ops android_fence_ops = {
>  	.get_driver_name = android_fence_get_driver_name,
>  	.get_timeline_name = android_fence_get_timeline_name,
>  	.enable_signaling = android_fence_enable_signaling,
> +	.disable_signaling = android_fence_disable_signaling,
>  	.signaled = android_fence_signaled,
>  	.wait = fence_default_wait,
>  	.release = android_fence_release,
> diff --git a/include/linux/fence.h b/include/linux/fence.h
> index bb52201..ce44348 100644
> --- a/include/linux/fence.h
> +++ b/include/linux/fence.h
> @@ -107,6 +107,7 @@ struct fence_cb {
>   * @get_driver_name: returns the driver name.
>   * @get_timeline_name: return the name of the context this fence belongs to.
>   * @enable_signaling: enable software signaling of fence.
> + * @disable_signaling: disable software signaling of fence (optional).
>   * @signaled: [optional] peek whether the fence is signaled, can be null.
>   * @wait: custom wait implementation, or fence_default_wait.
>   * @release: [optional] called on destruction of fence, can be null
> @@ -166,6 +167,7 @@ struct fence_ops {
>  	const char * (*get_driver_name)(struct fence *fence);
>  	const char * (*get_timeline_name)(struct fence *fence);
>  	bool (*enable_signaling)(struct fence *fence);
> +	void (*disable_signaling)(struct fence *fence);
>  	bool (*signaled)(struct fence *fence);
>  	signed long (*wait)(struct fence *fence, bool intr, signed long timeout);
>  	void (*release)(struct fence *fence);
> -- 
> 2.6.0.rc2.230.g3dd15c0
> 
> 
> -- 
> Dmitry
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
