Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3080 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab2D0VrF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 17:47:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.5] radio-mr800: complete update to the latest frameworks
Date: Fri, 27 Apr 2012 23:46:59 +0200
Cc: David Ellingsworth <david@identd.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204272346.59123.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series makes the radio-mr800 compliant with the latest V4L2
frameworks and adds stereo/signalstrength detection and hw seek support.

Tested fairly thoroughly, including whether suspend/resume works.

Regards,

	Hans

The following changes since commit bcb2cf6e0bf033d79821c89e5ccb328bfbd44907:

  [media] ngene: remove an unneeded condition (2012-04-26 15:29:23 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git mr800

for you to fetch changes up to 0719a2b4b3bd29579fc4c62de0d995eadb74af79:

  radio-mr800: add hardware seek support. (2012-04-27 23:39:37 +0200)

----------------------------------------------------------------
Hans Verkuil (3):
      radio-mr800: cleanup and have it comply to the V4L2 API.
      radio-mr800: add support for stereo and signal detection.
      radio-mr800: add hardware seek support.

 drivers/media/radio/radio-mr800.c |  524 +++++++++++++++++++++++++++++++++-----------------------------------------
 1 file changed, 234 insertions(+), 290 deletions(-)
