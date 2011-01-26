Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:4032 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab1AZHXx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jan 2011 02:23:53 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.39] fix cx18 regression
Date: Wed, 26 Jan 2011 08:23:43 +0100
Cc: Andy Walls <awalls@md.metrocast.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101260823.43809.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro, please get this upstream asap since this fix needs to go into 2.6.38
as well.

Regards,

	Hans

The following changes since commit e5fb95675639f064ca40df7ad319f1c380443999:
  Hans Verkuil (1):
        [media] vivi: fix compiler warning

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/media_tree.git cx18-fix

Hans Verkuil (1):
      cx18: fix kernel oops when setting MPEG control before capturing.

 drivers/media/video/cx18/cx18-driver.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
