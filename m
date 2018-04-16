Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46018 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752941AbeDPIuf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 04:50:35 -0400
Date: Mon, 16 Apr 2018 10:50:15 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, Warren Sturm <warren.sturm@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Andy Walls <awalls.cx18@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH stable v4.15 1/3] media: staging: lirc_zilog: broken
 reference counting
Message-ID: <20180416085015.GA2598@kroah.com>
References: <cover.1523785117.git.sean@mess.org>
 <2bd4184fbea37ecdfcb0a334c6bef45786feb486.1523785117.git.sean@mess.org>
 <20180416075228.GB2121@kroah.com>
 <20180416084344.k4e3tx4jd5lswfh3@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180416084344.k4e3tx4jd5lswfh3@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 16, 2018 at 09:43:45AM +0100, Sean Young wrote:
> On Mon, Apr 16, 2018 at 09:52:28AM +0200, Greg KH wrote:
> > On Sun, Apr 15, 2018 at 10:54:20AM +0100, Sean Young wrote:
> > > commit 615cd3fe6ccc ("[media] media: lirc_dev: make better use of
> > > file->private_data") removed the reference get from open, so on the first
> > > close the reference count hits zero and the lirc device is freed.
> > > 
> > > BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
> > > IP: lirc_thread+0x94/0x520 [lirc_zilog]
> > > PGD 22d69c067 P4D 22d69c067 PUD 22d69d067 PMD 0
> > > Oops: 0000 [#1] SMP NOPTI
> > > CPU: 2 PID: 701 Comm: zilog-rx-i2c-7 Tainted: P         C OE    4.15.14-300.fc27.x86_64 #1
> > > Hardware name: Gigabyte Technology Co., Ltd. GA-MA790FXT-UD5P/GA-MA790FXT-UD5P, BIOS F6 08/06/2009
> > > RIP: 0010:lirc_thread+0x94/0x520 [lirc_zilog]
> > > RSP: 0018:ffffb482c131be98 EFLAGS: 00010246
> > > RAX: 0000000000000000 RBX: ffff8fdabf056000 RCX: 0000000000000000
> > > RDX: 0000000000000000 RSI: 0000000000000246 RDI: 0000000000000246
> > > RBP: ffff8fdab740af00 R08: ffff8fdacfd214a0 R09: 0000000000000000
> > > R10: 0000000000000000 R11: 0000000000000040 R12: ffffb482c10dba48
> > > R13: ffff8fdabea89e00 R14: ffff8fdab740af00 R15: ffffffffc0b5e500
> > > FS:  0000000000000000(0000) GS:ffff8fdacfd00000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 0000000000000040 CR3: 00000002124c0000 CR4: 00000000000006e0
> > > Call Trace:
> > >  ? __schedule+0x247/0x880
> > >  ? get_ir_tx+0x40/0x40 [lirc_zilog]
> > >  kthread+0x113/0x130
> > >  ? kthread_create_worker_on_cpu+0x70/0x70
> > >  ? do_syscall_64+0x74/0x180
> > >  ? SyS_exit_group+0x10/0x10
> > >  ret_from_fork+0x22/0x40
> > > Code: 20 8b 85 80 00 00 00 85 c0 0f 84 a6 00 00 00 bf 04 01 00 00 e8 ee 34 d4 d7 e8 69 88 56 d7 84 c0 75 69 48 8b 45 18 c6 44 24 37 00 <48> 8b 58 40 4c 8d 6b 18 4c 89 ef e8 fc 4d d4 d7 4c 89 ef 48 89
> > > RIP: lirc_thread+0x94/0x520 [lirc_zilog] RSP: ffffb482c131be98
> > > CR2: 0000000000000040
> > > This code has been replaced completely in kernel v4.16 by a new driver,
> > > see commit acaa34bf06e9 ("media: rc: implement zilog transmitter"), and
> > > commit f95367a7b758 ("media: staging: remove lirc_zilog driver").
> > > 
> > > Fixes: 615cd3fe6ccc ("[media] media: lirc_dev: make better use of file->private_data")
> > > 
> > > Cc: stable@vger.kernel.org # v4.15
> > > Reported-by: Warren Sturm <warren.sturm@gmail.com>
> > > Tested-by: Warren Sturm <warren.sturm@gmail.com>
> > > Signed-off-by: Sean Young <sean@mess.org>
> > > ---
> > >  drivers/staging/media/lirc/lirc_zilog.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
> > > index 6bd0717bf76e..bf6869e48a0f 100644
> > > --- a/drivers/staging/media/lirc/lirc_zilog.c
> > > +++ b/drivers/staging/media/lirc/lirc_zilog.c
> > > @@ -1291,6 +1291,7 @@ static int open(struct inode *node, struct file *filep)
> > >  
> > >  	lirc_init_pdata(node, filep);
> > >  	ir = lirc_get_pdata(filep);
> > > +	get_ir_device(ir, false);
> > >  
> > >  	atomic_inc(&ir->open_count);
> > >  
> > > -- 
> > > 2.14.3
> > 
> > What is the git commit id of this patch, and the other patches in this
> > series and the 4.14 patch series that you sent out?
> 
> lirc_zilog was dropped in v4.16, so this can't be patched upstream.

Ah you are right, should we just ditch them here as well as they
obviously do not work? :)

> > Please read:
> >     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > for how to do this in a way that I can pick them up.
> 
> These patches have been tested with different types of hardware. Is there
> anything else I can do to get these patches included?

When submitting patches to stable, you need to be explicit as to why
they are needed, and if they are not upstream, why not.

In this case, for obviously broken code that is not used anymore (as
it is gone in 4.16), why don't we just take the patch that removed the
driver to the stable trees as well?

thanks,

greg k-h
