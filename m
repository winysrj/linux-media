Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m72EMrg7004516
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 10:22:53 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m72EMZwq010542
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 10:22:36 -0400
Date: Sat, 2 Aug 2008 16:22:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200808021530.33194.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0808021619140.25553@axis700.grange>
References: <87myjv1sfo.fsf@free.fr> <200808021530.33194.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Allocation of micron MT9M111 chip v42l ident ID
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

On Sat, 2 Aug 2008, Hans Verkuil wrote:

> On Saturday 02 August 2008 15:02:03 Robert Jarzmik wrote:
> > Hello,
> >
> > I will submit within the next few hours/days a driver for a Micron
> > mt9m111 camera chip. I know only one flavor of the MT9M111 chip,
> > there are no distinctions like monochrome/color models.
> >
> > Would that be possible to have a chip ID assigned in
> > v4l2-chip-ident.h, eg. something like :
> > +	V4L2_IDENT_MT9M111		= ???,
> > Is there a procedure for such things ?
> >
> > I'll wait for an answer before submitting the mt9m111 driver.
> 
> Just provide a patch for that header. Usually the number chosen is 
> similar to the chip type number. In this case I guess 9111 is a good 
> choice.

As I didn't know this rule, I just took the next free round enough number 
range:

	/* Micron CMOS sensor chips: 45000-45099 */
	V4L2_IDENT_MT9M001C12ST		= 45000,
	V4L2_IDENT_MT9M001C12STM	= 45005,
	V4L2_IDENT_MT9V022IX7ATC	= 45010, /* No way to detect "normal" I77ATx */
	V4L2_IDENT_MT9V022IX7ATM	= 45015, /* and "lead free" IA7ATx chips */

So, you can just as well continue this group as yours is called similarly 
and comes from the same manufacturer. We might guess, that "M" after MT9 
means some similarity, so, you can put yours somewhere between MT9M001 and 
MT9V022, although, doesn't really matter.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
