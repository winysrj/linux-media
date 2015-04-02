Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:38769 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747AbbDBLfF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Apr 2015 07:35:05 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 1459A2A00AB
	for <linux-media@vger.kernel.org>; Thu,  2 Apr 2015 13:34:33 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/3] cx18: v4l2_compliance fixes
Date: Thu,  2 Apr 2015 13:34:28 +0200
Message-Id: <1427974471-24804-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Various cx18 v4l2_compliance fixes. Note that this patch series relies
on https://patchwork.linuxtv.org/patch/29045/ being merged first.

Regards,

	Hans

Hans Verkuil (3):
  cx18: add support for control events
  cx18: fix VIDIOC_ENUMINPUT: wrong std value
  cx18: replace cropping ioctls by selection ioctls.

 drivers/media/pci/cx18/cx18-fileops.c | 25 +++++++++++++------
 drivers/media/pci/cx18/cx18-ioctl.c   | 47 +++++++++++++++++++----------------
 drivers/media/pci/cx18/cx18-streams.c |  6 ++++-
 3 files changed, 48 insertions(+), 30 deletions(-)

-- 
2.1.4

