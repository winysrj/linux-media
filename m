Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o6TIOotN022934
	for <video4linux-list@redhat.com>; Thu, 29 Jul 2010 14:24:50 -0400
Received: from mail-ww0-f46.google.com (mail-ww0-f46.google.com [74.125.82.46])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o6TIOeMc023310
	for <video4linux-list@redhat.com>; Thu, 29 Jul 2010 14:24:41 -0400
Received: by wwi17 with SMTP id 17so644650wwi.27
	for <video4linux-list@redhat.com>; Thu, 29 Jul 2010 11:24:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <001b01cb2f45$f445b8d0$dcd12a70$@com>
References: <AANLkTim-92xffBTddcCiizrV3L=bwvfF8Xt2nhvkxop1@mail.gmail.com>
	<001b01cb2f45$f445b8d0$dcd12a70$@com>
Date: Thu, 29 Jul 2010 14:59:50 -0300
Message-ID: <AANLkTi=xEnr0PH_tZ53KqXJE6pp8S82=kNOpDufZGKnJ@mail.gmail.com>
Subject: Re: Max size format
From: Gabriel Duarte <confusosk8@gmail.com>
To: "Charlie X. Liu" <charlie@sensoray.com>
Cc: video4linux-list <video4linux-list@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

I know, but the camera driver returns me 744x480. The image size is not a
problem to, because there is post processing to it;

On Thu, Jul 29, 2010 at 2:46 PM, Charlie X. Liu <charlie@sensoray.com>wrote:

> Usually, you should take 720x480 (D1.NTSC) or 720x576 (D1.PAL) or 640x480
> (VGA) size from a TV capture card.
>
> -----Original Message-----
> From: video4linux-list-bounces@redhat.com
> [mailto:video4linux-list-bounces@redhat.com] On Behalf Of Gabriel Duarte
> Sent: Thursday, July 29, 2010 9:56 AM
> To: video4linux-list
> Subject: Max size format
>
> Hello all!
> I've built an app to get the max size of my cameras! I got two capture
> devices, and simple webcam, with max size 640x480 and a TV capture card,
> max
> size 744x480. When I query my webcam, at /dev/video0, it returns the right
> size, but my TV card returns a weird size, like this:
>
>
> *gabriel@bourbaki:~/Desktop$ ./camera_size /dev/video0*
> *raw pixfmt: YUYV 640x480*
> *pixfmt: RGB3 640x480*
> *gabriel@bourbaki:~/Desktop$ ./camera_size /dev/video1*
> *raw pixfmt: BGR3 48x32*
> *pixfmt: RGB3 48x32*
> *
> *
> I'll attach my code and if someone find out what is going wrong, I'd be
> very
> glad!
>
> Thank you all!
>
>
> --
> Gabriel Duarte
> Linux User #471185
> Rio de Janeiro - RJ
> http://w3.impa.br/~gabrield
>
> Phones:
> (55) (21) 9463-7760  -> Mobile
> (55) (21) 2464-9302  -> Home
> (55) (21) 2529-5080  -> Work
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
>


-- 
Gabriel Duarte
Linux User #471185
Rio de Janeiro - RJ
http://w3.impa.br/~gabrield

Phones:
(55) (21) 9463-7760  -> Mobile
(55) (21) 2464-9302  -> Home
(55) (21) 2529-5080  -> Work
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
