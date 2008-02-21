Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1L1LmH0019021
	for <video4linux-list@redhat.com>; Wed, 20 Feb 2008 20:21:48 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m1L1LG6V024132
	for <video4linux-list@redhat.com>; Wed, 20 Feb 2008 20:21:16 -0500
Date: Thu, 21 Feb 2008 02:20:48 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: "H. Willstrand" <h.willstrand@gmail.com>
Message-ID: <20080221012048.GA2924@daniel.bse>
References: <47BC8BFC.2000602@kaiser-linux.li>
	<175f5a0f0802201232y6a1bfc53u4fe92fede3abcb34@mail.gmail.com>
	<47BC90CA.1000707@kaiser-linux.li>
	<175f5a0f0802201254q7dc96190k35caafe9ba7d3274@mail.gmail.com>
	<47BC9788.7070604@kaiser-linux.li>
	<20080220215850.GA2391@daniel.bse> <47BCA5BA.20009@kaiser-linux.li>
	<175f5a0f0802201441n5ea7bb58rdfa70663799edcad@mail.gmail.com>
	<47BCB5DB.8000800@kaiser-linux.li>
	<175f5a0f0802201602i52187c1fxb2e980c7e86fcca6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175f5a0f0802201602i52187c1fxb2e980c7e86fcca6@mail.gmail.com>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: V4L2_PIX_FMT_RAW
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

On Thu, Feb 21, 2008 at 01:02:39AM +0100, H. Willstrand wrote:
> What's the problem with having a name of the formalized data in the
> video stream? ie raw do not mean undefined.

I thought you wanted to avoid having to define V4L2_PIX_FMT_x for an
exploding number of proprietary formats that are quite similar but still
incompatible. It makes sense for formats that are used by more than one
driver.

> I don't see how separate RAW ioctl's will add value to the V4l2 API,
> it fits into the current API.

Yes, it does. Each driver having multiple raw formats just needs a
private control id to select one.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
