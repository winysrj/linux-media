Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4330 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab3HVK1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 06:27:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, matrandg@cisco.com
Subject: [RFCv3 PATCH 0/5] adv7604/ad9389b fixes and new adv7511/adv7842 drivers
Date: Thu, 22 Aug 2013 12:27:25 +0200
Message-Id: <1377167250-27589-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This RFCv3 is an update for patches 18-20 of the RFCv2 series:

http://www.spinics.net/lists/linux-media/msg67128.html

All the earlier patches are unchanged.

The changes since RFCv2 are:

- ad9389b/adv7604: set is_private only after you are sure all controls were
  created correctly, otherwise the struct v4l2_ctrl might be NULL.
- adv7511/adv7842: set is_private to true as well (was missing in the
  RFCv2 for these drivers).

If there are no more comments, then I'll make a pull request for the whole
series tomorrow.

Regards,

	Hans

