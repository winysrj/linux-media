Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:35101 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933190AbbLONa1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2015 08:30:27 -0500
Date: Tue, 15 Dec 2015 11:30:20 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Andrew Bresticker <abrestic@chromium.org>,
	Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Riley Andrews <riandrews@android.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] android: fix warning when releasing active sync point
Message-ID: <20151215133020.GD883@joana>
References: <20151215012955.GA28277@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151215012955.GA28277@dtor-ws>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2015-12-14 Dmitry Torokhov <dtor@chromium.org>:

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

This crash report seems to be for a 3.18 kernel. Can you reproduce it
on upstream kernel as well?

	Gustavo
