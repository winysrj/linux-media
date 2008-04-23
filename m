Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3NEC0Uf031057
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 10:12:00 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3NEBlep025078
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 10:11:47 -0400
Date: Wed, 23 Apr 2008 16:11:26 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Francisco Javier Cabello Torres <fjcabello@visual-tools.com>
Message-ID: <20080423141125.GA493@daniel.bse>
References: <440801370804230635t1d734144ta3a4ca5acd6b77f6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <440801370804230635t1d734144ta3a4ca5acd6b77f6@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: saa7130 driver error
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

On Wed, Apr 23, 2008 at 03:35:28PM +0200, Francisco Javier Cabello Torres wrote:
> When this happens VIDIOC_DQBUF ioctl returns -1 and errno=EIO.
> In this case application shoudl enqueue the buffer calling VIDIOC_QBUF.
> The problem is that after calling VIDIOC_DQBUF ioctl, v4l2_buffer structure
> is not
> properly filled. Buffer index isn't set and when I try to enqueue the buffer
> the driver
> always gives me an error.

This issue came up a few times on the list

http://marc.info/?t=105628128200001
http://marc.info/?t=108968901100001
http://marc.info/?t=117733484100008 (<- exactly 1 year ago!)
http://marc.info/?t=118708263500011

It doesn't look like there has been any agreement on how to handle this case.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
