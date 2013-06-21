Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4948 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945946Ab3FUUIr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 16:08:47 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr2.xs4all.nl (8.13.8/8.13.8) with ESMTP id r5LK8hAf085686
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 21 Jun 2013 22:08:45 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id B892635E0143
	for <linux-media@vger.kernel.org>; Fri, 21 Jun 2013 22:08:42 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.11] Conversions to v4l-async
Date: Fri, 21 Jun 2013 22:08:43 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201306212208.43086.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the v4l-async patches have been merged, these patches can be merged
as well.

	Hans

The following changes since commit ee17608d6aa04a86e253a9130d6c6d00892f132b:

  [media] imx074: support asynchronous probing (2013-06-21 16:36:15 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.11

for you to fetch changes up to a6277614fa957a3c26a3160e2fc662838d185c70:

  media: i2c: ths8200: add support v4l-async (2013-06-21 22:00:47 +0200)

----------------------------------------------------------------
Lad, Prabhakar (3):
      media: i2c: tvp7002: add support for asynchronous probing
      media: i2c: tvp7002: add OF support
      media: i2c: ths8200: add support v4l-async

 Documentation/devicetree/bindings/media/i2c/tvp7002.txt | 42 ++++++++++++++++++++++++++++++++++++++++++
 drivers/media/i2c/ths8200.c                             | 10 +++++++++-
 drivers/media/i2c/tvp7002.c                             | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 115 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp7002.txt
