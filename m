Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7C8Pcif026235
	for <video4linux-list@redhat.com>; Wed, 12 Aug 2009 04:25:39 -0400
Received: from mail-ew0-f208.google.com (mail-ew0-f208.google.com
	[209.85.219.208])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n7C8PNrA020829
	for <video4linux-list@redhat.com>; Wed, 12 Aug 2009 04:25:23 -0400
Received: by ewy4 with SMTP id 4so3184351ewy.3
	for <video4linux-list@redhat.com>; Wed, 12 Aug 2009 01:25:22 -0700 (PDT)
Message-ID: <4A827C70.4090500@gmail.com>
Date: Wed, 12 Aug 2009 10:25:20 +0200
From: Ryan Raasch <ryan.raasch@gmail.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: framebuffer overlay
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

Hello,

I am trying to write a driver for a camera using the new soc_camera in 
the mainline kernel the output is the overlay framebuffer (pxa270) and i 
would like to use the overlay output feature of v4l2 framework, but the 
framebuffer does not expose itself as a output device (not yet).

Are there any fb that i can use as an example for this?

 From looking at the driver code, it seems like the generic code of 
fbmem.c needs a v4l2 device. Is this in the right ballpark?

Thanks,
Ryan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
