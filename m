Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx01.extmail.prod.ext.phx2.redhat.com
	[10.5.110.5])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nACBeq9W025005
	for <video4linux-list@redhat.com>; Thu, 12 Nov 2009 06:40:52 -0500
Received: from mail-px0-f173.google.com (mail-px0-f173.google.com
	[209.85.216.173])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nACBeqJP020264
	for <video4linux-list@redhat.com>; Thu, 12 Nov 2009 06:40:52 -0500
Received: by pxi3 with SMTP id 3so1567605pxi.22
	for <video4linux-list@redhat.com>; Thu, 12 Nov 2009 03:40:51 -0800 (PST)
MIME-Version: 1.0
From: Shun-Yu Chang <shunyu.chang@gmail.com>
Date: Thu, 12 Nov 2009 19:39:36 +0800
Message-ID: <e858e0620911120339t68172862i7f6ec38e88bcf426@mail.gmail.com>
To: V4L-Linux <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: Camera preview, thin lines in the frames
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

Hello, list:
    I am new to v4l2.  I am working on integrating a usb camera device on
the beagleboard(Omap3530 dev board).
    Now I met a camera preview issue that is there are thin lines coming out
in the frames.
    I still have no idea how to describe this exactly. It's like the images
shows here,
    http://0xlab.org/~jeremy/camera_preview.html
    I modified capture.c sample to save the frames to picture files.  So in
my guess,  the problem is not in userspace. And this is not happen on my
laptop with the usb camera.
    Could anybody give me a clue ?  Any one would be thankful.

-- 
Regards,
-Jeremy
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
