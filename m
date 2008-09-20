Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx2.redhat.com (mx2.redhat.com [10.255.15.25])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with SMTP id m8K6Zqba016792
	for <video4linux-list@redhat.com>; Sat, 20 Sep 2008 02:35:52 -0400
Received: from smtp-vbr9.xs4all.nl (smtp-vbr9.xs4all.nl [194.109.24.29])
	by mx2.redhat.com (8.13.8/8.13.8) with SMTP id m8K6ZZkS018762
	for <video4linux-list@redhat.com>; Sat, 20 Sep 2008 02:35:35 -0400
Message-ID: <25239.208.252.119.63.1221892474.squirrel@webmail.xs4all.nl>
Date: Sat, 20 Sep 2008 08:34:34 +0200 (CEST)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Jadav, Brijesh R" <brijesh.j@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: Custom Standards
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

> Hi Hans,
>
> In the current V4L2 implementation, VIDIOC_ENUMSTD ioctl is implemented as
> part of V4L2 core driver (v4l2-ioctl.c). It is good to have this ioctl
> implemented in the core itself to avoid duplication of code, but it looks
> that there are no hooks available for custom standards. This ioctl is
> important for the application to know standards (supported in V4l2 core)
> and their attributes supported by the driver (including custom standards)
> although it has to include custom header file. Is there any way out for
> this problem?

Not at the moment. However, I've discussed this today with Manju from TI
and it is my opinion that the current standards should be effectively
frozen and that we need a new ioctl for dealing with these more
complicated standards. There are several reasons for this, but when I'm
back from my US trip in 8 days or so I'll think it over more carefully and
prepare an RFC with a proposal of how to handle this properly.

The main problem I have with adding HD standards to v4l2_std_id is that
there are dozens of HD standards defined. While there are only a few that
are in common use, the total number of actually used HD formats is much
higher. Too many to fit inside the available bits.

So I'm working on this (or at least once I'm back from my vacation!).

Regards,

        Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
