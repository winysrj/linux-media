Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1250 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaBCKEG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Feb 2014 05:04:06 -0500
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr6.xs4all.nl (8.13.8/8.13.8) with ESMTP id s13A42Lp099227
	for <linux-media@vger.kernel.org>; Mon, 3 Feb 2014 11:04:04 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.61.75.206] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id BEE432A00A5
	for <linux-media@vger.kernel.org>; Mon,  3 Feb 2014 11:03:46 +0100 (CET)
Message-ID: <52EF6991.9030101@xs4all.nl>
Date: Mon, 03 Feb 2014 11:04:01 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.14]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Three bug fixes that I would like to see merged for 3.14.

Regards,

	Hans

The following changes since commit 587d1b06e07b4a079453c74ba9edf17d21931049:

  [media] rc-core: reuse device numbers (2014-01-15 11:46:37 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-3.14e

for you to fetch changes up to 0f8cea07630ca15cc904613c6903a55e671bf5f0:

  adv7842: Composite free-run platfrom-data fix (2014-02-03 11:02:41 +0100)

----------------------------------------------------------------
Martin Bugge (2):
      v4l2-dv-timings: fix GTF calculation
      adv7842: Composite free-run platfrom-data fix

Masanari Iida (1):
      hdpvr: Fix memory leak in debug

 drivers/media/i2c/adv7842.c               | 2 +-
 drivers/media/usb/hdpvr/hdpvr-core.c      | 4 +++-
 drivers/media/v4l2-core/v4l2-dv-timings.c | 1 +
 3 files changed, 5 insertions(+), 2 deletions(-)
