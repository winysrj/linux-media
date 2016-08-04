Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:40925 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751604AbcHDJ7c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2016 05:59:32 -0400
Received: from [192.168.1.137] (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id 3152B1800DD
	for <linux-media@vger.kernel.org>; Thu,  4 Aug 2016 11:59:27 +0200 (CEST)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] cec: fix typo and locking improvements
Message-ID: <ba7a2bd2-53b0-b1ff-e617-082df28cd9e7@xs4all.nl>
Date: Thu, 4 Aug 2016 11:59:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These three patches improve low-level locking which was a bit messy, and they
fix a silly typo in cec-funcs.h.

I'd like to have this fixed in 4.8.

Regards,

	Hans

The following changes since commit 292eaf50c7df4ae2ae8aaa9e1ce3f1240a353ee8:

  [media] cec: fix off-by-one memset (2016-07-28 20:16:35 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git ceclock

for you to fetch changes up to c172c968ea7a7d9e8e418a4a361926d399ba20ac:

  cec-funcs.h: fix typo: && should be & (2016-08-04 11:29:38 +0200)

----------------------------------------------------------------
Hans Verkuil (3):
      cec: rename cec_devnode fhs_lock to just lock
      cec: improve locking
      cec-funcs.h: fix typo: && should be &

 drivers/staging/media/cec/cec-adap.c | 12 ++++++------
 drivers/staging/media/cec/cec-api.c  |  8 ++++----
 drivers/staging/media/cec/cec-core.c | 27 +++++++++++++++------------
 include/linux/cec-funcs.h            |  4 ++--
 include/media/cec.h                  |  2 +-
 5 files changed, 28 insertions(+), 25 deletions(-)
