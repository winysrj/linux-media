Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:22257 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab2GRIX1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 04:23:27 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH for 3.5] v4l2-dev: forgot to add VIDIOC_DV_TIMINGS_CAP.
Date: Wed, 18 Jul 2012 10:13:23 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>,
	"'Mauro Carvalho Chehab'" <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_jAnBQKfGVv+tgiP"
Message-Id: <201207181013.23597.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_jAnBQKfGVv+tgiP
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Linus,

I'm sending the attached one-liner patch directly to you for inclusion in 3.5 as
without it the new VIDIOC_DV_TIMINGS_CAP ioctl doesn't work. The cause was that
for 3.5 two patch series were merged, one changing V4L2 core ioctl handling and
one adding new functionality, and some of the new functionality wasn't handled
by the new V4L2 core code.

Mauro is still on a well-deserved vacation, so I'm sending it to you directly
so it can be merged for 3.5 before it is released.

Regards,

	Hans

--Boundary-00=_jAnBQKfGVv+tgiP
Content-Type: text/x-patch;
  charset="ISO-8859-1";
  name="0001-v4l2-dev-forgot-to-add-VIDIOC_DV_TIMINGS_CAP.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-v4l2-dev-forgot-to-add-VIDIOC_DV_TIMINGS_CAP.patch"

=46rom 3a9fa27511a2ed13a24ed431879557ddb3ca406b Mon Sep 17 00:00:00 2001
Message-Id: <3a9fa27511a2ed13a24ed431879557ddb3ca406b.1342592537.git.hans.v=
erkuil@cisco.com>
=46rom: Hans Verkuil <hans.verkuil@cisco.com>
Date: Wed, 11 Jul 2012 14:12:45 +0200
Subject: [PATCH 1/2] v4l2-dev: forgot to add VIDIOC_DV_TIMINGS_CAP.

The VIDIOC_DV_TIMINGS_CAP ioctl check wasn't added to determine_valid_ioctl=
s().
This caused this ioctl to always return -ENOTTY.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
=2D--
 drivers/media/video/v4l2-dev.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 83dbb2d..0cbada1 100644
=2D-- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -681,6 +681,7 @@ static void determine_valid_ioctls(struct video_device =
*vdev)
 	SET_VALID_IOCTL(ops, VIDIOC_G_DV_TIMINGS, vidioc_g_dv_timings);
 	SET_VALID_IOCTL(ops, VIDIOC_ENUM_DV_TIMINGS, vidioc_enum_dv_timings);
 	SET_VALID_IOCTL(ops, VIDIOC_QUERY_DV_TIMINGS, vidioc_query_dv_timings);
+	SET_VALID_IOCTL(ops, VIDIOC_DV_TIMINGS_CAP, vidioc_dv_timings_cap);
 	/* yes, really vidioc_subscribe_event */
 	SET_VALID_IOCTL(ops, VIDIOC_DQEVENT, vidioc_subscribe_event);
 	SET_VALID_IOCTL(ops, VIDIOC_SUBSCRIBE_EVENT, vidioc_subscribe_event);
=2D-=20
1.7.10.4


--Boundary-00=_jAnBQKfGVv+tgiP--
