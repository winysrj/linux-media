Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0F3SpZB018296
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 22:28:51 -0500
Received: from web95214.mail.in2.yahoo.com (web95214.mail.in2.yahoo.com
	[203.104.18.190])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n0F3SUE0009643
	for <video4linux-list@redhat.com>; Wed, 14 Jan 2009 22:28:31 -0500
Date: Thu, 15 Jan 2009 08:58:29 +0530 (IST)
From: niamathullah sharief <shariefbe@yahoo.co.in>
To: michael_h_williamson@yahoo.com,
	video4linux list <video4linux-list@redhat.com>,
	Kernel newbies <kernelnewbies@nl.linux.org>
In-Reply-To: <594227.63965.qm@web65505.mail.ac4.yahoo.com>
MIME-Version: 1.0
Message-ID: <876558.40055.qm@web95214.mail.in2.yahoo.com>
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

yes it get compiled...but i dont know what to do next...sharief@sharief-des=
ktop:~/Desktop/vidrivers$ gcc vgrabx.c /usr/lib/libX11.so.6 -Wall -o vgrabx
sharief@sharief-desktop:~/Desktop/vidrivers$ ls
rover.c  vgrab5.c  vgrab.c  vgrabx  vgrabx.c  vgrabx.c~  X11
sharief@sharief-desktop:~/Desktop/vidrivers$=C2=A0

how to capture the video?

--- On Thu, 15/1/09, Michael Williamson <michael_h_williamson@yahoo.com> wr=
ote:
From: Michael Williamson <michael_h_williamson@yahoo.com>
Subject: Re: About xawtv
To: shariefbe@yahoo.co.in
Date: Thursday, 15 January, 2009, 8:07 AM



--- On Wed, 1/14/09, niamathullah sharief <shariefbe@yahoo.co.in> wrote:

> From: niamathullah sharief <shariefbe@yahoo.co.in>
> Subject: Re: About xawtv
> To: michael_h_williamson@yahoo.com, "video4linux list"
<video4linux-list@redhat.com>, "Kernel newbies"
<kernelnewbies@nl.linux.org>
> Date: Wednesday, January 14, 2009, 7:35 PM
> yes i have this
> files....seeroot@sharief-desktop:/home/sharief# find / -name
> 'libX11*'
> /usr/lib/libX11.so.6
> /usr/lib/libX11.so.6.2.0
> root@sharief-desktop:/home/sharief#=C2=A0
>=20
> what to do with this files?

Try to compile it like this:

   # gcc vgrabx.c /usr/lib/libX11.so.6 -Wall -o vgrabx

or try the other one if it does not compile.

-Mike




=0A=0A=0A      From Chandigarh to Chennai - find friends all over India. Go=
 to http://in.promos.yahoo.com/groups/citygroups/
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
