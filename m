Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:37582 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757964AbbGQPdy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 11:33:54 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id C6B1B2A0091
	for <linux-media@vger.kernel.org>; Fri, 17 Jul 2015 17:32:51 +0200 (CEST)
Message-ID: <55A92023.3060703@xs4all.nl>
Date: Fri, 17 Jul 2015 17:32:51 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL v2 FOR v4.3] tc358743: add DT support
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since v1: add the "allow event subscription" patch.

Regards,

	Hans

The following changes since commit 6727d4fce95586e60922bdaf57b8a0eb99482557:

  [media] coda: make NV12 format default (2015-07-17 11:29:39 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.3c

for you to fetch changes up to 042fce8454c587b9d64aa2fdcc62dda22e0b1a48:

  tc358743: allow event subscription (2015-07-17 17:30:55 +0200)

----------------------------------------------------------------
Philipp Zabel (5):
      tc358743: register v4l2 asynchronous subdevice
      tc358743: enable v4l2 subdevice devnode
      tc358743: support probe from device tree
      tc358743: add direct interrupt handling
      tc358743: allow event subscription

 Documentation/devicetree/bindings/media/i2c/tc358743.txt |  48 ++++++++++++++++
 drivers/media/i2c/tc358743.c                             | 211 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 250 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tc358743.txt
