Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1702 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3HSOok (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 10:44:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, matrandg@cisco.com
Subject: [RFCv2 PATCH 00/20] dv-timings/adv7604/ad9389b fixes and new adv7511/adv7842 drivers
Date: Mon, 19 Aug 2013 16:44:09 +0200
Message-Id: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This second patch series combines these two earlier patch series:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg65582.html
http://www.mail-archive.com/linux-media@vger.kernel.org/msg65510.html

While rebasing the new drivers on the latest code I realized that it made more
sense to combine the two and to improve the v4l2-dv-timings functions a bit.

The first 17 patches apply a bunch of fixes from the internal Cisco tree and
it adds a number of improvements to v4l2-dv-timings. If there are no comments
regarding those patches, then I intend to make a pull request for them later
this week.

The final three patches add the new adv7842 and adv7511 drivers.

Changes since RFCv1 for those last three:

- use the new v4l2_*_dv_timings helpers
- use devm_kzalloc

TODO:

- adv7604 needs to use the new dv-timings helpers as well. It's done for
  the adv7842, but not yet for the adv7604.

- STD handling in adv7842 can be improved: at the moment the s_std value
  does not set the hardware correctly (the hardware is always set to
  autodetect).

- the advxxxx internal IP blocks are quite similar and parts of it can be
  refactored. In particular notifier, control and event IDs can easily be
  shared.

- the adv7xxx_check_dv_timings callback should notify the v4l2_device as
  well in case there are additional constraints in the bridge driver.

These TODOs do not block merging these new drivers IMHO and can be done
later.

Regards,

	Hans

