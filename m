Return-path: <linux-media-owner@vger.kernel.org>
Received: from mis07.de ([93.186.196.80]:39853 "EHLO mis07.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466AbZH3NII (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 09:08:08 -0400
Received: from pcvirus (p5DC8F776.dip.t-dialin.net [93.200.247.118])
	by mis07.de (Postfix) with ESMTPA id 17924144E022
	for <linux-media@vger.kernel.org>; Sun, 30 Aug 2009 15:08:04 +0200 (CEST)
Message-ID: <27AACDFC886B44FEA173C0F23613BD3D@pcvirus>
From: "rath" <mailings@hardware-datenbank.de>
To: <linux-media@vger.kernel.org>
Subject: V4L2 webcam image grab
Date: Sun, 30 Aug 2009 15:07:51 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0030_01CA2983.A4EFE440"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0030_01CA2983.A4EFE440
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit

Hi,

I tried to write a simple program which reads a webcam out and saves the
picture in a file. The camera is a Philips SPC1030NC with the uvc driver.

But the program doesn't work. The pictures look like the image [1] and
I get this output from my program, which is attached:

        Width: 640 Height: 480 Pixelformat: 1196444237
        libv4lconvert: Error decompressing JPEG: fill_nbits error: need 2 
more bits
        Fertig!

What have I to change in my program?

Regards, Joern

[1] http://royalclan.de/files/forum/webcam_image.ppm 

------=_NextPart_000_0030_01CA2983.A4EFE440
Content-Type: text/plain;
	format=flowed;
	name="ppm_webcam_grab.c";
	reply-type=original
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ppm_webcam_grab.c"

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <stdlib.h>
//#include <libv4l1.h>
#include <libv4l2.h>
//#include <linux/videodev.h>
#include <linux/videodev2.h>



int main()
{
	struct v4l2_format format;
	char *data;
	int fd;


	fd =3D v4l2_open("/dev/video0", O_RDWR);

	//Einstelllungen auslesen
	format.type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE;
	if(v4l2_ioctl(fd,VIDIOC_G_FMT, &format)<0){
		printf("Error getting Camera info");
	}

	printf("Width: %d Height: %d Pixelformat: %d\r\n", =
format.fmt.pix.width, format.fmt.pix.height, =
format.fmt.pix.pixelformat);

	format.fmt.pix.width=3D640;
	format.fmt.pix.height=3D480;
	format.fmt.pix.pixelformat=3DV4L2_PIX_FMT_RGB24;

	//Werte setzen
	if(v4l2_ioctl(fd, VIDIOC_S_FMT, &format)<0){
		printf("Error setting Camera settings");
	}

	//Speicher f=C3=BCr Bild reservieren
	data =3D malloc((format.fmt.pix.sizeimage*3));
	if(data=3D=3DNULL){
		printf("Error getting space for image");
		return 1;
	}

	//Bild einlesen
	if(v4l2_read(fd, data, format.fmt.pix.sizeimage*3) < 0){
		printf("v4l2_read() returned error \r\n");
	}

	//Ausgabedatei =C3=B6ffnen + Header schreiben
	FILE * img =3D fopen("webcam_image.ppm","w");
	fprintf(img, "P6\n%d %d\n255\n",format.fmt.pix.width, =
format.fmt.pix.height);

	fwrite(data, (format.fmt.pix.sizeimage*3),1, img);

	fclose(img);
	v4l2_close(fd);

	printf("Fertig!\r\n");

    return 0;
}

------=_NextPart_000_0030_01CA2983.A4EFE440--

