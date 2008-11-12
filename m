Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mACBrbTp019397
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 06:53:37 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mACBrPXW013738
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 06:53:25 -0500
Date: Wed, 12 Nov 2008 09:53:28 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Message-ID: <20081112095328.3377bd1b@pedra.chehab.org>
In-Reply-To: <200811121143.50233.laurent.pinchart@skynet.be>
References: <200811111753.03430.laurent.pinchart@skynet.be>
	<200811120214.55330.laurent.pinchart@skynet.be>
	<20081112005617.3b8df573@pedra.chehab.org>
	<200811121143.50233.laurent.pinchart@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [RFC] Add usb_endpoint_*, list_first_entry and
 uninitialized_var to compat.h
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

On Wed, 12 Nov 2008 11:43:50 +0100
Laurent Pinchart <laurent.pinchart@skynet.be> wrote:


> > Feel free to implement on the way that better fits on your needs.
> 
> If you don't mind I'll go for kernel version checking in this case, as I've 
> already committed several changes on top of that one to my local tree

Seems ok to me.

> and mercurial seems to support a single level of rollback only :-/ 

True. You may have more comfort if you enable mercurial mq extension.

>(if I ever want to restart a flame war I'll send a mail about another version control 
> system starting with G ;-)).

I would love to migrate to git ;) I think this will happen sooner or later.
Let's see if we can do something for the next year.

> If anyone encounters an issue with a vendor 
> kernel it will be easy to move the check to make_config_compat.pl.

True.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
