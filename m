Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4291 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab0ISJFT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 05:05:19 -0400
Received: from tschai.localnet (186.84-48-119.nextgentel.com [84.48.119.186])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id o8J95DCa035885
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 19 Sep 2010 11:05:18 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.37] cpia2: remove v4l1 support from this driver
Date: Sun, 19 Sep 2010 11:05:07 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009191105.07723.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Note that I asked Alan Cox to test this, but I never got a reply.

	Hans

The following changes since commit 991403c594f666a2ed46297c592c60c3b9f4e1e2:
  Mauro Carvalho Chehab (1):
        V4L/DVB: cx231xx: Avoid an OOPS when card is unknown (card=0)

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/v4l-dvb.git cpia2

Hans Verkuil (1):
      cpia2: remove V4L1 support from this driver.

 drivers/media/video/cpia2/Kconfig      |    2 +-
 drivers/media/video/cpia2/cpia2.h      |    8 +-
 drivers/media/video/cpia2/cpia2_core.c |   51 ++---
 drivers/media/video/cpia2/cpia2_v4l.c  |  332 +++-----------------------------
 drivers/media/video/cpia2/cpia2dev.h   |    4 +-
 5 files changed, 51 insertions(+), 346 deletions(-)

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
