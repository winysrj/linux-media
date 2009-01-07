Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n07I7EBk025778
	for <video4linux-list@redhat.com>; Wed, 7 Jan 2009 13:07:15 -0500
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n07I6wfT028518
	for <video4linux-list@redhat.com>; Wed, 7 Jan 2009 13:06:58 -0500
Received: by qw-out-2122.google.com with SMTP id 3so3589532qwe.39
	for <video4linux-list@redhat.com>; Wed, 07 Jan 2009 10:06:58 -0800 (PST)
Message-ID: <412bdbff0901071006r662b14b5ud42bd04adc7b7fbb@mail.gmail.com>
Date: Wed, 7 Jan 2009 13:06:57 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Paul Thomas" <pthomas8589@gmail.com>
In-Reply-To: <c785bba30901070927x9be4bdcr84ceb792ccac7afb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c785bba30812301646vf7572dcua9361eb10ec58716@mail.gmail.com>
	<412bdbff0812311420n3f42e13ew899be73cd855ba5d@mail.gmail.com>
	<c785bba30812311424r87bd070v9a01828c77d6a2a6@mail.gmail.com>
	<412bdbff0812311435n429787ecmbcab8de00ba05b6b@mail.gmail.com>
	<c785bba30812311444l65b3825aq844b79dd6f420c09@mail.gmail.com>
	<412bdbff0812311452o64538cdav4b948f6a9214ccdd@mail.gmail.com>
	<c785bba30901020850y51c7b9d2i47fd418828cd150c@mail.gmail.com>
	<c785bba30901030922y17d67d0bm822304a650a0e812@mail.gmail.com>
	<c785bba30901051633g7808197fl6d377420d799120c@mail.gmail.com>
	<c785bba30901070927x9be4bdcr84ceb792ccac7afb@mail.gmail.com>
Cc: video4linux-list <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: em28xx issues
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

On Wed, Jan 7, 2009 at 12:27 PM, Paul Thomas <pthomas8589@gmail.com> wrote:
> I thought a kernel oops was a big deal? Anyway, if the em28 device
> isn't well supported. What would be a well supported device that has
> an component input and preferably has been tested on ARM.
>
> thanks,
> Paul

Hello Paul,

I don't think anyone is saying that a kernel oops isn't a big deal.
The reality though is that this is a project worked on by a very small
number of *volunteers* and there is no assertion that your issue will
be dealt with as quickly as you like.

This issue is compounded by the fact that as far as we know it only
occurs on a single piece of hardware that nobody ever claimed was
supported and no developer has in their possession to debug the issue
with.  In cases like this the issue it may only take two or three
hours to debug if someone like myself has the device in question, but
I'm not going to spend my own money to go out and buy one.

By all means, if you want to debug the issue, we would be happy to
accept patches.  Or if you want to mail me the hardware so I could
take a look and see if I can debug the issue, that is something else
we can discuss.  But operating under the assumption that you are
somehow entitled to have a developer donate his time to address your
problem is perhaps not the best way to get help.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
