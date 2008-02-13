Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1DKbDJW023688
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 15:37:13 -0500
Received: from mail.isp.novis.pt (onyx.ip.pt [195.23.92.252])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1DKapGo030418
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 15:36:51 -0500
From: Ricardo Cerqueira <v4l@cerqueira.org>
To: linux-dvb-maintainer@linuxtv.org
In-Reply-To: <Pine.LNX.4.58.0802131025440.6264@shell2.speakeasy.net>
References: <20080212190235.4e86baf8@gaivota>
	<Pine.LNX.4.58.0802122120530.7642@shell2.speakeasy.net>
	<20080213155352.06d966cd@gaivota>
	<Pine.LNX.4.58.0802131025440.6264@shell2.speakeasy.net>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 20:36:44 +0000
Message-Id: <1202935004.17260.54.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
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

On Wed, 2008-02-13 at 10:45 -0800, Trent Piepho wrote:
> On Wed, 13 Feb 2008, Mauro Carvalho Chehab wrote:
> > On Tue, 12 Feb 2008 21:21:43 -0800 (PST)
> > Trent Piepho <xyzzy@speakeasy.org> wrote:
> >
> > The version with problems is the one dated by Jan, 16:
> > http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-January/006119.html
> >
> > As Ricardo stated on Feb, 5, he fixed the lock issues, that were present on
> > your first revision:
> >
> > http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-February/006292.html
> 
> I don't see what you are saying in that message.  Ricardo agreed it had a
> race condition and said he would, at some future point, redo it, but I
> never saw a new patch.

You missed it, then:

http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-February/006293.html

was sent in 25 minutes after the message Mauro mentioned.


> Nobody points to any issues, ever, when this happens.  Look at how broken
> the v4l2 only bttv driver was.  You still can't unload and load cx88-dvb
> since Markus's patch for hotplug, no one's fixed that regression.  Now
> there's yet another race in the cx88 subdriver code.  Maybe the original
> author who added that code should feel some motiviation to fix the
> regressions it caused....

Read the code that was actually committed: here's a helpful link:

http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=41a93616082af630e7242cba766a161d7847560b


> 
> I don't have the time or the desire to be the janitor who cleans up after
> sloppy coders' bugs.

You properly raised a red flag, and got a fix in return.
Don't expect fixes to be accompanied by a "are you happy now?"
follow-up; if you took the time to check the first commit, take the time
to read the rest.

Now... it looks as if you simply missed the second patch; it happens.
But next time you feel like sending this kind of message(s) to 3
separate lists, at least check your mail history (or read the code
you're commenting).

--
RC

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
