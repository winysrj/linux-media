Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBHJRRtH018025
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 14:27:27 -0500
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id mBHJRDPp031784
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 14:27:14 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Greg KH <greg@kroah.com>
Date: Wed, 17 Dec 2008 20:27:13 +0100
References: <200812082156.26522.hverkuil@xs4all.nl>
	<200812171437.33695.hverkuil@xs4all.nl>
	<20081217181645.GA26161@kroah.com>
In-Reply-To: <20081217181645.GA26161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812172027.13771.laurent.pinchart@skynet.be>
Cc: v4l <video4linux-list@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] cdev_put() race condition
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

Hi Greg,

On Wednesday 17 December 2008, Greg KH wrote:
> On Wed, Dec 17, 2008 at 02:37:33PM +0100, Hans Verkuil wrote:
> > > Again, don't use cdev's reference counting for your own object
> > > lifecycle, it is different and will cause problems, like you have found
> > > out.
> >
> > Sigh. It has nothing to do with how v4l uses it. And to demonstrate this,
> > here is how you reproduce it with the sg module (tested it with my USB
> > harddisk).
> >
> > 1) apply this patch to char_dev.c:
>
> <snip>
>
> Ok, since I can't convince you that using a cdev for your reference
> counting is incorrect, I'll have to go change the cdev code to prevent
> you from doing this :(

Don't give up yet :-)

As v4l isn't the only kernel subsystem wrongly using cdev (Hans showed that sg 
also suffered from race conditions), people seem not to understand cdev 
properly. Maybe you should start by explaining what cdev has been designed to 
handle and how to use it in device drivers (such as sg or v4l) instead of 
telling us what not to do.

> Anyway, do you have a patch for the cdev code to propose how to fix this
> issue you are having?

Regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
