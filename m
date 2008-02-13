Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1DHx4L8023109
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 12:59:04 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1DHwgPm008862
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 12:58:42 -0500
Date: Wed, 13 Feb 2008 15:58:28 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Robert Fitzsimons <robfitz@273k.net>
Message-ID: <20080213155828.4140b36c@gaivota>
In-Reply-To: <20080213163634.GA2798@localhost>
References: <20080213163634.GA2798@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Michael@redhat.com,
	linux-kernel@vger.kernel.org, Schimek <mschimek@gmx.at>
Subject: Re: [PATCH] bttv: Fix overlay divide error.
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

On Wed, 13 Feb 2008 16:38:11 +0000
Robert Fitzsimons <robfitz@273k.net> wrote:

> The initial work to convert the bttv driver to V4L2 "Partial conversion
> from V4L1 to V4L2" (e84619b17440ccca4e4db7583d126c4189b987e5), missed
> the line which set the appropriate overlay crop structure in the newly
> allocated bttv_buffer.  This then causes a divide error in the
> bttv_calc_geo function.
> 
> Signed-off-by: Robert Fitzsimons <robfitz@273k.net>

Applied, thanks.

> ---
>  drivers/media/video/bt8xx/bttv-driver.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> Hi Mauro
> 
> This patch against Linus's git tree fixes an overlay regression in the
> bttv driver in 2.6.25-rc1.
> 
> Robert
> 
>  divide error: 0000 [#1]
>  Modules linked in: usbhid hid ipt_MASQUERADE iptable_nat nf_nat ipt_LOG xt_limit xt_tcpudp nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables pppoe pppox ppp_generic slhc ipv6 tuner tea5767 tda8290 tda18271 tda827x tuner_xc2028 xc5000 tda9887 tuner_simple mt20xx tea5761 tvaudio msp3400 bttv videodev v4l1_compat ir_common compat_ioctl32 i2c_algo_bit v4l2_common videobuf_dma_sg videobuf_core btcx_risc tveeprom pcspkr i2c_core snd_bt87x ehci_hcd uhci_hcd sg usbcore sr_mod
> 
>  Pid: 8691, comm: xawtv.bin Not tainted (2.6.25-rc1-00051-g96b5a46 #9)
>  EIP: 0060:[<e0addeb5>] EFLAGS: 00210246 CPU: 0
>  EIP is at bttv_calc_geo+0x1a5/0x287 [bttv]
>  EAX: 00000000 EBX: 00000180 ECX: 00000000 EDX: 00000000
>  ESI: 00000000 EDI: cbcc12a0 EBP: b8239dd8 ESP: b8239d98
>   DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
>  Process xawtv.bin (pid: 8691, ti=b8239000 task=b71c5000 task.ti=b8239000)
>  Stack: 00000000 cbcc107c 00000000 e0af708c 81979820 0000002a 00200297 b8239de0
>         00000000 00000004 000000d0 00000054 803c028c 9a6ee4d8 00000000 e0ae3b90
>         b8239e04 e0ade946 00000120 00000000 e0ae3708 cbcc12d4 e0af708c 00000000
>  Call Trace:
>   [<e0ade946>] ? bttv_overlay_risc+0x98/0x12d [bttv]
>   [<e0adb60b>] ? bttv_overlay+0xa6/0xcd [bttv]
>   [<e09914af>] ? __video_do_ioctl+0x1076/0x2b48 [videodev]
>   [<80143e1d>] ? slob_page_alloc+0x144/0x19e
>   [<e099320e>] ? video_ioctl2+0x19f/0x24b [videodev]
>   [<80120a3a>] ? autoremove_wake_function+0x0/0x30
>   [<801230b4>] ? ktime_get+0x13/0x2f
>   [<802bc933>] ? unix_ioctl+0x83/0x8c
>   [<8027c46a>] ? sock_ioctl+0x1aa/0x1cb
>   [<e099306f>] ? video_ioctl2+0x0/0x24b [videodev]
>   [<8014eaa4>] ? vfs_ioctl+0x3c/0x4f
>   [<8014ecae>] ? do_vfs_ioctl+0x1f7/0x205
>   [<8019dae6>] ? copy_to_user+0x2a/0x34
>   [<8014ece8>] ? sys_ioctl+0x2c/0x48
>   [<801029b2>] ? syscall_call+0x7/0xb
>   =======================
>  Code: 5f 04 0f 46 45 e0 d1 ea 89 45 e0 89 c8 c1 e0 0c 01 d0 31 d2 f7 f3 8b 55 14 66 2d 00 10 66 89 47 06 89 d8 0f af 02 31 d2 8d 04 01 <f7> f1 8b 4d e0 8b 55 10 66 89 4f 0a 83 e0 fe 66 89 45 ca 66 89
>  EIP: [<e0addeb5>] bttv_calc_geo+0x1a5/0x287 [bttv] SS:ESP 0068:b8239d98
>  ---[ end trace 588d2506a3db8987 ]---
> 
> 
> diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
> index 907dc62..c152b81 100644
> --- a/drivers/media/video/bt8xx/bttv-driver.c
> +++ b/drivers/media/video/bt8xx/bttv-driver.c
> @@ -2760,6 +2760,7 @@ static int bttv_overlay(struct file *file, void *f, unsigned int on)
>  	if (on) {
>  		fh->ov.tvnorm = btv->tvnorm;
>  		new = videobuf_pci_alloc(sizeof(*new));
> +		new->crop = btv->crop[!!fh->do_crop].rect;
>  		bttv_overlay_risc(btv, &fh->ov, fh->ovfmt, new);
>  	} else {
>  		new = NULL;




Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
