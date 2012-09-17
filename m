Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2373 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab2IQIU2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 04:20:28 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id q8H8KPA9033684
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 17 Sep 2012 10:20:27 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id E29B335C012A
	for <linux-media@vger.kernel.org>; Mon, 17 Sep 2012 10:20:23 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.7] Two control framework enhancements
Date: Mon, 17 Sep 2012 10:20:24 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201209171020.24569.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request adds two new features to the control framework:

- a notify function that is needed to have a bridge driver be notified of
  subdevice control changes
- a new filter function to have more control over which controls are added
  by v4l2_ctrl_add_handler.

Both of these features are used by upcoming driver conversions (bttv, em28xx,
others).

Regards,

	Hans

The following changes since commit 36aee5ff9098a871bda38dbbdad40ad59f6535cf:

  [media] ir-rx51: Adjust dependencies (2012-09-15 19:44:30 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git ctrlfw

for you to fetch changes up to ccfe4a433304166f725d0d55f947f0cba7aecc1b:

  v4l2-ctrls: add a filter function to v4l2_ctrl_add_handler. (2012-09-17 10:17:22 +0200)

----------------------------------------------------------------
Hans Verkuil (2):
      v4l2-ctrls: add a notify callback.
      v4l2-ctrls: add a filter function to v4l2_ctrl_add_handler.

 Documentation/video4linux/v4l2-controls.txt    |   28 +++++++++++++++++++---------
 drivers/media/pci/cx88/cx88-blackbird.c        |    2 +-
 drivers/media/pci/cx88/cx88-video.c            |    2 +-
 drivers/media/platform/s5p-fimc/fimc-capture.c |    2 +-
 drivers/media/platform/soc_camera/soc_camera.c |    2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c           |   50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/media/v4l2-core/v4l2-device.c          |    2 +-
 include/media/v4l2-ctrls.h                     |   43 +++++++++++++++++++++++++++++++++++++++++--
 8 files changed, 114 insertions(+), 17 deletions(-)
