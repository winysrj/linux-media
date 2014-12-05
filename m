Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:47176 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840AbaLEO2Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Dec 2014 09:28:25 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 8868F2A002F
	for <linux-media@vger.kernel.org>; Fri,  5 Dec 2014 15:28:20 +0100 (CET)
Message-ID: <5481C104.6030806@xs4all.nl>
Date: Fri, 05 Dec 2014 15:28:20 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.19] v4l2-mediabus.h & documentation updates
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These fixes are needed for 3.19 and are a follow up to the colorspace
patch series.

They keep one extra __u32 free for future use in v4l2-mediabus.h as per Sakari's
suggestion. This suggestion came in after the colorspace patches were merged,
but it is a good idea.

And the documentation is updated (I missed a few things there).

Regards,

	Hans

The following changes since commit 71947828caef0c83d4245f7d1eaddc799b4ff1d1:

  [media] mn88473: One function call less in mn88473_init() after error (2014-12-04 16:00:47 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.19m

for you to fetch changes up to 4761f227d0256f5e35b55b1a98f2352b54fa900f:

  DocBook media: update version number and document changes. (2014-12-05 15:23:55 +0100)

----------------------------------------------------------------
Hans Verkuil (4):
      v4l2-mediabus.h: use two __u16 instead of two __u32
      DocBook media: add missing ycbcr_enc and quantization fields
      vivid.txt: document new controls
      DocBook media: update version number and document changes.

 Documentation/DocBook/media/v4l/compat.xml         | 12 ++++++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml         | 36 ++++++++++++++++++++++++++++++++++--
 Documentation/DocBook/media/v4l/subdev-formats.xml | 18 +++++++++++++++++-
 Documentation/DocBook/media/v4l/v4l2.xml           | 11 ++++++++++-
 Documentation/video4linux/vivid.txt                | 15 +++++++++++++++
 include/uapi/linux/v4l2-mediabus.h                 |  6 +++---
 6 files changed, 91 insertions(+), 7 deletions(-)
