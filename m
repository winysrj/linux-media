Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1MKoh1M000863
	for <video4linux-list@redhat.com>; Sun, 22 Feb 2009 15:50:43 -0500
Received: from smtp113.rog.mail.re2.yahoo.com (smtp113.rog.mail.re2.yahoo.com
	[68.142.225.229])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n1MKnLw4018942
	for <video4linux-list@redhat.com>; Sun, 22 Feb 2009 15:49:21 -0500
Message-ID: <49A1BA50.4090201@rogers.com>
Date: Sun, 22 Feb 2009 15:49:20 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Sergei Antonov <sa@sa.pp.ru>
References: <F13ADD43ECED4C45A8BE7A74E5B02BFE@W1>
In-Reply-To: <F13ADD43ECED4C45A8BE7A74E5B02BFE@W1>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Genius Look 317
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

Sergei Antonov wrote:
> Hi!
> I'm trying to make 'Genius Look 317' (0c45:60b0, gspca recognizes it)
> webcam work.
>
> v4lgrab.c (from linux-2.6.28.5\Documentation\video4linux) loops
> infinitely in this code:
>
>  do {
>    int newbright;
>    read(fd, buffer, win.width * win.height * bpp);
>    f = get_brightness_adj(buffer, win.width * win.height, &newbright);
>    if (f) {
>      vpic.brightness += (newbright << 8);
>      if(ioctl(fd, VIDIOCSPICT, &vpic)==-1) {
>        perror("VIDIOSPICT");
>        break;
>      }
>    }
>  } while (f);
>
> because variable 'f' is always non-zero.
> If I write 'while(0);' the resulting .ppm contains some random pixels
> in the top and the rest of the picture is black.
> Need help.

Hi, I'd re-title your message to include the fact that its a gspca based
webcam (to attract those developers attention) and send it off to the
linux-media mailing list (which is where discussion is transitioning to:
http://www.linuxtv.org/news.php?entry=2009-01-06.mchehab)

Cheers

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
