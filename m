Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4093 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195AbaICM7K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 08:59:10 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id s83Cx6hD002323
	for <linux-media@vger.kernel.org>; Wed, 3 Sep 2014 14:59:08 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.54.92.107] (173-38-208-170.cisco.com [173.38.208.170])
	by tschai.lan (Postfix) with ESMTPSA id 16E942A075A
	for <linux-media@vger.kernel.org>; Wed,  3 Sep 2014 14:59:02 +0200 (CEST)
Message-ID: <54071077.2050500@xs4all.nl>
Date: Wed, 03 Sep 2014 14:58:31 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.18] vivid: two small fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Speaks for itself...

Regards,

	Hans

The following changes since commit 4bf167a373bbbd31efddd9c00adc97ecc69fdb67:

  [media] v4l: vsp1: fix driver dependencies (2014-09-03 09:10:24 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git vivid-fixes

for you to fetch changes up to 73d0df6f49eda8f6b1042c1f9729c347e1f0ee32:

  vivid: add missing includes (2014-09-03 14:57:11 +0200)

----------------------------------------------------------------
Hans Verkuil (2):
      vivid: remove duplicate and unused g/s_edid functions
      vivid: add missing includes

 drivers/media/platform/vivid/vivid-core.c    |  1 +
 drivers/media/platform/vivid/vivid-rds-gen.c |  1 +
 drivers/media/platform/vivid/vivid-tpg.h     |  1 +
 drivers/media/platform/vivid/vivid-vbi-gen.c |  1 +
 drivers/media/platform/vivid/vivid-vid-cap.c |  1 +
 drivers/media/platform/vivid/vivid-vid-out.c | 57 -----------------------------------------------
 drivers/media/platform/vivid/vivid-vid-out.h |  1 -
 7 files changed, 5 insertions(+), 58 deletions(-)
