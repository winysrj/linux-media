Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n041mJjR012937
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 20:48:19 -0500
Received: from out3.laposte.net (out4.laposte.net [193.251.214.121])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n041m39o015989
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 20:48:03 -0500
Received: from meplus.info (localhost [127.0.0.1])
	by mwinf8307.laposte.net (SMTP Server) with ESMTP id DB22C7000086
	for <video4linux-list@redhat.com>; Sun,  4 Jan 2009 02:48:01 +0100 (CET)
Received: from wwinf8403 (lbao93aubmepnpf001-183-pip.meplus.info [10.98.50.10])
	by mwinf8307.laposte.net (SMTP Server) with ESMTP id CB4B07000081
	for <video4linux-list@redhat.com>; Sun,  4 Jan 2009 02:48:01 +0100 (CET)
From: Olivier Lorin <o.lorin@laposte.net>
To: video4linux-list@redhat.com
Message-ID: <19691783.686993.1231033681816.JavaMail.www@wwinf8403>
MIME-Version: 1.0
Date: Sun,  4 Jan 2009 02:48:01 +0100 (CET)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: =?utf-8?q?RFC_=3A_addition_of_a_flag_to_rotate_decoded_images_by?=
	=?utf-8?b?IDE4MMKw?=
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

Hi all,

I maintain the driver of a webcam (Genesys 05O3:05e3) embedded in a laptop =
screen which has the ability to pivot vertically up to 180=C2=B0. The raw B=
ayer data from the webcam come with the indication that the image is right =
up or upside down depending on how much the webcam has been rotated. One of=
 the sensor embedded in that webcam does not support the mirror and flip so=
 that the rotation of the image must be done by software at decoding time.
So what about a new V4L2_xxx set by the driver to tell the image has to be =
rotated by 180=C2=B0?
As it does not seem to be anticipated that the driver can change the image =
state on the fly, a way to do that may be a new V4L2_CID_UPSIDEDOWN which i=
s set by the driver and read by libv4l on a regular basis.

Regards,
Nol

 Cr=C3=A9ez votre adresse =C3=A9lectronique prenom.nom@laposte.net=20
 1 Go d'espace de stockage, anti-spam et anti-virus int=C3=A9gr=C3=A9s.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
