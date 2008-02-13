Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1DLsN7D014926
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 16:54:23 -0500
Received: from mail7.sea5.speakeasy.net (mail7.sea5.speakeasy.net
	[69.17.117.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1DLs1B2021445
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 16:54:01 -0500
Date: Wed, 13 Feb 2008 13:53:55 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Ricardo Cerqueira <v4l@cerqueira.org>
In-Reply-To: <1202935004.17260.54.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.58.0802131349400.6264@shell2.speakeasy.net>
References: <20080212190235.4e86baf8@gaivota>
	<Pine.LNX.4.58.0802122120530.7642@shell2.speakeasy.net>
	<20080213155352.06d966cd@gaivota>
	<Pine.LNX.4.58.0802131025440.6264@shell2.speakeasy.net>
	<1202935004.17260.54.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB fixes
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

On Wed, 13 Feb 2008, Ricardo Cerqueira wrote:
> On Wed, 2008-02-13 at 10:45 -0800, Trent Piepho wrote:
> > On Wed, 13 Feb 2008, Mauro Carvalho Chehab wrote:
> > > On Tue, 12 Feb 2008 21:21:43 -0800 (PST)
> > > Trent Piepho <xyzzy@speakeasy.org> wrote:
> > >
> > Nobody points to any issues, ever, when this happens.  Look at how broken
> > the v4l2 only bttv driver was.  You still can't unload and load cx88-dvb
> > since Markus's patch for hotplug, no one's fixed that regression.  Now
> > there's yet another race in the cx88 subdriver code.  Maybe the original
> > author who added that code should feel some motiviation to fix the
> > regressions it caused....
>
> Read the code that was actually committed: here's a helpful link:
>
> http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=41a93616082af630e7242cba766a161d7847560b

I did.  Looks like there is a race on access to core->active_ref.

> > I don't have the time or the desire to be the janitor who cleans up after
> > sloppy coders' bugs.
>
> You properly raised a red flag, and got a fix in return.
> Don't expect fixes to be accompanied by a "are you happy now?"
> follow-up; if you took the time to check the first commit, take the time
> to read the rest.

You could also CC the relevant parties.  Unless you're hoping they won't
notice something.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
