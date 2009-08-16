Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47711 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbZHPCht convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Aug 2009 22:37:49 -0400
Date: Sat, 15 Aug 2009 23:37:44 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Rath" <mailings@hardware-datenbank.de>
Cc: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>,
	<linux-media@vger.kernel.org>
Subject: Re: V4L image grab
Message-ID: <20090815233744.5a03e364@caramujo.chehab.org>
In-Reply-To: <FC1FB0CA6E6842A49F5F5B383DF6D8B8@pcvirus>
References: <5F4AD632B3F24770A35CD99D34F06294@pcvirus>
	<5e9665e10908150253s5793a36eyd35dd06c6e5d94a8@mail.gmail.com>
	<FC1FB0CA6E6842A49F5F5B383DF6D8B8@pcvirus>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 15 Aug 2009 20:23:43 +0200
"Rath" <mailings@hardware-datenbank.de> escreveu:

> With the example from the api specifications I get this output:
> root@beagleboard:~# ./capture -d /dev/video0
> ....................................................................................................
> Where can I find the captured images?

It would better to use v4l2grab instead.
> 
> ----- Original Message ----- 
> From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
> To: "Rath" <mailings@hardware-datenbank.de>
> Cc: <linux-media@vger.kernel.org>
> Sent: Saturday, August 15, 2009 11:53 AM
> Subject: Re: V4L image grab
> 
> 
> On Sat, Aug 15, 2009 at 6:36 AM, Rath<mailings@hardware-datenbank.de> wrote:
> > Hi,
> >
> > with this code from the internet I only get pictures with some undefined
> > pixels on the top and black pixels on the bottom.
> >
> > Where's the problem? I only want a simple example for image captureing.
> >
> > Here is the code:
> >
> > #include <stdio.h>
> > #include <unistd.h>
> > #include <fcntl.h>
> > #include <sys/ioctl.h>
> > #include <libv4l1.h>
> > #include <linux/videodev.h>
> >
> > #define GES_LAENGE (640*480)
> >
> > unsigned char bild[GES_LAENGE];
> >
> > int main()
> > {
> > int fd;
> > long laenge;
> > struct video_window video_win;
> > FILE *bilddatei;
> >
> > if((fd = v4l1_open("/dev/video0", O_RDONLY)) == -1)
> > {
> > printf("Fehler beim Oeffnen von /dev/video0\r\n");
> > return 1;
> > }
> > if( v4l1_ioctl( fd, VIDIOCGWIN, &video_win) == -1)
> > {
> > printf("Fehler beim setzen der Einstellungen\r\n");
> > return 1;
> > }
> > laenge = video_win.width * video_win.height;
> > if( laenge > GES_LAENGE)
> > {
> > printf("Bild ist groesser als angegeben\r\n");
> > return 1;
> > }
> >
> >
> > if( v4l1_read( fd, bild, laenge) == -1)
> > {
> > printf("Auslesen der Kamera nicht möglch\r\n");
> > return 1;
> > }
> > if((bilddatei = fopen( "bild.ppm", "w+b")) == NULL)
> > {
> > printf("Konnte die datei zum schreiben nicht öffnen\r\n");
> > return 1;
> > }
> > v4l1_close(fd);
> > fprintf( bilddatei, "P6\n%d %d\n255\n",video_win.width,
> > video_win.height);
> > fwrite( bild, 1, video_win.width*video_win.height,bilddatei);
> > fclose(bilddatei);
> > return 0;
> > }
> >
> 
> 
> Hi Joern,
> 
> That code seems to be using v4l1 APIs. How about using current version
> of video4linux?
> You can find a simple example code at following document:
> http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html#CAPTURE-EXAMPLE
> 
> And about the weird image you got from the v4l1 example code, could be
> a pixelformat missmatch or just some noise fetched but I can't say any
> further without knowing your environment :-)
> Cheers,
> 
> Nate
> 
> > Regards, Joern
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> 




Cheers,
Mauro
