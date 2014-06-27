Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3909 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbaF0IN1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jun 2014 04:13:27 -0400
Message-ID: <53AD279E.6030101@xs4all.nl>
Date: Fri, 27 Jun 2014 10:13:18 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: [GIT PULL FOR v3.16] Two 3.16 fixes
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The davinci bug was introduced in 3.16, the hdpvr bug in 3.10.

Regards,

	Hans

The following changes since commit b5b620584b9c4644b85e932895a742e0c192d66c:

   [media] technisat-sub2: Fix stream curruption on high bitrate (2014-06-26 09:20:18 -0300)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git for-v3.16b

for you to fetch changes up to ce8c2bc1e2c90fcc1f7a919846db5a11c32e0516:

   hdpvr: fix two audio bugs (2014-06-27 10:11:38 +0200)

----------------------------------------------------------------
Dan Carpenter (1):
       davinci: vpif: missing unlocks on error

Hans Verkuil (1):
       hdpvr: fix two audio bugs

  drivers/media/platform/davinci/vpif_capture.c | 1 +
  drivers/media/platform/davinci/vpif_display.c | 1 +
  drivers/media/usb/hdpvr/hdpvr-video.c         | 6 +++---
  3 files changed, 5 insertions(+), 3 deletions(-)
