Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB82II0f017294
	for <video4linux-list@redhat.com>; Sun, 7 Dec 2008 21:18:18 -0500
Received: from rn-out-0910.google.com (rn-out-0910.google.com [64.233.170.189])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB82G8jZ012250
	for <video4linux-list@redhat.com>; Sun, 7 Dec 2008 21:16:08 -0500
Received: by rn-out-0910.google.com with SMTP id k32so801749rnd.7
	for <video4linux-list@redhat.com>; Sun, 07 Dec 2008 18:16:07 -0800 (PST)
Message-ID: <ea3b75ed0812071816t9189c47s2d73724e3d780473@mail.gmail.com>
Date: Sun, 7 Dec 2008 21:16:07 -0500
From: "Brian Phelps" <lm317t@gmail.com>
To: alexWe <hondansx@gmx.de>
In-Reply-To: <1228565373925-1621999.post@n2.nabble.com>
MIME-Version: 1.0
References: <510940.57134.qm@web51804.mail.re2.yahoo.com>
	<1228565373925-1621999.post@n2.nabble.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: video4linux-list@redhat.com
Subject: Re: bttv timeouts
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

This seems to be a bug in the bttv-risc.c code, at least according to Vegard
Nossum on the Kernel Dev list:

I found that if you set pixfmt from YVU420 to YUYV in capture.c :
> V4L2_PIX_FMT_YUV420 seems to be the culprit!
> YUYV is the stable rock solid setting
> Right now I am talking to the linux-kernel list trying to track down
> the memory problem we are running into.
>
> The bug that I am running into is on an intel quad core machine, 2x4
> input chip bt878 based pci capture cards with /dev/video0-7
>
> All you have to do is change "count" from 100 to something large like
> 10million or so and change:
> fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
>
> to:
> fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV420;
>

Here is the patch from Vegard, but it caused a select time out using
capture.c.

