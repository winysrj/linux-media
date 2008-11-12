Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAC2udcA006890
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 21:56:39 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAC2u7Fv011019
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 21:56:13 -0500
Date: Wed, 12 Nov 2008 00:56:17 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Message-ID: <20081112005617.3b8df573@pedra.chehab.org>
In-Reply-To: <200811120214.55330.laurent.pinchart@skynet.be>
References: <200811111753.03430.laurent.pinchart@skynet.be>
	<alpine.LFD.2.00.0811111559550.5321@bombadil.infradead.org>
	<200811120214.55330.laurent.pinchart@skynet.be>
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

On Wed, 12 Nov 2008 02:14:55 +0100
Laurent Pinchart <laurent.pinchart@skynet.be> wrote:

> Hi Mauro,
> 
> On Tuesday 11 November 2008, Mauro Carvalho Chehab wrote:
> > On Tue, 11 Nov 2008, Laurent Pinchart wrote:
> > > Hi everybody,
> > >
> > > This patch adds support for the usb_endpoint_* functions as well as
> > > list_first_entry and uninitialized_var macros to compat.h. The uvcvideo
> > > driver requires it to compile on kernels older than 2.6.22.
> > >
> > > As the usb_endpoint_* functions needs struct usb_endpoint_descriptor,
> > > they are only defined if linux/usb.h has been included before compat.h.
> > > This avoids including linux/usb.h unconditionally. I've tested the patch
> > > by compiling the v4l-dvb tree on 2.6.16 and 2.6.27 and didn't get any
> > > warning or error.
> > >
> > > If nobody objects I'll include the changes in my tree with the related
> > > uvcvideo changes and send a pull request.
> >
> > I didn't test it here, but it seems OK to me.
> >
> > Maybe instead of testing for a specific version, you may use
> > make_config_compat.pl script to do some test at some include file, finding
> > for some specific API call, like we did for some KABI changes that
> > happened without incrementing kernel minor revision.
> 
> Are you referring to the test for a specific Redhat kernel version ?

Yes.

> When should compat.h test for a specific kernel version, and when should 
> make_config_compat.pl be used ?

There's no rule.

Using make_config_compat.pl works better than just checking for a specific
kernel version, since it will run a small script to check for the presence (or
absense) of a given function, but adding things at compat.h is more direct, so
it requires less time to add things there.

On the other hand, make_config_compat.pl allows a more robust compatibility
code, as time goes by, especially for vendor patched kernels.

Feel free to implement on the way that better fits on your needs.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
