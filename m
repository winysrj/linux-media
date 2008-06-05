Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m55L6x1F027084
	for <video4linux-list@redhat.com>; Thu, 5 Jun 2008 17:06:59 -0400
Received: from mailrelay010.isp.belgacom.be (mailrelay010.isp.belgacom.be
	[195.238.6.177])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m55L6bDL022093
	for <video4linux-list@redhat.com>; Thu, 5 Jun 2008 17:06:42 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "Gilles GIGAN" <gilles.gigan@gmail.com>
Date: Thu, 5 Jun 2008 23:06:31 +0200
References: <78877a450806012349j25cf72acm7aed866c3888ecdd@mail.gmail.com>
	<200806022239.52094.laurent.pinchart@skynet.be>
	<78877a450806021648o4eda07aqc342d842d67cd1c0@mail.gmail.com>
In-Reply-To: <78877a450806021648o4eda07aqc342d842d67cd1c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806052306.31478.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com
Subject: Re: Detecting webcam unplugging
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

On Tuesday 03 June 2008, Gilles GIGAN wrote:
> Hi Laurent,
>
> Your V4L1 driver is probably to blame.
>
>
> So does this means there is nothing userspace can do to safely detect
> unplugging events while capturing ?

It means the behaviour is not specified by the V4L specs, but I would expect 
sane drivers to return an error. If your driver doesn't it should probably be 
fixed.

> I tested other applications (ekiga, amsn, camorama and skype) with these
> webcams and got the same results (app freezes), whereas with V4L2 cameras,
> a popup warns the user the webcam has been unplugged and the app is still
> useable.
> If anyone comes up with something, I be glad to hear about it.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
