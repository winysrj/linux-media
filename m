Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2753 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab2D0LyR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 07:54:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.5] Clean up and fix dsbr100
Date: Fri, 27 Apr 2012 13:54:10 +0200
Cc: Alexey Klimov <klimov.linux@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204271354.10316.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Next in my quest to get old drivers cleaned up and V4L2 compliant is the
dsbr100 driver.

Changes:

- converted to the control framework + control events
- overall cleanup
- thorough testing using the radio-keene transmitter and v4l2-compliance.
- also tested suspend/resume

Regards,

	Hans

The following changes since commit bcb2cf6e0bf033d79821c89e5ccb328bfbd44907:

  [media] ngene: remove an unneeded condition (2012-04-26 15:29:23 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git dsbr100

for you to fetch changes up to 53b0945ea60f5e781004d71f35a458e4d02063da:

  dsbr100: clean up and update to the latest v4l2 framework (2012-04-27 13:13:26 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      dsbr100: clean up and update to the latest v4l2 framework

 drivers/media/radio/dsbr100.c |  527 +++++++++++++++++++++++++-----------------------------------------------------
 1 file changed, 165 insertions(+), 362 deletions(-)
