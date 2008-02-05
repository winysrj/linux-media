Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m15CPEQ9007355
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 07:25:14 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m15COpCF026347
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 07:24:52 -0500
Date: Tue, 5 Feb 2008 10:24:09 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Brandon Philips <brandon@ifup.org>
Message-ID: <20080205102409.4b7acb01@gaivota>
In-Reply-To: <20080205080038.GB8232@plankton.ifup.org>
References: <20080205012451.GA31004@plankton.ifup.org>
	<Pine.LNX.4.64.0802050815200.3863@axis700.grange>
	<20080205080038.GB8232@plankton.ifup.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com,
	Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
	v4lm <v4l-dvb-maintainer@linuxtv.org>
Subject: Re: NACK NACK!  [PATCH] Add two new fourcc codes for 16bpp formats
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

On Tue, 5 Feb 2008 00:00:38 -0800
Brandon Philips <brandon@ifup.org> wrote:

> On 08:16 Tue 05 Feb 2008, Guennadi Liakhovetski wrote:
> > On Mon, 4 Feb 2008, Brandon Philips wrote:
> > 
> > > On 15:31 Thu 31 Jan 2008, Guennadi Liakhovetski wrote:
> > > > From: Steven Whitehouse <steve@chygwyn.com>
> > > > 
> > > > This adds two new fourcc codes (as per info at fourcc.org)
> > > > for 16bpp mono and 16bpp Bayer formats.
> > > 
> > > This patch was merged in the following commit:
> > >  http://linuxtv.org/hg/v4l-dvb/rev/d002378ff8c2
> > > 
> > > I have a number of issues:
> > >  
> > > - Why was V4L2_CID_AUTOEXPOSURE added!  I am working to get an auto
> > >   exposure control into the spec but this was merged without discussion.
> > >   Please remove this and wait for my patch.
> > > 
> > > - Why was a SoC config option added with this commit?
> > > 
> > > - mailimport changes in this commit too!  Why is mailimport running
> > >   sudo!?! 
> > > 
> > > A mistake was obviously made here.
> > 
> > Yes, strange. In the original patch
> > 
> > http://marc.info/?l=linux-video&m=120179045830566&w=2
> > 
> > it was still ok.
> 
> Yea, it must have been something on Mauro's end.

Yes. It was a silly mistake from my side... I'll revert soon. I'm currently
backporting kernel changes.

I should be using a separate tree for testing newer changesets. Unfortunately,
mercurial spends a large amount of disk space when you fork a tree, since it
doesn't support versioning, and the 160Gb disk on my notebook is almost full
with lots and lots of mercurial branches :( So, sometimes, bad things happen.

Maybe we've took the wrong direction when we've decided to select
mercurial. It were better and easier to use, on that time, but the -git
improvements happened too fast.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
