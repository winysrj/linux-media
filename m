Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx13.extmail.prod.ext.phx2.redhat.com
	[10.5.110.18])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id p1A1GukI007696
	for <video4linux-list@redhat.com>; Wed, 9 Feb 2011 20:16:56 -0500
Received: from smtp2.sms.unimo.it (smtp2.sms.unimo.it [155.185.44.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1A1GkIV009796
	for <video4linux-list@redhat.com>; Wed, 9 Feb 2011 20:16:47 -0500
Received: from mail-qy0-f179.google.com ([209.85.216.179]:42352)
	by smtp2.sms.unimo.it with esmtps (TLS1.0:RSA_ARCFOUR_SHA1:16)
	(Exim 4.69) (envelope-from <76466@studenti.unimore.it>)
	id 1PnL9I-0003sH-8Z
	for video4linux-list@redhat.com; Thu, 10 Feb 2011 02:16:44 +0100
Received: by qyj19 with SMTP id 19so644265qyj.3
	for <video4linux-list@redhat.com>; Wed, 09 Feb 2011 17:16:42 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 10 Feb 2011 02:16:42 +0100
Message-ID: <AANLkTin9-uxNOALepFzVFURZ6a_AqUGwuEiB_nWfVxDy@mail.gmail.com>
Subject: patch for ov9655
From: Paolo Santinelli <paolo.santinelli@unimore.it>
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

Hi all,

I have an embedded smart camera equipped with an XScal-PXA270
processor running Linux 2.6.23 (just updated) and
the OV9655 Image sensor.

I have seen some patch (https://patchwork.kernel.org/patch/16548/) for
the  OV9655 that have the cropping function built in  and appear  to
be better than the driver currently in use (X300 camera board),

Please, could somebody tell me how to patch my  Linux 2.6.23 kernel ?

Here is what happen when I try to patch the kernel:


[root@localhost linux-2.6.23]# cat Add-ov9655-camera-driver.patch |
patch -p2 --dry-run
patching file drivers/media/video/Kconfig
Hunk #1 FAILED at 746.
1 out of 1 hunk FAILED -- saving rejects to file drivers/media/video/Kconfi=
g.rej
patching file drivers/media/video/Makefile
Hunk #1 FAILED at 145.
1 out of 1 hunk FAILED -- saving rejects to file
drivers/media/video/Makefile.rej
The next patch would create the file drivers/media/video/ov9655.c,
which already exists!  Assume -R? [n]


Thank you.

Paolo

-- =

--------------------------------------------------
Paolo Santinelli
ImageLab Computer Vision and Pattern Recognition Lab
Dipartimento di Ingegneria dell'Informazione
Universita' di Modena e Reggio Emilia
via Vignolese 905/B, 41125, Modena, Italy

Cell. +39 3472953357,=A0 Office +39 059 2056270, Fax +39 059 2056129
email:=A0 <mailto:paolo.santinelli@unimore.it> paolo.santinelli@unimore.it
URL:=A0 <http://imagelab.ing.unimo.it/> http://imagelab.ing.unimo.it
--------------------------------------------------

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=3Dunsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
