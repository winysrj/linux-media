Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:17990 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbZHOJxq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Aug 2009 05:53:46 -0400
Received: by qw-out-2122.google.com with SMTP id 8so684469qwh.37
        for <linux-media@vger.kernel.org>; Sat, 15 Aug 2009 02:53:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5F4AD632B3F24770A35CD99D34F06294@pcvirus>
References: <5F4AD632B3F24770A35CD99D34F06294@pcvirus>
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Date: Sat, 15 Aug 2009 18:53:27 +0900
Message-ID: <5e9665e10908150253s5793a36eyd35dd06c6e5d94a8@mail.gmail.com>
Subject: Re: V4L image grab
To: Rath <mailings@hardware-datenbank.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 15, 2009 at 6:36 AM, Rath<mailings@hardware-datenbank.de> wrote:
> Hi,
>
> with this code from the internet I only get pictures with some undefined
> pixels on the top and black pixels on the bottom.
>
> Where's the problem? I only want a simple example for image captureing.
>
> Here is the code:
>
> #include <stdio.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <sys/ioctl.h>
> #include <libv4l1.h>
> #include <linux/videodev.h>
>
> #define GES_LAENGE (640*480)
>
> unsigned char  bild[GES_LAENGE];
>
> int main()
> {
>       int fd;
>       long laenge;
>       struct video_window video_win;
>       FILE *bilddatei;
>
>       if((fd = v4l1_open("/dev/video0", O_RDONLY)) == -1)
>       {
>               printf("Fehler beim Oeffnen von /dev/video0\r\n");
>               return 1;
>       }
>       if( v4l1_ioctl( fd, VIDIOCGWIN, &video_win) == -1)
>       {
>               printf("Fehler beim setzen der Einstellungen\r\n");
>               return 1;
>       }
>       laenge = video_win.width * video_win.height;
>       if( laenge > GES_LAENGE)
>       {
>               printf("Bild ist groesser als angegeben\r\n");
>               return 1;
>       }
>
>
>       if( v4l1_read( fd, bild, laenge) == -1)
>       {
>               printf("Auslesen der Kamera nicht möglch\r\n");
>               return 1;
>       }
>       if((bilddatei = fopen( "bild.ppm", "w+b")) == NULL)
>       {
>               printf("Konnte die datei zum schreiben nicht öffnen\r\n");
>               return 1;
>       }
>       v4l1_close(fd);
>       fprintf( bilddatei, "P6\n%d %d\n255\n",video_win.width,
> video_win.height);
>       fwrite( bild, 1, video_win.width*video_win.height,bilddatei);
>       fclose(bilddatei);
>       return 0;
> }
>


Hi Joern,

That code seems to be using v4l1 APIs. How about using current version
of video4linux?
You can find a simple example code at following document:
http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html#CAPTURE-EXAMPLE

And about the weird image you got from the v4l1 example code, could be
a pixelformat missmatch or just some noise fetched but I can't say any
further without knowing your environment :-)
Cheers,

Nate

> Regards, Joern
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
