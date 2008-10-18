Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9IBI4ha002200
	for <video4linux-list@redhat.com>; Sat, 18 Oct 2008 07:18:04 -0400
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9IBHrp0019696
	for <video4linux-list@redhat.com>; Sat, 18 Oct 2008 07:17:54 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id m9IBHlRZ027990
	for <video4linux-list@redhat.com>; Sat, 18 Oct 2008 06:17:53 -0500
Received: from dbde71.ent.ti.com (localhost [127.0.0.1])
	by dbdp20.itg.ti.com (8.13.8/8.13.8) with ESMTP id m9IBHjjU003074
	for <video4linux-list@redhat.com>; Sat, 18 Oct 2008 16:47:46 +0530 (IST)
From: "Jadav, Brijesh R" <brijesh.j@ti.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Sat, 18 Oct 2008 16:47:47 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403DC2A8962@dbde02.ent.ti.com>
Content-Language: en-US
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Subject: Physically Contiguous Buffer
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

Hi All,

I am working with a device, which can work with physically non-contiguous b=
uffer. Since physically contiguous buffer can also be treated as non-contig=
uous buffer, device can also work with contiguous buffer. I am using videob=
uf-dma-sg layer for the buffer manager of non-contiguous buffer. The proble=
m I am facing is since this layer does not handle physically contiguous buf=
fers, whenever I pass pointer to the physically contiguous buffer to the vi=
deobuf_iolock function through VIDIOC_QBUF ioctl, it returns me error. Sinc=
e videobuf_iolock function always calls get_user_pages to get the user land=
 pages, it returns error for this buffer. Can someone help in solving this =
problem? Is it possible to treat physically contiguous buffer as non-contig=
uous buffer and create a scatter-gather list in this layer?

Thanks,
Brijesh Jadav

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
