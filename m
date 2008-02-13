Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1DHsVPx018326
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 12:54:31 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1DHs9d4005389
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 12:54:09 -0500
Date: Wed, 13 Feb 2008 15:53:52 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Message-ID: <20080213155352.06d966cd@gaivota>
In-Reply-To: <Pine.LNX.4.58.0802122120530.7642@shell2.speakeasy.net>
References: <20080212190235.4e86baf8@gaivota>
	<Pine.LNX.4.58.0802122120530.7642@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com,
	Ricardo Cerqueira <ricardo@cerqueira.org>,
	linux-kernel@vger.kernel.org, linux-dvb-maintainer@linuxtv.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
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

On Tue, 12 Feb 2008 21:21:43 -0800 (PST)
Trent Piepho <xyzzy@speakeasy.org> wrote:

> On Tue, 12 Feb 2008, Mauro Carvalho Chehab wrote:
> >    - cx88-mpeg: Allow concurrent access to cx88-mpeg devices;
> 
> So you decided to just commit this one with the race condition anyway?

The version with problems is the one dated by Jan, 16:
http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-January/006119.html

As Ricardo stated on Feb, 5, he fixed the lock issues, that were present on
your first revision:

http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-February/006292.html

I've pushed the reviewed version at the same day, for testing, at the
development environment:

http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-February/006326.html

Nobody pointed any newer issues on the reviewed version, since then.

If you still see any issues, please send us a patch fixing it.

Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
