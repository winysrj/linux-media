Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2107 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab0JKPl0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 11:41:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.37] Fix locking order in radio-mr800
Date: Mon, 11 Oct 2010 17:41:12 +0200
Cc: David Ellingsworth <david@identd.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010111741.13010.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit 9147e3dbca0712a5435cd2ea7c48d39344f904eb:
  Mauro Carvalho Chehab (1):
        V4L/DVB: cx231xx: use core-assisted lock

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/v4l-dvb.git mr800

Hans Verkuil (1):
      radio-mr800: fix locking order

 Documentation/video4linux/v4l2-framework.txt |    2 +-
 drivers/media/radio/radio-mr800.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
