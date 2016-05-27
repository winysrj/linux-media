Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:39261 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376AbcE0KmU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 06:42:20 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 7ADC51800E0
	for <linux-media@vger.kernel.org>; Fri, 27 May 2016 12:42:15 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.7] Two regression fixes for 4.7.
Message-ID: <57482487.40504@xs4all.nl>
Date: Fri, 27 May 2016 12:42:15 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

These are two regression fixes for 4.7. The adv7604 patch is also for 4.6.

Regards,

	Hans

The following changes since commit 4ddd4fd497da1dfd99aa197eaca053d1b3da8eaf:

  Merge tag 'v4.6' into patchwork (2016-05-18 06:29:23 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.7e

for you to fetch changes up to 401914d72a2cc7ed547a3477d15d4b3d519be98b:

  adv7604: Don't ignore pad number in subdev DV timings pad operations (2016-05-27 12:40:59 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      v4l2-ioctl: fix stupid mistake in cropcap condition

Laurent Pinchart (1):
      adv7604: Don't ignore pad number in subdev DV timings pad operations

 drivers/media/i2c/adv7604.c          | 46 +++++++++++++++++++++++++++++++++++-----------
 drivers/media/v4l2-core/v4l2-ioctl.c |  2 +-
 2 files changed, 36 insertions(+), 12 deletions(-)
