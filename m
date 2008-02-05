Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m15CeAoC017728
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 07:40:10 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m15CdnmE001726
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 07:39:49 -0500
Date: Tue, 5 Feb 2008 10:39:05 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Message-ID: <20080205103905.7665112d@gaivota>
In-Reply-To: <Pine.LNX.4.64.0802051050530.5546@axis700.grange>
References: <0810f250d078bf6159de.1202176996@localhost>
	<Pine.LNX.4.64.0802051050530.5546@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: Re: [PATCH 1 of 3] Backed out changeset d002378ff8c2
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

On Tue, 5 Feb 2008 10:52:01 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@pengutronix.de> wrote:

> On Mon, 4 Feb 2008, Brandon Philips wrote:
> 
> > # HG changeset patch
> > # User Brandon Philips <brandon@ifup.org>
> > # Date 1202175426 28800
> > # Node ID 0810f250d078bf6159de69569828c07cb54f4389
> > # Parent  d002378ff8c2d8e8bf3842d8f05469dd68398fc6
> > Backed out changeset d002378ff8c2
> > 
> > This change had a number of issues:
> >  - Adding an undiscussed control
> >  - Adding an unrelated mailimport change
> >  - Adding an unrelated kconfig change
> > 
> > diff --git a/linux/drivers/media/video/Kconfig b/linux/drivers/media/video/Kconfig
> > --- a/linux/drivers/media/video/Kconfig
> > +++ b/linux/drivers/media/video/Kconfig
> 
> Brandon, you wanted -p1 style patches - same for 2/3 and 3/3.

The patch is against -hg tree. So, the patch is correct. However, I've already
committed a backout patch at the tree. Probably, -hg will merge this correctly.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
