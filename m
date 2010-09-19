Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2049 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab0ISJGd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 05:06:33 -0400
Received: from tschai.localnet (186.84-48-119.nextgentel.com [84.48.119.186])
	(authenticated bits=0)
	by smtp-vbr4.xs4all.nl (8.13.8/8.13.8) with ESMTP id o8J96VWu065655
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 19 Sep 2010 11:06:32 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.37] Remove BKL from usbvision
Date: Sun, 19 Sep 2010 11:06:25 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009191106.25777.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit 991403c594f666a2ed46297c592c60c3b9f4e1e2:
  Mauro Carvalho Chehab (1):
        V4L/DVB: cx231xx: Avoid an OOPS when card is unknown (card=0)

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/v4l-dvb.git bkl

Hans Verkuil (1):
      usbvision: remove BKL from usbvision

 drivers/media/video/usbvision/usbvision-i2c.c   |    9 +++++++++
 drivers/media/video/usbvision/usbvision-video.c |    8 +++-----
 drivers/media/video/usbvision/usbvision.h       |    1 +
 3 files changed, 13 insertions(+), 5 deletions(-)

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
