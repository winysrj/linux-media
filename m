Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nACDvKOo015415
	for <video4linux-list@redhat.com>; Thu, 12 Nov 2009 08:57:20 -0500
Received: from mail-gx0-f216.google.com (mail-gx0-f216.google.com
	[209.85.217.216])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nACDv26h024533
	for <video4linux-list@redhat.com>; Thu, 12 Nov 2009 08:57:18 -0500
Received: by mail-gx0-f216.google.com with SMTP id 8so1997021gxk.11
	for <video4linux-list@redhat.com>; Thu, 12 Nov 2009 05:57:18 -0800 (PST)
Message-ID: <4AFC127F.4070300@gmail.com>
Date: Thu, 12 Nov 2009 14:49:51 +0100
From: Ryan Raasch <ryan.raasch@gmail.com>
MIME-Version: 1.0
To: Shun-Yu Chang <shunyu.chang@gmail.com>
References: <e858e0620911120339t68172862i7f6ec38e88bcf426@mail.gmail.com>
In-Reply-To: <e858e0620911120339t68172862i7f6ec38e88bcf426@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: Camera preview, thin lines in the frames
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



Shun-Yu Chang wrote:
> Hello, list:
>     I am new to v4l2.  I am working on integrating a usb camera device on
> the beagleboard(Omap3530 dev board).
>     Now I met a camera preview issue that is there are thin lines coming out
> in the frames.
>     I still have no idea how to describe this exactly. It's like the images
> shows here,
>     http://0xlab.org/~jeremy/camera_preview.html

I have two guesses. One is the jpeg compression ,or is it jpeg? Try 
saving in raw RGB or Ycbcr format and viewing with imagemagick.

Does this happen in live preview? Maybe write data from camera directly 
to screen to see if happening there.

The second would be the FIFO (hadn't worked with omap before) levels of 
the data lines to the processor in the kernel.

Look at the system processor (top) usage to see how much cpu% is being 
used. USB has high overhead.

Regards,
Ryan

>     I modified capture.c sample to save the frames to picture files.  So in
> my guess,  the problem is not in userspace. And this is not happen on my
> laptop with the usb camera.
>     Could anybody give me a clue ?  Any one would be thankful.
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
