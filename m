Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1JEHPgK019658
	for <video4linux-list@redhat.com>; Tue, 19 Feb 2008 09:17:25 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1JEGspW021663
	for <video4linux-list@redhat.com>; Tue, 19 Feb 2008 09:16:54 -0500
Date: Tue, 19 Feb 2008 11:16:40 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Bongani Hlope <bonganilinux@mweb.co.za>
Message-ID: <20080219111640.409870a9@gaivota>
In-Reply-To: <200802190121.36280.bonganilinux@mweb.co.za>
References: <200802171036.19619.bonganilinux@mweb.co.za>
	<20080218131125.2857f7c7@gaivota>
	<200802182320.40732.bonganilinux@mweb.co.za>
	<200802190121.36280.bonganilinux@mweb.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc[12] Video4Linux Bttv Regression
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

On Tue, 19 Feb 2008 01:21:36 +0200
Bongani Hlope <bonganilinux@mweb.co.za> wrote:

> On Monday 18 February 2008 23:20:40 Bongani Hlope wrote:
> > On Monday 18 February 2008 18:11:25 Mauro Carvalho Chehab wrote:
> > > Have you tested Robert's patch?
> >
> > Sorry almost forgot, I have and it fixes the TV but not the radio.
> >
> > > I can't see anything wrong on bttv_g_tuner lock. I suspect that the
> > > divide error caused some bad effects at some data on bttv.
> >
> >  The problems don't seem related because one is caused by opening the
> > "radio" application, the divide error is caused by using a TV viewing
> > application (I tried fbtv)
> >
> > > I've already applied his fix to my -git tree:
> >
> > Thanx, I'll try to bisect
> 
> I tried to bisect but the V4L/DVB changes are not bisect friendly, on two 
> occursions I just selected "git bisect bad" because the bttv driver wouldn't 
> compile, so I couldn't pin-point what causes the oops and hang.
> 
> Here are some few observations I made though (I started bisecting between 
> 2.6.24 and 2.6.25-rc1, saved me ~1000 commits):
> 1. On the third bisect, there's no oops my PC just hangs a I can't use any 
> open terminals
> 2. When I reached the V4L/DVB changes, my PC did not hag or oops, the radio 
> just didn't work (something about invalid VID**AUD**). This made it harder to 
> bisect, because it is not working and not breaking so is it good or bad...

Bisecting this won't be that easy. The support for the depreciated V4L1 API
were removed from bttv driver. Now, it uses v4l1-compat module, that translates
a V4L1 call into a V4L2 one. I'll try to seek for troubles at the current code.


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
