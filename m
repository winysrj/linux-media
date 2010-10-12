Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o9CLSqs6014684
	for <video4linux-list@redhat.com>; Tue, 12 Oct 2010 17:28:52 -0400
Received: from mail-yw0-f46.google.com (mail-yw0-f46.google.com
	[209.85.213.46])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9CLSf65005701
	for <video4linux-list@redhat.com>; Tue, 12 Oct 2010 17:28:41 -0400
Received: by ywi6 with SMTP id 6so1600068ywi.33
	for <video4linux-list@redhat.com>; Tue, 12 Oct 2010 14:28:41 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 12 Oct 2010 23:28:39 +0200
Message-ID: <AANLkTindsvcRTXRFboirLz0vTtE92R4MZ4V2xf8ccih5@mail.gmail.com>
Subject: VIDIOC_QBUF error 22, Invalid argument
From: Victor Gaspar Martin <victor.gaspar@gmail.com>
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

Hi all!

this is my first post in this mailing list so I hope I'm not asking in the
wrong place.

I had an application based on this code:
  http://libv4l2cam.googlecode.com/svn/trunk/v4l2stereo/libcam.cpp
working fine without problems, but since I updated my Ubuntu to the 10.04 (I
suppose this is somehow related) it began to crash randomly with the
following error:
  VIDIOC_QBUF error 22, Invalid argument

I traced the error and it happens in the method Camera::Get() when using
IO_METHOD_MMAP in the following lines:
    if (-1 =3D=3D xioctl(fd, VIDIOC_QBUF, &buf))
        errno_exit("VIDIOC_QBUF");
so when I try to read a frame from the camera.

Any hint of what could be going wrong?


Thank you very much.
Best regards,

-- =

V=EDctor Gaspar
---------------------------------------------------------------------------=
---------------------------------------
Please consider your environmental responsibilities before printing this
email.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=3Dunsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
