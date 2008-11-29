Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAT2QuMw006456
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 21:26:56 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAT2Qiiv028672
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 21:26:44 -0500
Date: Sat, 29 Nov 2008 00:26:34 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-ID: <20081129002634.07c11f7e@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.64.0811290020500.7032@axis700.grange>
References: <uljvhtzst.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0811281707440.4430@axis700.grange>
	<20081128171551.42c1b1e9@pedra.chehab.org>
	<Pine.LNX.4.64.0811290020500.7032@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH] Add ov7725 ov7720 support to ov772x driver
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

On Sat, 29 Nov 2008 00:22:27 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Fri, 28 Nov 2008, Mauro Carvalho Chehab wrote:
> 
> > On Fri, 28 Nov 2008 17:44:14 +0100 (CET)
> > Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > 
> > > Hi,
> > > 
> > > sorry it took me a while to find some time to look at this patch. In 
> > > principle it looks ok, just a couple of notes / questions:
> > > 
> > > (also Mauro): I am not sure if this is ok to submit a change to 
> > > include/media/v4l2-chip-ident.h in this patch, i.e., if I may pull it via 
> > > my tree. Mauro? Or shall it be submitted separately and _after_ it is 
> > > applied we can also push the main part of the patch? Here's the hunk I'm 
> > > talking about:
> > > 
> > > > diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
> > > > index bfe5142..14a205f 100644
> > > > --- a/include/media/v4l2-chip-ident.h
> > > > +++ b/include/media/v4l2-chip-ident.h
> > > > @@ -60,7 +60,8 @@ enum {
> > > >  
> > > >  	/* OmniVision sensors: reserved range 250-299 */
> > > >  	V4L2_IDENT_OV7670 = 250,
> > > > -	V4L2_IDENT_OV772X = 251,
> > > > +	V4L2_IDENT_OV7720 = 251,
> > > > +	V4L2_IDENT_OV7725 = 252,
> > > >  
> > > >  	/* Conexant MPEG encoder/decoders: reserved range 410-420 */
> > > >  	V4L2_IDENT_CX23415 = 415,
> > 
> > It is ok to be in the same patch, but I prefer if you split this into a
> > separate patch, especially since you're renaming the ID for a previous chip.
> 
> Oops, sorry, we cannot separate it that easily - ov772x.c would not 
> compile any more. So, we either have to commit it as a single patch 
> (easy), or make three patches out of it - add new IDs, switch ov772x.c, 
> remove the old ID. I am for the easy version.

I'm in favor of two patches:

First patch:
	s/V4L2_IDENT_OV772X/V4L2_IDENT_OV7720/g

Second patch:
	ov7225 patch plus new chip id addition.

Cheers,
Mauro.


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
