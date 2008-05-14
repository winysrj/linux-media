Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4EHvTIh012539
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 13:57:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4EHv1Nm009964
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 13:57:18 -0400
Date: Wed, 14 May 2008 14:55:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Message-ID: <20080514145554.10e3385c@gaivota>
In-Reply-To: <20080514165434.GC22115@cs181133002.pp.htv.fi>
References: <20080514114910.4bcfd220@gaivota>
	<20080514165434.GC22115@cs181133002.pp.htv.fi>
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

On Wed, 14 May 2008 19:54:34 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> On Wed, May 14, 2008 at 11:49:10AM -0300, Mauro Carvalho Chehab wrote:
> >...
> > PS.: There are yet a number of other Kconfig potential breakages at V4L/DVB. I'm 
> > currently working on fixing those issues. Basically, what users do is to select 
> > I2C, DVB and V4L as module. This works fine, but more complex scenarios where
> > you mix 'M' and 'Y' inside the subsystem generally cause compilation breakage.
> > Those scenarios are more theorical, since there's not much practical sense on
> > having a DVB driver foo as module, and V4L driver bar as in-kernel. However,
> > the better is to not allow compilation of the scenarios that don't work.
> > 
> > The main trouble at drivers/media Kbuild is that several rules there assumed that
> > "select" would check the "depends on" dependencies of the selected drivers.
> > However, this feature doesn't exist at the current Kbuild implementation. Even
> > if implemented, I suspect that this will generate circular dependency errors on
> > some cases.
> >...
> 
> The basic problem is that drivers/media/ does the most fancy kconfig 
> stuff in the kernel since it tries to both have very fine grained 
> dependencies and offer a usable kconfig UI to the user, which results
> in very complicated dependencies.

True.

> We are not getting this solved by any changes in the kconfig 
> implementation.
> 
> Thinking about reasonable ways to reduce the problem space:
> 
> Where could we reduce the complexity without big disadvantages?
> 
> Could we e.g. let VIDEO_DEV select I2C which would remove all the 
> fiddling with I2C dependencies (which is a bigger part of recent
> problems)?

This seems to be reasonable. However, there are quite a few devices that don't
need I2C (for example, some legacy ISA radio modules - also, some webcam
drivers don't use i2c layer to communicate with their i2c sensor - so - they
don't need I2C. The same also applies to some DVB drivers).

So, I'm not sure if this would be a good idea, since it will force I2C even for
devices that don't need. This is bad, for example, on embedded devices like
set-top-boxes and maybe on cellular phones with non-i2c webcams.

> I can make a patch for it after this pull went into Linus' tree if it is 
> considered an acceptable option.

It would be nice if you could help on fixing those issues.

One dependency that will probably solve is to add "depends on VIDEO_MEDIA &&
I2C" to all devices that are hybrid (bttv, saa7134, cx88, pvrusb, em28xx).

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
