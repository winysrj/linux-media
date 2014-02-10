Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4542 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbaBJKin (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 05:38:43 -0500
Received: from tschai.lan (173-38-208-170.cisco.com [173.38.208.170])
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id s1AAceqA054192
	for <linux-media@vger.kernel.org>; Mon, 10 Feb 2014 11:38:42 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 86FB72A00A8
	for <linux-media@vger.kernel.org>; Mon, 10 Feb 2014 11:38:15 +0100 (CET)
Message-ID: <52F8AC17.8040400@xs4all.nl>
Date: Mon, 10 Feb 2014 11:38:15 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.15] 3.15 updates
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Some sleep_on race fixes, s2255 driver cleanups in preparation for the vb2
conversion and some ths8200 fixes.

Regards,

	Hans

The following changes since commit 37e59f876bc710d67a30b660826a5e83e07101ce:

  [media, edac] Change my email address (2014-02-07 08:03:07 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.15b

for you to fetch changes up to 7f796a9c36552bd058c2e4cce7fa5e5c10945b36:

  omap_vout: avoid sleep_on race (2014-02-10 11:27:37 +0100)

----------------------------------------------------------------
Arnd Bergmann (1):
      omap_vout: avoid sleep_on race

Dean Anderson (7):
      s2255drv: removal of s2255_dmaqueue structure
      s2255drv: refactoring s2255_channel to s2255_vc
      s2255drv: buffer setup fix
      s2255drv: remove redundant parameter
      s2255drv: dynamic memory allocation efficiency fix
      s2255drv: fix for return code not checked
      s2255drv: cleanup of s2255_fh

Hans Verkuil (1):
      radio-cadet: avoid interruptible_sleep_on race

Martin Bugge (3):
      ths8200: Zero blanking level for RGB.
      ths8200: Corrected sync polarities setting.
      ths8200: Format adjustment.

 drivers/media/i2c/ths8200.c                  |  26 +--
 drivers/media/platform/omap/omap_vout_vrfb.c |   3 +-
 drivers/media/radio/radio-cadet.c            |  46 +++---
 drivers/media/usb/s2255/s2255drv.c           | 709 +++++++++++++++++++++++++++++++++++++++----------------------------------------
 4 files changed, 390 insertions(+), 394 deletions(-)
