Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9ECmC3W028207
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 08:48:12 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.239])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9ECm02B005686
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 08:48:00 -0400
Received: by rv-out-0506.google.com with SMTP id f6so2182413rvb.51
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 05:47:59 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Tue, 14 Oct 2008 21:46:51 +0900
Message-Id: <20081014124651.5194.93168.sendpatchset@rx1.opensource.se>
Cc: v4l-dvb-maintainer@linuxtv.org, mchehab@infradead.org
Subject: [PATCH 00/05] video: Extended vivi pixel format support
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

Extended vivi pixel format support

[PATCH 01/05] video: Precalculate vivi yuv values
[PATCH 02/05] video: Teach vivi about multiple pixel formats
[PATCH 03/05] video: Add uyvy pixel format support to vivi
[PATCH 04/05] video: Add support for rgb565 pixel formats to vivi
[PATCH 05/05] video: Add support for rgb555 pixel formats to vivi

These patches improve the RGB->YUV color space conversion code
in vivi.c and also add support for the following pixel formats:

V4L2_PIX_FMT_UYVY
V4L2_PIX_FMT_RGB565  /* gggbbbbb rrrrrggg */
V4L2_PIX_FMT_RGB565X /* rrrrrggg gggbbbbb */
V4L2_PIX_FMT_RGB555  /* gggbbbbb arrrrrgg */
V4L2_PIX_FMT_RGB555X /* arrrrrgg gggbbbbb */

With these patches the vivi driver can be used as a reference for
testing the byte order of 16-bit pixel formats. This allows testing
of user space software without actual capture hardware. It is also
useful for people who are developing new drivers and have doubts
which 16-bit RGB interpretation is the valid one (RGB vs BGR).

The color space conversion code is updated to use precalculated YUV
values instead of doing RGB->YUV calculation for every two pixels.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/media/video/vivi.c |  314 +++++++++++++++++++++++++++++++-------------
 1 file changed, 225 insertions(+), 89 deletions(-)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
