Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0F1ZiOF017191
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 20:35:44 -0500
Received: from web95216.mail.in2.yahoo.com (web95216.mail.in2.yahoo.com
	[203.104.18.192])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n0F1ZNpM026373
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 20:35:24 -0500
Date: Thu, 15 Jan 2009 07:05:22 +0530 (IST)
From: niamathullah sharief <shariefbe@yahoo.co.in>
To: michael_h_williamson@yahoo.com,
	video4linux list <video4linux-list@redhat.com>,
	Kernel newbies <kernelnewbies@nl.linux.org>
In-Reply-To: <827054.5585.qm@web65504.mail.ac4.yahoo.com>
MIME-Version: 1.0
Message-ID: <888416.68136.qm@web95216.mail.in2.yahoo.com>
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

yes i have this files....seeroot@sharief-desktop:/home/sharief# find / -nam=
e 'libX11*'
/usr/lib/libX11.so.6
/usr/lib/libX11.so.6.2.0
root@sharief-desktop:/home/sharief#=C2=A0

what to do with this files?
i am using UBUNTU micheal...
--- On Thu, 15/1/09, Michael Williamson <michael_h_williamson@yahoo.com> wr=
ote:
From: Michael Williamson <michael_h_williamson@yahoo.com>
Subject: Re: About xawtv
To: shariefbe@yahoo.co.in
Date: Thursday, 15 January, 2009, 1:07 AM



--- On Wed, 1/14/09, niamathullah sharief <shariefbe@yahoo.co.in> wrote:

> From: niamathullah sharief <shariefbe@yahoo.co.in>
> Subject: Re: About xawtv
> To: "Michael Williamson" <michael_h_williamson@yahoo.com>,
"video4linux list" <video4linux-list@redhat.com>, "Kernel
newbies" <kernelnewbies@nl.linux.org>
> Date: Wednesday, January 14, 2009, 11:48 AM
> yes i copied all the things micheal...Alright now and now i
> get the below things...but i cant understand what it
> is....root@sharief-desktop:/home/sharief/Desktop/vidrivers#
> gcc vgrabx.c -Wall -lX11 -o vgrabx
> /usr/bin/ld: cannot find -lX11
> collect2: ld returned 1 exit status
> root@sharief-desktop:/home/sharief/Desktop/vidrivers#=C2=A0

That means that there is another file needed.

Try this:

   # find / -name 'libX11*'

Is it found?
Normally, it is in directory "/usr/lib".=20

Does your computer have some administer function for installing software?=
=20
What Linux distribution are you using?
I think you need to put 'X11' or 'X11-devel' or 'SDL'
on your computer
using an administer tool. That way, all the needed files are added.

-Mike




=0A=0A=0A      Add more friends to your messenger and enjoy! Go to http://m=
essenger.yahoo.com/invite/
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
