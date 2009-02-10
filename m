Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1AAiloO028345
	for <video4linux-list@redhat.com>; Tue, 10 Feb 2009 05:44:47 -0500
Received: from bay0-omc1-s13.bay0.hotmail.com (bay0-omc1-s13.bay0.hotmail.com
	[65.54.246.85])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1AAiOpf007349
	for <video4linux-list@redhat.com>; Tue, 10 Feb 2009 05:44:24 -0500
Message-ID: <BAY133-W4652E95BF1075A6A6FD3FAD4BD0@phx.gbl>
From: Paco Camberos <pacocamberos@hotmail.com>
To: <video4linux-list@redhat.com>
Date: Tue, 10 Feb 2009 11:44:24 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: Question about bttv and V4L2_MEMORY_USEPTR
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


Hello=2C
I am using "SUSE Linux Enterprise Server 10 SP2 (i586)" with kernel 2.6.16.=
60-0.21-bigsmp and have one capture card:
=20
* v4l2 device:  "/dev/video0"   module                  : "bttv"   card    =
                : "BT878 video (AVerMedia TVPhone "
=20
   NOTE: The "bttv" module uses the "video_buf" module too.
My problem:
  I am unable to execute the V4l2 example program http://v4l2spec.bytesex.o=
rg/v4l2spec/capture.c using "application allocated buffer" (V4L2_MEMORY_USE=
RPTR):
=20
 # ./capture -u -d /dev/video0 VIDIOC_QBUF error 12=2C Cannot allocate memo=
ry
=20
  NOTE: V4L2_MEMORY_MMAP or V4L2_MEMORY_READ run OK.
Question:  Does "bttv" module support "application allocated buffer" (V4L2_=
MEMORY_USERPTR)? Or may it be a bug into the "video_buf" module?
Thanks a lot=2C
_________________________________________________________________
Ll=E9vate Messenger en tu m=F3vil all=E1 donde vayas =BFA qu=E9 esperas?
http://serviciosmoviles.es.msn.com/=
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
