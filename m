Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mARFsmGQ016733
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 10:54:48 -0500
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.250])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mARFsb8w023231
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 10:54:37 -0500
Received: by an-out-0708.google.com with SMTP id b2so396027ana.36
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 07:54:37 -0800 (PST)
Message-ID: <26aa882f0811270754l724d6893q39b6d0b8f6257b2c@mail.gmail.com>
Date: Thu, 27 Nov 2008 10:54:36 -0500
From: "Jackson Yee" <jackson@gotpossum.com>
To: v4l <video4linux-list@redhat.com>
In-Reply-To: <1227793923.3147.45.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11380.62.70.2.252.1227781392.squirrel@webmail.xs4all.nl>
	<1227793923.3147.45.camel@palomino.walls.org>
Subject: Re: RFC: drop support for kernels < 2.6.22
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

On Thu, Nov 27, 2008 at 8:52 AM, Andy Walls <awalls@radix.net> wrote:
> And from those working on or using surveillance/security systems, I
> suspect you might never hear anything.

I've been working in the surveillance industry for about three years
now. About 95% of the working machines out there are all Windows
machines or dedicated embedded machines running specialized firmware.
There are a few Linux compatible cards out there, but most of them use
the bttv driver to provide video, and other ones provided their own
driver against a particular kernel version and distribution (usually
Red Hat). I believe that the future probably lies in MPEG4/H264 IP
cameras, but until their costs decrease significantly, most people
will probably stick with the cheap bttv cards.

Linux surveillance projects are few and far in between - mostly
Zoneminder users and Kenneth Lavrsen's motion. That's one of the
reasons why I've been working on my project to provide a high level
language interface to the V4L2 API to allow rapid development of
projects for others.

My personal opinion is that backwards compatibility is definitely
helpful, but for most drivers out there, it's probably not necessary
since most users will update their kernel along with their
distributions, and that kernel will include the newer drivers while
older users can simply keep using their same kernels - especially with
an enterprise system. I have no problems if Hans wishes to devote his
time to the newer kernels.

--
Regards,
Jackson Yee
The Possum Company
540-818-4079
me@gotpossum.com

P.S. Happy Thanksgiving to those of us who are in the U.S.! My
family's having duck and crab legs instead of the traditional turkey
this year, but it's nice to have a day off once in a while instead of
our normal hectic schedules!

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
