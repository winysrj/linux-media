Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m85FTxZW001181
	for <video4linux-list@redhat.com>; Fri, 5 Sep 2008 11:30:00 -0400
Received: from idcmail-mo2no.shaw.ca (idcmail-mo2no.shaw.ca [64.59.134.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m85FTn6J016780
	for <video4linux-list@redhat.com>; Fri, 5 Sep 2008 11:29:49 -0400
Message-ID: <48C15069.4030404@ekran.org>
Date: Fri, 05 Sep 2008 08:29:45 -0700
From: "B. Bogart" <ben@ekran.org>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
References: <48C05DC8.5060700@ekran.org>	
	<1220568687.2736.12.camel@morgan.walls.org>
	<48C06C3A.5000104@ekran.org> <1220594487.1750.6.camel@localhost>
In-Reply-To: <1220594487.1750.6.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, IOhannes m zmoelnig <zmoelnig@iem.at>
Subject: Re: V4l2 :: Debugging an issue with cx8800 card.
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

Hello Jean-Francois,

I don't believe this is a size issue with svv (but it does appear to be
one with Gem) but the image really looks like NTSC interpreted as PAL to
me, in particular the VBI noise at the bottom.

I ran your test to confirm and:

bbogart@insitu:~/tmp/svv$ ./svv -rg -f 320x240
raw pixfmt: UYVY 320x240
pixfmt: UYVY 320x240
mmap method
raw image dumped to 'image.dat'

bbogart@insitu:~/tmp/svv$ ls -l image.dat
-rw-r--r-- 1 bbogart bbogart 153600 2008-09-05 08:23 image.dat
bbogart@insitu:~/tmp/svv$ ./svv -rg -f 640x480
raw pixfmt: UYVY 640x480
pixfmt: UYVY 640x480
mmap method

raw image dumped to 'image.dat'
bbogart@insitu:~/tmp/svv$ ls -l image.dat
-rw-r--r-- 1 bbogart bbogart 614400 2008-09-05 08:24 image.dat

>From your message I assume a larger file means that indeed the image
format is 640x480. Also mplayer shows video from this device as 640x480.

Johannes,

I'd feel better about svv "working" once I get the normal thing going,
but what Gem files should I compare with svv for stuff like choosing the
pixel format and allocating the size? I took a crack yesterday but I
felt like I was following a string through a haystack through the
various levels of abstraction from pix_video to v4l... FYI the behaviour
is the same for Gem compiled with v4l2 and v4l.

Thanks all,
.b.

Jean-Francois Moine wrote:
> On Thu, 2008-09-04 at 16:16 -0700, B. Bogart wrote:
>> I've not yet tried running your program, but did have some luck with:
>> http://moinejf.free.fr/svv.c
> 
> Hello B.,
> 
> It seems the driver cannot switch to 640x480. You may know it grabbing
> images with svv. Try
> 	svv -rg -f 640x480
> then
> 	svv -rg -f 320x240
> and check each time the size of image.dat.
> 
> Best regards.
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
