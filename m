Return-path: <linux-media-owner@vger.kernel.org>
Received: from mis07.de ([93.186.196.80]:42448 "EHLO mis07.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756075AbZHNVgj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2009 17:36:39 -0400
Received: from pcvirus (p5DC8FB2A.dip.t-dialin.net [93.200.251.42])
	by mis07.de (Postfix) with ESMTPA id E97B2144E01C
	for <linux-media@vger.kernel.org>; Fri, 14 Aug 2009 23:36:24 +0200 (CEST)
Message-ID: <5F4AD632B3F24770A35CD99D34F06294@pcvirus>
From: "Rath" <mailings@hardware-datenbank.de>
To: <linux-media@vger.kernel.org>
Subject: V4L image grab
Date: Fri, 14 Aug 2009 23:36:16 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

with this code from the internet I only get pictures with some undefined 
pixels on the top and black pixels on the bottom.

Where's the problem? I only want a simple example for image captureing.

Here is the code:

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <libv4l1.h>
#include <linux/videodev.h>

#define GES_LAENGE (640*480)

unsigned char  bild[GES_LAENGE];

int main()
{
        int fd;
        long laenge;
        struct video_window video_win;
        FILE *bilddatei;

        if((fd = v4l1_open("/dev/video0", O_RDONLY)) == -1)
        {
                printf("Fehler beim Oeffnen von /dev/video0\r\n");
                return 1;
        }
        if( v4l1_ioctl( fd, VIDIOCGWIN, &video_win) == -1)
        {
                printf("Fehler beim setzen der Einstellungen\r\n");
                return 1;
        }
        laenge = video_win.width * video_win.height;
        if( laenge > GES_LAENGE)
        {
                printf("Bild ist groesser als angegeben\r\n");
                return 1;
        }


        if( v4l1_read( fd, bild, laenge) == -1)
        {
                printf("Auslesen der Kamera nicht möglch\r\n");
                return 1;
        }
        if((bilddatei = fopen( "bild.ppm", "w+b")) == NULL)
        {
                printf("Konnte die datei zum schreiben nicht öffnen\r\n");
                return 1;
        }
        v4l1_close(fd);
        fprintf( bilddatei, "P6\n%d %d\n255\n",video_win.width,
video_win.height);
        fwrite( bild, 1, video_win.width*video_win.height,bilddatei);
        fclose(bilddatei);
        return 0;
}

Regards, Joern 

