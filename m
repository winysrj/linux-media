Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAC1Ergd003755
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 20:14:53 -0500
Received: from mailrelay003.isp.belgacom.be (mailrelay003.isp.belgacom.be
	[195.238.6.53])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAC1EhXe001818
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 20:14:43 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Wed, 12 Nov 2008 02:14:55 +0100
References: <200811111753.03430.laurent.pinchart@skynet.be>
	<alpine.LFD.2.00.0811111559550.5321@bombadil.infradead.org>
In-Reply-To: <alpine.LFD.2.00.0811111559550.5321@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811120214.55330.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com
Subject: Re: [RFC] Add usb_endpoint_*,
	list_first_entry and uninitialized_var to compat.h
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

On Tuesday 11 November 2008, Mauro Carvalho Chehab wrote:
> On Tue, 11 Nov 2008, Laurent Pinchart wrote:
> > Hi everybody,
> >
> > This patch adds support for the usb_endpoint_* functions as well as
> > list_first_entry and uninitialized_var macros to compat.h. The uvcvideo
> > driver requires it to compile on kernels older than 2.6.22.
> >
> > As the usb_endpoint_* functions needs struct usb_endpoint_descriptor,
> > they are only defined if linux/usb.h has been included before compat.h.
> > This avoids including linux/usb.h unconditionally. I've tested the patch
> > by compiling the v4l-dvb tree on 2.6.16 and 2.6.27 and didn't get any
> > warning or error.
> >
> > If nobody objects I'll include the changes in my tree with the related
> > uvcvideo changes and send a pull request.
>
> I didn't test it here, but it seems OK to me.
>
> Maybe instead of testing for a specific version, you may use
> make_config_compat.pl script to do some test at some include file, finding
> for some specific API call, like we did for some KABI changes that
> happened without incrementing kernel minor revision.

Are you referring to the test for a specific Redhat kernel version ? When 
should compat.h test for a specific kernel version, and when should 
make_config_compat.pl be used ?

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
