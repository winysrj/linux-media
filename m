Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46244
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbcGIK3s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jul 2016 06:29:48 -0400
Message-ID: <5780D216.9000604@osg.samsung.com>
Date: Sat, 09 Jul 2016 11:29:42 +0100
From: Luis de Bethencourt <luisbg@osg.samsung.com>
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>, kyungmin.park@samsung.com,
	k.debski@samsung.com, jtp.park@samsung.com, mchehab@kernel.org,
	javier@osg.samsung.com
CC: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: s5p-mfc fix invalid memory access from s5p_mfc_release()
References: <1468016965-10880-1-git-send-email-shuahkh@osg.samsung.com>
In-Reply-To: <1468016965-10880-1-git-send-email-shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/07/16 23:29, Shuah Khan wrote:
> If s5p_mfc_release() runs after s5p_mfc_remove(), the former will access
> invalid s5p_mfc_dev pointer saved in the s5p_mfc_ctx and runs into kernel
> paging request errors.
> 
> Clear ctx dev pointer in s5p_mfc_remove() and change s5p_mfc_release() to
> avoid work that requires ctx->dev.
> 
> odroid kernel: Unable to handle kernel paging request at virtual address
>     f17c1104
> odroid kernel: pgd = ebca4000
> odroid kernel: [f17c1104] *pgd=6e23d811, *pte=00000000, *ppte=00000000
> odroid kernel: Internal error: Oops: 807 [#1] PREEMPT SMP ARM
> odroid kernel: Modules linked in: cpufreq_userspace cpufreq_powersave
>     cpufreq_conservative s5p_mfc s5p_jpeg v4l2_mem2mem
>     videobuf2_dma_contig videobuf2_memops videobuf2_v4l2 videobuf2_core
>     v4l2_common videodev media
> odroid kernel: Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
> odroid kernel: task: c2241400 ti: e7018000 task.ti: e7018000
> odroid kernel: PC is at s5p_mfc_reset+0x40/0x28c [s5p_mfc]
> odroid kernel: LR is at s5p_mfc_reset+0x34/0x28c [s5p_mfc]
> odroid kernel: pc : [<bf15bfbc>]    lr : [<bf15bfb0>] psr: 60010013
> odroid kernel: [<bf15bfbc>] (s5p_mfc_reset [s5p_mfc]) from [<bf15c62c>]
>     (s5p_mfc_deinit_hw+0x14/0x3c [s5p_mfc])
> odroid kernel: [<bf15c62c>] (s5p_mfc_deinit_hw [s5p_mfc]) from [<bf155958>]
>     (s5p_mfc_release+0xac/0x1c4 [s5p_mfc])
> odroid kernel: [<bf155958>] (s5p_mfc_release [s5p_mfc]) from [<bf021344>]
>     (v4l2_release+0x38/0x74 [videodev])
> odroid kernel: [<bf021344>] (v4l2_release [videodev]) from [<c01e4274>]
>     (__fput+0x80/0x1c8)
> odroid kernel: [<c01e4274>] (__fput) from [<c0135c58>]
>     (task_work_run+0x94/0xc8)
> odroid kernel: [<c0135c58>] (task_work_run) from [<c010a9d4>]
>     (do_work_pending+0x7c/0xa4)
> odroid kernel: [<c010a9d4>] (do_work_pending) from [<c0107794>]
>     (slow_work_pending+0xc/0x20)
> odroid kernel: Code: eb3edacc e5953078 e3a06000 e2833c11 (e5836004)
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---

Thanks Shuah.

I've been following this while playing with an ODROID XU4 to fix some issues
in v4l2 usage in GStreamer. So I offered Shuah to test this for her.

Looks good :)

Tested-by: Luis de Bethencourt <luisbg@osg.samsung.com>
