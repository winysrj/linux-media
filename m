Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1888 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3FCHkR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 03:40:17 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id r537e58x064150
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 3 Jun 2013 09:40:07 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 09FC735E0049
	for <linux-media@vger.kernel.org>; Mon,  3 Jun 2013 09:40:04 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.10] Four fixes
Date: Mon, 3 Jun 2013 09:40:04 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201306030940.04468.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This superceeds my previous 3.10 pull request (https://patchwork.linuxtv.org/patch/18657/).

This pull request adds two core fixes: supporting V4L2_CTRL_CLASS_FM_RX as
valid radio controls and a fix in the clips debug code in v4l2-ioctl.c which
could cause an oops.

Both bugs were discovered while working on the saa7134 overhaul.

Regards,

	Hans

The following changes since commit 7eac97d7e714429f7ef1ba5d35f94c07f4c34f8e:

  [media] media: pci: remove duplicate checks for EPERM (2013-05-27 09:34:56 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.10d

for you to fetch changes up to dd353805d7c5c4de4277f737043e187b1c260372:

  v4l2-ioctl: don't print the clips list. (2013-06-03 09:35:22 +0200)

----------------------------------------------------------------
Hans Verkuil (4):
      DocBook/media/v4l: update version number.
      cx88: fix NULL pointer dereference
      v4l2-ctrls: V4L2_CTRL_CLASS_FM_RX controls are also valid radio controls.
      v4l2-ioctl: don't print the clips list.

 Documentation/DocBook/media/v4l/v4l2.xml |    2 +-
 drivers/media/pci/cx88/cx88-alsa.c       |    7 +++----
 drivers/media/pci/cx88/cx88-video.c      |    8 +++-----
 drivers/media/v4l2-core/v4l2-ctrls.c     |    2 ++
 drivers/media/v4l2-core/v4l2-ioctl.c     |   47 +++++++++++++++++++++--------------------------
 5 files changed, 30 insertions(+), 36 deletions(-)
