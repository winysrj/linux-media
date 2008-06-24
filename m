Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5OM52hv000622
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 18:05:02 -0400
Received: from mailrelay006.isp.belgacom.be (mailrelay006.isp.belgacom.be
	[195.238.6.172])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5OM4qKR005484
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 18:04:52 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Wed, 25 Jun 2008 00:04:48 +0200
References: <485F7A42.8020605@vidsoft.de>
	<200806240033.41145.laurent.pinchart@skynet.be>
	<20080624183601.235ff1d5@gaivota>
In-Reply-To: <20080624183601.235ff1d5@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806250004.48989.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, linux-uvc-devel@lists.berlios.de
Subject: Re: [Linux-uvc-devel] Thread safety of ioctls
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

On Tuesday 24 June 2008, Mauro Carvalho Chehab wrote:
> > > Can I enable more logging than setting the trace parameter to 0xfff?
> >
> > No without adding more printk's to the driver, which I encourage you to
> > do.
>
> This would be one advantage of having uvc driver using video_ioctl2. to see
> ioctl's it is just a matter of using debug=1. If you use debug=3, you'll
> also view all arguments of the ioctl.

That won't happen. Anyway, the UVC driver already prints out ioctl trace 
messages to the kernel if you set the trace parameter high enough. Gregor was 
asking for more debugging output than that.

> PS.: I'm still waiting for uvc patches for its kernel addition.

I've received all the feedback and review I'll probably get, so I'll send a 
new patch this week with the latest driver.

I've addressed some of your comments (such as not using enums at userspace 
interface). What is the rationale behind not having userspace and kernelspace 
APIs in a single .h file ? If I'm not mistaken kernel headers are stripped 
from their #ifdef __KERNEL__ sections but distributions anyway. It makes 
sense to have separate headers when they become big enough, but I don't think 
that's the case for a single driver like this one.

Cheers,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
