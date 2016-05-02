Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:63674 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbcEBUuk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 May 2016 16:50:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2] s5p-mfc: Don't try to put pm->clock if lookup failed
Date: Mon, 02 May 2016 22:49:58 +0200
Message-ID: <3778841.dDMP2IXCSZ@wuerfel>
In-Reply-To: <1462216462-32665-1-git-send-email-javier@osg.samsung.com>
References: <1462216462-32665-1-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 02 May 2016 15:14:22 Javier Martinez Canillas wrote:
> Failing to get the struct s5p_mfc_pm .clock is a non-fatal error so the
> clock field can have a errno pointer value. But s5p_mfc_final_pm() only
> checks if .clock is not NULL before attempting to unprepare and put it.
> 
> This leads to the following warning in clk_put() due s5p_mfc_final_pm():
> 
> WARNING: CPU: 3 PID: 1023 at drivers/clk/clk.c:2814 s5p_mfc_final_pm+0x48/0x74 [s5p_mfc]
> CPU: 3 PID: 1023 Comm: rmmod Tainted: G        W       4.6.0-rc6-next-20160502-00005-g5a15a49106bc #9
> Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
> [<c010e1bc>] (unwind_backtrace) from [<c010af28>] (show_stack+0x10/0x14)
> [<c010af28>] (show_stack) from [<c032485c>] (dump_stack+0x88/0x9c)
> [<c032485c>] (dump_stack) from [<c011b8e8>] (__warn+0xe8/0x100)
> [<c011b8e8>] (__warn) from [<c011b9b0>] (warn_slowpath_null+0x20/0x28)
> [<c011b9b0>] (warn_slowpath_null) from [<bf16004c>] (s5p_mfc_final_pm+0x48/0x74 [s5p_mfc])
> [<bf16004c>] (s5p_mfc_final_pm [s5p_mfc]) from [<bf157414>] (s5p_mfc_remove+0x8c/0x94 [s5p_mfc])
> [<bf157414>] (s5p_mfc_remove [s5p_mfc]) from [<c03fe1f8>] (platform_drv_remove+0x24/0x3c)
> [<c03fe1f8>] (platform_drv_remove) from [<c03fcc70>] (__device_release_driver+0x84/0x110)
> [<c03fcc70>] (__device_release_driver) from [<c03fcdd8>] (driver_detach+0xac/0xb0)
> [<c03fcdd8>] (driver_detach) from [<c03fbff8>] (bus_remove_driver+0x4c/0xa0)
> [<c03fbff8>] (bus_remove_driver) from [<c01886a8>] (SyS_delete_module+0x174/0x1b8)
> [<c01886a8>] (SyS_delete_module) from [<c01078c0>] (ret_fast_syscall+0x0/0x3c)
> 
> Assign the pointer to NULL in case of a lookup failure to fix the issue.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
