Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0NFOhWQ015744
	for <video4linux-list@redhat.com>; Fri, 23 Jan 2009 10:24:43 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.233])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0NFOOVB000815
	for <video4linux-list@redhat.com>; Fri, 23 Jan 2009 10:24:24 -0500
Received: by rv-out-0506.google.com with SMTP id f6so5216684rvb.51
	for <video4linux-list@redhat.com>; Fri, 23 Jan 2009 07:24:23 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 23 Jan 2009 12:24:23 -0300
Message-ID: <fb065a000901230724p40f99fd9xab2adea025a336@mail.gmail.com>
From: Cristhian Daniel Parra Trepowski <cdparra@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: Gspca problem with kernel 2.6.27
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

Hello Everyone,

I've been looking a lot for a fix to the problem of gspca_vc032x module wit=
h
kernels 2.6.27.xx without any luck. A description of the problem can be
found here <https://bugs.launchpad.net/ubuntu/+source/linux/+bug/271258>.

I installed the jfrancois
<http://linuxtv.org/hg/%7Ejfrancois/gspca/summary>version of the
driver from mercurial, and still have the same problem.

Basically, the module can't be loaded and when you try to do it, it hangs
up.

modprobe -s -v gspca_vc032x
insmod
/lib/modules/2.6.27.9-159.fc10.i686/kernel/drivers/media/video/v4l1-compat.=
ko

insmod
/lib/modules/2.6.27.9-159.fc10.i686/kernel/drivers/media/video/videodev.ko
insmod
/lib/modules/2.6.27.9-159.fc10.i686/kernel/drivers/media/video/gspca/gspca_=
main.ko

insmod
/lib/modules/2.6.27.9-159.fc10.i686/kernel/drivers/media/video/gspca/gspca_=
vc032x.ko

...
It hangs here.

  My hardware is:
  Bus 001 Device 002: ID 046d:0896 Logitech, Inc. OrbiCam

  My Kernel:
  2.6.27.9-159.fc10.i686

  =BFDoes someone know about a workaround on this?.

Thanks,
--=20
Cristhian Daniel Parra Trepowski....
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
