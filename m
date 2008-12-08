Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB925J6Z006479
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 21:05:19 -0500
Received: from mailrelay012.isp.belgacom.be (mailrelay012.isp.belgacom.be
	[195.238.6.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB924t8R027817
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 21:04:55 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Mon, 8 Dec 2008 23:39:14 +0100
References: <200811271536.46779.laurent.pinchart@skynet.be>
	<200812061934.00750.laurent.pinchart@skynet.be>
	<20081208200627.5894e44e@pedra.chehab.org>
In-Reply-To: <20081208200627.5894e44e@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812082339.14889.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, Michael Schimek <mschimek@gmx.at>
Subject: Re: [PATCH 0/4] Add zoom and privacy controls
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

Hi Mauro,

On Monday 08 December 2008, Mauro Carvalho Chehab wrote:
> On Sat, 6 Dec 2008 19:34:00 +0100
>
> Laurent Pinchart <laurent.pinchart@skynet.be> wrote:
> > Hi Mauro,
> >
> > On Thursday 27 November 2008, Laurent Pinchart wrote:
> > > Hi,
> > >
> > > this patch series adds support for zoom and privacy controls to V4L2:
> > >
> > > - the first two patches add the controls to videodev2.h
> > > - the 3rd patch updates v4l2-common.c with missing control names
> > > - the 4th patch updates the v4l2 api documentation
> > >
> > > I've split the additions to videodev2.h in two patches to document the
> > > new controls in the patches description as requested by Mauro.
> >
> > Is there anything that prevents those patches from being applied ?
>
> I was assuming that you would add this into your mercurial repository and
> ask me to pull from it ;)

The documentation part of the patch can't be pushed through mercurial, and I 
didn't want to submit it separately.

I will have to resubmit the patches anyway as Hans found a few mistakes. I 
will send them by e-mail and ask for an ack, and I'll then send a pull 
request. Where should the documentation part of the patchset go ? Why isn't 
the documentation stored in a repository ?

As a side note, is there an equivalent to git reset in Mercurial ? I know 
about hg undo but that only supports one level of undo, and once 
modifications have been pushed to my linuxtv.org repository there's no way 
back. How would I have had to proceed if I had pushed the patchset to 
linuxtv.org ? Would I have had to dump the repository, create a brand new one 
by cloning and reapply modifications ?

Cheers,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
