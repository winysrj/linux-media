Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0C4NECq008085
	for <video4linux-list@redhat.com>; Sun, 11 Jan 2009 23:23:14 -0500
Received: from web95203.mail.in2.yahoo.com (web95203.mail.in2.yahoo.com
	[203.104.18.179])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n0C4Msdm025287
	for <video4linux-list@redhat.com>; Sun, 11 Jan 2009 23:22:54 -0500
Date: Mon, 12 Jan 2009 09:52:52 +0530 (IST)
From: niamathullah sharief <shariefbe@yahoo.co.in>
To: michael_h_williamson@yahoo.com,
	video4linux list <video4linux-list@redhat.com>
In-Reply-To: <834598.65214.qm@web65507.mail.ac4.yahoo.com>
MIME-Version: 1.0
Message-ID: <954614.56519.qm@web95203.mail.in2.yahoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: 
Subject: Re: About xawtv
Reply-To: shariefbe@yahoo.co.in
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

Thanks micheal....Yes i can use xawtv program...but its very confusing....i=
 already learned the "c" programming....now i have to understand what is =
=C2=A0"v4l2 program does....Thats why i asked you...i saw all the programs =
in xawtv...including "streamer.c and capture.c"...but there is no mmap() fu=
nction there...Thats why i asked first....can you help me =C2=A0to capture =
video in your application which you sent me...?Thanks for your valuable rep=
ly.....

--- On Sun, 11/1/09, Michael Williamson <michael_h_williamson@yahoo.com> wr=
ote:
From: Michael Williamson <michael_h_williamson@yahoo.com>
Subject: Re: About xawtv
To: shariefbe@yahoo.co.in
Date: Sunday, 11 January, 2009, 11:00 PM



--- On Sun, 1/11/09, niamathullah sharief <shariefbe@yahoo.co.in> wrote:

> From: niamathullah sharief <shariefbe@yahoo.co.in>
> Subject: Re: About xawtv
> To: michael_h_williamson@yahoo.com, "video4linux list"
<video4linux-list@redhat.com>
> Date: Sunday, January 11, 2009, 12:45 AM
> yes its working micheal...but video is not working just
> still coming.....when i rotate the cam the video is not
> moving just standing still....i think its a still not an
> video..what to do for video?

The program I sent you, "vgrab.c", is for single (still) pictures
only.
For video, the program needs modification. Can you install the SDL library
on your computer? If not, I know another way.

Also, why you do not simply use the xawtv program for video?
Are you learning 'C' programming?

-Mike



     =20
=0A=0A=0A      Unlimited freedom, unlimited storage. Get it now, on http://=
help.yahoo.com/l/in/yahoo/mail/yahoomail/tools/tools-08.html/
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