Hi Brian,
>
> Can you see if this patch helps your problem?
>
>
> Vegard
>
>
> From 84396b14b9059de4a697df4ea4e036a22513436e Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Sat, 22 Nov 2008 12:12:11 +0100
> Subject: [PATCH] bttv: don't compare list_head's .next with NULL
>
> The list implementation doesn't store NULLs in .next/.prev, but
> uses poison values (for-sure invalid pointers). I assume that this
> code wanted to test whether an entry was the last in a list.
>
> This function is only ever called for the video capture list, so
> we know which list to check (it could have been vcapture as well).
>
> Patch is untested!
>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
> drivers/media/video/bt8xx/bttv-risc.c |   10 +++++-----
> 1 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/video/bt8xx/bttv-risc.c
> b/drivers/media/video/bt8xx/bttv-risc.c
> index 5b1b8e4..7a54c99 100644
> --- a/drivers/media/video/bt8xx/bttv-risc.c
> +++ b/drivers/media/video/bt8xx/bttv-risc.c
> @@ -649,14 +649,14 @@ bttv_buffer_activate_video(struct bttv *btv,
>       if (NULL != set->top  &&  NULL != set->bottom) {
>               if (set->top == set->bottom) {
>                       set->top->vb.state    = VIDEOBUF_ACTIVE;
> -                       if (set->top->vb.queue.next)
> +                       if (list_is_last(&set->top->vb.queue,
> &btv->capture))
>                               list_del(&set->top->vb.queue);
>               } else {
>                       set->top->vb.state    = VIDEOBUF_ACTIVE;
>                       set->bottom->vb.state = VIDEOBUF_ACTIVE;
> -                       if (set->top->vb.queue.next)
> +                       if (list_is_last(&set->top->vb.queue,
> &btv->capture))
>                               list_del(&set->top->vb.queue);
> -                       if (set->bottom->vb.queue.next)
> +                       if (list_is_last(&set->bottom->vb.queue,
> &btv->capture))
>                               list_del(&set->bottom->vb.queue);
>               }
>               bttv_apply_geo(btv, &set->top->geo, 1);
> @@ -671,7 +671,7 @@ bttv_buffer_activate_video(struct bttv *btv,
>                     ~0x0f, BT848_COLOR_CTL);
>       } else if (NULL != set->top) {
>               set->top->vb.state  = VIDEOBUF_ACTIVE;
> -               if (set->top->vb.queue.next)
> +               if (list_is_last(&set->top->vb.queue, &btv->capture))
>                       list_del(&set->top->vb.queue);
>               bttv_apply_geo(btv, &set->top->geo,1);
>               bttv_apply_geo(btv, &set->top->geo,0);
> @@ -682,7 +682,7 @@ bttv_buffer_activate_video(struct bttv *btv,
>               btaor(set->top->btswap & 0x0f,   ~0x0f, BT848_COLOR_CTL);
>       } else if (NULL != set->bottom) {
>               set->bottom->vb.state = VIDEOBUF_ACTIVE;
> -               if (set->bottom->vb.queue.next)
> +               if (list_is_last(&set->bottom->vb.queue, &btv->capture))
>                       list_del(&set->bottom->vb.queue);
>               bttv_apply_geo(btv, &set->bottom->geo,1);
>               bttv_apply_geo(btv, &set->bottom->geo,0);
> --
> 1.5.6.5
>
> On Wed, Nov 19, 2008 at 12:24 AM, Brian Phelps <lm317t@gmail.com> wrote:
> > This possible kernel bug (see bottom) is very reproducible when the
> > pci bus gets loaded with traffic, specifically video data.
> > It has been reproduced on 2 identical machines.
> >
> > Please let me know if you need more information
>
> Hi,
>
> Can you reproduce this with CONFIG_DEBUG_SLAB=y?
>
> Can you reproduce this with CONFIG_SLUB=y instead of SLAB? If not,
> could be a genuine bug in SLAB (but I doubt it). If yes, then SLUB
> debugging might help us more than SLAB debugging can.
>
> It sounds likely that bttv driver is involved somehow -- it would fit
> with your description too. Maybe the fact that the same driver is
> serving many devices on the same IRQ? But I guess that shouldn't
> really be a problem.
>
> It would also be interesting to see if you can find more different
> crashes in other places, like the corrupted page tables. Those are
> important clues. Like this:
>
> > [ 2128.370257] PGD 10869067 PUD 23232323 BAD
>
> That looks like a magic number of sorts. This was the only one I could
> find, however:
>
> crypto/anubis.c:      0x83838383U, 0x1b1b1b1bU, 0x0e0e0e0eU, 0x23232323U,
>
> But google has some more info. A google for "23232323 bug" turned up
> this thread:
>
> http://lkml.org/lkml/2008/1/5/51
>
> ...which also involves bttv driver. I've added the Ccs of that discussion.
>
> But it seems that it is not a regression at least. Did you try earlier
> kernels as well?
>
>
> Vegard
>
> --
> "The animistic metaphor of the bug that maliciously sneaked in while
> the programmer was not looking is intellectually dishonest as it
> disguises that the error is the programmer's own creation."
>       -- E. W. Dijkstra, EWD1036
>
> and ....
>
>
> On Sat, Nov 22, 2008 at 2:10 AM, Vegard Nossum <vegard.nossum@gmail.com>
> wrote:
> >> [  527.562373]  ffffffff8043b157 0000000000200200 ffffffffa02810d4
> >> ffff88001e13c600
> >
> > LIST_POISON2 on the stack:
> >
> > include/linux/poison.h:#define LIST_POISON2  ((void *) 0x00200200)
>
> So looking at bttv source code, I wonder what the codes like these are
> trying to do:
>
>                       if (set->top->vb.queue.next)
>                               list_del(&set->top->vb.queue);
>
> Code is ancient, I'll ask Mauro.
> - Hide quoted text -
>
>
> Vegard
>
> --
> "The animistic metaphor of the bug that maliciously sneaked in while
> the programmer was not looking is intellectually dishonest as it
> disguises that the error is the programmer's own creation."
>       -- E. W. Dijkstra, EWD1036
>
> On Sat, Dec 6, 2008 at 7:09 AM, alexWe <hondansx@gmx.de> wrote:
> >
> > Hi,
> >
> > Maybe this can help you. See here:
> > http://n2.nabble.com/Pre-crash-log-td1515298.html#a1621996
> >
> >
> > BR,
> > Alex
> >
> > --
> > View this message in context:
> http://n2.nabble.com/bttv-timeouts-tp1614747p1621999.html
> > Sent from the video4linux-list mailing list archive at Nabble.com.
> >
> > --
> > video4linux-list mailing list
> > Unsubscribe mailto:video4linux-list-request@redhat.com
> ?subject=unsubscribe
> > https://www.redhat.com/mailman/listinfo/video4linux-list
> >
> On Wed, Nov 19, 2008 at 12:24 AM, Brian Phelps <lm317t@gmail.com> wrote:
> > This possible kernel bug (see bottom) is very reproducible when the
> > pci bus gets loaded with traffic, specifically video data.
> > It has been reproduced on 2 identical machines.
> >
> > Please let me know if you need more information
>
> Hi,
>
> Can you reproduce this with CONFIG_DEBUG_SLAB=y?
>
> Can you reproduce this with CONFIG_SLUB=y instead of SLAB? If not,
> could be a genuine bug in SLAB (but I doubt it). If yes, then SLUB
> debugging might help us more than SLAB debugging can.
>
> It sounds likely that bttv driver is involved somehow -- it would fit
> with your description too. Maybe the fact that the same driver is
> serving many devices on the same IRQ? But I guess that shouldn't
> really be a problem.
>
> It would also be interesting to see if you can find more different
> crashes in other places, like the corrupted page tables. Those are
> important clues. Like this:
>
> > [ 2128.370257] PGD 10869067 PUD 23232323 BAD
>
> That looks like a magic number of sorts. This was the only one I could
> find, however:
>
> crypto/anubis.c:      0x83838383U, 0x1b1b1b1bU, 0x0e0e0e0eU, 0x23232323U,
>
> But google has some more info. A google for "23232323 bug" turned up
> this thread:
>
> http://lkml.org/lkml/2008/1/5/51
>
> ...which also involves bttv driver. I've added the Ccs of that discussion.
>
> But it seems that it is not a regression at least. Did you try earlier
> kernels as well?
>
>
> Vegard
>
> --
> "The animistic metaphor of the bug that maliciously sneaked in while
> the programmer was not looking is intellectually dishonest as it
> disguises that the error is the programmer's own creation."
>       -- E. W. Dijkstra, EWD1036
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
