Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3GMYWk6010489
	for <video4linux-list@redhat.com>; Wed, 16 Apr 2008 18:34:32 -0400
Received: from smtp1.infomaniak.ch (smtp1.infomaniak.ch [84.16.68.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3GMYKAT022113
	for <video4linux-list@redhat.com>; Wed, 16 Apr 2008 18:34:20 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Thu, 17 Apr 2008 00:41:43 +0200
References: <op.t3hn72busxcvug@mrubli-nb.am.logitech.com>
	<20080415004416.GA11071@plankton.ifup.org>
	<20080415001932.52039d0f@gaivota>
In-Reply-To: <20080415001932.52039d0f@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804170041.43718.laurent.pinchart@skynet.be>
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

Hi Mauro,

On Tuesday 15 April 2008, Mauro Carvalho Chehab wrote:
> On Mon, 14 Apr 2008 17:44:16 -0700
>
> Brandon Philips <brandon@ifup.org> wrote:
> > Ping.  I never saw patches come across for this.
>
> Brandon, Could you please add this on one of your trees, together with
> those pending V4L2 API patches for UVC? I want to merge those changes
> together with the in-kernel driver that firstly requires such changes.
>
> Btw, Laurent, are you ready for uvc inclusion? The window for the next
> kernel is about to open.

The driver is constantly evolving, but I don't see any showstopper.

How exactly should we proceed ? Should I submit a patch based on git 2.6.25 ? 
What about future patches ?

Do you have any opinion regarding keeping or closing the linux-uvc-devel 
mailing list ?

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
