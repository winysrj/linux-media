Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBJDYc5e020993
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 08:34:38 -0500
Received: from smtp-vbr16.xs4all.nl (smtp-vbr16.xs4all.nl [194.109.24.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBJDXSY5003630
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 08:33:29 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Date: Fri, 19 Dec 2008 14:32:25 +0100
References: <1229686780.3120.10.camel@palomino.walls.org>
In-Reply-To: <1229686780.3120.10.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812191432.25336.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, ivtv-devel@ivtvdriver.org
Subject: Re: cs5435: break; in S_CTRL routine appears bogus
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

On Friday 19 December 2008 12:39:40 Andy Walls wrote:
> Hans,
>
> The break; statement you pointed out in the cs5435 driver does appear to
> be bogus.  I haven't tested removing it yet.
>
> Unfortunately there is no history in the hg log about this particular
> line.  I can rationalize how it got there from a cx18-centric testing
> point of view.  But obviously this module needs to work for other
> drivers in the future.

I analyzed it and it's just a bogus line that can be removed. cx18 will 
never attempt to set these controls in the cs5345, so it is clearly some 
debug line that was never deleted.

I've converted cs5345 to v4l2_subdev and fixed this at the same time (it's 
how I found it). So I will add it to my v4l-dvb-subdev repo and ask for 
Mauro to pull from it.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
