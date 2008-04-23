Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3NDZwEq027358
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 09:35:58 -0400
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.240])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3NDZVkS026435
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 09:35:32 -0400
Received: by an-out-0708.google.com with SMTP id c31so786195ana.124
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 06:35:31 -0700 (PDT)
Message-ID: <440801370804230635t1d734144ta3a4ca5acd6b77f6@mail.gmail.com>
Date: Wed, 23 Apr 2008 15:35:28 +0200
From: "Francisco Javier Cabello Torres" <fjcabello@visual-tools.com>
To: video4linux-list@redhat.com, "Gerd Knorr" <kraxel@bytesex.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Cc: 
Subject: saa7130 driver error
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

Dear all,

I am developping a conventional video application over a saa7130 board.
I am using kernel 2.6.24.4 and I use saa7134 driver which is included.

I am able to open the device and get images using mmap way.
Sometimes saa7134 decoder is not able to complete a buffer and an
internal timeout rises. The function called is  saa7134_buffer_timeout
(saa7134-core.c).

When this happens VIDIOC_DQBUF ioctl returns -1 and errno=3DEIO.
In this case application shoudl enqueue the buffer calling VIDIOC_QBUF.
The problem is that after calling VIDIOC_DQBUF ioctl, v4l2_buffer structure
is not
properly filled. Buffer index isn't set and when I try to enqueue the buffe=
r
the driver
always gives me an error.

I have checked videbuf-core.c and as I expected,  videobuf_qbuf function
expects
buffer number in order to dequeue it.

The problem is each time this happens one buffer is lost. If you are using
eight buffers,
after eight errors the capture will stop.

Anyone has any clue?

Thanks in advance

Paco

--=20
Francisco Javier Cabello Torres
Investigaci=F3n y Desarrollo
Research and Development
-----
V I S U A L T O O L S
C/Isla Graciosa, 1.
28034 Madrid, Spain.
Telephone: + 34 91 729 48 44
Fax: +34 91 358 52 36
Clave p=FAblica:
http://keyserv.nic-se.se:11371/pks/lookup?op=3Dget&search=3D0x568AE122BBBE5=
820
--------------------------------------
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
