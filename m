Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB8M6m8P019326
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 17:06:48 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id mB8M6YH0017864
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 17:06:34 -0500
Date: Mon, 8 Dec 2008 20:06:27 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Message-ID: <20081208200627.5894e44e@pedra.chehab.org>
In-Reply-To: <200812061934.00750.laurent.pinchart@skynet.be>
References: <200811271536.46779.laurent.pinchart@skynet.be>
	<200812061934.00750.laurent.pinchart@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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


On Sat, 6 Dec 2008 19:34:00 +0100
Laurent Pinchart <laurent.pinchart@skynet.be> wrote:

> Hi Mauro,
> 
> On Thursday 27 November 2008, Laurent Pinchart wrote:
> > Hi,
> >
> > this patch series adds support for zoom and privacy controls to V4L2:
> >
> > - the first two patches add the controls to videodev2.h
> > - the 3rd patch updates v4l2-common.c with missing control names
> > - the 4th patch updates the v4l2 api documentation
> >
> > I've split the additions to videodev2.h in two patches to document the new
> > controls in the patches description as requested by Mauro.
> 
> Is there anything that prevents those patches from being applied ?

I was assuming that you would add this into your mercurial repository and ask
me to pull from it ;)



Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
