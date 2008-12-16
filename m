Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBGCX7c8002280
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 07:33:07 -0500
Received: from smtp-vbr5.xs4all.nl (smtp-vbr5.xs4all.nl [194.109.24.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBGCWsn8018882
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 07:32:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l <video4linux-list@redhat.com>
Date: Tue, 16 Dec 2008 13:32:52 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161332.52475.hverkuil@xs4all.nl>
Cc: Michael Schimek <mschimek@gmx.at>
Subject: V4L2 spec typo for V4L2_PIX_FMT_BGR32 format?
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

Hi,

The v4l2 spec says this 
(http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html#PIXFMT-RGB):

V4L2_PIX_FMT_BGR32  'BGR4'
   b7b6b5b4b3b2b1b0 g7g6g5g4g3g2g1g0 r7r6r5r4r3r2r1r0 a7a6a5a4a3a2a1a0
V4L2_PIX_FMT_RGB32  'RGB4'
   r7r6r5r4r3r2r1r0 g7g6g5g4g3g2g1g0 b7b6b5b4b3b2b1b0 a7a6a5a4a3a2a1a0

But I'm pretty sure this should be:

V4L2_PIX_FMT_BGR32  'BGR4'
   a7a6a5a4a3a2a1a0 b7b6b5b4b3b2b1b0 g7g6g5g4g3g2g1g0 r7r6r5r4r3r2r1r0
V4L2_PIX_FMT_RGB32  'RGB4'
   r7r6r5r4r3r2r1r0 g7g6g5g4g3g2g1g0 b7b6b5b4b3b2b1b0 a7a6a5a4a3a2a1a0

since the only difference should be endianess.

Or am I mistaken?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
