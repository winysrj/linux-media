Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:44039 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755456AbcHBL2F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Aug 2016 07:28:05 -0400
Received: from durdane.fritz.box (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id 59BAB1800E4
	for <linux-media@vger.kernel.org>; Tue,  2 Aug 2016 13:23:55 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/2] cec: improve locking
Date: Tue,  2 Aug 2016 13:23:52 +0200
Message-Id: <1470137034-7313-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

While reviewing the CEC core code I noticed a few potential problems
with locking under normal (and even not so normal) circumstances this
wouldn't cause problems, but in theory there could be corner cases where
you could get a deadlock or perhaps a race condition.

The first patch just renames a lock, the second actually improved the
locking scheme.

Regards,

	Hans

Hans Verkuil (2):
  cec: rename cec_devnode fhs_lock to just lock
  cec: improve locking

 drivers/staging/media/cec/cec-adap.c | 12 ++++++------
 drivers/staging/media/cec/cec-api.c  |  8 ++++----
 drivers/staging/media/cec/cec-core.c | 27 +++++++++++++++------------
 include/media/cec.h                  |  2 +-
 4 files changed, 26 insertions(+), 23 deletions(-)

-- 
2.8.1

