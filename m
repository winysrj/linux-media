Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:53048 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752884AbeEVLdR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 07:33:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/2] cec: two CEC bugs, one in core, one in adv7511
Date: Tue, 22 May 2018 13:33:12 +0200
Message-Id: <20180522113314.14666-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The first patch fixes an inconsistency in the cec core code where
wrong status information could be returned if a cec message was
canceled.

The second patch fixes a CEC adv7511 bug.

Regards,

	Hans

Hans Verkuil (2):
  cec: fix wrong tx/rx_status values when canceling a msg
  adv7511: fix incorrect clear of CEC receive interrupt

 drivers/media/cec/cec-adap.c | 19 +++++++++++++------
 drivers/media/i2c/adv7511.c  |  4 ++--
 2 files changed, 15 insertions(+), 8 deletions(-)

-- 
2.17.0
