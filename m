Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6SIbqxG031796
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 14:37:52 -0400
Received: from smtp5-g19.free.fr (smtp5-g19.free.fr [212.27.42.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6SIbRF7002619
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 14:37:27 -0400
To: Alan Stern <stern@rowland.harvard.edu>
References: <Pine.LNX.4.44L0.0807271808550.23282-100000@netrider.rowland.org>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 28 Jul 2008 20:37:25 +0200
In-Reply-To: <Pine.LNX.4.44L0.0807271808550.23282-100000@netrider.rowland.org>
	(Alan Stern's message of "Sun\,
	27 Jul 2008 18\:10\:02 -0400 \(EDT\)")
Message-ID: <87prox97oa.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH] Fix suspend/resume of pxa_camera driver
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

Alan Stern <stern@rowland.harvard.edu> writes:

> On Sun, 27 Jul 2008, Guennadi Liakhovetski wrote:
>
> IMO, suspend should be as transparent as possible for userspace.  So if
> a user program has started an audio or video stream before suspend,
> then after resume the stream should still be playing.
Yes, that's what I think too.

The only little thing that should change will be timeout problem (userspace
waits on a poll to get a video frame within 1 second for example).
I'm not sure how well this is handled, I didn't check.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
