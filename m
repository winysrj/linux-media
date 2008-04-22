Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3M8fSYt012807
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 04:41:28 -0400
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3M8em3I025264
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 04:40:49 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Brandon Philips <brandon@ifup.org>
Date: Tue, 22 Apr 2008 10:40:29 +0200
References: <op.t3hn72busxcvug@mrubli-nb.am.logitech.com>
	<20080415001932.52039d0f@gaivota>
	<20080422022221.GE7392@plankton.ifup.org>
In-Reply-To: <20080422022221.GE7392@plankton.ifup.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804221040.30350.laurent.pinchart@skynet.be>
Cc: linux1@rubli.info, Martin Rubli <v4l2-lists@rubli.info>,
	Linux and Kernel Video <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
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

On Tuesday 22 April 2008 04:22, Brandon Philips wrote:
> On 00:19 Tue 15 Apr 2008, Mauro Carvalho Chehab wrote:
> > Brandon, Could you please add this on one of your trees, together with
> > those pending V4L2 API patches for UVC? I want to merge those changes
> > together with the in-kernel driver that firstly requires such changes.
> 
> I have a tree with the change sets.  Please don't pull from the tip
> though: hg pull -r 4ca1ed646f89 http://ifup.org/hg/v4l-uvc
> 
> The tip of that tree has UVC and all of the Kconfig/Makefile bits too.
> 
> The patch set for the tree: http://ifup.org/hg/uvc-v4l-patches
> 
> If Laurent wants to add his sign off to that last patch (based on r204)
> we can commit that too :D

I want the driver to be properly reviewed on both video4linux-list and 
linux-usb. I will post a patch on both mailing lists today.

Thanks for taking care of the Kconfig/Makefile bits. Could you send them to me 
so that I can include them in the patch to be reviewed ?

Cheers,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
