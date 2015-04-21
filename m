Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:40697 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106AbbDUNy4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 09:54:56 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 4C4BE2A0089
	for <linux-media@vger.kernel.org>; Tue, 21 Apr 2015 15:54:29 +0200 (CEST)
Message-ID: <55365695.8080006@xs4all.nl>
Date: Tue, 21 Apr 2015 15:54:29 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.2] Fill in the description for VIDIOC_ENUM_FMT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure standard format descriptions by filling it in in the v4l2 core.
Currently these descriptions are all over the place and every driver dreams
up its own description. That's not good.

Regards,

	Hans

The following changes since commit e183201b9e917daf2530b637b2f34f1d5afb934d:

  [media] uvcvideo: add support for VIDIOC_QUERY_EXT_CTRL (2015-04-10 10:29:27 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.2c

for you to fetch changes up to b1a4374e55d847ae0b17b33c52a974de833ce228:

  vivid: drop format description (2015-04-21 15:39:49 +0200)

----------------------------------------------------------------
Hans Verkuil (4):
      v4l2-ioctl: fill in the description for VIDIOC_ENUM_FMT
      v4l2-pci-skeleton: drop format description
      vim2m: drop format description
      vivid: drop format description

 Documentation/video4linux/v4l2-pci-skeleton.c   |   2 -
 drivers/media/platform/vim2m.c                  |   4 --
 drivers/media/platform/vivid/vivid-core.h       |   1 -
 drivers/media/platform/vivid/vivid-vid-cap.c    |   4 --
 drivers/media/platform/vivid/vivid-vid-common.c |  50 -------------------
 drivers/media/v4l2-core/v4l2-ioctl.c            | 199 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 6 files changed, 192 insertions(+), 68 deletions(-)
