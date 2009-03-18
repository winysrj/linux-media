Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2IIpZ06006739
	for <video4linux-list@redhat.com>; Wed, 18 Mar 2009 14:51:35 -0400
Received: from tomts45-srv.bellnexxia.net (tomts45.bellnexxia.net
	[209.226.175.112])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n2IIpIWk020629
	for <video4linux-list@redhat.com>; Wed, 18 Mar 2009 14:51:18 -0400
Received: from toip53-bus.srvr.bell.ca ([67.69.240.54])
	by tomts45-srv.bellnexxia.net
	(InterMail vM.5.01.06.13 201-253-122-130-113-20050324) with ESMTP id
	<20090318185117.PXZE1557.tomts45-srv.bellnexxia.net@toip53-bus.srvr.bell.ca>
	for <video4linux-list@redhat.com>; Wed, 18 Mar 2009 14:51:17 -0400
From: Jonathan Lafontaine <jlafontaine@ctecworld.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Wed, 18 Mar 2009 14:50:44 -0400
Message-ID: <09CD2F1A09A6ED498A24D850EB1012081AFDF9E410@Colmatec004.COLMATEC.INT>
Content-Language: en-US
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Subject: capture raw/encode live
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

Hi, captuer from v4l2 device raw data buffer

I want to teletext / or write something on the image t odisplay to the scre=
en (overlay)

Then

Encode it to the disk mpeg2

Any good solution? Cause too much cpu % for now



Sure hardware chip could be approach,

I wantto keep raw data receive from v4l2... cause have to threat /mod it be=
fore encode it
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
