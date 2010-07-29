Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx07.extmail.prod.ext.phx2.redhat.com
	[10.5.110.11])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o6THkPdB021461
	for <video4linux-list@redhat.com>; Thu, 29 Jul 2010 13:46:25 -0400
Received: from gateway01.websitewelcome.com (gateway01.websitewelcome.com
	[69.56.159.19])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id o6THkGpa016594
	for <video4linux-list@redhat.com>; Thu, 29 Jul 2010 13:46:16 -0400
From: "Charlie X. Liu" <charlie@sensoray.com>
To: "'Gabriel Duarte'" <confusosk8@gmail.com>,
        "'video4linux-list'" <video4linux-list@redhat.com>
References: <AANLkTim-92xffBTddcCiizrV3L=bwvfF8Xt2nhvkxop1@mail.gmail.com>
In-Reply-To: <AANLkTim-92xffBTddcCiizrV3L=bwvfF8Xt2nhvkxop1@mail.gmail.com>
Subject: RE: Max size format
Date: Thu, 29 Jul 2010 10:46:19 -0700
Message-ID: <001b01cb2f45$f445b8d0$dcd12a70$@com>
MIME-Version: 1.0
Content-Language: en-us
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

Usually, you should take 720x480 (D1.NTSC) or 720x576 (D1.PAL) or 640x480
(VGA) size from a TV capture card.

-----Original Message-----
From: video4linux-list-bounces@redhat.com
[mailto:video4linux-list-bounces@redhat.com] On Behalf Of Gabriel Duarte
Sent: Thursday, July 29, 2010 9:56 AM
To: video4linux-list
Subject: Max size format

Hello all!
I've built an app to get the max size of my cameras! I got two capture
devices, and simple webcam, with max size 640x480 and a TV capture card, max
size 744x480. When I query my webcam, at /dev/video0, it returns the right
size, but my TV card returns a weird size, like this:


*gabriel@bourbaki:~/Desktop$ ./camera_size /dev/video0*
*raw pixfmt: YUYV 640x480*
*pixfmt: RGB3 640x480*
*gabriel@bourbaki:~/Desktop$ ./camera_size /dev/video1*
*raw pixfmt: BGR3 48x32*
*pixfmt: RGB3 48x32*
*
*
I'll attach my code and if someone find out what is going wrong, I'd be very
glad!

Thank you all!


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

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
