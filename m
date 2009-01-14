Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0EHoY2q001516
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 12:50:35 -0500
Received: from web95204.mail.in2.yahoo.com (web95204.mail.in2.yahoo.com
	[203.104.18.180])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n0EHmBgK030884
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 12:48:12 -0500
Date: Wed, 14 Jan 2009 23:18:10 +0530 (IST)
From: niamathullah sharief <shariefbe@yahoo.co.in>
To: Michael Williamson <michael_h_williamson@yahoo.com>,
	video4linux list <video4linux-list@redhat.com>,
	Kernel newbies <kernelnewbies@nl.linux.org>
In-Reply-To: <878642.52030.qm@web65512.mail.ac4.yahoo.com>
MIME-Version: 1.0
Message-ID: <96928.85289.qm@web95204.mail.in2.yahoo.com>
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


yes i copied all the things micheal...Alright now and now i get the below t=
hings...but i cant understand what it is....root@sharief-desktop:/home/shar=
ief/Desktop/vidrivers# gcc vgrabx.c -Wall -lX11 -o vgrabx
/usr/bin/ld: cannot find -lX11
collect2: ld returned 1 exit status
root@sharief-desktop:/home/sharief/Desktop/vidrivers#=C2=A0

--- On Tue, 13/1/09, Michael Williamson <michael_h_williamson@yahoo.com> wr=
ote:
From: Michael Williamson <michael_h_williamson@yahoo.com>
Subject: Re: About xawtv
To: shariefbe@yahoo.co.in
Date: Tuesday, 13 January, 2009, 10:49 PM



--- On Tue, 1/13/09, niamathullah sharief <shariefbe@yahoo.co.in> wrote:

> From: niamathullah sharief <shariefbe@yahoo.co.in>
> Subject: Re: About xawtv
> To: michael_h_williamson@yahoo.com, "video4linux list"
<video4linux-list@redhat.com>, "Kernel newbies"
<kernelnewbies@nl.linux.org>
> Date: Tuesday, January 13, 2009, 2:50 AM
> ya ok micheal..i am ready to install SDL library...but is
> the xawtv software is using this SDL library to display the
> captured pictures..?i think no....then how it is
> displaying..?I think this vgrab.c requires this SDL
> library....do you have any other program to display the
> captured pictures continuously as video without using this
> =C2=A0SDL library...?sorry if i asked any wrong
> question....Thanks a lot micheal....


I have used the 'X11' library for picture display.=20
The attached program is an example. Compile it with:

   # gcc vgrabx.c -Wall -lX11 -o vgrabx

-Mike



      =0A=0A=0A      Unlimited freedom, unlimited storage. Get it now, on h=
ttp://help.yahoo.com/l/in/yahoo/mail/yahoomail/tools/tools-08.html/
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
