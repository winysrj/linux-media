Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:45333 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbbDXOQ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 10:16:56 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 750E22A002F
	for <linux-media@vger.kernel.org>; Fri, 24 Apr 2015 16:16:27 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/5] vivid-tpg: fixes/improvements
Date: Fri, 24 Apr 2015 16:16:21 +0200
Message-Id: <1429884986-38671-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- Add logging
- Add full range variants of several Y'CbCr encodings to be
  consistent with the existing encodings
- Ignore quantization range for the XV601/709 encodings as that
  does not apply for those encodings

	Hans

Hans Verkuil (5):
  vivid-tpg: add tpg_log_status()
  vivid-tpg: add full range SMPTE 240M support
  vivid-tpg: add full range BT.2020 support
  vivid-tpg: add full range BT.2020C support
  vivid-tpg: fix XV601/709 Y'CbCr encoding

 drivers/media/platform/vivid/vivid-core.c |  13 +++-
 drivers/media/platform/vivid/vivid-tpg.c  | 109 ++++++++++++++++++++++++------
 drivers/media/platform/vivid/vivid-tpg.h  |   1 +
 3 files changed, 103 insertions(+), 20 deletions(-)

-- 
2.1.4

