Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:6367 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933277AbbLOKBJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2015 05:01:09 -0500
Subject: Re: [PATCH] android: fix warning when releasing active sync point
To: Dmitry Torokhov <dtor@chromium.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20151215012955.GA28277@dtor-ws>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?B?QXJ2ZSBIasO4bm5ldsOl?= =?UTF-8?Q?g?= <arve@android.com>,
	Riley Andrews <riandrews@android.com>,
	Andrew Bresticker <abrestic@chromium.org>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Message-ID: <566FE4E1.2040005@linux.intel.com>
Date: Tue, 15 Dec 2015 11:01:05 +0100
MIME-Version: 1.0
In-Reply-To: <20151215012955.GA28277@dtor-ws>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op 15-12-15 om 02:29 schreef Dmitry Torokhov:
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
>
NACK! There's no way to do this race free.
The driver should hold a refcount until fence is signaled.
