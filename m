Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0B6kS1H018380
	for <video4linux-list@redhat.com>; Sun, 11 Jan 2009 01:46:28 -0500
Received: from web95203.mail.in2.yahoo.com (web95203.mail.in2.yahoo.com
	[203.104.18.179])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n0B6jZNM018210
	for <video4linux-list@redhat.com>; Sun, 11 Jan 2009 01:45:36 -0500
Date: Sun, 11 Jan 2009 12:15:34 +0530 (IST)
From: niamathullah sharief <shariefbe@yahoo.co.in>
To: michael_h_williamson@yahoo.com,
	video4linux list <video4linux-list@redhat.com>
In-Reply-To: <990510.2253.qm@web65506.mail.ac4.yahoo.com>
MIME-Version: 1.0
Message-ID: <699072.5166.qm@web95203.mail.in2.yahoo.com>
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


yes its working micheal...but video is not working just still coming.....wh=
en i rotate the cam the video is not moving just standing still....i think =
its a still not an video..what to do for video?
--- On Sun, 11/1/09, Michael Williamson <michael_h_williamson@yahoo.com> wr=
ote:
From: Michael Williamson <michael_h_williamson@yahoo.com>
Subject: Re: About xawtv
To: shariefbe@yahoo.co.in
Date: Sunday, 11 January, 2009, 9:48 AM



--- On Sat, 1/10/09, niamathullah sharief <shariefbe@yahoo.co.in> wrote:

> From: niamathullah sharief <shariefbe@yahoo.co.in>
> Subject: Re: About xawtv
> To: "Michael Williamson" <michael_h_williamson@yahoo.com>,
"video4linux list" <video4linux-list@redhat.com>
> Date: Saturday, January 10, 2009, 9:22 PM
> Thanks williams...but now too i am getting the anither
> error....sharief@sharief-desktop:~/Desktop/video drivers$
> gcc vgrab.c -Wall -o vgrab
> sharief@sharief-desktop:~/Desktop/video drivers$ ./vgrab
> > picture.pgm
> open video failed: No such file or directory

By default, the program "vgrab.c" attempts to open
"/dev/video".=20
The error message you get means that it does not exist. Does=20
"/dev/video0" exist when you attach your webcam? If it does,=20
then try

   # ./vgrab /dev/video0 > picture.pgm

-Mike




     =20
=0A=0A=0A      Connect with friends all over the world. Get Yahoo! India Me=
ssenger at http://in.messenger.yahoo.com/?wm=3Dn/
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
