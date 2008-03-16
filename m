Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2GL5mU1022733
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 17:05:48 -0400
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.190])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2GL5Gei030839
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 17:05:16 -0400
Received: by fk-out-0910.google.com with SMTP id b27so5895632fka.3
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 14:05:15 -0700 (PDT)
To: Trent Piepho <xyzzy@speakeasy.org>
From: Frej Drejhammar <frej.drejhammar@gmail.com>
In-Reply-To: <Pine.LNX.4.58.0803161258550.20723@shell4.speakeasy.net> (Trent
	Piepho's message of "Sun, 16 Mar 2008 13:28:06 -0700 (PDT)")
References: <patchbomb.1205671781@liva.fdsoft.se>
	<200803161442.37610.hverkuil@xs4all.nl> <kod9eemd4.fsf@liva.fdsoft.se>
	<Pine.LNX.4.58.0803161258550.20723@shell4.speakeasy.net>
Date: Sun, 16 Mar 2008 22:05:11 +0100
Message-ID: <k1w6a2xdk.fsf@liva.fdsoft.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 0 of 2] cx88: Enable additional cx2388x features.
	Version 2
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

Trent,

> One of the things you should do it make the control inactive when in
> SECAM mode.  V4L2 has a flag to indicate controls that don't apply
> to the device's current mode.

I guess it is the V4L2_CTRL_FLAG_INACTIVE flag (in the flag field of
struct v4l2_queryctrl) you are referring to, correct?

> CAGC makes a difference for me too.  Some of my channels are over
> saturated and some are under saturated and CAGC fixes them.  I don't
> recall if I posted pictures last time CAGC came up, but it really
> does make a difference.

Good that I'm not the only one who wants/needs it :)

> I haven't ever been able to notice an effect from color killer.
> Maybe if you had poor reception from a B&W source?  Not much black
> and white on broadcast TV these days.

So maybe I should just skip the color killer then...

>> A quick grep shows that the bttv-driver also exposes chroma AGC as
>> a private control. Cx2584x has chroma AGC enabled by default. Maybe
>> the right thing to do is to enable chroma AGC by default for PAL
>> and NTSC?  Chroma AGC is something you'll find on most VCRs and
>> TVs, and then it is on by default.
>
> That's what I would do.  Have a standard control for CAGC and turn
> it on by default.

Then that's what I'll do. Expect a revised version of the patch which
enables CAGC by default for PAL+NTSC and implements the
V4L2_CTRL_FLAG_INACTIVE by the end of the week.

> If I wanted to be told I wasn't worthy to use my hardware, I'd run
> windows!

Hear, hear! :)

Regards,

--Frej

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
