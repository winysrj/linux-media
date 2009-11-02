Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nA2KOH9n028487
	for <video4linux-list@redhat.com>; Mon, 2 Nov 2009 15:24:17 -0500
Received: from mail-bw0-f214.google.com (mail-bw0-f214.google.com
	[209.85.218.214])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nA2KO0Qa008929
	for <video4linux-list@redhat.com>; Mon, 2 Nov 2009 15:24:01 -0500
Received: by bwz6 with SMTP id 6so6867813bwz.11
	for <video4linux-list@redhat.com>; Mon, 02 Nov 2009 12:24:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4AEE9AAA.80104@st.com>
References: <4AEE9AAA.80104@st.com>
Date: Mon, 2 Nov 2009 20:23:59 +0000
Message-ID: <5387cd30911021223u2c1349b8gd7baca736f8fbae6@mail.gmail.com>
From: Nick Morrott <knowledgejunkie@gmail.com>
To: v4l <video4linux-list@redhat.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: hvr1300 DVB regression
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

2009/11/2 Raffaele BELARDI <raffaele.belardi@st.com>:
> I'm no longer able with recent kernels to tune DVB channels with my
> HVR1300. This is a mythtv box but I replicated the problem using
> www.linuxtv.org utilities to exclude mythtv issues.
>
> Using kernel 2.6.26-r4 and 2.6.27-r8 I am able to tune both analog and
> DVB channels.
> Using kernel 2.6.30-r6 I can only tune to analog channels. 'dvbscan'
> returns no channel info.
>
> I suspect a tuner problem.

Have you read https://bugs.launchpad.net/mythtv/+bug/439163 and
comments (esp. https://bugs.launchpad.net/mythtv/+bug/439163/comments/50)?

Cheers,
Nick

-- 
Nick Morrott

MythTV Official wiki:
http://mythtv.org/wiki/
MythTV users list archive:
http://www.gossamer-threads.com/lists/mythtv/users

"An investment in knowledge always pays the best interest." - Benjamin Franklin

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
