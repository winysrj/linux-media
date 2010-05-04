Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080Ab0EDCJi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 May 2010 22:09:38 -0400
Date: Mon, 3 May 2010 23:09:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Guy Martin <gmsoft@tuxicoman.be>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] stv090x Fix kernel oops when plugging two cards
Message-ID: <20100503230924.3f560423@pedra>
In-Reply-To: <20100411231529.1538cf69@borg.bxl.tuxicoman.be>
References: <20100411231529.1538cf69@borg.bxl.tuxicoman.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 11 Apr 2010 23:15:29 +0200
Guy Martin <gmsoft@tuxicoman.be> escreveu:

> Etiquetas: NonJunk 
> From: Guy Martin <gmsoft@tuxicoman.be>
> To: linux-media@vger.kernel.org
> Subject: [PATCH] stv090x Fix kernel oops when plugging two cards
> Date: Sun, 11 Apr 2010 23:15:29 +0200
> Sender: linux-media-owner@vger.kernel.org
> X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
> 
> 
> Hi linux-media,
> 
> This patch fix initialization of the TT s2-1600 card when plugging two
> of them in the same box. The frontend relies on the fact that
> state->config->tuner_sleep is set to put the tuner sleep. However the
> config struct is shared amongst all cards. The patch adds a check for
> fe->tuner_priv to be set, validating that a tuner has been attached to
> the frontend.
> 
> This has been introduced in commit 5ff2bc2dc92c on linux-tv's v4l-dvb mercurial.
> 
> Signed-off-by : Guy Martin <gmsoft@tuxicoman.be>
> 
> For reference, here is the null pointer deref :
> [   96.521023] saa7146: register extension 'budget dvb'.
> [   96.521052] budget dvb 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   96.521070] IRQ 16/: IRQF_DISABLED is not guaranteed on shared IRQs
> [   96.521076] saa7146: found saa7146 @ mem ffffc90011182c00 (revision 1, irq 16) (0x13c2,0x101c). 
> [   96.521080] saa7146 (0): dma buffer size 192512
> [   96.521081] DVB: registering new adapter (TT-Budget S2-1600 PCI)
> [   96.539929] adapter has MAC addr = 00:d0:5c:cc:b0:a2 
> [   96.890149] stv6110x_attach: Attaching STV6110x 
> [   96.912516] DVB: registering adapter 0 frontend 0 (STV090x Multistandard)...
> [   96.912600] budget dvb 0000:05:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [   96.912639] IRQ 17/: IRQF_DISABLED is not guaranteed on shared IRQs
> [   96.912667] saa7146: found saa7146 @ mem ffffc90011314800 (revision 1, irq 17) (0x13c2,0x101c). 
> [   96.912673] saa7146 (1): dma buffer size 192512
> [   96.912676] DVB: registering new adapter (TT-Budget S2-1600 PCI)
> [   96.930893] adapter has MAC addr = 00:d0:5c:cc:b0:a3 
> [   97.233478] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
> [   97.233647] IP: [<ffffffffa029c450>] stv6110x_set_mode+0x70/0x80 [stv6110x]
> [   97.233753] PGD 3c16f067 PUD 3c383067 PMD 0 
> [   97.234147] CPU 0 
> [   97.234246] Pid: 5200, comm: modprobe Not tainted 2.6.33.2 #1 P5Q SE/P5Q SE
> [   97.234317] RIP: 0010:[<ffffffffa029c450>]  [<ffffffffa029c450>] stv6110x_set_mode+0x70/0x80 [stv6110x]
> [   97.234456] RSP: 0018:ffff88003c125c98  EFLAGS: 00010246
> [   97.234461] RAX: ffffffffa029c460 RBX: ffff88003f84d800 RCX: ffff88003a19e140
> [   97.234461] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> [   97.234461] RBP: ffff88003f84d828 R08: 0000000000000002 R09: 0000000000000004
> [   97.234461] R10: 0000000000000003 R11: 0000000000000010 R12: ffff88003f84d800
> [   97.234461] R13: ffff88003f84d828 R14: ffff88003f84d828 R15: 0000000000000001
> [   97.234461] FS:  00007f9f7253e6f0(0000) GS:ffff880001800000(0000) knlGS:0000000000000000
> [   97.234461] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   97.234461] CR2: 0000000000000010 CR3: 000000003c382000 CR4: 00000000000006b0
> [   97.234461] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   97.234461] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   97.234461] Process modprobe (pid: 5200, threadinfo ffff88003c124000, task ffff88003e893ac0)
> [   97.234461]  ffff88003f84d800 ffff88003f84d828 ffff88003f84d800 ffffffffa0292343
> [   97.234461] <0> ffff88003f84d828 ffff88003ef70ae0 ffffffffa0280800 ffffffffa02934d2
> [   97.234461] <0> ffffffffa0295260 0000000000000000 ffffffffa02948b0 ffff88003df79800
> [   97.234461]  [<ffffffffa0292343>] ? stv090x_sleep+0x33/0x120 [stv090x]
> [   97.234461]  [<ffffffffa02934d2>] ? stv090x_attach+0x1e2/0x73c [stv090x]
> [   97.234461]  [<ffffffff81007cc5>] ? dma_generic_alloc_coherent+0xa5/0x160
> [   97.234461]  [<ffffffffa026e1f5>] ? saa7146_init_one+0x7d5/0x910 [saa7146]
> [   97.234461]  [<ffffffff811b84b2>] ? local_pci_probe+0x12/0x20
> [   97.234461]  [<ffffffff811b87d0>] ? pci_device_probe+0x110/0x120
> [   97.234461]  [<ffffffff81221788>] ? driver_probe_device+0x98/0x1b0
> [   97.234461]  [<ffffffff81221933>] ? __driver_attach+0x93/0xa0
> [   97.234461]  [<ffffffff812218a0>] ? __driver_attach+0x0/0xa0 
> [   97.234461]  [<ffffffff81220f18>] ? bus_for_each_dev+0x58/0x80
> [   97.234461]  [<ffffffff8122079d>] ? bus_add_driver+0x14d/0x280
> [   97.234461]  [<ffffffffa0284000>] ? budget_init+0x0/0xc [budget]
> [   97.234461]  [<ffffffff81221c29>] ? driver_register+0x79/0x170
> [   97.234461]  [<ffffffffa0284000>] ? budget_init+0x0/0xc [budget]
> [   97.234461]  [<ffffffff811b8a48>] ? __pci_register_driver+0x58/0xe0
> [   97.234461]  [<ffffffffa0284000>] ? budget_init+0x0/0xc [budget]
> [   97.234461]  [<ffffffff810001d5>] ? do_one_initcall+0x35/0x190
> [   97.234461]  [<ffffffff81063d37>] ? sys_init_module+0xe7/0x260
> [   97.234461]  [<ffffffff8100256b>] ? system_call_fastpath+0x16/0x1b
> [   97.234461] RIP  [<ffffffffa029c450>] stv6110x_set_mode+0x70/0x80 [stv6110x]
> [   97.234461]  RSP <ffff88003c125c98>
> [   97.240074] ---[ end trace b53ecbbbbef15e99 ]---
> 
> 
> Regards,
>   Guy
> 
> diff -r 7c0b887911cf linux/drivers/media/dvb/frontends/stv090x.c
> --- a/linux/drivers/media/dvb/frontends/stv090x.c	Mon Apr 05 22:56:43 2010 -0400
> +++ b/linux/drivers/media/dvb/frontends/stv090x.c	Sun Apr 11 13:46:43 2010 +0200
> @@ -4664,7 +4664,7 @@
>  	if (stv090x_i2c_gate_ctrl(state, 1) < 0)
>  		goto err;
>  
> -	if (state->config->tuner_sleep) {
> +	if (fe->tuner_priv && state->config->tuner_sleep) {

This fix seem to be at the wrong place. There's nothing on stv090x.c that require
a not null value for fe->tuner_priv.

However, by looking at drivers/media/dvb/frontends/stv6110x.c, we see:

static int stv6110x_sleep(struct dvb_frontend *fe)
{
        return stv6110x_set_mode(fe, TUNER_SLEEP);
}

and: 

static int stv6110x_set_mode(struct dvb_frontend *fe, enum tuner_mode mode)
{
        struct stv6110x_state *stv6110x = fe->tuner_priv;
...

So, a better fix for your bug is to add a check for fe->tuner_priv inside stv6110x_sleep().

-- 

Cheers,
Mauro
