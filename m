Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBVJc7I6025333
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 14:38:07 -0500
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBVJbDKZ022734
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 14:37:13 -0500
Received: by qw-out-2122.google.com with SMTP id 3so2349714qwe.39
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 11:37:12 -0800 (PST)
Message-ID: <412bdbff0812311137o74aa3aa0y49248109f968f7e8@mail.gmail.com>
Date: Wed, 31 Dec 2008 14:37:12 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Paul Thomas" <pthomas8589@gmail.com>
In-Reply-To: <c785bba30812311134v86c1552o6fb7e76191c50182@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c785bba30812301646vf7572dcua9361eb10ec58716@mail.gmail.com>
	<20081231155344.4cc4594a@gmail.com>
	<c785bba30812311128u27f9326ah16728a17a5fce7e3@mail.gmail.com>
	<412bdbff0812311133y7c3c4f28u9d9ed99cbc18233b@mail.gmail.com>
	<c785bba30812311134v86c1552o6fb7e76191c50182@mail.gmail.com>
Cc: video4linux-list@redhat.com
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

On Wed, Dec 31, 2008 at 2:34 PM, Paul Thomas <pthomas8589@gmail.com> wrote:
> Devin,
>
> Here it is,
>
> CC [M]  /home/raid5/kernels/v4l-dvb/v4l/bttv-input.o
> In file included from /home/raid5/kernels/v4l-dvb/v4l/bttvp.h:36,
>                 from /home/raid5/kernels/v4l-dvb/v4l/bttv-input.c:28:
> include/linux/pci.h:1126: error: expected declaration specifiers or

Ok, you're running 2.6.27.9 I presume.

Please update to the latest version of v4l-dvb, as that issue should
have been fixed yesterday.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
