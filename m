Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38277 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaI1LMR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Sep 2014 07:12:17 -0400
Date: Sun, 28 Sep 2014 08:12:11 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org
Subject: Re: em28xx breaks after hibernate
Message-ID: <20140928081211.4b26aa18@recife.lan>
In-Reply-To: <20140928105540.GA28748@linuxtv.org>
References: <20140926084215.772adce9@recife.lan>
	<20140926090316.5ae56d93@recife.lan>
	<20140926122721.GA11597@linuxtv.org>
	<20140926101222.778ebcaf@recife.lan>
	<20140926132513.GA30084@linuxtv.org>
	<20140926142543.GA3806@linuxtv.org>
	<54257888.90802@osg.samsung.com>
	<20140926150602.GA15766@linuxtv.org>
	<20140926152228.GA21876@linuxtv.org>
	<20140926124309.558c8682@recife.lan>
	<20140928105540.GA28748@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 28 Sep 2014 12:55:40 +0200
Johannes Stezenbach <js@linuxtv.org> escreveu:

> On Fri, Sep 26, 2014 at 12:43:09PM -0300, Mauro Carvalho Chehab wrote:
> > Em Fri, 26 Sep 2014 17:22:28 +0200
> > Johannes Stezenbach <js@linuxtv.org> escreveu:
> > 
> > > On Fri, Sep 26, 2014 at 05:06:02PM +0200, Johannes Stezenbach wrote:
> > > > 
> > > > [   20.212162] usb 1-1: reset high-speed USB device number 2 using ehci-pci
> > > > [   20.503868] em2884 #0: Resuming extensions
> > > > [   20.505275] em2884 #0: Resuming video extensionem2884 #0: Resuming DVB extension
> > > > [   20.533513] drxk: status = 0x439130d9
> > > > [   20.534282] drxk: detected a drx-3913k, spin A2, xtal 20.250 MHz
> > > > [   23.008852] em2884 #0: writing to i2c device at 0x52 failed (error=-5)
> > > > [   23.011408] drxk: i2c write error at addr 0x29
> > > > [   23.013187] drxk: write_block: i2c write error at addr 0x8303b4
> > > > [   23.015440] drxk: Error -5 while loading firmware
> > > > [   23.017291] drxk: Error -5 on init_drxk
> > > > [   23.018835] em2884 #0: fe0 resume 0
> > > > 
> > > > Any idea on this?
> > > 
> > > I backed out Mauro's test patch, now it seems to work
> > > (v3.17-rc5-734-g214635f, no patches, em28xx as modules).
> > > But I'm not 100% sure the above was related to this,
> > > it seemed the 930C got upset during all the testing
> > > and I had to unplug it to get it back working.
> > 
> > Could you please test again with the patch? Without it, I suspect that,
> > if you suspend while streaming, the frontend won't relock again after
> > resume. Of course, I may be wrong ;)
> 
> I tried again both with and without the patch.  The issue above
> odesn't reproduce, but after hibernate it fails to tune
> (while it works after suspend-to-ram).  Restarting dvbv5-zap
> does not fix it.  All I get is:
> 
> [  500.299216] drxk: Error -22 on dvbt_sc_command
> [  500.301012] drxk: Error -22 on set_dvbt
> [  500.301967] drxk: Error -22 on start

Just to be 100% sure if I understood well: you're having exactly
the same behavior with and without my patch, right?

If so, I guess I'll keep it, as we'll likely need to add more stuff
for the frontend resume logic, and with that patch, it now have some
space to add an specific restart sequence at resume.

I'll see if I can work on another patch for you today. If not,
I won't be able to touch on it until the end of the week, as I'm
traveling next week.

> There are no other errors messages during hibernate + resume.
> It happens whether I let dvbv5-zap run during hibernate
> or stop it first. 


