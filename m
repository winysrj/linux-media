Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAOM9pjR031485
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 17:09:51 -0500
Received: from smtp-vbr14.xs4all.nl (smtp-vbr14.xs4all.nl [194.109.24.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAOM9eIC010837
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 17:09:40 -0500
Received: from tschai.lan (cm-84.208.85.194.getinternet.no [84.208.85.194])
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id mAOM9cFl025027
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 23:09:39 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l <video4linux-list@redhat.com>
Date: Mon, 24 Nov 2008 23:09:37 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811242309.37489.hverkuil@xs4all.nl>
Subject: v4l2_device/v4l2_subdev: please review
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

Hi all,

I've finally tracked down the last oops so I could make a new tree with 
all the latest changes.

My http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-ng tree contains the 
following:

- v4l2: add v4l2_device and v4l2_subdev structs to the v4l2 framework.
- v4l2-common: add i2c helper functions
- cs53l32a: convert to v4l2_subdev.
- cx25840: convert to v4l2_subdev.
- m52790: convert to v4l2_subdev.
- msp3400: convert to v4l2_subdev.
- saa7115: convert to v4l2_subdev.
- saa7127: convert to v4l2_subdev.
- saa717x: convert to v4l2_subdev.
- tuner: convert to v4l2_subdev.
- upd64031a: convert to v4l2_subdev.
- upd64083: convert to v4l2_subdev.
- vp27smpx: convert to v4l2_subdev.
- wm8739: convert to v4l2_subdev.
- wm8775: convert to v4l2_subdev.
- ivtv: convert to v4l2_device/v4l2_subdev.

These files are the most important ones to look at:

linux/Documentation/video4linux/v4l2-framework.txt
linux/drivers/media/video/v4l2-device.c
linux/drivers/media/video/v4l2-subdev.c
linux/include/media/v4l2-device.h
linux/include/media/v4l2-subdev.h

In addition, I've converted all the i2c modules used by ivtv and also 
ivtv itself.

If there is no new feedback then I'll make a pull request for this on 
Friday. Once it is in I'll start converting other drivers.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
