Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0GBheFk018407
	for <video4linux-list@redhat.com>; Fri, 16 Jan 2009 06:43:40 -0500
Received: from out1.laposte.net (out2.laposte.net [193.251.214.119])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0GBhN72032716
	for <video4linux-list@redhat.com>; Fri, 16 Jan 2009 06:43:23 -0500
Received: from meplus.info (localhost [127.0.0.1])
	by mwinf8209.laposte.net (SMTP Server) with ESMTP id 5F187700008C
	for <video4linux-list@redhat.com>; Fri, 16 Jan 2009 12:43:14 +0100 (CET)
Received: from wwinf8401 (lbao93aubmepnpf001-182-pip.meplus.info [10.98.49.10])
	by mwinf8209.laposte.net (SMTP Server) with ESMTP id 46B567000085
	for <video4linux-list@redhat.com>; Fri, 16 Jan 2009 12:43:14 +0100 (CET)
From: Olivier Lorin <o.lorin@laposte.net>
To: video4linux-list@redhat.com
Message-ID: <31415843.70859.1232106194273.JavaMail.www@wwinf8401>
MIME-Version: 1.0
Date: Fri, 16 Jan 2009 12:43:14 +0100 (CET)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re:RFC: Where to store camera properties (upside down, needs sw
 whitebalance, etc). ?
Reply-To: Olivier Lorin <o.lorin@laposte.net>
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


> >> 2) With some cams the upside down ness may actually be stored in an ee=
prom, or
> >> in some cases even determined by a switch (so the cam can be rotated
> >> manually by the user and the the switch indicates the position)
> >>
> >> In these cases we need a userspace API to find this out too. Since thi=
s is a
> >> per frame thing for some cams (one frame could be upright, the next up=
side
> >> down). I would like to suggest to define some V4L2_BUF_FLAG_ 's for th=
is
> >> which can be used by drivers to indicate that the picture in the buffe=
r is
> >> vflipped or hflipped (with upside down being both together).
>
>
> Please be aware of the fact that, when the gspca-sq905 module is
> considered complete, there will need to be some kind of scheme which will
> take its needs into consideration. Here is what happens with these
> cameras:
>
> 1. All of them have the same Vendor:Product number, 0x2770:0x9120.
>
> 2. Some of them emit output which needs vertical inversion, but for some
> others a horizontal mirroring is required, instead.
>
> 3. The way that you can tell which is needed is that a four-byte model
> number is requested, and that can be parsed to decide which of (1) or
> (2) to do. The way the camera works, the first step in initializing it is
> to read this number; the streaming takes place after that.
>
> Clearly, it is possible either to perform the appropriate action on the
> frames either in the module, or in userspace, in libv4l. Equally obvious,
> if the action has to take place in userspace then there has to be some wa=
y
> to pass the appropriate information on.
>
> From my point of view, it does not matter whether the appropriate
> manipulations take place in the module or in userspace. I merely want to
> point out that the information does not come from the Vendor:Product
> number, but from a specific query which takes place after the module is i=
n
> control and is sending commands to the camera. And, if the manipulation i=
s
> done in userspace then the information has to be passed on, too.
>
> Theodore Kilgore

The use of the buffer flags makes the life easier as this flag=20
is read for every image. So we can solve for the flip/rotation=20
issues with the help of two new buffer flags: V4L2_BUF_FLAG_NEEDS_HFLIP=20
and V4L2_BUF_FLAG_NEEDS_VFLIP.

A driver has to set them properly. Does the rotation or flip(s)=20
apply to every image (e.g. sensor upside down) or change with frames
(e.g. Genesys webcams), that no more matters .
I can do the patch these days.
I do not remember if there is h/v flip functions in the libv4l,=20
maybe they have to be added.

Regards,
Nol

 Cr=C3=A9ez votre adresse =C3=A9lectronique prenom.nom@laposte.net=20
 1 Go d'espace de stockage, anti-spam et anti-virus int=C3=A9gr=C3=A9s.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