> On rmmod it Oopsed:
> 
> root@debian:~# rmmod em28xx_dvb em28xx_v4l drxk em28xx
> [ 1992.790039] em2884 #0: Closing DVB extension
> [ 1992.797623] xc5000 2-0061: destroying instance
> [ 1992.799595] general protection fault: 0000 [#1] PREEMPT SMP
> [ 1992.800032] Modules linked in: drxk em28xx_dvb(-) em28xx_v4l videobuf2_vmalloc videobuf2_memops videobuf2_core em28xx tveeprom
> [ 1992.800032] CPU: 3 PID: 2095 Comm: rmmod Not tainted 3.17.0-rc5-00734-g214635f-dirty #91
> [ 1992.800032] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [ 1992.800032] task: ffff88003cf700d0 ti: ffff88003c398000 task.ti: ffff88003c398000
> [ 1992.800032] RIP: 0010:[<ffffffff81320721>]  [<ffffffff81320721>] release_firmware+0x2c/0x52
> [ 1992.800032] RSP: 0000:ffff88003c39be58  EFLAGS: 00010246
> [ 1992.800032] RAX: ffffffff8188d408 RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000006
> [ 1992.800032] RDX: 0000000000000004 RSI: ffff88003cf70860 RDI: 6b6b6b6b6b6b6b6b
> [ 1992.800032] RBP: ffff88003c39be60 R08: 0000000000000200 R09: 0000000000000001
> [ 1992.800032] R10: ffff88003c39bcc0 R11: ffffffff82ac6100 R12: ffff88003bc5a000
> [ 1992.800032] R13: ffff88003d6a81c8 R14: 00007fd6e977d090 R15: 0000000000000800
> [ 1992.800032] FS:  00007fd6e8633700(0000) GS:ffff88003e200000(0000) knlGS:0000000000000000
> [ 1992.800032] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 1992.800032] CR2: 0000000000400184 CR3: 000000003b996000 CR4: 00000000000006a0
> [ 1992.800032] Stack:
> [ 1992.800032]  ffff88003befcc00 ffff88003c39be80 ffffffff813cbd36 ffff88003bc5a000
> [ 1992.800032]  ffff88003baa2000 ffff88003c39bea0 ffffffff813e2f75 ffff88003d6a8000
> [ 1992.800032]  ffff88003baa2000 ffff88003c39bec8 ffffffffa0046804 ffff88003baa2000
> [ 1992.800032] Call Trace:
> [ 1992.800032]  [<ffffffff813cbd36>] xc5000_release+0xa0/0xbf
> [ 1992.800032]  [<ffffffff813e2f75>] dvb_frontend_detach+0x35/0x7d
> [ 1992.800032]  [<ffffffffa0046804>] em28xx_dvb_fini+0x195/0x1d0 [em28xx_dvb]
> [ 1992.800032]  [<ffffffffa0009211>] em28xx_unregister_extension+0x3d/0x79 [em28xx]
> [ 1992.800032]  [<ffffffffa0048e20>] em28xx_dvb_unregister+0x10/0x1f0 [em28xx_dvb]
> [ 1992.800032]  [<ffffffff810942e8>] SyS_delete_module+0x141/0x19e
> [ 1992.800032]  [<ffffffff81488792>] system_call_fastpath+0x16/0x1b
> [ 1992.800032] Code: 48 85 ff 48 c7 c0 08 d4 88 81 48 89 e5 53 48 89 fb 74 3b 48 3d 08 d4 88 81 74 10 48 8b 50 08 48 39 53 08 74 18 48 83 c0 18 eb e8 <48> 8b 7b 18 48 85 ff 75 13 48 8b 7b 08 e8 32 16 de ff 48 89 df
> [ 1992.800032] RIP  [<ffffffff81320721>] release_firmware+0x2c/0x52
> [ 1992.800032]  RSP <ffff88003c39be58>
> [ 1992.867774] ---[ end trace 499f4df0704fd661 ]---
> 
> (xc5000 is non-modular because it is autoselected by some dependency)

Please try this change:

[media] em28xx: remove firmware before releasing xc5000 priv state

hybrid_tuner_release_state() can free the priv state, so we need to
release the firmware before calling it.

Signed-off-by: Mauro Carvalho Chehab

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index e44c8aba6074..803a0e63d47e 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -1333,9 +1333,9 @@ static int xc5000_release(struct dvb_frontend *fe)
 
 	if (priv) {
 		cancel_delayed_work(&priv->timer_sleep);
-		hybrid_tuner_release_state(priv);
 		if (priv->firmware)
 			release_firmware(priv->firmware);
+		hybrid_tuner_release_state(priv);
 	}
 
 	mutex_unlock(&xc5000_list_mutex);

> 
> 
> Johannes
