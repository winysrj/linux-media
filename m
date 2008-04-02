Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m32IsoNA028478
	for <video4linux-list@redhat.com>; Wed, 2 Apr 2008 14:54:50 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m32Isb79009815
	for <video4linux-list@redhat.com>; Wed, 2 Apr 2008 14:54:37 -0400
Received: by yw-out-2324.google.com with SMTP id 3so304456ywj.81
	for <video4linux-list@redhat.com>; Wed, 02 Apr 2008 11:54:32 -0700 (PDT)
Date: Wed, 2 Apr 2008 11:54:24 -0700
From: Brandon Philips <brandon@ifup.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080402185423.GA7281@plankton.ifup.org>
References: <patchbomb.1206699511@localhost> <20080328160946.029009d8@gaivota>
	<20080329052559.GA4470@plankton.ifup.org>
	<20080331153555.6adca09b@gaivota>
	<20080331192618.GA21600@plankton.ifup.org>
	<20080331183136.3596bfb3@gaivota>
	<20080401031130.GA18963@plankton.ifup.org>
	<20080401174919.4bdc3c54@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401174919.4bdc3c54@gaivota>
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

On 17:49 Tue 01 Apr 2008, Mauro Carvalho Chehab wrote:
> On Mon, 31 Mar 2008 20:11:30 -0700
> Brandon Philips <brandon@ifup.org> wrote:
> 
> > On 18:31 Mon 31 Mar 2008, Mauro Carvalho Chehab wrote:
> > > > > The patch is wrong. 
> > > > 
> > > > The patch fixes the unsafe way vivi is doing multiple opens right now
> > > > and I am uninterested in spending anymore time trying to fix up vivi
> > > > right now.  If you could fix vivi up that would be great.  
> > > 
> > > If the issue is specific to to vivi, that's ok. I'm just wandering if the
> > > changesets would break a driver for a real device.
> > > 
> > > Unfortunately, I couldn't test your patch on a real hardware. The hardware I use
> > > here to test PCI boards is currently broken[1].
> > 
> > I have tested my series on saa7134 hardware and it went OK.  Although,
> > having someone else play with my patchset would be nice :)
> 
> Have you tested to run ffmpeg or mencoder under /dev/video0, while listening to
> something using mmap()? The errors I got with vivi seems to occur if I do something like:
> 
> App A starts streaming;
> App B starts streaming;
> Stop A app -> OOPS
> 
> I didn't got error with this sequence:
> 
> App A starts streaming;
> App B starts streaming;
> Stop B;
> Stop A.

On saa7134 I can't start more than one application streaming at once.
The other application gets -EBUSY when it tries to do streamon.

I tried with mplayer and fswebcam and combinations of them.

I did get fswebcam using read() and mplayer using mmap() and it worked
fine, although each application was only getting half the frames.

How do you use ffmpeg/mencoder with v4l2 devices?  I Googled around but
couldn't find anything that worked.

> > > > > 	2) you can see a program with an userspace app and record the
> > > > > 	stream with another app. Both xawtv and xdtv do this, when you
> > > > > 	ask for record: They call mencoder, asking it to read from
> > > > > 	/dev/video0. This way, you'll have the tv app reading, using
> > > > > 	mmap() or overlay methods, while mencoder is calling read() to
> > > > > 	receive the stream.
> > > > 
> > > > Yes, I know.  But, vivi has no permission control mechanism right now
> > > > for differentiating between streaming file handles and control ones.
> > > 
> > > What the other drivers do is to implement a small code for this lock. You may
> > > take a look on res_get(), for example, on cx88. 
> > 
> > Yes, I know.  But, I don't don't have time to fix vivi up all the way.
> 
> Ok. Could you please update your tree with the latest patches? I think the
> better way is to merge they on v4l/dvb and ask more people to test.

Updated with Jon's comments too and I just removed the copyright updates
for vivi- too much trouble: http://ifup.org/hg/v4l-dvb

Thanks,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
