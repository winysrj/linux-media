Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBQD999K016493
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 08:09:09 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBQD8sDk022856
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 08:08:55 -0500
Date: Fri, 26 Dec 2008 11:08:33 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Luca Olivetti <luca@ventoso.org>, Ingo Molnar <mingo@elte.hu>
Message-ID: <20081226110833.7e61bb20@caramujo.chehab.org>
In-Reply-To: <20081225103050.GA553@elte.hu>
References: <20081224121252.7560391e@caramujo.chehab.org>
	<20081225081907.GA4628@elte.hu> <20081225103050.GA553@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCHES for 2.6.28] V4L/DVB fixes
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Luca,

Could you please verify this issue?

Ingo,
What .config you used to get this error?

Cheers,
Mauro.

On Thu, 25 Dec 2008 11:30:50 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> i also needed the patch below.
> 
> 	Ingo
> --------------->
> From 62595544017bd8865adba84f7dd0796b5acc9794 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Thu, 25 Dec 2008 11:27:22 +0100
> Subject: [PATCH] dvb/usb: work around this crash for now:
> 
> [    8.585448] calling  opera1_module_init+0x0/0x40
> [    8.592370] usbcore: registered new interface driver opera1
> [    8.597879] initcall opera1_module_init+0x0/0x40 returned 0 after 5 msecs
> [    8.602341] calling  af9005_usb_module_init+0x0/0xb0
> [    8.609143] usbcore: registered new interface driver dvb_usb_af9005
> [    8.613625] BUG: unable to handle kernel paging request at ff100000
> [    8.619858] IP: [<c0c21b02>] af9005_usb_module_init+0x92/0xb0
> [    8.619858] *pdpt = 0000000000c6b001 *pde = 0000000000000000
> [    8.623858] Oops: 0000 [#1] SMP
> [    8.623858]
> [    8.623858] Pid: 1, comm: swapper Not tainted (2.6.26-rc6-tip-00382-g5bf10cd-dirty #8770)
> [    8.623858] EIP: 0060:[<c0c21b02>] EFLAGS: 00010286 CPU: 1
> [    8.623858] EIP is at af9005_usb_module_init+0x92/0xb0
> [    8.623858] EAX: ff100000 EBX: 00000000 ECX: 00000000 EDX: f6c55ee8
> [    8.623858] ESI: 00000000 EDI: 00000000 EBP: f6c55f60 ESP: f6c55f54
> [    8.623858]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    8.623858] Process swapper (pid: 1, ti=f6c54000 task=f6c538a0 task.ti=f6c54000)
> [    8.623858] Stack: 00000005 00000000 00000005 f6c55fe0 c0bef7f4 c0a2e531 00000000 00000005
> [    8.623858]        00000000 f6c54000 00d25d95 00000002 c0c50d8c c0c21a70 00000000 6f727200
> [    8.623858]        6f632072 2d206564 00203232 f6c53490 f6c55fac c0125568 f6c57fc0 c0103c66
> [    8.623858] Call Trace:
> [    8.623858]  [<c0bef7f4>] ? kernel_init+0x1a4/0x2b0
> [    8.623858]  [<c0c21a70>] ? af9005_usb_module_init+0x0/0xb0
> [    8.623858]  [<c0125568>] ? schedule_tail+0x18/0x50
> [    8.623858]  [<c0103c66>] ? ret_from_fork+0x6/0x20
> [    8.623858]  [<c0bef650>] ? kernel_init+0x0/0x2b0
> [    8.623858]  [<c0bef650>] ? kernel_init+0x0/0x2b0
> [    8.623858]  [<c0104fa7>] ? kernel_thread_helper+0x7/0x10
> [    8.623858]  =======================
> [    8.623858] Code: c3 89 44 24 04 c7 04 24 60 72 ae c0 e8 28 8e 50 ff 89 d8 83 c4 08 5b 5d c3 b8 00 00 10 ff 85 c0 74 c1 b8 00 00 10 ff 85 c0 74 b8 <a1> 00 00 10 ff c7 05 b4 96 b9 c0 00 00 10 ff a3 b8 96 b9 c0 eb
> [    8.635859] EIP: [<c0c21b02>] af9005_usb_module_init+0x92/0xb0 SS:ESP 0068:f6c55f54
> [    8.635859] Kernel panic - not syncing: Fatal exception
> [    8.635859] Pid: 1, comm: swapper Tainted: G      D   2.6.26-rc6-tip-00382-g5bf10cd-dirty #8770
> [    8.635859]  [<c0129cfb>] panic+0x4b/0x110
> [    8.635859]  [<c01059b5>] die+0x115/0x180
> [    8.635859]  [<c0118cfc>] do_page_fault+0x2ac/0x880
> [    8.635859]  [<c01d5abb>] ? sysfs_addrm_finish+0x1b/0x1c0
> [    8.635859]  [<c0118a50>] ? do_page_fault+0x0/0x880
> [    8.635859]  [<c08d1212>] error_code+0x72/0x80
> [    8.635859]  [<c0c21b02>] ? af9005_usb_module_init+0x92/0xb0
> [    8.635859]  [<c0bef7f4>] kernel_init+0x1a4/0x2b0
> [    8.635859]  [<c0c21a70>] ? af9005_usb_module_init+0x0/0xb0
> [    8.635859]  [<c0125568>] ? schedule_tail+0x18/0x50
> [    8.635859]  [<c0103c66>] ? ret_from_fork+0x6/0x20
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/media/dvb/dvb-usb/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
> index 1d1b3c2..448d42b 100644
> --- a/drivers/media/dvb/dvb-usb/Kconfig
> +++ b/drivers/media/dvb/dvb-usb/Kconfig
> @@ -236,6 +236,7 @@ config DVB_USB_OPERA1
>  config DVB_USB_AF9005
>  	tristate "Afatech AF9005 DVB-T USB1.1 support"
>  	depends on DVB_USB && EXPERIMENTAL
> +	depends on BROKEN
>  	select MEDIA_TUNER_MT2060 if !MEDIA_TUNER_CUSTOMIZE
>  	select MEDIA_TUNER_QT1010 if !MEDIA_TUNER_CUSTOMIZE
>  	help




Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
