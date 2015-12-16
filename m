Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33355 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbbLPIga (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 03:36:30 -0500
Subject: Re: [PATCH] android: fix warning when releasing active sync point
To: Dmitry Torokhov <dtor@chromium.org>
References: <20151215012955.GA28277@dtor-ws>
 <566FE4E1.2040005@linux.intel.com>
 <CAE_wzQ-s1q4WA0QBsJvSCO28Wd_XRzYrieCkGxdT8p-2YubNAg@mail.gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?B?QXJ2ZSBIasO4bm5ldsOl?= <arve@android.com>,
	Riley Andrews <riandrews@android.com>,
	Andrew Bresticker <abrestic@chromium.org>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	devel@driverdev.osuosl.org
From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Message-ID: <5671227B.3060708@linux.intel.com>
Date: Wed, 16 Dec 2015 09:36:11 +0100
MIME-Version: 1.0
In-Reply-To: <CAE_wzQ-s1q4WA0QBsJvSCO28Wd_XRzYrieCkGxdT8p-2YubNAg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op 15-12-15 om 18:19 schreef Dmitry Torokhov:
> On Tue, Dec 15, 2015 at 2:01 AM, Maarten Lankhorst
> <maarten.lankhorst@linux.intel.com> wrote:
>> Op 15-12-15 om 02:29 schreef Dmitry Torokhov:
>>> Userspace can close the sync device while there are still active fence
>>> points, in which case kernel produces the following warning:
>>>
>>> [   43.853176] ------------[ cut here ]------------
>>> [   43.857834] WARNING: CPU: 0 PID: 892 at /mnt/host/source/src/third_party/kernel/v3.18/drivers/staging/android/sync.c:439 android_fence_release+0x88/0x104()
>>> [   43.871741] CPU: 0 PID: 892 Comm: Binder_5 Tainted: G     U 3.18.0-07661-g0550ce9 #1
>>> [   43.880176] Hardware name: Google Tegra210 Smaug Rev 1+ (DT)
>>> [   43.885834] Call trace:
>>> [   43.888294] [<ffffffc000207464>] dump_backtrace+0x0/0x10c
>>> [   43.893697] [<ffffffc000207580>] show_stack+0x10/0x1c
>>> [   43.898756] [<ffffffc000ab1258>] dump_stack+0x74/0xb8
>>> [   43.903814] [<ffffffc00021d414>] warn_slowpath_common+0x84/0xb0
>>> [   43.909736] [<ffffffc00021d530>] warn_slowpath_null+0x14/0x20
>>> [   43.915482] [<ffffffc00088aefc>] android_fence_release+0x84/0x104
>>> [   43.921582] [<ffffffc000671cc4>] fence_release+0x104/0x134
>>> [   43.927066] [<ffffffc00088b0cc>] sync_fence_free+0x74/0x9c
>>> [   43.932552] [<ffffffc00088b128>] sync_fence_release+0x34/0x48
>>> [   43.938304] [<ffffffc000317bbc>] __fput+0x100/0x1b8
>>> [   43.943185] [<ffffffc000317cc8>] ____fput+0x8/0x14
>>> [   43.947982] [<ffffffc000237f38>] task_work_run+0xb0/0xe4
>>> [   43.953297] [<ffffffc000207074>] do_notify_resume+0x44/0x5c
>>> [   43.958867] ---[ end trace 5a2aa4027cc5d171 ]---
>>>
>>> Let's fix it by introducing a new optional callback (disable_signaling)
>>> to fence operations so that drivers can do proper clean ups when we
>>> remove last callback for given fence.
>>>
>>> Reviewed-by: Andrew Bresticker <abrestic@chromium.org>
>>> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
>>>
>> NACK! There's no way to do this race free.
> Can you please explain the race because as far as I can see there is not one.\
The entire code in fence.c assumes that a fence can only go from not enable_signaling to .enable_signaling. .enable_signaling is not refcounted so 2 calls to .enable_disabling and 1 to .disable_signaling would mess up.
Furthermore we try to make sure that fence_signal doesn't take locks if its unneeded. With a disable_signaling callback you would always need locks.

To get rid of these warnings make sure that there's a refcount on the fence until it's signaled.
>> The driver should hold a refcount until fence is signaled.
> If we are no longer interested in fence why do we need to wait for the
> fence to be signaled?
It's the part of the design. A driver tracks its outstanding requests and submissions, and every submission has its own fence. Before the driver releases its final ref the request should be completed or aborted. In either case it must call fence_signal.
