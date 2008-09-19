Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8J76EBd008651
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 03:06:14 -0400
Received: from comal.ext.ti.com (comal.ext.ti.com [198.47.26.152])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m8J75k9F020156
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 03:05:46 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id m8J75dqh021973
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 02:05:45 -0500
Received: from dbde70.ent.ti.com (localhost [127.0.0.1])
	by dbdp20.itg.ti.com (8.13.8/8.13.8) with ESMTP id m8J75cIg026698
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 12:35:39 +0530 (IST)
From: "Jadav, Brijesh R" <brijesh.j@ti.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Fri, 19 Sep 2008 12:35:37 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403CD7C8B7B@dbde02.ent.ti.com>
Content-Language: en-US
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Subject: Custom Standards
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

Hi Hans,

In the current V4L2 implementation, VIDIOC_ENUMSTD ioctl is implemented as =
part of V4L2 core driver (v4l2-ioctl.c). It is good to have this ioctl impl=
emented in the core itself to avoid duplication of code, but it looks that =
there are no hooks available for custom standards. This ioctl is important =
for the application to know standards (supported in V4l2 core) and their at=
tributes supported by the driver (including custom standards) although it h=
as to include custom header file. Is there any way out for this problem?

Thanks,
Brijesh Jadav
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
