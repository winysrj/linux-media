Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3703 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaJFHz4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Oct 2014 03:55:56 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id s967tq8f008787
	for <linux-media@vger.kernel.org>; Mon, 6 Oct 2014 09:55:54 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 38BD42A0376
	for <linux-media@vger.kernel.org>; Mon,  6 Oct 2014 09:55:51 +0200 (CEST)
Message-ID: <54324B07.2080408@xs4all.nl>
Date: Mon, 06 Oct 2014 09:55:51 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.18] Various fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various fixes for v3.18.

Regards,

	Hans

The following changes since commit cf3167cf1e969b17671a4d3d956d22718a8ceb85:

  [media] pt3: fix DTV FE I2C driver load error paths (2014-09-28 22:23:42 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.18e

for you to fetch changes up to 9bff252026c06ec42c60602c1cfc2ad7eb24d1bc:

  saa7146: Create a device name before it's used (2014-10-06 09:48:54 +0200)

----------------------------------------------------------------
Hans Verkuil (2):
      vivid: fix Kconfig FB dependency
      em28xx: fix uninitialized variable warning

Lubomir Rintel (1):
      saa7146: Create a device name before it's used

 drivers/media/common/saa7146/saa7146_core.c | 6 +++---
 drivers/media/platform/vivid/Kconfig        | 5 ++++-
 drivers/media/usb/em28xx/em28xx-core.c      | 2 +-
 3 files changed, 8 insertions(+), 5 deletions(-)
