Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:43843 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966454AbcHBNQ6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Aug 2016 09:16:58 -0400
Received: from durdane.fritz.box (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id D0F981800E4
	for <linux-media@vger.kernel.org>; Tue,  2 Aug 2016 15:16:51 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH (repost) 0/2] cec: improve locking
Date: Tue,  2 Aug 2016 15:16:49 +0200
Message-Id: <1470143811-9228-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

I posted these two patches in the middle of Baole's patch bomb, and they
never turned up in the mailing list.

Reposting. Apologies if they now appear twice.

These two patches clean up some rare and obscure potential locking issues
in the CEC framework. I noticed these when reviewing the code.

The first patch just renames a struct field, the second actually fixes
the locking issues.

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

