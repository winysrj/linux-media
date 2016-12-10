Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:57850 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751388AbcLJJoQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Dec 2016 04:44:16 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH for v4.10 0/6] cec: 2 small fixes and a race condition fix
Date: Sat, 10 Dec 2016 10:44:07 +0100
Message-Id: <20161210094413.8832-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The first two patches address small bugs that were found while testing.

The remaining four patches address a race condition in the way logical
addresses are claimed that was found when running the cec-compliance
test with the debug option of the cec module set to 2.

It was possible for the configuration to be cleared while the cec core was
still broadcasting the new features and physical addresses after it claimed
the logical address(es). Afterwards the core ended up in an inconsistent
state that causes later compliance tests to fail.

The first three patches prepare the ground for the final patch to actually
fix the race condition.

Regards,

	Hans

Hans Verkuil (6):
  cec: when canceling a message, don't overwrite old status info
  cec: CEC_MSG_GIVE_FEATURES should abort for CEC version < 2
  cec: update log_addr[] before finishing configuration
  cec: replace cec_report_features by cec_fill_msg_report_features
  cec: move cec_report_phys_addr into cec_config_thread_func
  cec: fix race between configuring and unconfiguring

 drivers/media/cec/cec-adap.c | 101 ++++++++++++++++++++++---------------------
 1 file changed, 51 insertions(+), 50 deletions(-)

-- 
2.10.2

