Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4RLaZAE018630
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 17:36:35 -0400
Received: from smtp-vbr6.xs4all.nl (smtp-vbr6.xs4all.nl [194.109.24.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4RLZwke027439
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 17:35:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux and Kernel Video <video4linux-list@redhat.com>
Date: Tue, 27 May 2008 23:35:35 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805272335.35852.hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb
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

Hi Mauro,

Please pull from http://www.linuxtv.org/hg/~hverkuil/v4l-dvb for the 
following:

- videodev: small fixes for VIDIOC_G_FREQUENCY and VIDIOC_G_FMT

__video_do_ioctl incorrectly zeroed the tuner field of v4l2_frequency 
for the G_FREQ ioctl and did not zero the full fmt union of v4l2_format 
for VIDIOC_G_FMT.

Thanks,

	Hans

diffstat:
 videodev.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
