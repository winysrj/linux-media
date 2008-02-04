Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m14CqSi4017815
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 07:52:28 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m14Cq7xI010183
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 07:52:07 -0500
Date: Mon, 4 Feb 2008 10:51:29 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Message-ID: <20080204105129.1bc23bdf@gaivota>
In-Reply-To: <Pine.LNX.4.64.0801272006570.5942@axis700.grange>
References: <Pine.LNX.4.64.0801231646090.4932@axis700.grange>
	<Pine.LNX.4.64.0801272006570.5942@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [RFC PATCH 0/8] Patch series to add soc_camera virtual v4l2 and
 its users
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

On Sun, 27 Jan 2008 20:12:25 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@pengutronix.de> wrote:

> On Wed, 23 Jan 2008, Guennadi Liakhovetski wrote:
> 
> > Hi all
> > 
> > Following the first preliminary version I posted on 11.01 to this list, 
> > following this message I am posting the soc_camera driver, an SoC part for 
> > the PXA27x CPU, two camera drivers, a platform-specific part, that's not 
> > yet in the mainline, so, so far this is only an example, and an auxiliary 
> > i2c driver for a GPIO extender. Also two fourcc codes and a new control 
> > are added to the V4L2 API. A lot of changes since the previous version, 
> > including all new names. This patch series is against 2.6.23. There seem 
> > to have been a few significant changes around v4l2 since then, so, forward 
> > porting it to 2.6.24 will need some work too. But the good news is, that I 
> > do not expect to significantly change this driver any more. So, please 
> > review, comment, and test if you can.
> 
> Mauro, you probably saw this my patch series and the following discussion. 
> A question to you - I have fixed all issues pointed out by Trent Piepho 
> and Sakari Ailus in my local tree, now I have to forward port the patches 
> to
> 
>     ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master
> 
> After this is done, would you be prepared to accept them or do you see any 
> principle problems with those patches?

On a quick look, they seem ok. Yet, I would prefer if you later move the
sensors interface to use v4l2-int-device. This will allow future reusage of
those drivers with other cameras.

I should be analyzing your series today and commit if all are ok.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
