Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2SCTgPo018134
	for <video4linux-list@redhat.com>; Sun, 28 Mar 2010 08:29:42 -0400
Received: from mail-pv0-f174.google.com (mail-pv0-f174.google.com
	[74.125.83.174])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2SCTRGl006300
	for <video4linux-list@redhat.com>; Sun, 28 Mar 2010 08:29:28 -0400
Received: by pva18 with SMTP id 18so2291234pva.33
	for <video4linux-list@redhat.com>; Sun, 28 Mar 2010 05:29:27 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 28 Mar 2010 20:29:27 +0800
Message-ID: <3c76e9761003280529r14d86dbepa0f61e8d94d969d3@mail.gmail.com>
Subject: Image format set with VIDIOC_S_FMT successfully on host PC, yet
	failed on target ARM dev-board.
From: Gallon Fr <gallonfr@gmail.com>
To: video4linux-list@redhat.com
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

Hi,all:
I got a problem while I was trying to capture a frame through a webcam
on a dev-board.I just followed the example provided by V4L2 specs and
made a little change in the process_image() function.The code runs
well on my PC,and I can exactly get a converted BMP file after setting
the image format to "YUYV".
BUT when port it to ARM, I just got the "Invalid Argument" error
returned by VIDIOC_S_FMT.I tried with the G_FMT ioctl both on PC and
ARM and the result confused me.While on ARM the returned supported
format is "MJPG",rather than "YUYV" on PC and that's why the S_FMT
complained.
Here is some info about my environment.
host-pc: Fedora 12( kernel 2.6.31.5)
target-arm: arm-linux (kernel 2.6.32.2) EABI enabled/V4L enabled/gspca
enabled/uvc enabled
cross-compiler: Soucery G++ (EABI)
Should I just install a module to ARM or add something else?Or maybe
someone could leave me a hint?
Thanks and Regards
Fei

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
