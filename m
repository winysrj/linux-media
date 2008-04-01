Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m31KoA0E010292
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 16:50:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m31KnwTF002885
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 16:49:58 -0400
Date: Tue, 1 Apr 2008 17:49:19 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Brandon Philips <brandon@ifup.org>
Message-ID: <20080401174919.4bdc3c54@gaivota>
In-Reply-To: <20080401031130.GA18963@plankton.ifup.org>
References: <patchbomb.1206699511@localhost> <20080328160946.029009d8@gaivota>
	<20080329052559.GA4470@plankton.ifup.org>
	<20080331153555.6adca09b@gaivota>
	<20080331192618.GA21600@plankton.ifup.org>
	<20080331183136.3596bfb3@gaivota>
	<20080401031130.GA18963@plankton.ifup.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

On Mon, 31 Mar 2008 20:11:30 -0700
Brandon Philips <brandon@ifup.org> wrote:

> On 18:31 Mon 31 Mar 2008, Mauro Carvalho Chehab wrote:
> > > > The patch is wrong. 
> > > 
> > > The patch fixes the unsafe way vivi is doing multiple opens right now
> > > and I am uninterested in spending anymore time trying to fix up vivi
> > > right now.  If you could fix vivi up that would be great.  
> > 
> > If the issue is specific to to vivi, that's ok. I'm just wandering if the
> > changesets would break a driver for a real device.
> > 
> > Unfortunately, I couldn't test your patch on a real hardware. The hardware I use
> > here to test PCI boards is currently broken[1].
> 
> I have tested my series on saa7134 hardware and it went OK.  Although,
> having someone else play with my patchset would be nice :)

Have you tested to run ffmpeg or mencoder under /dev/video0, while listening to
something using mmap()? The errors I got with vivi seems to occur if I do something like:

App A starts streaming;
App B starts streaming;
Stop A app -> OOPS

I didn't got error with this sequence:

App A starts streaming;
App B starts streaming;
Stop B;
Stop A.

> > > > 	2) you can see a program with an userspace app and record the
> > > > 	stream with another app. Both xawtv and xdtv do this, when you
> > > > 	ask for record: They call mencoder, asking it to read from
> > > > 	/dev/video0. This way, you'll have the tv app reading, using
> > > > 	mmap() or overlay methods, while mencoder is calling read() to
> > > > 	receive the stream.
> > > 
> > > Yes, I know.  But, vivi has no permission control mechanism right now
> > > for differentiating between streaming file handles and control ones.
> > 
> > What the other drivers do is to implement a small code for this lock. You may
> > take a look on res_get(), for example, on cx88. 
> 
> Yes, I know.  But, I don't don't have time to fix vivi up all the way.

Ok. Could you please update your tree with the latest patches? I think the
better way is to merge they on v4l/dvb and ask more people to test.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
