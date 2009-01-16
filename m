Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0G0DQR9013890
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 19:13:26 -0500
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0G0DBA2014701
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 19:13:12 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 16 Jan 2009 01:13:08 +0100
References: <1229889214.3050.8.camel@johannes>
	<200812221050.57039.laurent.pinchart@skynet.be>
	<1232046155.5839.50.camel@johannes>
In-Reply-To: <1232046155.5839.50.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901160113.08610.laurent.pinchart@skynet.be>
Cc: video4linux-list <video4linux-list@redhat.com>, lkml@vger.kernel.org
Subject: Re: uvcvideo prints lots of "unknown event"
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

Hi Johannes,

On Thursday 15 January 2009, Johannes Berg wrote:
> On Mon, 2008-12-22 at 10:50 +0100, Laurent Pinchart wrote:
> > Could you please try the attached patched ?
>
> Were you planning to get this patch into the kernel?

The patch has been integrated into 2.6.29-rc1.

> It doesn't seem to apply any more to 2.6.29-rc1, but at the same time it now 
prints the messages again.

Can you double check that you're really running 2.6.29-rc1 and that the driver 
source includes the patch ?

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
