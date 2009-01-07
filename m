Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n07IOTIx006115
	for <video4linux-list@redhat.com>; Wed, 7 Jan 2009 13:24:29 -0500
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.25])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n07IOApq021853
	for <video4linux-list@redhat.com>; Wed, 7 Jan 2009 13:24:12 -0500
Received: by qw-out-2122.google.com with SMTP id 3so3593658qwe.39
	for <video4linux-list@redhat.com>; Wed, 07 Jan 2009 10:24:10 -0800 (PST)
Message-ID: <412bdbff0901071024p7a16343cha01c09ea6ae2b5a2@mail.gmail.com>
Date: Wed, 7 Jan 2009 13:24:10 -0500
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

A quick look at the code does show something interesting:

There are a number of cases where we dereference the result of the
"INPUT" macro as follows without checking the number of inputs
defined:

route.input = INPUT(index)->vmux;

and here is the macro definition:

#define INPUT(nr) (&em28xx_boards[dev->model].input[nr])

It may be the case that a NULL pointer deference would occur if there
was only one input defined (as is the case for the PointNix camera).

As a test, you might want to copy the other two inputs for the
PointNix device profile from some other device, and see if you still
hits an oops during input selection.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
