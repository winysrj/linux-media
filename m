Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4552 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab3AGQ0W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 11:26:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.7] Fix modulator regression in kernel 3.7.
Date: Mon, 7 Jan 2013 17:26:14 +0100
Cc: Manjunatha Halli <manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201301071726.14899.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch fixes a regression that was introduced in 3.7 and made these
four drivers useless. It's the same problem for all: the new vfl_dir field
wasn't set correctly for these radio modulator drivers.

Tested with the radio-keene driver.

Regards,

	Hans

The following changes since commit 8cd7085ff460ead3aba6174052a408f4ad52ac36:

  [media] get_dvb_firmware: Fix the location of firmware for Terratec HTC (2013-01-01 11:18:26 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git modulators

for you to fetch changes up to 86552330c91fff094a07c0018ca34a9f45362a64:

  radio: set vfl_dir correctly to fix modulator regression. (2013-01-05 13:01:30 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      radio: set vfl_dir correctly to fix modulator regression.

 drivers/media/radio/radio-keene.c       |    1 +
 drivers/media/radio/radio-si4713.c      |    1 +
 drivers/media/radio/radio-wl1273.c      |    1 +
 drivers/media/radio/wl128x/fmdrv_v4l2.c |   10 ++++++++++
 4 files changed, 13 insertions(+)
