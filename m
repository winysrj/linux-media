Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m31HBtii031703
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 13:11:55 -0400
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.187])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m31HBhi0010088
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 13:11:44 -0400
Received: by rv-out-0910.google.com with SMTP id k15so1296256rvb.51
	for <video4linux-list@redhat.com>; Tue, 01 Apr 2008 10:11:43 -0700 (PDT)
Date: Mon, 31 Mar 2008 20:11:30 -0700
From: Brandon Philips <brandon@ifup.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080401031130.GA18963@plankton.ifup.org>
References: <patchbomb.1206699511@localhost> <20080328160946.029009d8@gaivota>
	<20080329052559.GA4470@plankton.ifup.org>
	<20080331153555.6adca09b@gaivota>
	<20080331192618.GA21600@plankton.ifup.org>
	<20080331183136.3596bfb3@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331183136.3596bfb3@gaivota>
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: Re: [PATCH 0 of 9] videobuf fixes
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

On 18:31 Mon 31 Mar 2008, Mauro Carvalho Chehab wrote:
> > > The patch is wrong. 
> > 
> > The patch fixes the unsafe way vivi is doing multiple opens right now
> > and I am uninterested in spending anymore time trying to fix up vivi
> > right now.  If you could fix vivi up that would be great.  
> 
> If the issue is specific to to vivi, that's ok. I'm just wandering if the
> changesets would break a driver for a real device.
> 
> Unfortunately, I couldn't test your patch on a real hardware. The hardware I use
> here to test PCI boards is currently broken[1].

I have tested my series on saa7134 hardware and it went OK.  Although,
having someone else play with my patchset would be nice :)

> > > 	2) you can see a program with an userspace app and record the
> > > 	stream with another app. Both xawtv and xdtv do this, when you
> > > 	ask for record: They call mencoder, asking it to read from
> > > 	/dev/video0. This way, you'll have the tv app reading, using
> > > 	mmap() or overlay methods, while mencoder is calling read() to
> > > 	receive the stream.
> > 
> > Yes, I know.  But, vivi has no permission control mechanism right now
> > for differentiating between streaming file handles and control ones.
> 
> What the other drivers do is to implement a small code for this lock. You may
> take a look on res_get(), for example, on cx88. 

Yes, I know.  But, I don't don't have time to fix vivi up all the way.

> Btw, we had this lock on past versions of vivi, but this were removed on this
> changeset:
> 
> changeset:   6275:cba23263534b
> user:        bphilips@suse.de <bphilips@suse.de>
> date:        Thu Sep 27 20:55:17 2007 -0300
> files:       linux/drivers/media/video/vivi.c
> description:
> V4L: vivi.c remove the "resource" locking
> 
> The "resource" locking in vivi isn't needed since
> streamon/streamoff/read_stream do mutual exclusion using
> q->reading/q->streaming.
> 
> Maybe we can just revert this changeset.

That won't fix it.  The locking I removed in cba23263534b is not related
to the locking that is required to protect the problems that we are
seeing with opening up multiple mplayers.  The multiple mplayers issue
is mostly related to the shutting down of the kthreads and lack of
locking on the vivi_dev fields.

Cheers,

	Brandon

> [1] I tried to fix it during the weekend, without success. The
> Ethernet interface is not working fine - most of the time, it doesn't
> send packets.  Also, with 2 PCI's inside, only one is working fine. If
> I plug 3 PCI devices, all devices work badly. I tried to replace the
> power supply, but the troubles still continue. I think I'll need to
> start saving some money to buy a newer hardware :(

Isn't shipping hardware to Brazil is really hard?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
