Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3122 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbaBUHkr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Feb 2014 02:40:47 -0500
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr4.xs4all.nl (8.13.8/8.13.8) with ESMTP id s1L7ehkR061646
	for <linux-media@vger.kernel.org>; Fri, 21 Feb 2014 08:40:45 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 0F15C2A01A7
	for <linux-media@vger.kernel.org>; Fri, 21 Feb 2014 08:40:41 +0100 (CET)
Message-ID: <530702F8.2030501@xs4all.nl>
Date: Fri, 21 Feb 2014 08:40:40 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.14] Kconfig fixes and vb2 regression fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The first two patches fix some Kconfig dependencies and the second two patches
fix regressions introduced in vb2 in 3.14.

They were found by v4l2-compliance and tested very well.

Regards,

	Hans

The following changes since commit 37e59f876bc710d67a30b660826a5e83e07101ce:

  [media, edac] Change my email address (2014-02-07 08:03:07 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.14e

for you to fetch changes up to e1b326e45d7e935be8ece34ef87a0549d1b13789:

  vb2: fix PREPARE_BUF regression. (2014-02-21 08:37:17 +0100)

----------------------------------------------------------------
Hans Verkuil (4):
      si4713: fix Kconfig dependencies
      saa6752hs: depends on CRC32
      vb2: fix read/write regression
      vb2: fix PREPARE_BUF regression.

 drivers/media/i2c/Kconfig                |  1 +
 drivers/media/radio/si4713/Kconfig       |  6 +++---
 drivers/media/v4l2-core/videobuf2-core.c | 54 ++++++++++++++++++++++++++++++++++++++++++------------
 3 files changed, 46 insertions(+), 15 deletions(-)
