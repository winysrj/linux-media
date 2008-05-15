Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4F0px9s011286
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 20:51:59 -0400
Received: from mail6.sea5.speakeasy.net (mail6.sea5.speakeasy.net
	[69.17.117.8])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4F0pk3q026915
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 20:51:47 -0400
Date: Wed, 14 May 2008 17:51:40 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Adrian Bunk <bunk@kernel.org>
In-Reply-To: <20080514193822.GA21795@cs181133002.pp.htv.fi>
Message-ID: <Pine.LNX.4.58.0805141749470.23876@shell4.speakeasy.net>
References: <20080514114910.4bcfd220@gaivota>
	<20080514165434.GC22115@cs181133002.pp.htv.fi>
	<20080514145554.10e3385c@gaivota>
	<20080514193822.GA21795@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-dvb-maintainer@linuxtv.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB fixes for 2.6.26
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

On Wed, 14 May 2008, Adrian Bunk wrote:
> > It would be nice if you could help on fixing those issues.
> >
> > One dependency that will probably solve is to add "depends on VIDEO_MEDIA &&
> > I2C" to all devices that are hybrid (bttv, saa7134, cx88, pvrusb, em28xx).
>
> What about converting all dependencies on I2C to select's?

Doesn't that just increase the problems with failing to have correct
dependencies?  Anything that selects I2C needs to depend on everything I2C
depends on.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
