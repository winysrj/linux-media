Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m45KYwNf002024
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 16:34:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m45KYjST019828
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 16:34:45 -0400
Date: Mon, 5 May 2008 16:34:23 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <20080502150645.GA23481@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0805051625090.3218@bombadil.infradead.org>
References: <20080430110115.GA5633@elte.hu> <s5hiqxzwqak.wl%tiwai@suse.de>
	<20080430.041703.89847530.davem@davemloft.net>
	<20080430112959.GA32556@uranus.ravnborg.org>
	<20080430121854.GC30735@elte.hu>
	<20080502150645.GA23481@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: video4linux-list@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
	Takashi Iwai <tiwai@suse.de>, efault@gmx.de,
	linux-kernel@vger.kernel.org, linux-dvb-maintainer@linuxtv.org,
	Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>
Subject: Re: [patch, -git] media/video/sound build fix, TEA5761/TEA5767
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

> Which is exactly what my "require SYMBOL2 would give us.
> A webcam would not depends on USB, but would "require USB".
> If the decide to include the webcam she will optionally be prompted
> so she can decide if it is OK to include USB support too

This would be a nice feature. In fact, some SELECT's were wrongly added 
in the past, at V4L/DVB Kconfig's as people understood that this would be 
the behaviour of SELECT.

IMO, I think it is preferred that "SELECT" could act as you've described: 
Check if all dependencies for the selected symbol are satisfied. If not, 
auto-selects or prompt to the users.

The auto-select feature, without prompting could be very helpful to allow 
testing kconfig items, since, instead of running all randomconfig's, 
subsystem maintainers can use scripts that will do something like 
allnoconfig, and then select just the symbols requested by each driver 
(*).


(*) Something like:
 	make select="DRIVER_FOO"
 		and
 	make select="DRIVER_FOO_MODULE"

could just do this: marks NO to everything and Y (or M) to the symbol, and 
just the required dependencies for that symbol to compile.

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
