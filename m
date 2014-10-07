Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3553 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaJGMJd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Oct 2014 08:09:33 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id s97C9UUr065516
	for <linux-media@vger.kernel.org>; Tue, 7 Oct 2014 14:09:31 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.54.92.107] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id E4D3B2A009F
	for <linux-media@vger.kernel.org>; Tue,  7 Oct 2014 14:09:26 +0200 (CEST)
Message-ID: <5433D7D7.3090705@xs4all.nl>
Date: Tue, 07 Oct 2014 14:08:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.18] Various fixes (v2)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various fixes for v3.18.

It supersedes this pull request: https://patchwork.linuxtv.org/patch/26348/
The only change is the addition of the vivid buffer overrun fix.

Regards,

	Hans

The following changes since commit cf3167cf1e969b17671a4d3d956d22718a8ceb85:

  [media] pt3: fix DTV FE I2C driver load error paths (2014-09-28 22:23:42 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.18e

for you to fetch changes up to d3c3935f2e9964f96b93e2239870dc26c6723fd4:

  vivid: fix buffer overrun (2014-10-07 14:03:46 +0200)

----------------------------------------------------------------
Hans Verkuil (3):
      vivid: fix Kconfig FB dependency
      em28xx: fix uninitialized variable warning
      vivid: fix buffer overrun

Lubomir Rintel (1):
      saa7146: Create a device name before it's used

 drivers/media/common/saa7146/saa7146_core.c | 6 +++---
 drivers/media/platform/vivid/Kconfig        | 5 ++++-
 drivers/media/platform/vivid/vivid-tpg.c    | 2 +-
 drivers/media/usb/em28xx/em28xx-core.c      | 2 +-
 4 files changed, 9 insertions(+), 6 deletions(-)
