Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nAJG4hn1030629
	for <video4linux-list@redhat.com>; Thu, 19 Nov 2009 11:04:43 -0500
Received: from gv-out-0910.google.com (gv-out-0910.google.com [216.239.58.189])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nAJG4RlE013465
	for <video4linux-list@redhat.com>; Thu, 19 Nov 2009 11:04:28 -0500
Received: by gv-out-0910.google.com with SMTP id n40so402256gve.13
	for <video4linux-list@redhat.com>; Thu, 19 Nov 2009 08:04:26 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 19 Nov 2009 21:34:26 +0530
Message-ID: <968530b20911190804n18853c88r76ac96b3c2cd85dc@mail.gmail.com>
From: Mayank Mangla <mayyankk@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Subject: Allocating video buffers from user space
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
I am a new member in this forum. I am currently trying to write a V4L2
driver for a camera which outputs very high resolution images. The problem
is if I call S_FMT with the correct width&height, the subsequent call to
VIDIOC_REQBUFS fails saying "Cannot allocate memory". I have tried to user
buffer memory type as V4L2_MEMORY_USERPTR, but video_reqbufs still tries to
allocate memory in kernel space (which I think is a bug).

Is there any way to allocate buffers in user space and Queue/Dequeue these
buffers to V4L2 driver?

Regards,
Mayank
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
