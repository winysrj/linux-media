Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:40952 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751673AbcF1Lwe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 07:52:34 -0400
To: linux-media <linux-media@vger.kernel.org>
Cc: Ulrich Hecht <ulrich.hecht+renesas@gmail.co>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] rcar-vin patches
Message-ID: <577264F9.5040506@xs4all.nl>
Date: Tue, 28 Jun 2016 13:52:25 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Updated these patches.

Ulrich, sorry, the compile error was my fault: I added these patches in the
wrong order.

Regards,

	Hans

The following changes since commit 904aef0f9f6deff94223c0ce93eb598c47dd3aad:

  [media] v4l2-ctrl.h: fix comments (2016-06-28 08:07:04 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.8c

for you to fetch changes up to e86f5324263ff8a3f1a49dbada27f076c4327005:

  media: rcar-vin: add DV timings support (2016-06-28 13:50:35 +0200)

----------------------------------------------------------------
Ulrich Hecht (3):
      media: rcar-vin: pad-aware driver initialisation
      media: rcar_vin: Use correct pad number in try_fmt
      media: rcar-vin: add DV timings support

 drivers/media/platform/rcar-vin/rcar-v4l2.c | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/media/platform/rcar-vin/rcar-vin.h  |   2 ++
 2 files changed, 111 insertions(+), 3 deletions(-)
