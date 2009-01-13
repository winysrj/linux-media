Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0DJef6u011982
	for <video4linux-list@redhat.com>; Tue, 13 Jan 2009 14:40:42 -0500
Received: from out1.laposte.net (out2.laposte.net [193.251.214.119])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0DJeRlu023344
	for <video4linux-list@redhat.com>; Tue, 13 Jan 2009 14:40:28 -0500
Received: from meplus.info (localhost [127.0.0.1])
	by mwinf8216.laposte.net (SMTP Server) with ESMTP id 331A97000087
	for <video4linux-list@redhat.com>; Tue, 13 Jan 2009 20:40:27 +0100 (CET)
Received: from wwinf8216 (lbao93aubmepnpf001-182-pip.meplus.info [10.98.49.10])
	by mwinf8216.laposte.net (SMTP Server) with ESMTP id 12E0A7000085
	for <video4linux-list@redhat.com>; Tue, 13 Jan 2009 20:40:27 +0100 (CET)
From: Olivier Lorin <o.lorin@laposte.net>
To: video4linux-list@redhat.com
Message-ID: <17868849.303177.1231875627056.JavaMail.www@wwinf8216>
MIME-Version: 1.0
Date: Tue, 13 Jan 2009 20:40:27 +0100 (CET)
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

Hi!

> We came to the conclusion that having a table in the kernel only for the
> purpose of userspace being able to query it, is not very efficient, and i=
n
> general is not a good idea.
>
> So for the table of upside down webcam's we came to the following conclus=
ion:
> -if the driver can do the rotation itself (in hw) then the table should b=
e in
> the driver and it should invert the meaning of its hflip and vflip contro=
ls,
> (iow off is flip, on is do not flip) so that usserspace won't notice the =
cam
> being upside down in anyway
> -if the driver can not do the rotation libv4l will do it, and the table o=
f cams
> which need this (such as certain uvc models) will be part of libv4l
>
> So I started thinking about my proposal to add read-only controls (CID's)=
 to
> drivers which libv4l can query to find out if it would be a good idea to =
do
> things like software white balance for a cam.
>
> On second thought this is a bad idea for all the same reasons, having a t=
able
> in the kernel, just so that userspace can query it makes little sense. Be=
tter
> to just put the table in userspace.
>
> So this mail mainly is a retraction of my earlier proposal (instead I wil=
l
> completely handle this in libv4l). But there are 2 special cases libv4l w=
ill
> still need some userspace <-> kernel API for:
>
> 1) With some bridges it is common to not have a usbid per bridge / sensor
> combi, but cams with the same usb-id can have different sensors (the driv=
er
> finds out which one by probing the i2c bus between the bridge and sensor)=
.
> Since things like whitebalance and autogain are often done in the sensor,
> in these cases libv4l will need a way to find out the sensor (the bridge =
it
> can deduct from the usb-id). So we need a userspace API to query which
> sensor a bridge is connected too.
>
> I would like to suggest to use one of the 4 reserved __u32's in the
> v4l2_capability struct for this. We could then make a very large enum wit=
h
> all known sensors and store that there, but instead I would suggest to ma=
ke
> this a driver specific field, so v4l2_capability would then look like thi=
s:

I hope that "driver specific field" does not mean that the same bit may hav=
e
different meanings depending on the webcam!


> 2) With some cams the upside down ness may actually be stored in an eepro=
m, or
> in some cases even determined by a switch (so the cam can be rotated
> manually by the user and the the switch indicates the position)
>
> In these cases we need a userspace API to find this out too. Since this i=
s a
> per frame thing for some cams (one frame could be upright, the next upsid=
e
> down). I would like to suggest to define some V4L2_BUF_FLAG_ 's for this
> which can be used by drivers to indicate that the picture in the buffer i=
s
> vflipped or hflipped (with upside down being both together).

In the case of the Genesys webcams using the gl860 bridge,
the upside down state is not really relevant per frame as
there is some instabilities when it is as upside down as right up
so that it is not usefull to check every image state
(by the way it's not a switch but a kind gravity sensor).
The V4L2_BUF_FLAG is a good idea as it matches better the image state purpo=
se
than the V4L2_CID, however it is not to be confused with the upside down se=
nsor
as in these cases, it is not usefull to check regularly the orientation of =
the image
so that V4L2_BUF_FLAG seems not to be as suitable as some v4L2 capability.
For the read-only properties, to avoid to use the V4L2_CID seems to be quit=
e logical as
they may appear in the allowed settings on a webcam viewer GUI although the=
y
are not to be changed by the user.

 Cr=C3=A9ez votre adresse =C3=A9lectronique prenom.nom@laposte.net=20
 1 Go d'espace de stockage, anti-spam et anti-virus int=C3=A9gr=C3=A9s.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
