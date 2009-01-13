Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0D8qa5s017879
	for <video4linux-list@redhat.com>; Tue, 13 Jan 2009 03:52:36 -0500
Received: from web95201.mail.in2.yahoo.com (web95201.mail.in2.yahoo.com
	[203.104.18.177])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n0D8oTxn028858
	for <video4linux-list@redhat.com>; Tue, 13 Jan 2009 03:50:30 -0500
Date: Tue, 13 Jan 2009 14:20:28 +0530 (IST)
From: niamathullah sharief <shariefbe@yahoo.co.in>
To: michael_h_williamson@yahoo.com,
	video4linux list <video4linux-list@redhat.com>,
	Kernel newbies <kernelnewbies@nl.linux.org>
In-Reply-To: <555483.44416.qm@web65512.mail.ac4.yahoo.com>
MIME-Version: 1.0
Message-ID: <594352.33024.qm@web95201.mail.in2.yahoo.com>
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


ya ok micheal..i am ready to install SDL library...but is the xawtv softwar=
e is using this SDL library to display the captured pictures..?i think no..=
..then how it is displaying..?I think this vgrab.c requires this SDL librar=
y....do you have any other program to display the captured pictures continu=
ously as video without using this =C2=A0SDL library...?sorry if i asked any=
 wrong question....Thanks a lot micheal....
--- On Tue, 13/1/09, Michael Williamson <michael_h_williamson@yahoo.com> wr=
ote:
From: Michael Williamson <michael_h_williamson@yahoo.com>
Subject: Re: About xawtv
To: shariefbe@yahoo.co.in
Date: Tuesday, 13 January, 2009, 2:21 AM



--- On Sun, 1/11/09, niamathullah sharief <shariefbe@yahoo.co.in> wrote:

> From: niamathullah sharief <shariefbe@yahoo.co.in>
> Subject: Re: About xawtv
> To: michael_h_williamson@yahoo.com, "video4linux list"
<video4linux-list@redhat.com>
> Date: Sunday, January 11, 2009, 10:22 PM
> Thanks micheal....Yes i can use xawtv program...but its very
> confusing....i already learned the "c"
> programming....now i have to understand what is =C2=A0"v4l2
> program does....Thats why i asked you...i saw all the
> programs in xawtv...including "streamer.c and
> capture.c"...but there is no mmap() function
> there...Thats why i asked first....can you help me =C2=A0to
> capture video in your application which you sent
> me...?Thanks for your valuable reply.....

I would describe V4L and V4L2 as software in the Linux kernel that helps
to use cameras with Linux. They provide a common programming interface
for different kinds of cameras.

To capture video using the program "vgrab.c", it needs to be modified
to continuously capture and display pictures, instead of storing a single
picture as a file. One way to display the captured pictures is with the
library called 'SDL'. Can you determine if it is installed on your
computer? If it is not, can you install it?  (A google search for SDL
will find the website to download it.)=20

Another possibility for displaying pictures is with the 'X11' library,=20
but it is more complicated.

-Mike





=0A=0A=0A      Add more friends to your messenger and enjoy! Go to http://m=
essenger.yahoo.com/invite/
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
