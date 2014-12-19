Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:41153 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243AbaLSKvw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 05:51:52 -0500
Received: from [10.61.169.145] (173-38-208-170.cisco.com [173.38.208.170])
	by tschai.lan (Postfix) with ESMTPSA id 22CFC2A002F
	for <linux-media@vger.kernel.org>; Fri, 19 Dec 2014 11:51:36 +0100 (CET)
Message-ID: <54940342.3040802@xs4all.nl>
Date: Fri, 19 Dec 2014 11:51:46 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT FIXES FOR v3.19]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

sh_veu has been broken since 3.11. Fix this for 3.19 with a CC to stable.

Regards,

	Hans

The following changes since commit 427ae153c65ad7a08288d86baf99000569627d03:

  [media] bq/c-qcam, w9966, pms: move to staging in preparation for removal (2014-12-16 23:21:44 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.19n

for you to fetch changes up to 02c0cd83680ebd62eebfe2e863d8e16db0e19582:

  sh_veu: v4l2_dev wasn't set (2014-12-19 11:49:44 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      sh_veu: v4l2_dev wasn't set

 drivers/media/platform/sh_veu.c | 1 +
 1 file changed, 1 insertion(+)
