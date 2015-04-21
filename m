Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:36054 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbbDUNue (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 09:50:34 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id C08692A0089
	for <linux-media@vger.kernel.org>; Tue, 21 Apr 2015 15:50:02 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv3 0/4] Fill in the description for VIDIOC_ENUM_FMT
Date: Tue, 21 Apr 2015 15:49:57 +0200
Message-Id: <1429624201-44743-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series is identical to https://patchwork.linuxtv.org/patch/29080/
but it removes the description from the skeleton driver and the virtual
drivers. Since those are basically reference drivers it makes sense to update
those first.

I'll make a pull request of this as well, since this is ready for 4.2.

Regards,

	Hans

Hans Verkuil (4):
  v4l2-ioctl: fill in the description for VIDIOC_ENUM_FMT
  v4l2-pci-skeleton: drop format description
  vim2m: drop format description
  vivid: drop format description

 Documentation/video4linux/v4l2-pci-skeleton.c   |   2 -
 drivers/media/platform/vim2m.c                  |   4 -
 drivers/media/platform/vivid/vivid-core.h       |   1 -
 drivers/media/platform/vivid/vivid-vid-cap.c    |   4 -
 drivers/media/platform/vivid/vivid-vid-common.c |  50 ------
 drivers/media/v4l2-core/v4l2-ioctl.c            | 199 +++++++++++++++++++++++-
 6 files changed, 192 insertions(+), 68 deletions(-)

-- 
2.1.4

