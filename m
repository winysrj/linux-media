Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBIKD2HI009589
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 15:13:02 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBIKChEY006312
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 15:12:43 -0500
Date: Thu, 18 Dec 2008 21:12:58 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
In-Reply-To: <20081218193619.GJ10620@game.jcrosoft.org>
Message-ID: <Pine.LNX.4.64.0812182110470.8046@axis700.grange>
References: <Pine.LNX.4.64.0812181613050.5510@axis700.grange>
	<20081218160841.GA13851@linux-sh.org>
	<Pine.LNX.4.64.0812181717320.5510@axis700.grange>
	<20081218162439.GA27151@linux-sh.org>
	<Pine.LNX.4.64.0812181730080.5510@axis700.grange>
	<20081218193619.GJ10620@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Magnus Damm <damm@igel.co.jp>, video4linux-list@redhat.com,
	Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: Re: A patch got applied to v4l bypassing v4l lists
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

On Thu, 18 Dec 2008, Jean-Christophe PLAGNIOL-VILLARD wrote:

> > Agree - breaking bisection is not something I'm looking into.
> > 
> > If you like, I can explain to you where this extra work comes from. That's 
> > my current understanding of the work flow on v4l, it might still be not 
> > quite right, so I'll be happy if anyone corrects me and tells me a better 
> > way to handle this.
> > 
> > v4l uses mercurial repositories as primary dveelopment trees. These 
> > repositories do not contain complete kernel trees, instead, they present a 
> > directory with some tools, where linux is a subdirectory of, and that's 
> > where a part of the kernel is reproduced.
> 
> so why do not you use git and git-modules it will save you time and will be
> simplest to use and track the v4l tree

I do use git, that's what I'm developing with, and then I have to export 
patches from git, import them in mercurial to prepare a pull request into 
the central v4l-dvb hg repository.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
