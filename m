Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0O0smPJ023034
	for <video4linux-list@redhat.com>; Fri, 23 Jan 2009 19:54:48 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0O0sTgp005981
	for <video4linux-list@redhat.com>; Fri, 23 Jan 2009 19:54:32 -0500
Date: Fri, 23 Jan 2009 22:54:02 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Magnus Damm" <magnus.damm@gmail.com>
Message-ID: <20090123225402.161cbf05@caramujo.chehab.org>
In-Reply-To: <aec7e5c30901152057o54136434v4f8875ad1b683c44@mail.gmail.com>
References: <20081210045432.3810.42700.sendpatchset@rx1.opensource.se>
	<Pine.LNX.4.64.0901111924320.16531@axis700.grange>
	<aec7e5c30901152057o54136434v4f8875ad1b683c44@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] videobuf-dma-contig: fix USERPTR free handling
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

On Fri, 16 Jan 2009 13:57:27 +0900
"Magnus Damm" <magnus.damm@gmail.com> wrote:

> On Mon, Jan 12, 2009 at 3:26 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > On Wed, 10 Dec 2008, Magnus Damm wrote:
> >
> >> From: Magnus Damm <damm@igel.co.jp>
> >>
> >> This patch fixes a free-without-alloc bug for V4L2_MEMORY_USERPTR
> >> video buffers.
> >>
> >> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> >
> > Mauro, what about this patch? Is it correct? If so, it shall be applied I
> > presume, as in that case it is a bug-fix.
> 
> It's a bug fix and getting it included would be great!

The patch is ok. I've just committed it. I should be adding on my next upstream pull request.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
