Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4EK5H9v004226
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 16:05:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4EK4atJ028474
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 16:04:55 -0400
Date: Wed, 14 May 2008 17:04:05 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Message-ID: <20080514170405.330c0d0a@gaivota>
In-Reply-To: <20080514193822.GA21795@cs181133002.pp.htv.fi>
References: <20080514114910.4bcfd220@gaivota>
	<20080514165434.GC22115@cs181133002.pp.htv.fi>
	<20080514145554.10e3385c@gaivota>
	<20080514193822.GA21795@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	linux-dvb-maintainer@linuxtv.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PATCHES] V4L/DVB fixes for 2.6.26
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


> > > I can make a patch for it after this pull went into Linus' tree if it is 
> > > considered an acceptable option.
> > 
> > It would be nice if you could help on fixing those issues.
> > 
> > One dependency that will probably solve is to add "depends on VIDEO_MEDIA &&
> > I2C" to all devices that are hybrid (bttv, saa7134, cx88, pvrusb, em28xx).
> 
> What about converting all dependencies on I2C to select's?

This seems to be a good idea.

> VIDEO_V4L2_COMMON might perhaps need a small trick,

I suspect that this can now be replaced by VIDEO_DEV, on webcam/radio drivers
or VIDEO_MEDIA for hybrid V4L/DVB drivers. Btw, I think we can replace
VIDEO_MEDIA into just MEDIA.

> but otherwise that 
> would be a straightforward solution to solve these problems.

This will solve several troubles. Still, I think that there are still some
other missing dependencies (like INPUT, on drivers that select IR).
> 
> Any problem I miss or should I bake a patch?

I can't see any trouble on this approach. Feel free to work on it.

Thanks,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
