Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3UJ4PB2003944
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 15:04:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3UJ4EYC019142
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 15:04:14 -0400
Date: Wed, 30 Apr 2008 16:03:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Patrick Boettcher <patrick.boettcher@desy.de>
Message-ID: <20080430160354.29dfe255@gaivota>
In-Reply-To: <Pine.LNX.4.64.0804300953140.480@pub4.ifh.de>
References: <20080429185009.716c3284@gaivota>
	<Pine.LNX.4.64.0804300953140.480@pub4.ifh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-dvb-maintainer@linuxtv.org, Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB updates and fixes
 for 2.6.26
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

Hi Patrick

On Wed, 30 Apr 2008 10:02:43 +0200 (CEST)
Patrick Boettcher <patrick.boettcher@desy.de> wrote:

> Hi Mauro,
> 
> sorry to say that now and not earlier, but:
> 
> On Tue, 29 Apr 2008, Mauro Carvalho Chehab wrote:
> > .../{dvb/frontends => common/tuners}/mt2266.c      |    0
> > .../{dvb/frontends => common/tuners}/mt2266.h      |    4 +-
> 
> The mt2266 is a zero-IF (baseband) tuner. I think there is no analog 
> decoder for this kind of tuners.

Ah, ok. I'm not 100% sure, but I think some chips, like cx88 could theoretically
support a baseband tuner. But you're right: there's no known board using mt2266. 

> Maybe the move was not necessary, but maybe all tuners should go to 
> common.

Good point. 

It seems easier to maintain if we should move all terrestrial/cable [1]
(analog and/or digital) tuners into common/tuners. 

Cheers,
Mauro


[1] I don't see any technical sense of moving satellite tuners, except for
having just one place for all tuners, or if there are some tendency of hybrid
satellite/terrestrial tuners.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
