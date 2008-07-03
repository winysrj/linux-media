Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6353PD7002310
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 01:03:25 -0400
Received: from web88207.mail.re2.yahoo.com (web88207.mail.re2.yahoo.com
	[206.190.37.222])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6353Dwx021431
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 01:03:13 -0400
Date: Wed, 2 Jul 2008 22:03:07 -0700 (PDT)
From: Dwaine Garden <dwainegarden@rogers.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
Message-ID: <25283.57206.qm@web88207.mail.re2.yahoo.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Can we remove saa711x.c?
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

What about the saa7113?=A0 Have any of those devices moved over to the saa7=
115.c?=0AIt was the best decision for the usbvision driver to use what was =
packaged in the v4l kernel.=0A=0A=0A----- Original Message ----=0AFrom: Han=
s Verkuil <hverkuil@xs4all.nl>=0ATo: dwainegarden@rogers.com=0ACc: v4l <vid=
eo4linux-list@redhat.com>; Mauro Carvalho Chehab <mchehab@infradead.org>=0A=
Sent: Tuesday, July 1, 2008 2:28:26 AM=0ASubject: Re: Can we remove saa711x=
.c?=0A=0A> Sounds good to me.=A0 What about the other saa711().c modules?=
=A0 Have all=0A> the drivers moved over to the saa7115.c?=0A=0Asaa7111 is s=
till used by zoran and mxb.=0Asaa7114 is still used by zoran as well.=0A=0A=
I can test the zoran with the saa7111 (I'm fairly certain my iomega Buz=0Ah=
as a saa7111), and I've contacted the mxb maintainer in the hope that he=0A=
has one (it's been unmaintained for two years or so, so it might be=0Adiffi=
cult to find someone with that hardware).=0A=0AI'm hoping someone might hav=
e a zoran device with a saa7114, but if not=0Athen I wonder whether we shou=
ldn't just replace it and cross our fingers.=0A=0ARegards,=0A=0A=A0 =A0 =A0=
 =A0 Hans=0A=0A>=0A> ------Original Message------=0A> From: Hans Verkuil=0A=
> Sender:=0A> To: v4l=0A> Cc: Mauro Carvalho Chehab=0A> Subject: Can we rem=
ove saa711x.c?=0A> Sent: Jun 30, 2008 4:51 PM=0A>=0A> Hi all,=0A>=0A> It lo=
oks like the saa711x module is unused right now. Unless I'm missing=0A> som=
ething I propose we remove it before the 2.6.27 window opens.=0A>=0A> Regar=
ds,=0A>=0A> =A0=A0=A0 Hans=0A>=0A> --=0A> video4linux-list mailing list=0A>=
 Unsubscribe mailto:video4linux-list-request@redhat.com?subject=3Dunsubscri=
be=0A> https://www.redhat.com/mailman/listinfo/video4linux-list=0A>=0A>=0A>=
 Sent from my BlackBerry device on the Rogers Wireless Network=0A>=0A>=0A=
=0A=0A--=0Avideo4linux-list mailing list=0AUnsubscribe mailto:video4linux-l=
ist-request@redhat.com?subject=3Dunsubscribe=0Ahttps://www.redhat.com/mailm=
an/listinfo/video4linux-list=0A
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
