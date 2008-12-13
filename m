Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBD2fvxY009222
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 21:41:57 -0500
Received: from mail-bw0-f20.google.com (mail-bw0-f20.google.com
	[209.85.218.20])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBD2fiOh014674
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 21:41:45 -0500
Received: by bwz13 with SMTP id 13so6218958bwz.3
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 18:41:44 -0800 (PST)
Message-ID: <208cbae30812121841q659ca7aeod0941696264e7632@mail.gmail.com>
Date: Sat, 13 Dec 2008 05:41:43 +0300
From: "Alexey Klimov" <klimov.linux@gmail.com>
To: "David Ellingsworth" <david@identd.dyndns.org>
In-Reply-To: <30353c3d0812090449g30b55d64r4da5069a41cd0b4e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228752855.1809.93.camel@tux.localhost>
	<30353c3d0812081403p11f1fcaam1b15a2650f05bcdf@mail.gmail.com>
	<208cbae30812081410i37ad8da8ue43f907ad9a54b@mail.gmail.com>
	<30353c3d0812081620v1e633530qa3539888c18a1cda@mail.gmail.com>
	<30353c3d0812090449g30b55d64r4da5069a41cd0b4e@mail.gmail.com>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/2] radio-mr800: correct unplug, fix to previous patch
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

Hello, David

On Tue, Dec 9, 2008 at 3:49 PM, David Ellingsworth
<david@identd.dyndns.org> wrote:
>
> I thought about this more and you might want to reconstitute the
> meaning of the users member of the amradio struct. Currently
> amradio_start is called whenever the device is opened and amradio_stop
> is called whenever it is closed. Thus if the device were opened twice,
> it would call the start routine twice. The other issue is that once it
> has been opened more than one time, the first time it is closed,
> amradio_stop is called. It may make more since to turn this member
> into a counter that is incremented on open and decremented on close.
> Then if the counter is 0 on open, before increment, call amradio_start
> and if it's 0 on close, after decrement, call amradio_stop. Once this
> is done, amradio_start will only be called once when the device is
> initially opened and amradio_stop will be called once when during
> close when all users all users have closed the device. I don't know if
> it matters or not, but you may also want to take a look at the control
> which mutes the device for it seems to call amradio_start and
> amradio_stop as well. Ideally if the device is stopped by the user
> before the final close amradio_stop should not be called, so you
> should check if it's not muted as well.
>
> Finally I noticed that the muted flag is not modified within the
> context of the lock in amradio_start and amradio_stop. This should be
> corrected to ensure a race condition doesn't exist between the two
> states. I also think that amradio_start and amradio_stop should verify
> the device's state before proceeding. For example if the device is not
> muted during a call to amradio_start it should return an error since
> it's already started. And if it's muted during a call to amradio_stop
> it should return an error.
>
> The suspend/resume functions needs to be fixed as well. amradio_start
> should only be called if the device wasn't muted when it was
> suspended. Likewise, amradio_stop should only be called during suspend
> if the device isn't muted. Since the amradio_start and amradio_stop
> manipulate the muted variable you may need another variable to
> determine how to resume from suspend. You might be able to use the
> muted variable, by resetting it to one to on suspend after calling
> amradio_stop when it's not muted. And then resetting it to 0 in resume
> if it's 1 before calling amradio_start in resume. None the less,
> resume/suspend should return the device to it's prior state. IE. if it
> was muted upon suspend, it should be muted upon resume and vice versa.

This works like a todo-list for next activity(work) about driver for
me. I'll be guided by your advices.
Thanks for reviewing and help, David. Your answers are always very
accurate and rational.

-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
