Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3GMdr1n012385
	for <video4linux-list@redhat.com>; Wed, 16 Apr 2008 18:39:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3GMdfcD024900
	for <video4linux-list@redhat.com>; Wed, 16 Apr 2008 18:39:41 -0400
Date: Wed, 16 Apr 2008 19:39:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Message-ID: <20080416193924.7a0f26b9@gaivota>
In-Reply-To: <200804170041.43718.laurent.pinchart@skynet.be>
References: <op.t3hn72busxcvug@mrubli-nb.am.logitech.com>
	<20080415004416.GA11071@plankton.ifup.org>
	<20080415001932.52039d0f@gaivota>
	<200804170041.43718.laurent.pinchart@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux1@rubli.info, Martin Rubli <v4l2-lists@rubli.info>,
	Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: [PATCH] Support for write-only controls
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

On Thu, 17 Apr 2008 00:41:43 +0200
Laurent Pinchart <laurent.pinchart@skynet.be> wrote:

> Hi Mauro,
> 
> On Tuesday 15 April 2008, Mauro Carvalho Chehab wrote:
> > On Mon, 14 Apr 2008 17:44:16 -0700
> >
> > Brandon Philips <brandon@ifup.org> wrote:
> > > Ping.  I never saw patches come across for this.
> >
> > Brandon, Could you please add this on one of your trees, together with
> > those pending V4L2 API patches for UVC? I want to merge those changes
> > together with the in-kernel driver that firstly requires such changes.
> >
> > Btw, Laurent, are you ready for uvc inclusion? The window for the next
> > kernel is about to open.
> 
> The driver is constantly evolving, but I don't see any showstopper.
> 
> How exactly should we proceed ? Should I submit a patch based on git 2.6.25 ? 

The better is to generate against -hg, but against 2.6.25 should also be fine.

> What about future patches ?

You may submit to me as they are tested. I prefer if you use hg. Otherwise,
please submit via email.

> Do you have any opinion regarding keeping or closing the linux-uvc-devel 
> mailing list ?

It is up to you. There are some drivers already with specific lists, like ivtv
and pvrusb2. If you prefer, you may also use the std V4L ML.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
