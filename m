Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8I6xYps026371
	for <video4linux-list@redhat.com>; Thu, 18 Sep 2008 02:59:34 -0400
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8I6xWkX003691
	for <video4linux-list@redhat.com>; Thu, 18 Sep 2008 02:59:32 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id m8I6xOsx014904
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Thu, 18 Sep 2008 01:59:31 -0500
Received: from dbde70.ent.ti.com (localhost [127.0.0.1])
	by dbdp20.itg.ti.com (8.13.8/8.13.8) with ESMTP id m8I6xMqj013674
	for <video4linux-list@redhat.com>; Thu, 18 Sep 2008 12:29:23 +0530 (IST)
From: "Jadav, Brijesh R" <brijesh.j@ti.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Thu, 18 Sep 2008 12:29:22 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403CD6B7339@dbde02.ent.ti.com>
Content-Language: en-US
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: Sliced VBI Capture with Memory Mapped Buffers
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

I want to capture Sliced VBI data using the Memory mapped buffer exchange m=
echanism with the device node same as that of video capture. The problem is=
 how to distinguish between video buffer and sliced vbi buffer when mapping=
 them since mmap system call takes buffer offset as the argument and queryb=
uf ioclt always provides me the buffer offset starting from 0 so the offset=
 of the first buffer of both video data and sliced vbi data is 0. It looks =
like i have to create separate device node for the vbi data. Is there any o=
ther way out? Is there any way i can synchronize the sliced vbi data with t=
he video data?

Thanks,
Brijesh Jadav
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
