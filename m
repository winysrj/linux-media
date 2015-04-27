Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:37246 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752622AbbD0HaD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2015 03:30:03 -0400
Received: from tschai.cisco.com (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 559F32A0095
	for <linux-media@vger.kernel.org>; Mon, 27 Apr 2015 09:29:56 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/5] Fix compiler warnings
Date: Mon, 27 Apr 2015 09:29:50 +0200
Message-Id: <1430119795-16527-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Various patches to fix compiler warnings. Some of these appeared after
I switched to gcc-5.1.0 for the daily build.

There is one more warning in a davinci driver remaining, I've asked
Prabhakar to look at that one.

Regards,

	Hans

Hans Verkuil (5):
  s5c73m3/s5k5baf/s5k6aa: fix compiler warnings
  s3c-camif: fix compiler warnings
  cx24123/mb86a20s/s921: fix compiler warnings
  dib8000: fix compiler warning
  radio-bcm2048: fix compiler warning

 drivers/media/dvb-frontends/cx24123.h            | 2 +-
 drivers/media/dvb-frontends/dib8000.h            | 2 +-
 drivers/media/dvb-frontends/mb86a20s.h           | 2 +-
 drivers/media/dvb-frontends/s921.h               | 2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c         | 2 +-
 drivers/media/i2c/s5k5baf.c                      | 2 +-
 drivers/media/i2c/s5k6aa.c                       | 2 +-
 drivers/media/platform/s3c-camif/camif-capture.c | 4 ++--
 drivers/staging/media/bcm2048/radio-bcm2048.c    | 3 +--
 9 files changed, 10 insertions(+), 11 deletions(-)

-- 
2.1.4

