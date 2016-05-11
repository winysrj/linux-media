Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:58436 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276AbcEKHLf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 03:11:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Subject: [PATCH 0/3] CEC Framework fixes
Date: Wed, 11 May 2016 09:11:25 +0200
Message-Id: <1462950688-23290-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

While stress testing my CEC Framework v16 patch series found here:

http://www.spinics.net/lists/linux-input/msg44422.html

I discovered a few issues when dealing with HDMI disconnects.

The adv7511 patch fixes a potential race condition (never seen it go
wrong, but I feel much safer with the new code). The WARN_ON patch
removes a WARN_ON I thought could never happen when in fact it can
in a disconnect scenario, and the final patch fixes a nasty kernel
oops because the delayed work timer was never cleaned up while the
underlying data structure was freed.

I decided not to post a v17 patch series to avoid spamming everyone,
instead I'll merge these fixes in my cec pull request for Mauro and
update that pull request.

Regards,

	Hans

Hans Verkuil (3):
  adv7511: always update CEC irq mask
  cec: remove WARN_ON
  cec: correctly cancel delayed work when the CEC adapter is disabled

 drivers/media/i2c/adv7511.c     |  4 ++--
 drivers/staging/media/cec/cec.c | 29 ++++++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 7 deletions(-)

-- 
2.8.1

