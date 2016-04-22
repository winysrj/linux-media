Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:41208 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066AbcDVNDt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 09:03:49 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 3131C18021C
	for <linux-media@vger.kernel.org>; Fri, 22 Apr 2016 15:03:43 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/6] Various rcar-vin and adv* fixes
Date: Fri, 22 Apr 2016 15:03:36 +0200
Message-Id: <1461330222-34096-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

While testing Niklas' new rcar-vin driver I found various problems
that is fixed in this patch series.

The main problem is the adv7180 driver which was simply broken when
it comes to detecting standards. This should now be fixed (at least
it works for me now).

As a result the sta2x11_vip driver needed to be changed as well.

The new rcar-vin driver driver didn't support the source change event.
While not relevant for the adv7180 driver (at least on the Koelsch
board the irq from that chip isn't hooked up), it certainly is needed
for the adv7612 driver. It doesn't hurt to add it here.

Niklas, just fold it in your patch.

The v4l2-compliance test complained about a missing V4L2_CID_DV_RX_POWER_PRESENT
control. This was because that control was marked private. The reality
is that that makes no sense and the control should just be inherited by
the rcar-vin driver. In practice making this private is just annoying.

The last patch is an rcar-vin bug fix. Niklas, just fold it in your
patch for the v8.

Niklas, Federico, can you both check the adv7180 changes?

Regards,

	Hans

Hans Verkuil (6):
  adv7180: fix broken standards handling
  sta2x11_vip: fix s_std
  rcar-vin: support the source change event and fix s_std
  tc358743: drop bogus comment
  media/i2c/adv*: make controls inheritable instead of private
  rcar-vin: failed start_streaming didn't call s_stream(0)

 drivers/media/i2c/ad9389b.c                 |   8 --
 drivers/media/i2c/adv7180.c                 | 118 +++++++++++++++++++---------
 drivers/media/i2c/adv7511.c                 |   6 --
 drivers/media/i2c/adv7604.c                 |   8 --
 drivers/media/i2c/adv7842.c                 |   6 --
 drivers/media/i2c/tc358743.c                |   1 -
 drivers/media/pci/sta2x11/sta2x11_vip.c     |  26 +++---
 drivers/media/platform/rcar-vin/rcar-dma.c  |   4 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  48 ++++++++++-
 9 files changed, 139 insertions(+), 86 deletions(-)

-- 
2.8.0.rc3

