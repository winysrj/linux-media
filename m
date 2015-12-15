Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:33123 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933369AbbLONuU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2015 08:50:20 -0500
Subject: Re: [PATCH] android: fix warning when releasing active sync point
To: Gustavo Padovan <gustavo@padovan.org>,
	Dmitry Torokhov <dtor@chromium.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<devel@driverdev.osuosl.org>,
	Andrew Bresticker <abrestic@chromium.org>,
	=?UTF-8?Q?Arve_Hj=c3=b8nnev=c3=a5g?= <arve@android.com>,
	<dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	Riley Andrews <riandrews@android.com>,
	<linux-media@vger.kernel.org>
References: <20151215012955.GA28277@dtor-ws> <20151215133020.GD883@joana>
From: Frank Binns <frank.binns@imgtec.com>
Message-ID: <56701A99.3000404@imgtec.com>
Date: Tue, 15 Dec 2015 13:50:17 +0000
MIME-Version: 1.0
In-Reply-To: <20151215133020.GD883@joana>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is this not the issue fixed by 8e43c9c75?

Thanks
Frank

On 15/12/15 13:30, Gustavo Padovan wrote:
> 2015-12-14 Dmitry Torokhov <dtor@chromium.org>:
>
>> Userspace can close the sync device while there are still active fence
>> points, in which case kernel produces the following warning:
>>
>> [   43.853176] ------------[ cut here ]------------
>> [   43.857834] WARNING: CPU: 0 PID: 892 at /mnt/host/source/src/third_party/kernel/v3.18/drivers/staging/android/sync.c:439 android_fence_release+0x88/0x104()
>> [   43.871741] CPU: 0 PID: 892 Comm: Binder_5 Tainted: G     U 3.18.0-07661-g0550ce9 #1
>> [   43.880176] Hardware name: Google Tegra210 Smaug Rev 1+ (DT)
>> [   43.885834] Call trace:
>> [   43.888294] [<ffffffc000207464>] dump_backtrace+0x0/0x10c
>> [   43.893697] [<ffffffc000207580>] show_stack+0x10/0x1c
>> [   43.898756] [<ffffffc000ab1258>] dump_stack+0x74/0xb8
>> [   43.903814] [<ffffffc00021d414>] warn_slowpath_common+0x84/0xb0
>> [   43.909736] [<ffffffc00021d530>] warn_slowpath_null+0x14/0x20
>> [   43.915482] [<ffffffc00088aefc>] android_fence_release+0x84/0x104
>> [   43.921582] [<ffffffc000671cc4>] fence_release+0x104/0x134
>> [   43.927066] [<ffffffc00088b0cc>] sync_fence_free+0x74/0x9c
>> [   43.932552] [<ffffffc00088b128>] sync_fence_release+0x34/0x48
>> [   43.938304] [<ffffffc000317bbc>] __fput+0x100/0x1b8
>> [   43.943185] [<ffffffc000317cc8>] ____fput+0x8/0x14
>> [   43.947982] [<ffffffc000237f38>] task_work_run+0xb0/0xe4
>> [   43.953297] [<ffffffc000207074>] do_notify_resume+0x44/0x5c
>> [   43.958867] ---[ end trace 5a2aa4027cc5d171 ]---
> This crash report seems to be for a 3.18 kernel. Can you reproduce it
> on upstream kernel as well?
>
> 	Gustavo
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

