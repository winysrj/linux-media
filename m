Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0OD388T018574
	for <video4linux-list@redhat.com>; Sat, 24 Jan 2009 08:03:08 -0500
Received: from biz30.inmotionhosting.com (biz30.inmotionhosting.com
	[74.124.203.40])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0OD21Xb011746
	for <video4linux-list@redhat.com>; Sat, 24 Jan 2009 08:02:01 -0500
Received: from [88.249.20.122] (helo=[192.168.2.3])
	by biz30.inmotionhosting.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69) (envelope-from <caglarakyuz@gmail.com>)
	id 1LQi97-0001UG-KE
	for video4linux-list@redhat.com; Sat, 24 Jan 2009 05:01:57 -0800
Message-ID: <497B11E5.8080700@gmail.com>
Date: Sat, 24 Jan 2009 15:04:37 +0200
From: Yusuf Caglar AKYUZ <caglarakyuz@gmail.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: DaVinci VPFE Driver and video_queue_core_init
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

I'm trying to fix build errors of davinci_vfpe.c, camera input driver
for davinci platform. Kernel in question is 2.6.28.

Currently driver uses video_queue_init which is deprecated if I'm not
wrong. I thought driver should use video_queue_core_init. However,
video_queue_core_init requires videobuf_qtype_ops and this driver
doesn't have any related structures and functions defined. Moreover,
AFAICS no other driver uses video_queue_core_init. I wonder if there is
something fundamentally wrong.

Driver seems to work other than VIDIOC_REQBUFS ioctl. What can I do?
Should I implement videobuf_qtype_ops functions or not? Or some big
changes are needed in the driver?

Any help would be appreciated, thanks.

Caglar Akyuz
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkl7EeUACgkQ/nL+S5dojeh+8QCcC6XdI+fV4JqSIQdduYVM0plb
ghgAnArJkGkvMyW310vfDba2g6biwWXv
=ZZ+r
-----END PGP SIGNATURE-----

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
