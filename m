Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1KFUMVd026705
	for <video4linux-list@redhat.com>; Fri, 20 Feb 2009 10:30:22 -0500
Received: from mail-gx0-f171.google.com (mail-gx0-f171.google.com
	[209.85.217.171])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1KFUBIn011533
	for <video4linux-list@redhat.com>; Fri, 20 Feb 2009 10:30:11 -0500
Received: by gxk19 with SMTP id 19so2403766gxk.3
	for <video4linux-list@redhat.com>; Fri, 20 Feb 2009 07:30:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <499EC9CC.3040703@linuxtv.org>
References: <412bdbff0902200317h26f4d42fh4327b3ff08c79d5c@mail.gmail.com>
	<499EC9CC.3040703@linuxtv.org>
Date: Fri, 20 Feb 2009 10:30:11 -0500
Message-ID: <412bdbff0902200730p5a2a0822rb3b15d9c316365af@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Steven Toth <stoth@linuxtv.org>
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

On Fri, Feb 20, 2009 at 10:18 AM, Steven Toth <stoth@linuxtv.org> wrote:
> Devin Heitmueller wrote:
>>
>> Hello,
>>
>> There is now a test repository that provides analog support for the
>> HVR-950q:
>>
>> http://linuxtv.org/hg/~dheitmueller/hvr950q-analog
>>
>> I welcome people interested in analog support for the 950q to download
>> the tree and provide feedback.
>
> I only have time today for a small amount of testing but QAM and ATSC are
> still working reliably. No obvious issues. No obvious regressions.
>
> I'll load this up on my myth box this weekend and ensure it's still reliable
> over the long term.
>
> I'll be in touch.

Hello Steven,

Thank you for taking the time to test.

One thing that would be useful, and I'm addressing this to everyone,
is when reporting feedback (positive or negative) you please indicate
which application(s) you tested with, as well as what kernel version
and CPU architecture you tested on.

Right now one of the big issues is while that I do not know of any
issues, the code has had limited exposure in terms of the applications
and kernels tested with.  By providing this information, that will
help me tremendously in evaluating whether enough *different* cases
are being tested or whether everybody is basically testing the same
thing.

Thanks,

Devin


-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
