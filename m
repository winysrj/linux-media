Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:50070 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbbDMOV3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2015 10:21:29 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id DC4002A0099
	for <linux-media@vger.kernel.org>; Mon, 13 Apr 2015 16:21:14 +0200 (CEST)
Message-ID: <552BD0DA.1080503@xs4all.nl>
Date: Mon, 13 Apr 2015 16:21:14 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT FIXES FOR v4.1] marvell-ccic fix
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This one was part of a 4.1 pull request that never made it in time for 4.1,
but this fix should really go to 4.1 since the marvell-ccic driver is
currently broken (swapped color components).

Regards,

	Hans

The following changes since commit e183201b9e917daf2530b637b2f34f1d5afb934d:

  [media] uvcvideo: add support for VIDIOC_QUERY_EXT_CTRL (2015-04-10 10:29:27 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.1i

for you to fetch changes up to 0b2838093effc6ee07705b04c0ad3293c2bf7f6a:

  marvell-ccic: fix Y'CbCr ordering (2015-04-13 16:18:51 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      marvell-ccic: fix Y'CbCr ordering

 drivers/media/platform/marvell-ccic/mcam-core.c | 14 +++++++-------
 drivers/media/platform/marvell-ccic/mcam-core.h |  8 ++++----
 2 files changed, 11 insertions(+), 11 deletions(-)
