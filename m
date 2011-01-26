Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id p0QKjeOU009256
	for <video4linux-list@redhat.com>; Wed, 26 Jan 2011 15:45:40 -0500
Received: from smtp2.sms.unimo.it (smtp2.sms.unimo.it [155.185.44.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0QKjVna012291
	for <video4linux-list@redhat.com>; Wed, 26 Jan 2011 15:45:31 -0500
Received: from mail-ey0-f179.google.com ([209.85.215.179]:41399)
	by smtp2.sms.unimo.it with esmtps (TLS1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.69) (envelope-from <76466@studenti.unimore.it>)
	id 1PiCF8-0006E9-6a
	for video4linux-list@redhat.com; Wed, 26 Jan 2011 21:45:30 +0100
Received: by eyg24 with SMTP id 24so790698eyg.24
	for <video4linux-list@redhat.com>; Wed, 26 Jan 2011 12:45:29 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 26 Jan 2011 21:45:29 +0100
Message-ID: <AANLkTiny6hNE68x_kFh37o328w2Et70RBfKFOarqtxZG@mail.gmail.com>
Subject: Image sensor OV9655 and
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

Dear Sirs,
Hi all,

I am currently trying to write C code for an embedded smart camera
equipped with an XScal-PXA270 processor running Linux 2.6.9-dma270 and
the OV9655 Image sensor.

I am asking help, my goal is capture a subfield of the whole image.

How to do it?

Is this function (VIDIOCSCAPTURE or something else?) supported by the
Video4Linux driver for the OV9655 Image sensor ?

Currently I am able to reconfigure the OV9655 in order to change the
whole image resolution, 640x480, 320x240 and even lower. The problem
is I need do it dynamically, quickly, without close the camera and
then reopen it every time I need sub-capture the image.

I don't have any experience using device driver.

I have tried to change the capture area using this call:

vw.width  =3D new_image_width;
vw.height =3D new_image_height;

ioctl(fd_camera, VIDIOCSWIN, &vw)

where vw is a struct video_window.

I get the right image but it seems to be not vertically centred, it
appears shifted and wrapped vertically. To get the right image I have
to close and reopen the camera. The  closing and opening operations
take too much time. I would like dynamically  change the  linux device
driver behaviour without close and reopen the camera.

BTW, the VIDIOCSCAPTURE doesn't work!

Somebody could help me ?

Thanks

Paolo Santinelli

-- =

--------------------------------------------------
PhD student Paolo Santinelli
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
