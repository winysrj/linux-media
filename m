Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3246 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbaEXVQp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 May 2014 17:16:45 -0400
Message-ID: <53810C1E.7040509@xs4all.nl>
Date: Sat, 24 May 2014 23:16:14 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: [GIT PULL FOR v3.16] solo6x10 patches, with description
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The same solo6x10 patches, but with a proper description.

Regards,

	Hans

The following changes since commit 85ac1a1772bb41da895bad83a81f6a62c8f293f6:

  [media] media: stk1160: Avoid stack-allocated buffer for control URBs (2014-05-24 17:12:11 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.16h

for you to fetch changes up to a7b8579b64a0245a3ee33f212175124495e47ad6:

  solo6x10: Kconfig: Add supported card list to the SOLO6X10 knob (2014-05-24 23:10:35 +0200)

----------------------------------------------------------------
Ismael Luceno (2):
      solo6x10: Reduce OSD writes to the minimum necessary
      solo6x10: Kconfig: Add supported card list to the SOLO6X10 knob

 drivers/staging/media/solo6x10/Kconfig            | 12 +++++++++---
 drivers/staging/media/solo6x10/solo6x10-enc.c     | 31 ++++++++++++++-----------------
 drivers/staging/media/solo6x10/solo6x10-offsets.h |  2 ++
 3 files changed, 25 insertions(+), 20 deletions(-)
