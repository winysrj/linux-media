Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2709 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab2IQIRJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 04:17:09 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id q8H8H7ka090312
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 17 Sep 2012 10:17:08 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 3822335C012A
	for <linux-media@vger.kernel.org>; Mon, 17 Sep 2012 10:17:00 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.7] Two fixes
Date: Mon, 17 Sep 2012 10:17:00 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201209171017.00829.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request fixes a problem when using vb2_fop_read/write in non-blocking
mode and a tuner-core issue when setting the audmode for a radio device.

Regards,

	Hans

The following changes since commit 36aee5ff9098a871bda38dbbdad40ad59f6535cf:

  [media] ir-rx51: Adjust dependencies (2012-09-15 19:44:30 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git fixes

for you to fetch changes up to 862f7d91ff01bba8a59b89beef8cba715814a2f6:

  tuner-core: map audmode to STEREO for radio devices. (2012-09-17 10:14:55 +0200)

----------------------------------------------------------------
Hans Verkuil (2):
      vb2: fix wrong owner check
      tuner-core: map audmode to STEREO for radio devices.

 drivers/media/v4l2-core/tuner-core.c     |    5 ++++-
 drivers/media/v4l2-core/videobuf2-core.c |    4 ++--
 2 files changed, 6 insertions(+), 3 deletions(-)
