Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBA7kZRc014210
	for <video4linux-list@redhat.com>; Wed, 10 Dec 2008 02:46:35 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.226])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBA7kLWo006318
	for <video4linux-list@redhat.com>; Wed, 10 Dec 2008 02:46:21 -0500
Received: by rv-out-0506.google.com with SMTP id f6so317134rvb.51
	for <video4linux-list@redhat.com>; Tue, 09 Dec 2008 23:46:21 -0800 (PST)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Wed, 10 Dec 2008 16:44:35 +0900
Message-Id: <20081210074435.5727.93374.sendpatchset@rx1.opensource.se>
Cc: g.liakhovetski@gmx.de
Subject: [PATCH 00/03] video: nv1x/nvx1 support for the sh_mobile_ceu driver
	V2
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

NV12/NV21/NV16/NV61 support V2:

[PATCH 01/03] sh_mobile_ceu: use new pixel format translation code
[PATCH 02/03] sh_mobile_ceu: add NV12 and NV21 support
[PATCH 03/03] sh_mobile_ceu: add NV16 and NV61 support

This patchset is the second version of the nv12/nv21 patch named:
"video: nv12/nv21 support for the sh_mobile_ceu driver". This time
YUV support is added by using the new pixel format translation code.
The bulk of the work is done by the NV12 and NV21 patch and it only
requires the pixel format translation patches. NV16 and NV61 support
also requires the NV16/NV61 fourcc patch recently posted.

Tested with ov772x using soc_camera_platform and the ov772x
driver on a Migo-R QVGA board.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/media/video/sh_mobile_ceu_camera.c |  219 ++++++++++++++++++++++------
 1 file changed, 176 insertions(+), 43 deletions(-)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
