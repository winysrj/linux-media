Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4FD4ugO023289
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 09:04:57 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.236])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4FD4k6r003169
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 09:04:46 -0400
Received: by rv-out-0506.google.com with SMTP id f6so468921rvb.51
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 06:04:46 -0700 (PDT)
Message-ID: <62e5edd40805150604h6d0f23ffybf13eb6b07d87a76@mail.gmail.com>
Date: Thu, 15 May 2008 15:04:45 +0200
From: "=?ISO-8859-1?Q?Erik_Andr=E9n?=" <erik.andren@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Subject: In-kernel frame conversion
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

Hi list,
I'm one of the developers of the m560x project. (
http://sourceforge.net/projects/m560x-driver/ )
aiming to provide a driver for the ALi m5602, m5603 chipsets.

As no datasheets for these chipsets are available we are resorted to revers=
e
engineer the windows driver.
This driver is unfortunately braindead, always sending Bayer-encoded frames
at a fixed VGA resolution.
Color recovery, resizing and format conversion is all done in software.

Currently we do the same in order to make the camera useful as many relevan=
t
linux v4l2 applications fail to have user-space routines converting
Bayer-frames.

Is it possible to get a driver included upstream and still have such
kernel-space frame conversion routines or do they have to go in order to ge=
t
the driver in an acceptable shape?

Regards,
Erik Andr=E9n
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
