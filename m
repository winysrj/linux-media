Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8CJJkX8031934
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 15:19:46 -0400
Received: from idcmail-mo2no.shaw.ca (idcmail-mo2no.shaw.ca [64.59.134.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8CJJZHO011035
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 15:19:35 -0400
Message-ID: <48CAC0C5.905@ekran.org>
Date: Fri, 12 Sep 2008 12:19:33 -0700
From: "B. Bogart" <ben@ekran.org>
MIME-Version: 1.0
References: <48C05DC8.5060700@ekran.org>
	<1220568687.2736.12.camel@morgan.walls.org>
In-Reply-To: <1220568687.2736.12.camel@morgan.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, gem-dev@iem.at
Subject: Re: Re: V4l2 :: Debugging an issue with cx8800 card.
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

I have made progress.

I've managed to get my card working in Gem with some minor changes to
the code. I'm not sure what this code does though, so I'm not sure what
the longer term effect will be.

I'm sending this to the v4l list as you all are the best to advice on a
proper solution to this issue.

I've attached the original, and the hacked version.

Basically the hacked version ignores all errors when running the
following command:

xioctl (m_tvfd, VIDIOC_DQBUF, &buf)

What does this command actually do? Why are there two instances in the
capture function?

I can use the card at 640x480.

The result is the frame-rate is horrid compared to mplayer (which I
suppose makes sense based on those removed error reports) and also using
the V4L1 w/ a bt8x8 card.

Does this change give a hint as to what is causing the problem?

What is the proper way to fix the issue, rather than commenting out
error codes?

Thanks all,
B. Bogart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
