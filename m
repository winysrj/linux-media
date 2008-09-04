Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m84E4q1U001983
	for <video4linux-list@redhat.com>; Thu, 4 Sep 2008 10:04:53 -0400
Received: from mta4.srv.hcvlny.cv.net (mta4.srv.hcvlny.cv.net [167.206.4.199])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m84E4crM019975
	for <video4linux-list@redhat.com>; Thu, 4 Sep 2008 10:04:39 -0400
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6O003RICFMDY60@mta4.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Thu, 04 Sep 2008 10:04:36 -0400 (EDT)
Date: Thu, 04 Sep 2008 10:04:34 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <f4fceb150809011155pa06831eoff1ef993d3eb17c9@mail.gmail.com>
To: Yair Weinberger <yairwein@gmail.com>
Message-id: <48BFEAF2.9060805@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <f4fceb150809011152n2a0adf2aqffb67a4cf87449c3@mail.gmail.com>
	<f4fceb150809011155pa06831eoff1ef993d3eb17c9@mail.gmail.com>
Cc: video4linux-list <video4linux-list@redhat.com>
Subject: Re: Hauppauge WinTV USB2-Stick with Hardy
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

Yair Weinberger wrote:
> Hi,
> I bought a new Hauppauge WinTV USB2-Stick (At least that's the writing
> on the card).  According to the v4l documentation, this card should be
> supported in the em28xx drivers (card #4).  However, in the
> documentation the vendor & device ID should be 2040:4200 or 2040:4201,
> and my output of lsusb is 2040:6610.
> I checked the em28xx-cards.c file, and my ID doesn't seem to appear
> there (nor in any other file as far as I know).
> The device is of course not automatically recognized, Output of dmesg
> | grep em28xx:
> [  198.082257] em28xx v4l2 driver version 0.1.0 loaded
> [  198.082294] usbcore: registered new interface driver em28xx
> 
> Trying to load it with card=4 produced the following error in the dmesg output:
> em28xx probing error: endpoint is non-ISO endpoint.
> 
> I attached what I think is the appropriate inf file from the Windows
> drivers disk (renamed as text).  I will happily provide more data if required.
> 
> Any advice will be appreciated,
>  Wein

The 66xx model is not supported my the em28xx driver.

For this you need Mauro's tm6010 development trees at 
linuxtv.org/hg/~mchehab/... although I'm not sure what level of support 
he has for that unit.

- Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
