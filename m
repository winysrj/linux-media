Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56391 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752478AbZBAWzS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Feb 2009 17:55:18 -0500
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] general protection fault: 0000 [1] SMP with 2.6.27 and	2.6.28
Date: Sun, 1 Feb 2009 23:38:48 +0100
References: <49565ABD.7030209@clara.co.uk> <498467E3.4010403@clara.co.uk> <1233524352.3091.51.camel@palomino.walls.org>
In-Reply-To: <1233524352.3091.51.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902012338.49861@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Sat, 2009-01-31 at 15:01 +0000, Chris Mayo wrote:
> > > I've been seeing general protection fault's with 2.6.27 and 2.6.28
> > > (gentoo-sources, amd64) used with vdr. Unfortunately I can't reproduce
> > > them on demand.
> > > 
> > 
> > Two more of these with 2.6.28 so I switched back to 2.6.25 and now four
> > weeks with no more
> > 
> > > 
> > > 
> > > vdr: [5577] switching device 2 to channel 2
> > > DVB: frontend 1 frequency limits undefined - fix the driver
> > > general protection fault: 0000 [1] SMP
> > > CPU 0
> > > Modules linked in: snd_pcm_oss snd_mixer_oss it87 hwmon_vid r8169
> > > dvb_ttpci saa7146_vv videobuf_dma_sg videobuf_core sp8870 budget l64781
> > > ves1x93 budget_ci lnbp21 budget_core saa7146 ttpci_eeprom tda1004x
> > > ir_common tda10023 stv0299 k8temp snd_hda_intel snd_pcm snd_timer snd
> > > snd_page_alloc forcedeth i2c_nforce2
> > > Pid: 5721, comm: kdvb-fe-1 Not tainted 2.6.27-gentoo-r5 #1
> > > RIP: 0010:[<ffffffffa00e8a79>]  [<ffffffffa00e8a79>]
> > > grundig_29504_401_tuner_set_params+0x39/0x100 [budget]
> > > RSP: 0018:ffff88003d3edda0  EFLAGS: 00010202
> > > RAX: ffff88003d3eddb0 RBX: ffff88003e0de000 RCX: 00000000ffffffff
> > > RDX: 2802000000000004 RSI: ffff88003efe5808 RDI: ffff88003efe4010
> > > RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> > > R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003efe5808
> > > vdr: [5720] changing pids of channel 30 from 203+203:407=eng,408=und:0:0
> > > to 203+203:407=eng,408=und:603=eng:0
> > > R13: ffff88003efe4000 R14: 000000001d324372 R15: ffff88003efe59d8
> > > FS:  0000000045a17950(0000) GS:ffffffff80710600(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > > CR2: 0000000000f86000 CR3: 0000000000201000 CR4: 00000000000006e0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > Process kdvb-fe-1 (pid: 5721, threadinfo ffff88003d3ec000, task
> > > ffff88003f2cd890)
> > > Stack:  0000000400000000 ffff88003d3eddb0 ffff88003f2cd890 7fffffffffffffff
> > > ffff88003efe4010 ffffffffa00e5660 ffff88003d3edec0 ffff88003efe59d8
> > > ffff88003efe59b0 ffffffff8059815d 00000000ffffffff ffff88003efe5800
> > > Call Trace:
> > > [<ffffffffa00e5660>] apply_frontend_param+0x40/0x3e0 [l64781]
> > > [<ffffffff8059815d>] schedule_timeout+0xad/0xf0
> > > [<ffffffff8041c45d>] dvb_frontend_swzigzag_autotune+0xcd/0x220
> > > [<ffffffff80598a2c>] __down_interruptible+0x9c/0xd0
> > > [<ffffffff8041ceba>] dvb_frontend_swzigzag+0x19a/0x290
> > > [<ffffffff802549b6>] down_interruptible+0x36/0x60
> > > [<ffffffff8041d3b8>] dvb_frontend_thread+0x408/0x4c0
> > > [<ffffffff80250570>] autoremove_wake_function+0x0/0x30
> > > [<ffffffff8041cfb0>] dvb_frontend_thread+0x0/0x4c0
> > > [<ffffffff802501b7>] kthread+0x47/0x80
> > > [<ffffffff80232887>] schedule_tail+0x27/0x70
> > > [<ffffffff8020ca49>] child_rip+0xa/0x11
> > > [<ffffffff80250170>] kthread+0x0/0x80
> > > [<ffffffff8020ca3f>] child_rip+0x0/0x11
> > > 
> > > 
> > > Code: 97 d0 02 00 00 48 8b 58 38 48 8d 44 24 10 48 85 d2 48 c7 04 24 00
> > > 00 00 00 66 c7 44 24 04 04 00 48 89 44 24 08 0f 84 af 00 00 00 <0f> b6
> > > 02 66 89 04 24 8b 0e b8 05 3d 95 0c 44 8d 81 48 39 27 02
> > > RIP  [<ffffffffa00e8a79>] grundig_29504_401_tuner_set_params+0x39/0x100
> > > [budget]
> > > RSP <ffff88003d3edda0>
> > > ---[ end trace 33ec88b18fe8a71a ]---
> 
> This one and the two other are all suffering from the same error a
> derefernce of the %rdx register that points to garbage.
> 
> The source code in question is in
> linux/drivers/media/dvb/ttpci/budget.c:grundig_29504_401_tuner_set_params():
> 
> static int grundig_29504_401_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
> {
>         struct budget *budget = fe->dvb->priv;
>         u8 *tuner_addr = fe->tuner_priv;
>         u32 div;
>         u8 cfg, cpump, band_select;
>         u8 data[4];
>         struct i2c_msg msg = { .flags = 0, .buf = data, .len = sizeof(data) };
> 
>         if (tuner_addr)
>                 msg.addr = *tuner_addr;
>         else
>                 msg.addr = 0x61;
> 
>         div = (36125000 + params->frequency) / 166666;
> [...]
> 
> The oops code disassembles to this
> 
>   13:	48 8b 58 38          	mov    0x38(%rax),%rbx
>   17:	48 8d 44 24 10       	lea    0x10(%rsp),%rax
>   1c:	48 85 d2             	test   %rdx,%rdx       if (tuner_addr) ...
>   1f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)     msg.flags = 0
>   26:	00 
>   27:	66 c7 44 24 04 04 00 	movw   $0x4,0x4(%rsp)  msg.len = sizeof(data)
>   2e:	48 89 44 24 08       	mov    %rax,0x8(%rsp)  msg.buf = data
>   33:	0f 84 af 00 00 00    	je     0xe8            if (tuner_addr) ...
>   39:	0f b6 02             	movzbl (%rdx),%eax     *tuner_addr  <--- Ooops is here	
>   3c:	66 89 04 24          	mov    %ax,(%rsp)
>   40:	8b 0e                	mov    (%rsi),%ecx
>   42:	b8 05 3d 95 0c       	mov    $0xc953d05,%eax        1/166666 (times 0x200000000000)
>   47:	44 8d 81 48 39 27 02 	lea    0x2273948(%rcx),%r8d   36125000 + params->frequency
> 
> 
> So tuner_addr is non-NULL and is not a valid pointer either.
> 
> It looks like linux/drivers/media/dvb/ttpci/budget.c:frontend_init() is
> setting the pointer up properly.  So something else is trashing the
> struct dvb_frontend structure pointed to by the variable fe.  Finding
> what's doing that will be difficult.
> 
> Without a device nor steps to reliably reproduce, that's about all I can
> help with.
> 
> Regards,
> Andy

Afaik this bug was fixed in changeset
http://linuxtv.org/hg/v4l-dvb/rev/f4d7d0b84940

CU
Oliver


-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------
