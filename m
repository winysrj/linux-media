Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:58957 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750949AbcGQPCk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 11:02:40 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id C1B67180C37
	for <linux-media@vger.kernel.org>; Sun, 17 Jul 2016 17:02:34 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/7] cec: various fixes
Date: Sun, 17 Jul 2016 17:02:27 +0200
Message-Id: <1468767754-48542-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

While writing more and better compliance tests for the CEC API I found
a number of corner cases that were not handled correctly.

For the most part it was fields that weren't initialized correctly, but
but more serious was the fact that there was no limit to the number of
pending transmits. The other important bug was that the result of a
non-blocking transmit was never returned to userspace, so applications
using this method would have no way of knowing that the transmit was
successful or not.

The last patch adds MONITOR_ALL mode to vivid.

Regards,

	Hans

Hans Verkuil (7):
  cec: CEC_RECEIVE overwrote the timeout field
  cec: clear all status fields before transmit and always fill in
    sequence
  cec: don't set fh to NULL in CEC_TRANSMIT
  cec: zero unused msg part after msg->len
  cec: limit the size of the transmit queue
  cec: fix test for unconfigured adapter in main message loop
  vivid: support monitor all mode

 drivers/media/platform/vivid/vivid-cec.c | 44 ++++++++---------------
 drivers/staging/media/cec/cec-adap.c     | 61 +++++++++++++++++++++-----------
 drivers/staging/media/cec/cec-api.c      | 12 +++----
 include/media/cec.h                      | 19 +++++++---
 4 files changed, 75 insertions(+), 61 deletions(-)

-- 
2.8.1

