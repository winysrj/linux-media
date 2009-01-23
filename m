Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0NIfe2N009122
	for <video4linux-list@redhat.com>; Fri, 23 Jan 2009 13:41:40 -0500
Received: from web95210.mail.in2.yahoo.com (web95210.mail.in2.yahoo.com
	[203.104.18.186])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n0NIfO9K029416
	for <video4linux-list@redhat.com>; Fri, 23 Jan 2009 13:41:24 -0500
Date: Sat, 24 Jan 2009 00:11:23 +0530 (IST)
From: niamathullah sharief <shariefbe@yahoo.co.in>
To: michael_h_williamson@yahoo.com,
	video4linux list <video4linux-list@redhat.com>,
	Kernel newbies <kernelnewbies@nl.linux.org>
In-Reply-To: <787717.19693.qm@web65509.mail.ac4.yahoo.com>
MIME-Version: 1.0
Message-ID: <372895.40141.qm@web95210.mail.in2.yahoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: 
Subject: Re: mmap()
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


micheal..you are telling that read() function will do the same as the mmap(=
) does..but the read() will read the data from the memory i think....is thi=
s ,,ap() is also doing the same one?if yes....how its actually the data (wh=
en capturing the video) was stored in memory....?
--- On Fri, 23/1/09, Michael Williamson <michael_h_williamson@yahoo.com> wr=
ote:
From: Michael Williamson <michael_h_williamson@yahoo.com>
Subject: Re: mmap()
To: shariefbe@yahoo.co.in
Date: Friday, 23 January, 2009, 10:28 PM



--- On Fri, 1/23/09, niamathullah sharief <shariefbe@yahoo.co.in> wrote:

> From: niamathullah sharief <shariefbe@yahoo.co.in>
> Subject: mmap()
> To: "video4linux list" <video4linux-list@redhat.com>,
"Kernel newbies" <kernelnewbies@nl.linux.org>, "micheal
williams" <michael_h_williamson@yahoo.com>
> Date: Friday, January 23, 2009, 7:14 AM
> Hello,=C2=A0 =C2=A0Actually what is mmap()?why it used?shall we
> write the program without that function?



The mmap() function makes the memory containing
the picture pixel data available to the program.

The alternative is to use the read() function,
to get the picture pixel data. I do not have
a program that does it that way.=20

It is possible to get picture pixel data from a=20
camera from the shell prompt like this:

   # head -c 304128 /dev/video0 > pict.raw

That does the same things as open() and=20
read() functions do using a 'C' program.


-Mike




=0A=0A=0A      Add more friends to your messenger and enjoy! Go to http://m=
essenger.yahoo.com/invite/
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
