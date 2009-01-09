Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n09GsAtx032332
	for <video4linux-list@redhat.com>; Fri, 9 Jan 2009 11:54:10 -0500
Received: from web95215.mail.in2.yahoo.com (web95215.mail.in2.yahoo.com
	[203.104.18.191])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n09Grp3q014123
	for <video4linux-list@redhat.com>; Fri, 9 Jan 2009 11:53:52 -0500
Date: Fri, 9 Jan 2009 22:23:50 +0530 (IST)
From: niamathullah sharief <shariefbe@yahoo.co.in>
To: Michael Williamson <michael_h_williamson@yahoo.com>,
	video4linux list <video4linux-list@redhat.com>
In-Reply-To: <170703.53133.qm@web65508.mail.ac4.yahoo.com>
MIME-Version: 1.0
Message-ID: <761101.51753.qm@web95215.mail.in2.yahoo.com>
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


Michael whether this program will work?i mean whether it will capture the i=
mage?if  yes how to do that?
--- On Fri, 9/1/09, Michael Williamson <michael_h_williamson@yahoo.com> wro=
te:
From: Michael Williamson <michael_h_williamson@yahoo.com>
Subject: Re: About xawtv
To: shariefbe@yahoo.co.in
Date: Friday, 9 January, 2009, 2:22 AM



--- On Wed, 1/7/09, niamathullah sharief <shariefbe@yahoo.co.in> wrote:

> From: niamathullah sharief <shariefbe@yahoo.co.in>
> Subject: About xawtv
> To: "video4linux list" <video4linux-list@redhat.com>
> Date: Wednesday, January 7, 2009, 11:31 AM
> Hello friends,
>=20
> =C2=A0  i downloaded the xawtv package...but i dont which
> program is used to capture the video....i found there is a
> program called "capture.c" in common directory in
> that package..but i didnt find any memory mapping function
> in that program....so i am very much confused......can
> anyone tell me which program is used to capture the
> image....?Thanks a lot...


I do not know about xawtv, but I can give you a simple program that I
use, as an example. I'll attach it, with filename "vgrab5.c".
Also, I=20
attached another program, "rover.c", that displays pictures using the
SDL library, which must be installed before compiling.

-Mike



      =0A=0A=0A      Add more friends to your messenger and enjoy! Go to ht=
tp://messenger.yahoo.com/invite/
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
