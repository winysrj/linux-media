Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3339 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaBQKIP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 05:08:15 -0500
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id s1HA8D71039036
	for <linux-media@vger.kernel.org>; Mon, 17 Feb 2014 11:08:14 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 7980F2A00AD
	for <linux-media@vger.kernel.org>; Mon, 17 Feb 2014 11:07:39 +0100 (CET)
Message-ID: <5301DF6B.1010100@xs4all.nl>
Date: Mon, 17 Feb 2014 11:07:39 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.15] 3.15 patches
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- si4713: make const structs really const
- improve compat32 handling in v4l2-compat-ioctl32.c & v4l2-subdev
- vivi fixes (based on v4l2-compliance tests)

Regards,

	Hans

The following changes since commit 37e59f876bc710d67a30b660826a5e83e07101ce:

  [media, edac] Change my email address (2014-02-07 08:03:07 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.15c

for you to fetch changes up to 3a19641862df1d3e351f43a1e56c3b68a94a78ed:

  vivi: queue_setup improvements. (2014-02-17 11:04:34 +0100)

----------------------------------------------------------------
Hans Verkuil (5):
      radio-usb-si4713: make array of structs const.
      v4l2-subdev: Allow 32-bit compat ioctls
      vivi: fix sequence counting
      vivi: drop unused field
      vivi: queue_setup improvements.

 drivers/media/platform/vivi.c                 |  34 ++++++++++----------------
 drivers/media/radio/si4713/radio-usb-si4713.c |   4 ++--
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 101 +++++-------------------------------------------------------------------------
 drivers/media/v4l2-core/v4l2-subdev.c         |  14 +++++++++++
 include/media/v4l2-subdev.h                   |   4 ++++
 5 files changed, 38 insertions(+), 119 deletions(-)
