Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4707 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab3KKOdC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Nov 2013 09:33:02 -0500
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr7.xs4all.nl (8.13.8/8.13.8) with ESMTP id rABEWwU6040169
	for <linux-media@vger.kernel.org>; Mon, 11 Nov 2013 15:33:01 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id EE3BA2A1F80
	for <linux-media@vger.kernel.org>; Mon, 11 Nov 2013 15:32:54 +0100 (CET)
Message-ID: <5280EA96.3070707@xs4all.nl>
Date: Mon, 11 Nov 2013 15:32:54 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.13] Various fixes.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 80f93c7b0f4599ffbdac8d964ecd1162b8b618b9:

  [media] media: st-rc: Add ST remote control driver (2013-10-31 08:20:08 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.13e

for you to fetch changes up to e83c52b545afd331056f34a030099ed5c801b26e:

  wm8775: fix broken audio routing. (2013-11-11 15:26:02 +0100)

----------------------------------------------------------------
Dan Carpenter (1):
      cx231xx: use after free on error path in probe

Hans Verkuil (3):
      bttv: don't setup the controls if there are no video devices.
      tef6862/radio-tea5764: actually assign clamp result.
      wm8775: fix broken audio routing.

Libin Yang (1):
      marvell-ccic: drop resource free in driver remove

Wei Yongjun (1):
      saa7164: fix return value check in saa7164_initdev()

 drivers/media/i2c/wm8775.c                       | 4 +---
 drivers/media/pci/bt8xx/bttv-driver.c            | 3 ++-
 drivers/media/pci/saa7164/saa7164-core.c         | 4 +++-
 drivers/media/platform/marvell-ccic/mmp-driver.c | 7 -------
 drivers/media/radio/radio-tea5764.c              | 2 +-
 drivers/media/radio/tef6862.c                    | 2 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c        | 2 +-
 7 files changed, 9 insertions(+), 15 deletions(-)
