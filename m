Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7A7PMKa007949
	for <video4linux-list@redhat.com>; Mon, 10 Aug 2009 03:25:22 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n7A7P7Wx019654
	for <video4linux-list@redhat.com>; Mon, 10 Aug 2009 03:25:07 -0400
Date: Mon, 10 Aug 2009 09:25:05 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: javier Martin <javier.martin@vista-silicon.com>
Message-ID: <20090810072505.GA285@daniel.bse>
References: <eedb5540908060842rb7e2ac7g920310563fa8ddb4@mail.gmail.com>
	<20090807192045.GK5842@pengutronix.de>
	<eedb5540908092351v7b46b392i1a3c697a906c87dd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eedb5540908092351v7b46b392i1a3c697a906c87dd@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: H.264 format support?
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

On Mon, Aug 10, 2009 at 08:51:49AM +0200, javier Martin wrote:
> Yes, I know Freescale has it integrated in the same package, but the
> truth is that in V4L2 there is no definition for H264 output format.
> That makes a little difficult for a driver which outputs H.264 to
> enter mainline kernel. That is why I am asking for an H.264 output
> format definition..

Pixel formats are added as needed. So you can create this format
yourself and later post it (including a small patch for the V4L2 API
spec) as part of the patch set for the driver.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
