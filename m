Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m91JkmWw002482
	for <video4linux-list@redhat.com>; Wed, 1 Oct 2008 15:46:48 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m91Jkcde029905
	for <video4linux-list@redhat.com>; Wed, 1 Oct 2008 15:46:38 -0400
Date: Wed, 1 Oct 2008 21:46:17 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Vinicius Kamakura <thehexa@gmail.com>
Message-ID: <20081001194617.GA226@daniel.bse>
References: <20080908160012.574456184D5@hormel.redhat.com>
	<48C5948D.5030504@migmasys.com> <20080909190727.GA2184@daniel.bse>
	<3ebb0dc80809300125n24567d11kf4b414b7909c8270@mail.gmail.com>
	<20080930121259.GA237@daniel.bse>
	<3ebb0dc80810011127v38c55961yd37cd13e32fcc829@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ebb0dc80810011127v38c55961yd37cd13e32fcc829@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: a multichannel capture problem
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

On Wed, Oct 01, 2008 at 03:27:39PM -0300, Vinicius Kamakura wrote:
> Isn't that the same as using the VIDIOC_S_INPUT ioctl?
> Or is there a performance gain (less field/frame skipping) on doing that?

I wanted the lowest latency and the least impact on the hardware.

Doing

  m[1]^=0x20;

should be faster than calling the kernel to do it.

It was a quick hack..

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
