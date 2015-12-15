Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:36777 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964956AbbLORW6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2015 12:22:58 -0500
Received: by mail-io0-f170.google.com with SMTP id o67so26878639iof.3
        for <linux-media@vger.kernel.org>; Tue, 15 Dec 2015 09:22:58 -0800 (PST)
Received: from mail-ig0-f169.google.com (mail-ig0-f169.google.com. [209.85.213.169])
        by smtp.gmail.com with ESMTPSA id j28sm1394287ioo.3.2015.12.15.09.22.57
        for <linux-media@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Tue, 15 Dec 2015 09:22:57 -0800 (PST)
Received: by mail-ig0-f169.google.com with SMTP id mv3so107690961igc.0
        for <linux-media@vger.kernel.org>; Tue, 15 Dec 2015 09:22:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151215133020.GD883@joana>
References: <20151215012955.GA28277@dtor-ws>
	<20151215133020.GD883@joana>
Date: Tue, 15 Dec 2015 09:22:56 -0800
Message-ID: <CAE_wzQ_4ygv3h0tvScLihR+j9xg=OL1kS2qxE-KNH2DOxRNgUw@mail.gmail.com>
Subject: Re: [PATCH] android: fix warning when releasing active sync point
From: Dmitry Torokhov <dtor@chromium.org>
To: Gustavo Padovan <gustavo@padovan.org>,
	Dmitry Torokhov <dtor@chromium.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Andrew Bresticker <abrestic@chromium.org>,
	=?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
	dri-devel@lists.freedesktop.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Riley Andrews <riandrews@android.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 15, 2015 at 5:30 AM, Gustavo Padovan <gustavo@padovan.org> wrote:
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
>
> This crash report seems to be for a 3.18 kernel. Can you reproduce it
> on upstream kernel as well?

Unfortunately this board does not run upsrteam just yet, but looking
at the sync driver and fence code we are pretty much in sync with
upstream.

Thanks.

-- 
Dmitry
