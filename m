Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1KHJYer032592
	for <video4linux-list@redhat.com>; Fri, 20 Feb 2009 12:19:34 -0500
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.29])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1KHIfCo008981
	for <video4linux-list@redhat.com>; Fri, 20 Feb 2009 12:18:42 -0500
Received: by yw-out-2324.google.com with SMTP id 9so369139ywe.81
	for <video4linux-list@redhat.com>; Fri, 20 Feb 2009 09:18:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b24e53350902200913h3760ccbdqc9f14217afe5fdb1@mail.gmail.com>
References: <412bdbff0902200317h26f4d42fh4327b3ff08c79d5c@mail.gmail.com>
	<499EC9CC.3040703@linuxtv.org>
	<b24e53350902200910p1f5745b6s864490400f50b9@mail.gmail.com>
	<b24e53350902200911udfb9717t5429dd2b9fc81355@mail.gmail.com>
	<b24e53350902200913h3760ccbdqc9f14217afe5fdb1@mail.gmail.com>
Date: Fri, 20 Feb 2009 12:18:40 -0500
Message-ID: <412bdbff0902200918g328b8541v5414ad98ead688a2@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Robert Krakora <rob.krakora@messagenetsystems.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: HVR-950q analog support - testers wanted
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

On Fri, Feb 20, 2009 at 12:13 PM, Robert Krakora
<rob.krakora@messagenetsystems.com> wrote:
> I have three Linux-based media-ports here and I will put an HR950Q on
> each and let them run with my tester that changes channels and that
> opens and closes the device...

Robert,

Thank you for offering to take the time to test.  I am definitely
interested in the results.

One thing worth noting is that Michael Krufky pointed out a couple of
cases this morning where I missed a mutex, so if you connect multiple
950q's to the same system you might hit a race condition at system
bootup.  I'll nail it down this weekend but I wanted to warn you in
advance since you said you had multiple 950q devices.

Of course, I would be *very* interested in finding some way to get you
to do some testing of multiple devices connected at the same time once
that fix is in.  I only have one unit to test with so I haven't really
exercised that use case.

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
