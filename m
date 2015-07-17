Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:50772 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755122AbbGQPAt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 11:00:49 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id CFF382A0091
	for <linux-media@vger.kernel.org>; Fri, 17 Jul 2015 16:59:46 +0200 (CEST)
Message-ID: <55A91862.3000901@xs4all.nl>
Date: Fri, 17 Jul 2015 16:59:46 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.3] tc358743: add DT support
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 6727d4fce95586e60922bdaf57b8a0eb99482557:

  [media] coda: make NV12 format default (2015-07-17 11:29:39 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.3c

for you to fetch changes up to df9d259dcf8c000878e04ffd3ed6a22bfc0fb02f:

  tc358743: add direct interrupt handling (2015-07-17 16:52:28 +0200)

----------------------------------------------------------------
Philipp Zabel (4):
      tc358743: register v4l2 asynchronous subdevice
      tc358743: enable v4l2 subdevice devnode
      tc358743: support probe from device tree
      tc358743: add direct interrupt handling

 Documentation/devicetree/bindings/media/i2c/tc358743.txt |  48 +++++++++++++++++
 drivers/media/i2c/tc358743.c                             | 192 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 233 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tc358743.txt
