Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id p0QLKWtK029213
	for <video4linux-list@redhat.com>; Wed, 26 Jan 2011 16:20:32 -0500
Received: from namebay.info (mail.namebay.info [80.247.68.40])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0QLKM2P022861
	for <video4linux-list@redhat.com>; Wed, 26 Jan 2011 16:20:23 -0500
Received: from localhost by namebay.info (MDaemon PRO v9.6.2)
	with ESMTP id md50000829528.msg
	for <video4linux-list@redhat.com>; Wed, 26 Jan 2011 22:20:10 +0100
Message-ID: <20110126221937.20441nqheholaokp@webmail.hebergement.com>
Date: Wed, 26 Jan 2011 22:19:37 +0100
From: fpantaleao@mobisensesystems.com
To: video4linux-list@redhat.com
Subject: Re: Image sensor OV9655 and
References: <AANLkTiny6hNE68x_kFh37o328w2Et70RBfKFOarqtxZG@mail.gmail.com>
In-Reply-To: <AANLkTiny6hNE68x_kFh37o328w2Et70RBfKFOarqtxZG@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Reply-To: fpantaleao@mobisensesystems.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"; DelSp="Yes"
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

Paolo,

In order to capture a portion of an image (ROI), both sensor and  =

PXA270 Quick Capture Interface must be correctly configured. I don't  =

know OV9655 sensor but you can find similar solution in the video  =

drivers for MBS270 V2 board:
http://www.mobisensesystems.com/fics/xscale_BSPs/2009_08/system/src/linux-2=
.6.26-mbs270.tar.bz2

Best regards,

Florian PANTALEAO


Paolo Santinelli <paolo.santinelli@unimore.it> a =E9crit=A0:

> Dear Sirs,
> Hi all,
>
> I am currently trying to write C code for an embedded smart camera
> equipped with an XScal-PXA270 processor running Linux 2.6.9-dma270 and
> the OV9655 Image sensor.
>
> I am asking help, my goal is capture a subfield of the whole image.
>
> How to do it?
>
> Is this function (VIDIOCSCAPTURE or something else?) supported by the
> Video4Linux driver for the OV9655 Image sensor ?
>
> Currently I am able to reconfigure the OV9655 in order to change the
> whole image resolution, 640x480, 320x240 and even lower. The problem
> is I need do it dynamically, quickly, without close the camera and
> then reopen it every time I need sub-capture the image.
>
> I don't have any experience using device driver.
>
> I have tried to change the capture area using this call:
>
> vw.width  =3D new_image_width;
> vw.height =3D new_image_height;
>
> ioctl(fd_camera, VIDIOCSWIN, &vw)
>
> where vw is a struct video_window.
>
> I get the right image but it seems to be not vertically centred, it
> appears shifted and wrapped vertically. To get the right image I have
> to close and reopen the camera. The  closing and opening operations
> take too much time. I would like dynamically  change the  linux device
> driver behaviour without close and reopen the camera.
>
> BTW, the VIDIOCSCAPTURE doesn't work!
>
> Somebody could help me ?
>
> Thanks
>
> Paolo Santinelli
>
> --
> --------------------------------------------------
> PhD student Paolo Santinelli
> ImageLab Computer Vision and Pattern Recognition Lab
> Dipartimento di Ingegneria dell'Informazione
> Universita' di Modena e Reggio Emilia
> via Vignolese 905/B, 41125, Modena, Italy
>
> Cell. +39 3472953357,=A0 Office +39 059 2056270, Fax +39 059 2056129
> email:=A0 <mailto:paolo.santinelli@unimore.it> paolo.santinelli@unimore.it
> URL:=A0 <http://imagelab.ing.unimo.it/> http://imagelab.ing.unimo.it
> --------------------------------------------------
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=3Dunsubscr=
ibe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>





--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=3Dunsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
